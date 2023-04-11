import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MultiImageCapture extends StatelessWidget {
  final RxList<File> capturedImages = RxList();
  final Future<bool> Function(File image) onRemoveImage;
  final Future<void> Function(File image)? onAddImage;
  final Function(List<File> finalImages)? onComplete;
  final int maxImages;
  bool isPrimaryOn = true;

  final Rxn<CameraController> _cameraController = Rxn();
  final RxList<CameraDescription> _availableCameras = RxList();
  final Rx<bool> _camerasLoading = Rx(true);

  final ScrollController _imagesScrollController = ScrollController();

  final File _dummyImageFile = File('');

  MultiImageCapture({
    Key? key,
    List<File> preCapturedImages = const [],
    required this.onRemoveImage,
    this.onAddImage,
    this.onComplete,
    this.maxImages = 200,
  }) : super(key: key) {
    capturedImages.addAll(preCapturedImages);
    initPrimaryCamera();
  }

  Future<void> initPrimaryCamera() async {
    _availableCameras.addAll(await availableCameras());
    _camerasLoading.value = false;
    if (_availableCameras.isNotEmpty) {
      _cameraController.value =
          CameraController(_availableCameras.first, ResolutionPreset.max);
      await _cameraController.value!.initialize();
      _cameraController.refresh();
    }
  }

  Future<void> initSecondaryCamera() async {
    _availableCameras.addAll(await availableCameras());
    _camerasLoading.value = false;
    if (_availableCameras.length > 1) {
      _cameraController.value =
          CameraController(_availableCameras.elementAt(1), ResolutionPreset.max);
      await _cameraController.value!.initialize();
      _cameraController.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _cameraController.value?.dispose();
        onComplete?.call(capturedImages.toList());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("Capture Images"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Obx(() {
          return Stack(children: [
            _buildCameraPreview(context),
            Positioned(
              top: 0,
              left: 0,
              child: _buildCapturedImagesPane(context),
            ),
          ]);
        }),
      ),
    );
  }

  Widget _buildCameraPreview(BuildContext context) {
    if (_camerasLoading.value) {
      return const Center(child: CircularProgressIndicator());
    } else if (_availableCameras.isEmpty) {
      return const Center(
          child: Text("No Available Cameras",
              style: TextStyle(color: Colors.black)));
    } else {
      return SizedBox.expand(
        child: CameraPreview(
          _cameraController.value!,
          child: Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          if (isPrimaryOn) {
                            initSecondaryCamera();
                          } else {
                            initPrimaryCamera();
                          }
                          isPrimaryOn = !isPrimaryOn;
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(10),
                         // foregroundColor: Colors.red, // <-- Splash color
                        ),
                        child: const Icon(Icons.switch_camera, color: Colors.white),
                      )
                  ),
                  Flexible(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: capturedImages.contains(_dummyImageFile)
                            ? null
                            : () => captureImage(context),
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                          //foregroundColor: Colors.red, // <-- Splash color
                        ),
                        child: const Icon(Icons.camera, color: Colors.white),
                      )
                  ),
                  Flexible(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () async {
                          await onComplete?.call(capturedImages);
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(10),
                          //foregroundColor: Colors.red, // <-- Splash color
                        ),
                        child: const Icon(Icons.send, color: Colors.white),
                      )
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildCapturedImagesPane(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
        child: Container(
          height: 120,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(color: Colors.transparent),
          child: ListView.builder(
            controller: _imagesScrollController,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              var imageFile = capturedImages.elementAt(index);

              bool isDummy = imageFile == _dummyImageFile;

              return Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Colors.lightBlue, width: 2),
                      ),
                      child: isDummy
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: Center(child: CircularProgressIndicator()),
                      )
                          : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          capturedImages.elementAt(index),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: -20,
                      right: -20,
                      child: IconButton(
                        icon: const Icon(Icons.remove_circle_outlined,
                            color: Colors.red, size: 28),
                        onPressed: () =>
                            removeImageFile(capturedImages.elementAt(index)),
                      ),
                    )
                  ],
                ),
              );
            },
            itemCount: capturedImages.length,
            padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
          ),
        ),
      ),
    );
  }

  Future<void> captureImage(BuildContext context) async {
    if (capturedImages.length >= maxImages) {
      // TODO: Show warning dialog
      return;
    }

    capturedImages.add(_dummyImageFile);

    var xFile = await _cameraController.value!.takePicture();
    File imgFile = File(xFile.path);
    onAddImage?.call(imgFile);
    capturedImages.remove(_dummyImageFile);
    capturedImages.add(imgFile);

    _imagesScrollController.animateTo(
      _imagesScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> removeImageFile(File file) async {
    bool isRemoved = await onRemoveImage(file);
    if (isRemoved) capturedImages.remove(file);
  }
}

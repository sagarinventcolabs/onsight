import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/strings.dart';


class MultiImageCapture extends StatefulWidget {
  final RxList<File> capturedImages = RxList();
  final Future<bool> Function(File image) onRemoveImage;
  final Future<void> Function(File image)? onAddImage;
  final Function(List<File> finalImages)? onComplete;
  final int maxImages;
  bool isPrimaryOn = true;
  bool isFlashOn = false;
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
      _cameraController.value = CameraController(_availableCameras.first, ResolutionPreset.max);
      await _cameraController.value!.initialize();
      _cameraController.value!.setFlashMode(FlashMode.off);
      _cameraController.refresh();
    }
  }

  Future<void> initSecondaryCamera() async {
    _availableCameras.addAll(await availableCameras());
    _camerasLoading.value = false;
    if (_availableCameras.length > 1) {
      _cameraController.value = CameraController(_availableCameras.elementAt(1), ResolutionPreset.max);
      await _cameraController.value!.initialize();
      _cameraController.value!.setFlashMode(FlashMode.off);
      _cameraController.refresh();
    }
  }

  @override
  State<MultiImageCapture> createState() => _MultiImageCaptureState();
}

class _MultiImageCaptureState extends State<MultiImageCapture> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await widget._cameraController.value?.dispose();
        widget.onComplete?.call(widget.capturedImages.toList());
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
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: IconButton(
                icon: Icon(widget.isFlashOn ? Icons.flash_on : Icons.flash_off, color: Colors.white),
                onPressed: (){
                  setState(() {
                    if(widget.isFlashOn){
                      widget._cameraController.value!.setFlashMode(FlashMode.off);
                    } else {
                      widget._cameraController.value!.setFlashMode(FlashMode.torch);
                    }
                    widget.isFlashOn = !widget.isFlashOn;
                  });
                },
              ),
            ),
          ],
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
    if (widget._camerasLoading.value) {
      return const Center(child: CircularProgressIndicator());
    } else if (widget._availableCameras.isEmpty) {
      return const Center(
          child: Text("No Available Cameras",
              style: TextStyle(color: Colors.black)));
    } else {
      return SizedBox.expand(
        child: CameraPreview(
          widget._cameraController.value!,
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
                          if (widget.isPrimaryOn) {
                            widget.initSecondaryCamera();
                          } else {
                            widget.initPrimaryCamera();
                          }
                          widget.isPrimaryOn = !widget.isPrimaryOn;
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
                        onPressed: (){
                          print(widget.capturedImages.length);
                          if(widget.capturedImages.isNotEmpty){
                            if(widget.capturedImages.length==10){
                              Get.closeAllSnackbars();
                              Get.snackbar(alert, youHaveReachedTheMaximumLimitOf);
                            }
                          }
                          widget.capturedImages.contains(widget._dummyImageFile)
                              ? null
                              :captureImage(context);
                        },
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
                          await widget.onComplete?.call(widget.capturedImages);
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
      child: Container(
        height: 120,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(color: Colors.transparent),
        child: ListView.builder(
          controller: widget._imagesScrollController,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            var imageFile = widget.capturedImages.elementAt(index);

            bool isDummy = imageFile == widget._dummyImageFile;

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
                        widget.capturedImages.elementAt(index),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -15,
                    right: -15,
                    child: GestureDetector(
                      onTap: (){
                        removeImageFile(widget.capturedImages.elementAt(index));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          Assets.icClose2,
                          height: Dimensions.height25,
                          width: Dimensions.height25,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
          itemCount: widget.capturedImages.length,
          padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
        ),
      ),
    );
  }

  Future<void> captureImage(BuildContext context) async {
    if (widget.capturedImages.length >= widget.maxImages) {
      // TODO: Show warning dialog
      return;
    }

    widget.capturedImages.add(widget._dummyImageFile);

    var xFile = await widget._cameraController.value!.takePicture();
    File imgFile = File(xFile.path);
    widget.onAddImage?.call(imgFile);
    widget.capturedImages.remove(widget._dummyImageFile);
    widget.capturedImages.add(imgFile);
    widget._imagesScrollController.animateTo(
      widget._imagesScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    widget._cameraController.value!.setFlashMode(FlashMode.off);
    setState(() => widget.isFlashOn = !widget.isFlashOn);
  }

  Future<void> removeImageFile(File file) async {
    bool isRemoved = await widget.onRemoveImage(file);
    if (isRemoved) widget.capturedImages.remove(file);
  }
}
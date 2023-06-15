import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/repository/database_managers/image_manager.dart';
import 'package:on_sight_application/repository/database_model/image_model.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/screens/job_photos/view_model/job_photos_controller.dart';
import 'package:on_sight_application/screens/job_photos/view_model/upload_job_photos_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dialogs.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/functions/functions.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class UploadJobPhotosNote extends StatefulWidget {
  const UploadJobPhotosNote({Key? key}) : super(key: key);

  @override
  State<UploadJobPhotosNote> createState() => _UploadJobPhotosNoteState();
}

class _UploadJobPhotosNoteState extends State<UploadJobPhotosNote> {
  /// putting upload job photos controller
  late UploadJobPhotosController _uploadJobPhotosC;

  ScrollController _scrollController = ScrollController();
  JobPhotosController controller = Get.find<JobPhotosController>();
  var id = "";
  var jobNumber = "";
  var i = 0;
  var key = null;

  @override
  void initState() {
    if (Get.isRegistered<UploadJobPhotosController>()) {
      _uploadJobPhotosC = Get.find<UploadJobPhotosController>();
    } else {
      _uploadJobPhotosC = Get.put(UploadJobPhotosController());
    }
    super.initState();

    id = Get.arguments[0];
    jobNumber = Get.arguments[1];
    key = Get.arguments[2];
    _uploadJobPhotosC.initSpeech();
    i = controller.categoryList.indexWhere((element) => element.id == id);
    // showImagePreview();
  }

  @override
  void dispose() {
    _uploadJobPhotosC.stopListening();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // showImagePreview();
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        List<ImageModel> listModel = await ImageManager()
            .getImageByCategoryIdandJobNumber(id, jobNumber);
        if (listModel.length < _uploadJobPhotosC.jobPhotosList.length) {
          dialogAction(context, title: doYouWantDiscardPhotos, onTapYes: () {
            Get.back();
            Get.back();
          }, onTapNo: () {
            Get.back();
          });
        } else {
          Get.back();
        }
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: ColourConstants.primary,
                size: Dimensions.height25,
              ),
              onPressed: () async {
                List<ImageModel> listModel = await ImageManager()
                    .getImageByCategoryIdandJobNumber(id, jobNumber);
                if (listModel.length < _uploadJobPhotosC.jobPhotosList.length) {
                  dialogAction(context, title: doYouWantDiscardPhotos,
                      onTapYes: () {
                    Get.back();
                    Get.back();
                  }, onTapNo: () {
                    Get.back();
                  });
                } else {
                  Get.back();
                }
              },
            ),
            elevation: 0.0,
            backgroundColor:
                Get.isDarkMode ? ColourConstants.black : ColourConstants.white,
            title: Text(uploadText,
                style: TextStyle(
                    color: Get.isDarkMode
                        ? ColourConstants.white
                        : ColourConstants.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: Dimensions.font16)),
            actions: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(Dimensions.radius10),
                              topRight: Radius.circular(Dimensions.radius10))),
                      isScrollControlled: true,
                      context: context,
                      builder: (context) =>
                          // bottomSheetWidget(Routes.uploadJobPhotosNote, id, jobNumber, key==null?smallUpdateStr:add));
                          bottomSheetImagePicker(
                              Routes.uploadJobPhotosNote)).then((value) {
                    ImagePickerJobPhoto(Routes.uploadJobPhotosNote, id,
                        jobNumber, key == null ? smallUpdateStr : add);
                  });
                },
                child: Image.asset(
                  Assets.icAdd,
                  height: Dimensions.height25,
                  width: Dimensions.height25,
                ),
              ),
              SizedBox(width: Dimensions.height11)
            ],
          ),
          bottomNavigationBar: Obx(() => GestureDetector(
                onTap: () async {
                  if (_uploadJobPhotosC.enableButton.isTrue) {
                    ImageManager manager = ImageManager();
                    for (var element in _uploadJobPhotosC.jobPhotosList) {
                      if (controller.categoryList[i].sendEmail != null) {
                        if (controller.categoryList[i].sendEmail == true) {
                          element.isEmailRequired = 1;
                        } else {
                          element.isEmailRequired = 0;
                        }
                      }
                      await manager.insertImage(element);
                    }
                    controller.categoryList[i].listPhotos =
                        await manager.getImageByCategoryIdandJobNumber(
                            controller.categoryList[i].id.toString(),
                            jobNumber);
                    controller.categoryList.refresh();
                    controller.update();
                    if (controller.categoryList[i].listPhotos!.isNotEmpty) {
                      //await _uploadJobPhotosC.saveImage(i, jobNumber);
                      defaultDialog(Get.context!,
                          title: key == null
                              ? addPhotos
                              : key == smallUpdateStr
                                  ? photosUpdatedSuccessfully
                                  : photosAddedSuccessfully,
                          cancelable: false, onTap: () {
                        Get.back();
                        Get.back();
                      });
                    }
                  }
                },
                child: Container(
                  height: Dimensions.height50,
                  margin: EdgeInsets.only(
                      left: Dimensions.width35,
                      right: Dimensions.width35,
                      bottom: Dimensions.height16),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.all(Radius.circular(Dimensions.radius8)),
                      color: _uploadJobPhotosC.enableButton.isTrue
                          ? ColourConstants.primary
                          : ColourConstants.grey),
                  child: Center(
                      child: Text(
                    key == null
                        ? addPhotos
                        : key == smallUpdateStr
                            ? updatePhotos
                            : addPhotos,
                    style: TextStyle(
                        color: ColourConstants.white,
                        fontWeight: FontWeight.w300,
                        fontSize: Dimensions.font16),
                  )),
                ),
              )),
          body: Obx(() => ListView(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.height14),
                shrinkWrap: true,
                controller: _scrollController,
                children: [
                  Text(
                      "You have selected ${_uploadJobPhotosC.jobPhotosList.length} photos to upload!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Get.isDarkMode
                              ? ColourConstants.white
                              : ColourConstants.greyText,
                          fontWeight: FontWeight.w400,
                          fontSize: Dimensions.font14)),
                  SizedBox(height: Dimensions.height20),
                  ListView.builder(
                      shrinkWrap: true,
                      controller: _scrollController,
                      itemCount: _uploadJobPhotosC.jobPhotosList.length,
                      itemBuilder: (builder, photoIndex) {
                        return imageNoteWidget(photoIndex);
                      }),
                  SizedBox(
                    height: Dimensions.height20,
                  )
                ],
              ))),
    );
  }

  showImagePreview() {
    showDialog(
        context: Get.context!,
        builder: (ctx) {
          return StatefulBuilder(builder: (builderCtx, setState) {
            return Scaffold(
              backgroundColor: ColourConstants.black,
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                actions: [
                  GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: Dimensions.height10),
                        child: Icon(
                          Icons.close,
                          color: ColourConstants.white,
                          size: Dimensions.height30,
                        ),
                      ))
                ],
                backgroundColor: ColourConstants.black,
                elevation: 0,
                automaticallyImplyLeading: false,
              ),
              body: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: PhotoViewGallery.builder(
                    scrollPhysics: const BouncingScrollPhysics(),
                    builder: (BuildContext context, int index) {
                      return PhotoViewGalleryPageOptions(
                        imageProvider: FileImage(File(
                            _uploadJobPhotosC.jobPhotosList[index].imagePath ??
                                "")),
                        initialScale: PhotoViewComputedScale.contained * 0.8,
                        maxScale: 1.0,
                      );
                    },
                    itemCount: _uploadJobPhotosC.jobPhotosList.length,
                    loadingBuilder: (context, event) => Center(
                      child: Container(
                        width: Dimensions.height15,
                        height: Dimensions.height15,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )),
              bottomNavigationBar: Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.height20),
                child: Container(
                  height: Dimensions.height50,
                  margin: EdgeInsets.only(
                      bottom: Dimensions.height35, top: Dimensions.height10),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.all(Radius.circular(Dimensions.height8)),
                      color: ColourConstants.primary),
                  child: Center(
                      child: Text(
                    removeStr,
                    style: TextStyle(
                        color: ColourConstants.white,
                        fontWeight: FontWeight.w400,
                        fontSize: Dimensions.font16),
                  )),
                ),
              ),
            );
          });
        });
  }

  /// define image with note widget
  Widget imageNoteWidget(photoIndex) {
    return Padding(
      padding: EdgeInsets.only(top: Dimensions.height10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _uploadJobPhotosC.jobPhotosList[photoIndex].imagePath != null
              ? Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        singleImageDialogJobPhoto(
                            image: _uploadJobPhotosC
                                .jobPhotosList[photoIndex].imagePath!,
                            context: context);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(Dimensions.height5),
                        child: Container(
                          height: Dimensions.height50,
                          width: Dimensions.height50,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  //image: Image.memory(base64Decode(_uploadJobPhotosC.jobPhotosList[photoIndex].imageString.toString())).image,
                                  image: Image.file(File(_uploadJobPhotosC.jobPhotosList[photoIndex].imagePath.toString())).image,
                                  fit: BoxFit.fill),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(Dimensions.radius30))),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 5,
                      top: 0,
                      child: GestureDetector(
                        onTap: () async {
                          ImageManager manager = ImageManager();
                          var result = await manager.existOrNot(
                              _uploadJobPhotosC
                                  .jobPhotosList[photoIndex].imageName
                                  .toString());
                          if (result.toString() == "true") {
                            ImageModel dynamic = await manager
                                .getImageByImageName(_uploadJobPhotosC
                                    .jobPhotosList[photoIndex].imageName
                                    .toString());
                            await manager.deleteImage(dynamic.imageName!);
                          }

                          controller.categoryList[i].listPhotos =
                              await manager.getImageByCategoryIdandJobNumber(
                                  controller.categoryList[i].id.toString(),
                                  jobNumber);
                          if (controller.categoryList[i].listPhotos!.isEmpty) {
                            controller.categoryList[i].isChecked = false;
                            var button = false;
                            for (var element in controller.categoryList) {
                              if (element.isChecked != null) {
                                if (element.isChecked!) {
                                  button = true;
                                }
                              }
                            }
                            controller.enableButton.value = button;
                          }
                          _uploadJobPhotosC.jobPhotosList.removeAt(photoIndex);
                          if (_uploadJobPhotosC.jobPhotosList.isEmpty) {
                            _uploadJobPhotosC.enableButton.value = false;
                          } else {
                            _uploadJobPhotosC.enableButton.value = true;
                          }

                          controller.categoryList.refresh();
                          controller.update();
                          _uploadJobPhotosC.update();
                        },
                        child: Image.asset(
                          Assets.icClose,
                          height: Dimensions.height18,
                          width: Dimensions.height18,
                        ),
                      ),
                    )
                  ],
                )
              : Image.asset(
                  Assets.icAddedPhotosWithCross,
                  height: Dimensions.height40,
                  width: Dimensions.height40,
                ),
          SizedBox(width: Dimensions.height10),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textField(photoIndex),
              SizedBox(height: Dimensions.height12),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Dimensions.height20,
                    width: Dimensions.height20,
                    child: Checkbox(
                        value: _uploadJobPhotosC
                                    .jobPhotosList[photoIndex].promoFlag ==
                                1
                            ? true
                            : false,
                        checkColor: ColourConstants.white,
                        activeColor: ColourConstants.greenColor,
                        onChanged: (bool? newValue) {
                          _uploadJobPhotosC.enableButton.value = true;
                          _uploadJobPhotosC.update();
                          if (newValue == true) {
                            _uploadJobPhotosC
                                .jobPhotosList[photoIndex].promoFlag = 1;
                            _uploadJobPhotosC.jobPhotosList.refresh();
                            _uploadJobPhotosC.update();
                          } else {
                            _uploadJobPhotosC
                                .jobPhotosList[photoIndex].promoFlag = 0;
                            _uploadJobPhotosC.jobPhotosList.refresh();
                            _uploadJobPhotosC.update();
                          }
                        }),
                  ),
                  SizedBox(width: Dimensions.height10),
                  Text(promoStr,
                      style: TextStyle(
                          color: Get.isDarkMode
                              ? ColourConstants.white
                              : ColourConstants.black,
                          fontWeight: FontWeight.w400,
                          fontSize: Dimensions.font12)),
                  SizedBox(width: Dimensions.height5),
                ],
              ),
            ],
          ))
        ],
      ),
    );
  }

  /// job photo note text field widget
  Widget textField(photoIndex) {
    if (_uploadJobPhotosC.jobPhotosList[photoIndex].imageNote != null) {
      _uploadJobPhotosC.jobPhotosList[photoIndex].controller!.text =
          _uploadJobPhotosC.jobPhotosList[photoIndex].imageNote!;
    }
    return TextField(
      maxLines: null,
      controller: _uploadJobPhotosC.jobPhotosList[photoIndex].controller,
      keyboardType: TextInputType.text,
      onChanged: (val) {
        _uploadJobPhotosC.enableButton.value = true;
        _uploadJobPhotosC.update();
        _uploadJobPhotosC.jobPhotosList[photoIndex].imageNote = val.toString();
      },
      cursorColor: ColourConstants.primary,
      style: TextStyle(
          color: Get.isDarkMode ? ColourConstants.white : ColourConstants.black,
          fontWeight: FontWeight.w400,
          fontSize: Dimensions.font13),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
            horizontal: Dimensions.height10, vertical: Dimensions.height13),
        labelText: addNotes,
        labelStyle: TextStyle(
            color: Get.isDarkMode
                ? ColourConstants.white
                : ColourConstants.greyText,
            fontWeight: FontWeight.w400),
        suffixIconConstraints: BoxConstraints(
            minHeight: Dimensions.height25, minWidth: Dimensions.height25),
        suffixIcon: GestureDetector(
          onTap: () {
            if (_uploadJobPhotosC.speechToText.value.isNotListening) {
              // _uploadJobPhotosC.stopListening();
              _uploadJobPhotosC.startListening(photoIndex, i);
            } else {
              _uploadJobPhotosC.stopListening();
            }
          },
          child: Padding(
            padding: EdgeInsets.only(
                right: Dimensions.height11, left: Dimensions.height8),
            child: _uploadJobPhotosC.jobPhotosList[photoIndex].isListening
                ? Image.asset(
                    Assets.icMicUnMute,
                    height: Dimensions.height25,
                    width: Dimensions.height25,
                    color: Colors.blue,
                  )
                : Image.asset(
                    Assets.icMicMute,
                    height: Dimensions.height25,
                    width: Dimensions.height25,
                    color: Get.isDarkMode ? ColourConstants.white : null,
                  ),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Get.isDarkMode
                    ? ColourConstants.white
                    : ColourConstants.primary)),
        border: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Get.isDarkMode
                    ? ColourConstants.white
                    : ColourConstants.primary)),
        disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Get.isDarkMode
                    ? ColourConstants.white
                    : ColourConstants.primary)),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Get.isDarkMode
                    ? ColourConstants.white
                    : ColourConstants.primary)),
        filled: true,
        fillColor: Get.isDarkMode
            ? ColourConstants.black
            : ColourConstants.textFieldFillColor,
      ),
    );
  }
}

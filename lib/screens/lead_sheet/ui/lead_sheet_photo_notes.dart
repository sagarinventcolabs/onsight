import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/repository/database_managers/leadsheet_image_manager.dart';
import 'package:on_sight_application/repository/database_model/lead_sheet_image_model.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/screens/lead_sheet/view_model/leadsheet_image_controller.dart';
import 'package:on_sight_application/screens/lead_sheet/view_model/lead_sheet_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dialogs.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/functions/functions.dart';
import 'package:on_sight_application/utils/strings.dart';

class LeadSheetPhotosNote extends StatefulWidget {
  const LeadSheetPhotosNote({Key? key}) : super(key: key);

  @override
  State<LeadSheetPhotosNote> createState() => _LeadSheetPhotosNoteState();
}

class _LeadSheetPhotosNoteState extends State<LeadSheetPhotosNote> {
  /// putting upload job photos controller
  late LeadSheetImageController _uploadJobPhotosC;

  final ScrollController _scrollController = ScrollController();
  LeadSheetController controller = Get.find<LeadSheetController>();
  var id = "";

  var i = -1;
  var key;

  @override
  void initState() {
    if (Get.isRegistered<LeadSheetImageController>()) {
      _uploadJobPhotosC = Get.find<LeadSheetImageController>();
    } else {
      _uploadJobPhotosC = Get.put(LeadSheetImageController());
    }
    super.initState();

    id = Get.arguments[0];
    key = Get.arguments[1];
    _uploadJobPhotosC.initSpeech();
    i = controller.list.indexWhere((element) => element.exhibitorId == id);
  }

  @override
  void dispose() {
    _uploadJobPhotosC.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        List<LeadSheetImageModel> listModel = await LeadSheetImageManager()
            .getImageByExhibitorIdAndShowNumber(
                id, controller.showNumber.value);
        if (listModel.length < _uploadJobPhotosC.photoList.length) {
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
                color: Get.isDarkMode
                    ? ColourConstants.white
                    : ColourConstants.primary,
                size: Dimensions.height25,
              ),
              onPressed: () async {
                List<LeadSheetImageModel> listModel =
                    await LeadSheetImageManager()
                        .getImageByExhibitorIdAndShowNumber(
                            id, controller.showNumber.value);
                if (listModel.length < _uploadJobPhotosC.photoList.length) {
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
                      // backgroundColor: Get.isDarkMode ? ColourConstants.grey900 : ColourConstants.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(Dimensions.radius10),
                              topRight: Radius.circular(Dimensions.radius10))),
                      isScrollControlled: true,
                      context: context,
                      builder: (context) =>
                          //bottomSheetImagePickerLeadSheet(Routes.leadSheetPhotosNote, id, key==null?smallUpdateStr:add));
                          bottomSheetImagePicker(
                              Routes.leadSheetPhotosNote)).then((value) {
                    ImagePickerLeadSheet(Routes.leadSheetPhotosNote, id,
                        key == null ? smallUpdateStr : add);
                  });
                },
                child: Image.asset(
                  Assets.icAdd,
                  height: Dimensions.height25,
                  width: Dimensions.height25,
                ),
              ),
              SizedBox(width: Dimensions.height16)
            ],
          ),
          bottomNavigationBar: Obx(() => GestureDetector(
                onTap: () async {
                  if (_uploadJobPhotosC.enableButton.isTrue) {
                    LeadSheetImageManager manager = LeadSheetImageManager();
                    for (var element in _uploadJobPhotosC.photoList) {
                      element.exhibitorId = controller.list[i].exhibitorId;
                      element.showNumber = controller.showNumber.value;
                      await manager.insertImage(element);
                    }

                    controller.list[i].yetToSubmit =
                        await manager.getYetToSubmitCount(
                            controller.list[i].exhibitorId.toString(),
                            controller.showNumber.value);
                    controller.list.refresh();
                    controller.selectedExhibitorModel.first =
                        controller.list[i];
                    controller.selectedExhibitorModel.refresh();
                    print(controller.selectedExhibitorModel.first.yetToSubmit);
                    controller.updateSelectedModel(controller.list[i]);
                    controller.update();

                    defaultDialog(Get.context!,
                        title: key == smallUpdateStr
                            ? photosUpdatedSuccessfully
                            : photosAddedSuccessfully,
                        cancelable: false, onTap: () {
                      controller.buttonSubmit.value = true;
                      controller.update();
                      Get.back();
                      Get.back(result: true);
                    });
                  }
                },
                child: Container(
                  height: Dimensions.height50,
                  margin: EdgeInsets.only(
                      left: Dimensions.height35,
                      right: Dimensions.height35,
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
                padding: EdgeInsets.symmetric(horizontal: Dimensions.height16),
                shrinkWrap: true,
                controller: _scrollController,
                children: [
                  Text(
                      "You have selected ${_uploadJobPhotosC.photoList.length} photos to upload!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Get.isDarkMode
                              ? ColourConstants.white
                              : ColourConstants.greyText,
                          fontWeight: FontWeight.w400,
                          fontSize: Dimensions.font14)),
                  SizedBox(height: Dimensions.height30),
                  ListView.builder(
                      shrinkWrap: true,
                      controller: _scrollController,
                      itemCount: _uploadJobPhotosC.photoList.length,
                      itemBuilder: (builder, photoIndex) {
                        return imageNoteWidget(photoIndex);
                      }),
                ],
              ))),
    );
  }

  /// define image with note widget
  Widget imageNoteWidget(photoIndex) {
    return Padding(
      padding: EdgeInsets.only(top: Dimensions.height10),
      child: Row(
        children: [
          _uploadJobPhotosC.photoList[photoIndex].imagePath != null
              ? Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        singleImageDialog(
                            context: context,
                            image: _uploadJobPhotosC
                                .photoList[photoIndex].imagePath!);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(Dimensions.height5),
                        child: Container(
                          height: Dimensions.height50,
                          width: Dimensions.height50,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(File(_uploadJobPhotosC
                                      .photoList[photoIndex].imagePath!)),
                                  fit: BoxFit.fill),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(Dimensions.height30))),
                        ),
                      ),
                    ),
                    Positioned(
                      right: Dimensions.height5,
                      top: 0,
                      child: GestureDetector(
                        onTap: () async {
                          LeadSheetImageManager manager =
                              LeadSheetImageManager();
                          var result = await manager.existOrNot(
                              _uploadJobPhotosC.photoList[photoIndex].imageName
                                  .toString());
                          if (result.toString() == "true") {
                            LeadSheetImageModel dynamic = await manager
                                .getImageByImageName(_uploadJobPhotosC
                                    .photoList[photoIndex].imageName
                                    .toString());
                            await manager.deleteImage(dynamic.rowID!);
                          }

                          _uploadJobPhotosC.photoList.removeAt(photoIndex);
                          if (_uploadJobPhotosC.photoList.isEmpty) {
                            _uploadJobPhotosC.enableButton.value = false;
                          }
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
          Expanded(child: textField(photoIndex))
        ],
      ),
    );
  }

  /// job photo note text field widget
  Widget textField(photoIndex) {
    if (_uploadJobPhotosC.photoList[photoIndex].imageNote != null) {
      _uploadJobPhotosC.photoList[photoIndex].controller!.text =
          _uploadJobPhotosC.photoList[photoIndex].imageNote!;
    }
    return TextField(
      maxLines: null,
      controller: _uploadJobPhotosC.photoList[photoIndex].controller,
      keyboardType: TextInputType.text,
      onChanged: (val) {
        _uploadJobPhotosC.photoList[photoIndex].imageNote = val.toString();
      },
      cursorColor: ColourConstants.primary,
      style: TextStyle(
          color: Get.isDarkMode ? ColourConstants.white : ColourConstants.black,
          fontWeight: FontWeight.w400,
          fontSize: Dimensions.font13),
      decoration: InputDecoration(
        isDense: true,
        // Added this
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
              _uploadJobPhotosC.startListening(photoIndex);
            } else {
              _uploadJobPhotosC.stopListening();
            }
          },
          child: Padding(
            padding: EdgeInsets.only(
                right: Dimensions.height11, left: Dimensions.height8),
            child: _uploadJobPhotosC.photoList[photoIndex].isListening
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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/repository/database_managers/image_manager.dart';
import 'package:on_sight_application/repository/database_model/image_model.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/screens/promo_pictures/view_model/promo_pictures_controller.dart';
import 'package:on_sight_application/screens/promo_pictures/view_model/upload_promo_pictures_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dialogs.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/functions/functions.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';
import 'package:on_sight_application/utils/strings.dart';


class UploadPromoPictureScreen extends StatefulWidget {
  const UploadPromoPictureScreen({Key? key}) : super(key: key);

  @override
  State<UploadPromoPictureScreen> createState() => _UploadPromoPictureScreenState();
}

class _UploadPromoPictureScreenState extends State<UploadPromoPictureScreen> {

  late UploadPromoPicturesController uploadPromoPicturesController ;
  ScrollController _scrollController = ScrollController();
  PromoPicturesController controller = Get.find<PromoPicturesController>();
  var id = "";
  var jobNumber = "";
  var i = 0;
  var key = null;
  @override
  void initState() {
    if(Get.isRegistered<UploadPromoPicturesController>()){
      uploadPromoPicturesController = Get.find<UploadPromoPicturesController>();
    }else{
      uploadPromoPicturesController = Get.put(UploadPromoPicturesController());
    }
    super.initState();

    uploadPromoPicturesController.initSpeech();

  }


  @override
  void dispose() {
    uploadPromoPicturesController.stopListening();
    controller.photoList.clear();
    controller.update();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color:Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,
              size: Dimensions.height25,
            ),
            onPressed: () async{
              List<ImageModel> listModel = await ImageManager().getImageByCategoryIdandJobNumber(id, jobNumber);
              if(listModel.length<controller.photoList.length){
                dialogAction(context, title: doYouWantDiscardPhotos, onTapYes: (){
                  controller.photoList.clear();
                  controller.update();
                  Get.back();
                  Get.back();
                },
                    onTapNo: (){
                      Get.back();
                    });
              }else {
                Get.back();
              }
            },
          ),
          elevation: 0.0,
          backgroundColor: Get.isDarkMode ? ColourConstants.black : ColourConstants.white,
          title: Text(uploadText,
              style: TextStyle(
                  color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: Dimensions.font16)),
          actions: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  //  backgroundColor: Get.isPlatformDarkMode ? ColourConstants.grey900 : ColourConstants.white,
                    //backgroundColor: Color.fromARGB(255, 0, 0, 0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(Dimensions.radius10),
                            topRight: Radius.circular(Dimensions.radius10))),
                    isScrollControlled: true,
                    context: context,
                    builder: (context) =>
                        bottomSheetImagePickerPromo(Routes.uploadPromoPictureScreen)).then((value) {
                       // bottomSheetImagePickerPromoPictures(Routes.uploadPromoPictureScreen)).then((value) {
                  ImagePickerPromoPictures(Routes.promoPictureScreen);
                  if(controller.photoList.isNotEmpty){
                    uploadPromoPicturesController.enableButton.value = true;
                    controller.update();
                  }
                  setState((){});
                });
              },
              child: Image.asset(
                Assets.icAdd2,
                height: Dimensions.height25,
                width: Dimensions.height25,
              ),
            ),
            SizedBox(width: Dimensions.height16)
          ],
        ),
        bottomNavigationBar: Obx(()=>
            GestureDetector(
          onTap: () async {

            if(uploadPromoPicturesController.enableButton.isTrue) {
              if (controller.radioButtonValue == 1) {
                analyticsFireEvent(promoPicturesKey, input: {
                  photoCount: controller.photoList.length.toString().trim(),
                  showNumber: controller.showController.text,
                  type: controller.radioButtonValue == 1 ? photosSubmittedToShow : photosSubmittedToNotShow,
                  user:(sp?.getString(Preference.FIRST_NAME)??"")/*+"_"+sp?.getString(Preference.LAST_NAME)??""*/
                });
              }else{
                analyticsFireEvent(promoPicturesKey, input: {
                  photoCount: controller.photoList.length.toString().trim(),
                  type: controller.radioButtonValue == 1 ? photosSubmittedToShow : photosSubmittedToNotShow,
                  user:(sp?.getString(Preference.FIRST_NAME)??"")/*+"_"+sp?.getString(Preference.LAST_NAME)??""*/
                });
              }
              dynamic token = await sp?.getString(Preference.ACCESS_TOKEN)??"";
              await uploadPromoPicturesController.runApiPromoPicturs(token,0);
              uploadPromoPicturesController.enableButton.value = false;
            }
          },
          child: Container(
            height: Dimensions.height50,
            margin: EdgeInsets.only(left: Dimensions.height35, right: Dimensions.height35, bottom: Dimensions.height16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(Dimensions.radius8)),
                color: uploadPromoPicturesController.enableButton.isTrue?ColourConstants.primary:ColourConstants.grey),
            child: Center(
                child: Text(
                  key==null?addPhotos:key==smallUpdateStr?updatePhotos:addPhotos,
                  style: TextStyle(
                      color: ColourConstants.white,
                      fontWeight: FontWeight.w300,
                      fontSize: Dimensions.font16),
                ),
               ),
              ),
             ),
            ),
        body: Obx(() => ListView(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.height16),
          shrinkWrap: true,
          controller: _scrollController,
          children: [
            Text("You have selected ${controller.photoList.length} photos to upload!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color:Get.isDarkMode?ColourConstants.white: ColourConstants.greyText,
                    fontWeight: FontWeight.w400,
                    fontSize: Dimensions.font14)),
            SizedBox(height: Dimensions.height30),
            ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                itemCount: controller.photoList.length,
                itemBuilder: (builder, photoIndex) {
                  return imageNoteWidget(photoIndex);
                }),
          ],
        )));
  }

  /// define image with note widget
  Widget imageNoteWidget(photoIndex) {
    return Padding(
      padding: EdgeInsets.only(top: Dimensions.height10),
      child: Row(
        children: [
          controller.photoList[photoIndex].imagePath != null
              ? Stack(
            children: [
              GestureDetector(
                onTap: (){
                  singleImageDialog(context: context,image: controller.photoList[photoIndex].imagePath!);
                },
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.height5),
                  child: Container(
                    height: Dimensions.height50,
                    width: Dimensions.height50,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(File(controller.photoList[photoIndex].imagePath!)),
                            fit: BoxFit.fill),
                        borderRadius: BorderRadius.all(Radius.circular(Dimensions.height30))),
                  ),
                ),
              ),
              Positioned(
                right: 5,
                top: 0,
                child: GestureDetector(
                  onTap: () async {
                    ImageManager manager = ImageManager();
                    var result = await manager.existOrNot(controller.photoList[photoIndex].imageName.toString());
                    if(result.toString()=="true"){
                      ImageModel dynamic = await manager.getImageByImageName(controller.photoList[photoIndex].imageName.toString());
                      await manager.deleteImage(dynamic.rowID!);
                    }

                    controller.photoList.removeAt(photoIndex);
                    if(controller.photoList.isEmpty){
                      uploadPromoPicturesController.enableButton.value = false;
                    }else{
                      uploadPromoPicturesController.enableButton.value = true;
                    }

                    uploadPromoPicturesController.update();
                  },
                  child: Image.asset(
                    Assets.icClose2,
                    height: Dimensions.height18,
                    width: Dimensions.height18,
                  ),
                ),
              )
            ],
          )
              : Image.asset(
            Assets.icAddedPhotoWithCross,
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

    if(controller.photoList[photoIndex].imageNote!=null) {
      controller.photoList[photoIndex].controller!.text =
      controller.photoList[photoIndex].imageNote!;
    }
    return TextField(
      maxLines: null,
      controller: controller.photoList[photoIndex].controller,
      keyboardType: TextInputType.text,
      onChanged: (val){
        uploadPromoPicturesController.enableButton.value = true;
        uploadPromoPicturesController.update();
        controller.photoList[photoIndex].imageNote = val.toString();
      },
      cursorColor: ColourConstants.primary,
      style: TextStyle(
          color: Get.isDarkMode ? ColourConstants.white : ColourConstants.black,
          fontWeight: FontWeight.w400,
          fontSize: Dimensions.font13),
      decoration: InputDecoration(
        isDense: true,
        // Added this
        contentPadding: EdgeInsets.symmetric(horizontal: Dimensions.height10, vertical: Dimensions.height13),
        labelText: addNotes,
        labelStyle: TextStyle(color: Get.isDarkMode ? ColourConstants.white :  ColourConstants.greyText, fontWeight: FontWeight.w400),
        //floatingLabelStyle: TextStyle(color: !isValidPhone ? ColourConstants.red : ColourConstants.black54),
        //errorText: !isValidPhone ? jobNumberValidation : null,
        suffixIconConstraints: BoxConstraints(minHeight: Dimensions.height25, minWidth: Dimensions.height25),
        suffixIcon: GestureDetector(
          onTap: () {
            if (uploadPromoPicturesController.speechToText.value.isNotListening) {
              uploadPromoPicturesController.startListening(photoIndex, i);

            } else {
              uploadPromoPicturesController.stopListening();
            }
          },
          child: Padding(
            padding: EdgeInsets.only(right: Dimensions.height11, left: Dimensions.height8),
            child: controller.photoList[photoIndex].isListening? Image.asset(
              Assets.icMic,
              height: Dimensions.height25,
              width: Dimensions.height25,
              color: Colors.blue,
            ): Image.asset(
              Assets.icMic,
              height: Dimensions.height25,
              width: Dimensions.height25,
              color: Get.isDarkMode?ColourConstants.white:null,
            ),
          ),
        ),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary)),
        border: UnderlineInputBorder(borderSide: BorderSide(color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary)),
        disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary)),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary)),
        filled: true,
        fillColor: Get.isDarkMode ? ColourConstants.black : ColourConstants.textFieldFillColor,

      ),
    );
  }
}
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/repository/database_managers/app_internet_manager.dart';
import 'package:on_sight_application/screens/field_issue/view_model/field_issue_controller.dart';
import 'package:on_sight_application/screens/field_issue/view_model/photo_comment_controller.dart';
import 'package:on_sight_application/utils/connectivity.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dialogs.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/strings.dart';

class FieldIssuePhotoScreen extends StatefulWidget {
  const FieldIssuePhotoScreen({Key? key}) : super(key: key);

  @override
  State<FieldIssuePhotoScreen> createState() => _FieldIssuePhotoScreenState();
}

class _FieldIssuePhotoScreenState extends State<FieldIssuePhotoScreen> {

  ///  photo comment controller variable
  PhotoCommentController photoCommentController = Get.find<PhotoCommentController>();
  ///  field issue controller variable
  FieldIssueController controller = Get.find<FieldIssueController>();

  @override
  initState(){
    super.initState();
    photoCommentController.initSpeech();
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
              color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,
              size: Dimensions.height25,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          elevation: 0.0,
          backgroundColor: Get.isDarkMode ? ColourConstants.black : ColourConstants.white,
          title: Text(addPhotoComment,
              style: TextStyle(
                  color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: Dimensions.font16),
          ),
          actions: [
           GestureDetector(
             onTap: (){
               showModalBottomSheet(
                 //  backgroundColor: Get.isDarkMode ? ColourConstants.grey900 : ColourConstants.white,
                   shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.only(
                           topLeft: Radius.circular(Dimensions.height10),
                           topRight: Radius.circular(Dimensions.height10),
                       ),
                   ),
                   isScrollControlled: true,
                   context: context,
                   builder: (context) =>  bottomSheetImagePickerFieldIssue(smallUpdateStr),
               );
             },
               child:  Image.asset(
               Assets.icAdd,
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
            bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
            if (isNetActive) {
              photoCommentController.enableButton.value = false;
              controller.update();
              var connectivityResult = await (Connectivity().checkConnectivity());
              if (connectivityResult == ConnectivityResult.wifi) {
                photoCommentController.submitApi();
              }else{
                AppInternetManager appInternetManager = AppInternetManager();
                var a = await appInternetManager.getSettingsTable();
                if(a[0][appInternetStatus] == 1){
                  photoCommentController.submitApi();
                }else{
                  photoCommentController.submitApi(showSnackBar: true);
                }
              }
            }
          },
          child: Container(
            height: Dimensions.height50,
            margin: EdgeInsets.only(left: Dimensions.height35, right: Dimensions.height35, bottom: Dimensions.height16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(Dimensions.height8)),
                color: photoCommentController.enableButton.isTrue?ColourConstants.primary:ColourConstants.grey),
            child: Center(
                child: Text(
                  submit,
                  style: TextStyle(
                      color: ColourConstants.white,
                      fontWeight: FontWeight.w300,
                      fontSize: Dimensions.font16),
                )),
          ),
        )
        ),
        body: Obx(() =>
            GestureDetector(
              onTap: (){
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    textField(),
                    photoWidget(),
                  ],
                ),
              ),
            )
        ));
  }

  /// job photo note text field widget
  Widget textField() {

    return Padding(
      padding:  EdgeInsets.all(Dimensions.height20),
      child: TextField(
      maxLines: null,
      controller: photoCommentController.commentController,
      keyboardType: TextInputType.text,
      cursorColor: ColourConstants.primary,
      onChanged: (val){
          photoCommentController.validate();
          controller.requestModel.value.comment = val.toString();
          controller.requestModel.refresh();
          controller.update();
        },
      style: TextStyle(
          color: Get.isDarkMode ? ColourConstants.white : ColourConstants.black,
          fontWeight: FontWeight.w400,
          fontSize: Dimensions.font13),
      decoration: InputDecoration(
        isDense: true,
        // Added this
        contentPadding:
        EdgeInsets.symmetric(horizontal: Dimensions.height10, vertical: Dimensions.height13),
        labelText: addComment,
        labelStyle: const TextStyle(color: ColourConstants.greyText, fontWeight: FontWeight.w400),
        suffixIconConstraints: BoxConstraints(minHeight: Dimensions.height25, minWidth: Dimensions.height25),
        suffixIcon: GestureDetector(
          onTap: () {
            if (photoCommentController.speechToText.value.isNotListening) {
              photoCommentController.startListening();
            } else {
              photoCommentController.stopListening();
            }
          },
          child: Padding(
            padding: EdgeInsets.only(right: Dimensions.height11, left: Dimensions.height8),
            child: photoCommentController.isListening.isTrue? Image.asset(
              Assets.icMicUnMute,
              height: Dimensions.height25,
              width: Dimensions.height25,
              color: Colors.blue,
            ): Image.asset(
              Assets.icMicMute,
              height: Dimensions.height25,
              width: Dimensions.height25,
              color: Get.isDarkMode ? ColourConstants.white : null,
            ),
          ),
        ),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ColourConstants.primary)),
        border: const UnderlineInputBorder(borderSide: BorderSide(color: ColourConstants.primary)),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ColourConstants.primary)),
        errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ColourConstants.red)),
        focusedErrorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ColourConstants.red)),
        filled: true,
        fillColor: Get.isDarkMode ? ColourConstants.grey900 : ColourConstants.textFieldFillColor,
      ),
    ),);
  }

  /// Photo Widget
  Widget photoWidget() {

    return Padding(
      padding: EdgeInsets.all(Dimensions.height20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: photoCommentController.photoList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4),
        itemBuilder: (BuildContext context, int index) {
          return Stack(
            children: [
              GestureDetector(
                onTap: (){
                  singleImageDialog(image: photoCommentController.photoList[index].imagePath??"", context: context);
                },
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.height5),
                  child: Container(
                    height: Dimensions.height60,
                    width: Dimensions.height60,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(File(photoCommentController.photoList[index].imagePath!)),
                            fit: BoxFit.fill),
                        borderRadius: BorderRadius.all(Radius.circular(Dimensions.height30))),
                  ),
                ),
              ),
              Positioned(
                right: Dimensions.height17,
                top: Dimensions.height2,
                child: GestureDetector(
                  onTap: () async {
                   photoCommentController.photoList.removeAt(index);
                   photoCommentController.photoList.refresh();
                   photoCommentController.update();
                   if(photoCommentController.photoList.length==0){
                     photoCommentController.enableButton.value = false;
                     photoCommentController.update();
                   }
                  },
                  child: Image.asset(
                    Assets.icClose,
                    height: Dimensions.height18,
                    width: Dimensions.height18,
                  ),
                ),
              )
            ],
          );
        },
      )


    );
  }
}

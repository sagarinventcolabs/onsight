import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/screens/field_issue/view_model/field_issue_controller.dart';
import 'package:on_sight_application/screens/field_issue/view_model/photo_comment_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/strings.dart';

class FieldIssueCommentScreen extends StatefulWidget {
  const FieldIssueCommentScreen({Key? key}) : super(key: key);

  @override
  State<FieldIssueCommentScreen> createState() =>
      _FieldIssueCommentScreenState();
}

class _FieldIssueCommentScreenState extends State<FieldIssueCommentScreen> {
  PhotoCommentController photoCommentController =
      Get.find<PhotoCommentController>();

  FieldIssueController controller = Get.find<FieldIssueController>();


  @override
  initState() {
    super.initState();
    photoCommentController.initSpeech();
    photoCommentController.commentButton.value = false;
    photoCommentController.update();
  }

  @override
  void dispose() {
    photoCommentController.stopListening();
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
              color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,
              size: Dimensions.height25,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          elevation: 0.0,
          backgroundColor: Get.isDarkMode ? ColourConstants.black : ColourConstants.white,
          title: Text(addComment,
              style: TextStyle(
                  color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: Dimensions.font18)),
        ),
        bottomNavigationBar: Obx(() => GestureDetector(
              onTap: () async {
                if(photoCommentController.commentButton.isTrue) {
                  setState(() {
                    photoCommentController.commentButton.value = false;
                  });
                  Timer(Duration(seconds: 4),(){
                    setState(() {
                      photoCommentController.commentButton.value = true;
                    });
                  });
                  print(controller.requestModel.value.toJson());
                  await controller.createCaseWithComment();
                }
              },
              child: Container(
                height: Dimensions.height50,
                margin: EdgeInsets.only(left: Dimensions.height35, right: Dimensions.height35, bottom: Dimensions.height16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(Dimensions.height8)),
                    color: photoCommentController.commentButton.isTrue
                        ? ColourConstants.primary
                        : ColourConstants.grey),
                child: Center(
                    child: Text(
                  submit,
                  style: TextStyle(
                      color: ColourConstants.white,
                      fontWeight: FontWeight.w300,
                      fontSize: Dimensions.font16),
                )),
              ),
            )),
        body: Obx(() => textField()));
  }

  /// comment field issue text field widget
  Widget textField() {
    return Padding(
      padding: EdgeInsets.all(Dimensions.height20),
      child: TextField(
        maxLines: null,
        controller: photoCommentController.commentController,
        keyboardType: TextInputType.text,
        cursorColor: ColourConstants.primary,
        onChanged: (val){
          photoCommentController.validate();
          controller.requestModel.value.comment = val.toString();
          if(val.isEmpty){
            photoCommentController.commentButton.value = false;
            photoCommentController.update();
          }
        },
        style: TextStyle(
            color: Get.isDarkMode ? ColourConstants.white : ColourConstants.black,
            fontWeight: FontWeight.w400,
            fontSize: Dimensions.font13),
        decoration: InputDecoration(
          isDense: true,
          // Added this
          contentPadding: EdgeInsets.symmetric(horizontal: Dimensions.height10, vertical: Dimensions.height13),
          labelText: addComment,
          labelStyle: const TextStyle(
              color: ColourConstants.greyText, fontWeight: FontWeight.w400),
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
              child: photoCommentController.isListening.isTrue
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
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ColourConstants.primary)),
          border: UnderlineInputBorder(borderSide: BorderSide(color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary)),
          errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ColourConstants.red)),
          focusedErrorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ColourConstants.red)),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary)),
          filled: true,
          fillColor: Get.isDarkMode ? Colors.grey.shade900 : ColourConstants.textFieldFillColor,
        ),
      ),
    );
  }

}

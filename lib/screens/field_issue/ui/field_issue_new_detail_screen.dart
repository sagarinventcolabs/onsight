import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/screens/field_issue/view_model/field_issue_controller.dart';
import 'package:on_sight_application/screens/field_issue/view_model/photo_comment_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dialogs.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';
import 'package:on_sight_application/utils/strings.dart';


class FieldIssueDetailScreen extends StatefulWidget {

  const FieldIssueDetailScreen({Key? key}) : super(key: key);

  @override
  State<FieldIssueDetailScreen> createState() => _FieldIssueDetailScreenState();
}

class _FieldIssueDetailScreenState extends State<FieldIssueDetailScreen> {

  // Field Issue Controller variable
  FieldIssueController controller = Get.find<FieldIssueController>();
  //Photo Comment Controller variable
  PhotoCommentController photoCommentController = Get.put(PhotoCommentController());

/// initialize class.....
  @override
  void initState() {
    super.initState();
    controller.initSpeech();
    controller.requestModel.value.userFirstName = sp?.getString(Preference.FIRST_NAME)??"";
    controller.requestModel.value.userLastName = sp?.getString(Preference.LAST_NAME)??"";
    controller.requestModel.value.userFullName = controller.requestModel.value.userFirstName.toString()+" "+controller.requestModel.value.userLastName.toString();
    controller.isValidTitle.value = true;
  }

  /// main widget.......
  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Image.asset(
            Assets.appBarLeadingButton,
            color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,
            height: Dimensions.height25,
            width: Dimensions.height25,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        elevation: 0.0,
        backgroundColor: Get.isDarkMode ? ColourConstants.black : ColourConstants.white,
        title: Text(controller.requestModel.value.workOrderNumber??"",
            style: TextStyle(
                color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.font16)),
      ),
      body: Obx(()=>  SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(Dimensions.height20, Dimensions.height20, Dimensions.height20, 0),
              child: Text(addDetails,
                style: TextStyle(
                    fontSize: Dimensions.font16,
                    fontWeight:FontWeight.w700,
                    color: Get.isDarkMode ? ColourConstants.white : ColourConstants.textColour
                ),),),
            Container(
              margin: EdgeInsets.all(Dimensions.height20),
              constraints: BoxConstraints(
                  minHeight: Dimensions.height50
              ),
              child: TextField(
                  keyboardType: TextInputType.text,
                  controller: controller.titleController,
                  onChanged: (val){
                    controller.requestModel.value.title = val;
                    controller.requestModel.refresh();
                    // controller.checkValidTitle();
                    controller.isValidTitle.value = true;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(regexToRemoveEmoji)),
                    FilteringTextInputFormatter.deny(RegExp("0-9"))
                  ],
                  decoration: InputDecoration(
                    label: Text.rich(TextSpan(
                      children: [
                        TextSpan(
                          text: addTitle,
                        ),
                        TextSpan(
                            text: "*",
                          style: TextStyle(color: ColourConstants.red)
                        ),
                      ]
                    ),
                    ),
                    labelStyle: TextStyle(color: Get.isDarkMode ? ColourConstants.white : Colors.black54),
                    floatingLabelStyle: TextStyle(color: controller.isValidTitle.isFalse ? ColourConstants.red : ColourConstants.primary),
                    errorText: controller.isValidTitle.isFalse ? pleaseEnterTitleFirst : null,
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Get.isDarkMode ? ColourConstants.white : ColourConstants.borderGreyColor)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: ColourConstants.primary)),
                    border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary)),
                    errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: ColourConstants.red)),
                    focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: ColourConstants.red)),
                  )
              ),
            ),
            textField(),

            SizedBox(height: Dimensions.height20,),
            Padding(
              padding: EdgeInsets.fromLTRB(Dimensions.height20, Dimensions.height20, Dimensions.height20, 0),
              child: Text(chooseType,
                style: TextStyle(
                    fontSize: Dimensions.font16,
                    fontWeight:FontWeight.w700,
                    color: Get.isDarkMode ? ColourConstants.white : ColourConstants.textColour
                ),
              ),
            ),

            Padding(
                padding:  EdgeInsets.fromLTRB(Dimensions.height20, Dimensions.height20, Dimensions.height20, 0),
                child: GestureDetector(
                  onTap: (){
                    controller.selectedOption.value = "0";
                    FocusScope.of(context).unfocus();
                    if(controller.checkValidTitle()) {
                      PhotoCommentController photoCommentController = Get.find<PhotoCommentController>();
                      photoCommentController.photoList.clear();
                      photoCommentController.commentController.clear();
                      showModalBottomSheet(
                          backgroundColor: Get.isDarkMode ? Colors.grey.shade900 : ColourConstants.white,
                          //backgroundColor: Color.fromARGB(255, 0, 0, 0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(Dimensions.height10),
                                  topRight: Radius.circular(Dimensions.height10))),
                          isScrollControlled: true,
                          context: context,
                          builder: (context) => bottomSheetImagePickerFieldIssue(add));
                    }
                  },
                  child:  Container(
                      color: Get.isDarkMode ? Colors.grey.shade900 : ColourConstants.white,
                      child: Padding(
                        padding:  EdgeInsets.all(Dimensions.height10),
                        child: Row(
                          children: [
                            Flexible(
                                flex: 1,
                                child: Image.asset(Assets.galleryAdd, height: Dimensions.height40, width: Dimensions.height40)),
                            Expanded(
                                flex: 5,
                                child: Padding(padding: EdgeInsets.only(left: Dimensions.height10),
                                    child: Text(addPhoto,  style: TextStyle(
                                        color: Get.isDarkMode ? ColourConstants.white : ColourConstants.textColour,
                                        fontWeight: FontWeight.w700,
                                        fontSize: Dimensions.font16)))),
                          ],
                        ),
                      )
                  ),
                )
            ),

            Padding(
                padding:  EdgeInsets.fromLTRB(Dimensions.height20, Dimensions.height20, Dimensions.height20, 0),
                child: GestureDetector(
                  onTap: (){
                    FocusScope.of(context).unfocus();
                    controller.selectedOption.value = "1";
                    photoCommentController.commentController.clear();
                    if(controller.checkValidTitle()) {
                      Get.toNamed(Routes.fieldIssueCategoryScreen,
                          arguments: Routes.fieldIssueDetailScreen);
                    }
                  },
                  child: Container(
                      color: Get.isDarkMode ? Colors.grey.shade900 : ColourConstants.white,
                      child: Padding(
                        padding:  EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Flexible(
                                flex: 1,
                                child: Image.asset(Assets.icAddComment, height: Dimensions.height40, width: Dimensions.height40)),
                            Expanded(
                                flex: 5,
                                child: Padding(padding: EdgeInsets.only(left: Dimensions.height10),
                                    child: Text(addComment,  style: TextStyle(
                                        color: Get.isDarkMode ? ColourConstants.white : ColourConstants.textColour,
                                        fontWeight: FontWeight.w700,
                                        fontSize: Dimensions.font16,
                                       ),
                                    ),
                                ),
                            ),
                          ],
                        ),
                      )
                  ),
                )
            )
          ],
        ),
      )),

    );
  }


  /// Field Issue  description text field widget
  Widget textField() {

    return Padding(
      padding: EdgeInsets.fromLTRB(Dimensions.height20, 0, Dimensions.height20, Dimensions.height20),
      child: TextField(
        maxLines: null,
        keyboardType: TextInputType.text,
        cursorColor: ColourConstants.primary,
        controller: controller.descriptionController,
        onChanged: (value){
          controller.requestModel.value.description = value;
          controller.requestModel.refresh();
        },
        style: TextStyle(
            color: Get.isDarkMode ? ColourConstants.white : ColourConstants.black,
            fontWeight: FontWeight.w400,
            fontSize: Dimensions.font13),
        decoration: InputDecoration(
          isDense: true,
          // Added this
          contentPadding: EdgeInsets.symmetric(horizontal: Dimensions.height10, vertical: Dimensions.height13),
          labelText: description,
          labelStyle: TextStyle(fontSize: Dimensions.font15, color: ColourConstants.greyText, fontWeight: FontWeight.w400),
          suffixIconConstraints: BoxConstraints(minHeight: Dimensions.height25, minWidth: Dimensions.height25),
          suffixIcon: GestureDetector(
            onTap: () {
              if (controller.speechToText.value.isNotListening) {
                controller.startListening();
              } else {
                controller.stopListening();
              }
            },
            child: Padding(
              padding: EdgeInsets.only(right: Dimensions.height11, left: Dimensions.height8),
              child: controller.isListening.isTrue?Image.asset(
                Assets.icMicUnMute,
                height: Dimensions.height20,
                width: Dimensions.height20,
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
          focusedErrorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ColourConstants.red)),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary)),
          disabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ColourConstants.primary)),
          errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ColourConstants.red)),
          filled: true,
          fillColor: Get.isDarkMode ? Colors.grey.shade900 : ColourConstants.textFieldFillColor,
        ),
      ),);
  }

/// Dispose Class............
  @override
  void dispose() {
    super.dispose();
    controller.descriptionController.clear();
    controller.titleController.clear();
  }
}

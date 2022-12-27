import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/screens/project_evaluation/view_model/project_evaluation_controller.dart';
import 'package:on_sight_application/screens/project_evaluation/view_model/project_evaluation_install_controller.dart';
import 'package:on_sight_application/utils/connectivity.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/strings.dart';

class ProjectEvaluationInstallScreen extends StatefulWidget {
  const ProjectEvaluationInstallScreen({Key? key}) : super(key: key);

  @override
  State<ProjectEvaluationInstallScreen> createState() =>
      _ProjectEvaluationInstallScreenState();
}

class _ProjectEvaluationInstallScreenState extends State<ProjectEvaluationInstallScreen> {
  /// putting upload job photos controller
  ProjectEvaluationInstallController projectEvaluationInstallC =
      Get.find<ProjectEvaluationInstallController>();
  ProjectEvaluationController controller =
      Get.find<ProjectEvaluationController>();
  ScrollController scrollController = ScrollController();
  var id = "";


  @override
  void initState() {
    super.initState();
    //id = Get.arguments;
    id = "0";

    projectEvaluationInstallC.initSpeech();
    projectEvaluationInstallC.additionalTextController.clear();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      projectEvaluationInstallC.validate();
    });
    projectEvaluationInstallC.additionalTextController.text = projectEvaluationInstallC.model!.comments.toString();
  }


  @override
  Widget build(BuildContext context) {
    Theme.of(context) == Brightness.dark;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,
              size: Dimensions.font25,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          elevation: 0.0,
          backgroundColor: Get.isDarkMode ? ColourConstants.black : ColourConstants.white,
          title:Text(controller.jobPhotosModellist.first.jobNumber.toString(),
              style: TextStyle(
                  color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: Dimensions.font16),
          ),
        ),
        bottomNavigationBar: Obx(()=> GestureDetector(
          onTap: () async {
            if(projectEvaluationInstallC.enableButton.isTrue) {
              var body = projectEvaluationInstallC.createFinalJson();
              bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
              if(isNetActive) {
                projectEvaluationInstallC.checkEvaluationExistornot(Get.context,
                    controller.jobPhotosModellist.first.jobNumber!.toString(),
                    projectEvaluationInstallC.model!.categoryName.toString(),
                    body);
              }else{
                Get.snackbar(alert, pleaseCheckInternet);
              }
            }
          },
          child: Container(
            height: Dimensions.height50,
            margin: EdgeInsets.only(left: Dimensions.height35, right: Dimensions.height35, bottom: Dimensions.height16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(Dimensions.radius8)),
                color: projectEvaluationInstallC.enableButton.isTrue?ColourConstants.primary:ColourConstants.grey),
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
        body: Obx(()=> ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: Dimensions.height16),
          controller: scrollController,
          children: [
            ListView.builder(
                shrinkWrap: true,
                controller: scrollController,
                itemCount: projectEvaluationInstallC.questionList.length,
                itemBuilder: (context, index){
                  return imageNoteWidget(index);
                }),
            SizedBox(height: Dimensions.height16),
            additionalTextField(),
            SizedBox(height: Dimensions.height16),
          ],
        ))

    );
  }

  /// define image with note widget
  Widget imageNoteWidget(index) {
    return Padding(
      padding: EdgeInsets.only(top: Dimensions.height16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: projectEvaluationInstallC.questionList[index].question.toString(),
              style: TextStyle(
                  color: Get.isDarkMode ? ColourConstants.white : ColourConstants.greyText,
                  fontWeight: FontWeight.w400,
                  fontSize: Dimensions.font16),
              children: <TextSpan>[
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                      color: ColourConstants.red,
                      fontWeight: FontWeight.w500,
                      fontSize: Dimensions.font15),
                ),
              ],
            ),
          ),
          SizedBox(height: Dimensions.font14),
          Row(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: Dimensions.height25,
                    width: Dimensions.height25,
                    child: Theme(
                      data: ThemeData(
                        unselectedWidgetColor:
                            ColourConstants.grey.withOpacity(.5), // Your color
                      ),
                      child: Radio<bool>(
                        value:true,
                        groupValue: projectEvaluationInstallC.questionList[index].answer,
                        //checkColor: ColourConstants.white,
                        activeColor: ColourConstants.greenColor,
                        onChanged: (value) {

                          projectEvaluationInstallC.questionList[index].selected = value;
                          projectEvaluationInstallC.questionList[index].answer = value;
                          projectEvaluationInstallC.toggleVisibility(index, value);
                          projectEvaluationInstallC.validate();
                        },
                        // onChanged:(int? newValue){
                        //   controller.updateChecked(index, newValue);
                        // },
                      ),
                    ),
                  ),
                  SizedBox(width: Dimensions.height10),
                  Text(Yes,
                      style: TextStyle(
                          color: Get.isDarkMode ? ColourConstants.white : ColourConstants.greyText,
                          fontWeight: FontWeight.w400,
                          fontSize: Dimensions.font14)),
                ],
              ),
              SizedBox(width: Dimensions.font35),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: Dimensions.font25,
                    width: Dimensions.font25,
                    child: Theme(
                      data: ThemeData(
                        unselectedWidgetColor:
                            ColourConstants.grey.withOpacity(.5), // Your color
                      ),
                      child: Radio<bool>(
                        value: false,
                        groupValue: projectEvaluationInstallC.questionList[index].answer,
                        //checkColor: ColourConstants.white,
                        activeColor: ColourConstants.greenColor,
                        onChanged: (value) {

                          projectEvaluationInstallC.questionList[index].selected = value;
                          projectEvaluationInstallC.questionList[index].answer = value;
                          projectEvaluationInstallC.toggleVisibility(index, value);
                          projectEvaluationInstallC.validate();
                        },
                        // onChanged:(int? newValue){
                        //   controller.updateChecked(index, newValue);
                        // },
                      ),
                    ),
                  ),
                  SizedBox(width: Dimensions.font10),
                  Text(No,
                      style: TextStyle(
                          color: Get.isDarkMode ? ColourConstants.white : ColourConstants.greyText,
                          fontWeight: FontWeight.w400,
                          fontSize: Dimensions.font14)),
                ],
              ),
            ],
          ),
          SizedBox(height: Dimensions.font10),
          Visibility(
              visible:  projectEvaluationInstallC.questionList[index].visible,
              child: textField(index))
        ],
      ),
    );
  }

  /// Answer text field widget
  Widget textField(photoIndex) {
    projectEvaluationInstallC.questionList[photoIndex].explainController?.text = projectEvaluationInstallC.questionList[photoIndex].details ??"";
    return TextField(
      maxLines: null,
      controller: projectEvaluationInstallC.questionList[photoIndex].explainController,
      keyboardType: TextInputType.text,
      cursorColor: ColourConstants.primary,
      onChanged: (val){
        projectEvaluationInstallC.questionList[photoIndex].details = val.toString();
        projectEvaluationInstallC.validate();
      },
      style: TextStyle(
          color: Get.isDarkMode ? ColourConstants.white : ColourConstants.black,
          fontWeight: FontWeight.w400,
          fontSize: Dimensions.font13),
      decoration: InputDecoration(
        isDense: true,
        // Added this
        contentPadding:
        EdgeInsets.symmetric(horizontal: Dimensions.font10, vertical: Dimensions.font13),
        hintText: explain,
        hintStyle: TextStyle(
            color: Get.isDarkMode ? ColourConstants.white : ColourConstants.greyText,
            fontWeight: FontWeight.w500,
            fontSize: Dimensions.font14),
        //floatingLabelStyle: TextStyle(color: !isValidPhone ? ColourConstants.red : ColourConstants.black54),
        //errorText: !isValidPhone ? jobNumberValidation : null,
        suffixIconConstraints: BoxConstraints(minHeight: Dimensions.font25, minWidth: Dimensions.font25),
        suffixIcon: GestureDetector(
          onTap: () {
            if (projectEvaluationInstallC.speechToText.value.isNotListening) {
              projectEvaluationInstallC.startListening(photoIndex);
            } else {
              projectEvaluationInstallC.stopListening();
            }
          },
          child: Padding(
            padding: EdgeInsets.only(right: Dimensions.font11, left: Dimensions.font8),
            //child: Icon(_uploadJobPhotosC.speechToText.value.isNotListening ? Icons.mic_off : Icons.mic,size: 25,color: ColourConstants.greyText,),
            child: projectEvaluationInstallC.questionList[photoIndex].isListening
                ?Image.asset(
              Assets.ic_mic,
              height: Dimensions.font25,
              width: Dimensions.font25,
              color: Colors.blue,
            ):Image.asset(
              Assets.ic_mic,
              height: Dimensions.font25,
              width: Dimensions.font25,
              color: Get.isDarkMode ? ColourConstants.white : null,
            ),
          ),
        ),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary)),
        border: UnderlineInputBorder(borderSide: BorderSide(color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary)),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary)),
        disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary)),
        filled: true,
        fillColor: Get.isDarkMode ? ColourConstants.grey900 : ColourConstants.textFieldFillColor,
      ),
    );
  }

  /// Answer text field widget
  Widget additionalTextField() {
    return TextField(
      maxLines: null,
      controller:projectEvaluationInstallC.additionalTextController,
      keyboardType: TextInputType.text,
      cursorColor: ColourConstants.primary,
      onChanged: (val){
        projectEvaluationInstallC.model?.comments = val.toString();
      },
      style: TextStyle(
          color: Get.isDarkMode ? ColourConstants.white : ColourConstants.black,
          fontWeight: FontWeight.w400,
          fontSize: Dimensions.font13),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: Dimensions.font10, vertical: Dimensions.font13),
        labelText: additionalComments,
        labelStyle: TextStyle(
            color: Get.isDarkMode ? ColourConstants.white : ColourConstants.greyText,
            fontWeight: FontWeight.w500,
            fontSize: Dimensions.font14),
        //floatingLabelStyle: TextStyle(color: !isValidPhone ? ColourConstants.red : ColourConstants.black54),
        //errorText: !isValidPhone ? jobNumberValidation : null,
        suffixIconConstraints: BoxConstraints(minHeight: Dimensions.font25, minWidth: Dimensions.font25),
        suffixIcon: GestureDetector(
          onTap: () {
            if (projectEvaluationInstallC.speechToText.value.isNotListening) {
              projectEvaluationInstallC.startListeningAdditional();
            } else {
              projectEvaluationInstallC.stopListening();
            }
          },
          child: Padding(
            padding: EdgeInsets.only(right: Dimensions.font11, left: Dimensions.font8),
            child: projectEvaluationInstallC.isListening.isTrue?
            Image.asset(
              Assets.ic_mic,
              height: Dimensions.font25,
              width: Dimensions.font25,
              color: Colors.blue,
            ):Image.asset(
              Assets.ic_mic,
              height: Dimensions.font25,
              width: Dimensions.font25,
              color: Get.isDarkMode ? ColourConstants.white : null,
            ),
          ),
        ),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary)),
        border: UnderlineInputBorder(borderSide: BorderSide(color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary)),
        disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary)),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary)),
        filled: true,
        fillColor: Get.isDarkMode ? ColourConstants.grey900 : ColourConstants.textFieldFillColor,

      ),
    );
  }

  @override
  void dispose(){
    projectEvaluationInstallC.stopListening();
    super.dispose();
    projectEvaluationInstallC.enableButton.value = false;
    projectEvaluationInstallC.questionList.clear();
    projectEvaluationInstallC.update();

  }
}

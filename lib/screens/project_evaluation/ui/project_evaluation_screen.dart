import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/screens/project_evaluation/view_model/project_evaluation_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/functions/SearchFunctions.dart';
import 'package:on_sight_application/utils/functions/functions.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:on_sight_application/utils/widgets/base_typeahead.dart';

class ProjectEvaluationScreen extends StatefulWidget {
  const ProjectEvaluationScreen({Key? key}) : super(key: key);

  @override
  ProjectEvaluationScreenState createState() => ProjectEvaluationScreenState();
}

class ProjectEvaluationScreenState extends State<ProjectEvaluationScreen>  with SearchFunctions{
  TextEditingController projectEvaluationController =  TextEditingController(text: "");
  bool _enableButton = false;
  FocusNode projectEvaluationFocusNode = FocusNode();
  bool buttonEnable = false;
  ProjectEvaluationController controller = Get.find<ProjectEvaluationController>();
  bool checkedValue= false;

  final ScrollController _scrollController = ScrollController();

  void _scrollDown() {
    Future.delayed(const Duration(seconds: 1), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200),
        curve: Curves.fastOutSlowIn,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    controller.isValidJobNumber.value = true;
  }

  @override
  Widget build(BuildContext context) {
    (Theme.of(context) == Brightness.dark);
    return  Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(icon:  Image.asset(Assets.appBarLeadingButton,color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,height: Dimensions.height25,width: Dimensions.height25,), onPressed: () {
           Get.offAllNamed(Routes.dashboardScreen);
          },),
          elevation: 0.0,
          backgroundColor: Get.isDarkMode ? ColourConstants.black : ColourConstants.white,
          title: Text(projectEvaluation, style: TextStyle(color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,fontWeight: FontWeight.bold, fontSize: Dimensions.font17)),
        ),
        bottomNavigationBar: GestureDetector(
          onTap: ()async{
            if(_enableButton) {
              setState(() {
                _enableButton = false;
              });
              Timer(Duration(seconds: 3),(){
                _enableButton = true;
              });
              AnalyticsFireEvent(ProjectEvaluation, input: {
                jobNumber:projectEvaluationController.text.toString(),
                user:sp?.getString(Preference.FIRST_NAME)??""
              });
              FocusScope.of(context).unfocus();
              saveSuggestion(projectEvaluationController.text);
              controller.value.value=1;
              controller.update();
              var response = await controller.getProjectEvaluationDetails(projectEvaluationController.text.toString(), checkedValue);
              if(response!=null){
                if(response.toString().contains(jobNumberIsNotFound)){
                  controller.updateIsValid(false);
                }
              }
            }
          },
          child: Container(
            height: Dimensions.height50,
            margin: EdgeInsets.only(bottom: Dimensions.height35,right: Dimensions.height20,left: Dimensions.height20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(Dimensions.radius8)),
                color:_enableButton? ColourConstants.primary : ColourConstants.grey
            ),
            child: Center(child: Text(submit, style: TextStyle(color: ColourConstants.white, fontWeight: FontWeight.w400, fontSize: Dimensions.font16),)),
          ),
        ),
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.height20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: Dimensions.height80),
                  Image.asset(Get.isDarkMode ? Assets.il_project_evaluation : Assets.ic_project_evalution,height: MediaQuery.of(context).size.height/4.3),
                  SizedBox(height: Dimensions.height50),
                  Obx(() => BaseTypeAhead(
                      controller: projectEvaluationController,
                      focusNode: projectEvaluationFocusNode,
                      onTap: (){
                        _scrollDown();
                      },
                      inputFormatters: [FilteringTextInputFormatter.deny(" "), FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9-]"))],
                      onChanged: (val){
                        _scrollDown();
                        controller.value.value = 0;
                        controller.update();
                        if(_validate()){
                          if(!_enableButton ){
                            setState(() {
                              _enableButton = true;
                            });
                          }
                        }else{
                          setState(() {
                            _enableButton = false;
                          });
                        }
                        if(val.length>4){
                          setState(() {
                            _enableButton = true;
                          });
                        }else{
                          setState(() {
                            _enableButton = false;
                            },
                          );
                        }
                      },
                    labelText: jobLabel,
                    floatingLabelStyle: TextStyle(color: controller.isValidJobNumber.isFalse ? Colors.red : Get.isDarkMode ? ColourConstants.white : ColourConstants.primary),
                    errorText: controller.isValidJobNumber.isFalse ? jobNumberValidation : null,
                    suggestionsCallback:getSuggestion,
                    onSuggestionSelected: (String? suggestion) {
                      final user = suggestion!;
                      projectEvaluationController.text = user;
                      controller.update();
                      if(_validate()){
                        if(!_enableButton ){
                          setState(() {
                            _enableButton = true;
                          });
                        }
                      }else{
                        setState(() {
                          _enableButton = false;
                        });
                      }
                    },
                  )),
                  SizedBox(height: Dimensions.height15),
                  Row(
                    children: [
                      SizedBox(
                        height: Dimensions.height20,
                        width: Dimensions.height20,
                        child: Theme(
                          data: ThemeData(
                            unselectedWidgetColor: ColourConstants.grey.withOpacity(.5), // Your color
                          ),
                          child: Checkbox(value: checkedValue,
                            checkColor: Get.isDarkMode ? ColourConstants.black : ColourConstants.white,
                            activeColor: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,
                            onChanged: (newValue) {
                              setState((){
                                checkedValue = newValue!;
                              });
                            },),
                        ),
                      ),
                      SizedBox(width: Dimensions.height8),
                      Text(downloadJobsRelatedShow,style:  TextStyle(fontWeight: FontWeight.normal, fontSize: Dimensions.font13)),
                    ],
                  ),
                  SizedBox(height: Dimensions.height100),
                ],
              ),
            ),
          ),
        )
    );
  }

  _validate() {
    if (projectEvaluationController.text.isEmpty) {
      setState(() {
        _enableButton = false;
      });
      return false;
    }else if(projectEvaluationController.text.length<4){
      setState(() {
        _enableButton = false;
      });
      return false;
    }else {
      controller.updateIsValid(true);
    }
    return true;
  }
}

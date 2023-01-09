import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/screens/field_issue/view_model/field_issue_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/functions/SearchFunctions.dart';
import 'package:on_sight_application/utils/functions/functions.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:on_sight_application/utils/widgets/base_typeahead.dart';
import 'package:on_sight_application/utils/widgets/custom_drop_down.dart';

class FieldIssues extends StatefulWidget {
  const FieldIssues({Key? key}) : super(key: key);

  @override
  FieldIssuesState createState() => FieldIssuesState();
}

class FieldIssuesState extends State<FieldIssues> with SearchFunctions{


  FocusNode jobFocusNode = FocusNode();
  FieldIssueController controller = Get.put(FieldIssueController());
  SuggestionsBoxController suggestionsBoxController = SuggestionsBoxController();

  final List<String> _locations = [
    jobNumber,
    showNumber,
    showName,
    exhibitorName
  ];
  String _selectedLocation = jobNumber;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

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
  Widget build(BuildContext context) {
    Theme.of(context) == Brightness.dark;
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
          title: Text(fieldIssues,
              style: TextStyle(
                  color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: Dimensions.font16)),
        ),
        bottomNavigationBar: Obx(() =>
            GestureDetector(
              onTap: () async {
                FocusScope.of(context).unfocus();
                if (controller.enableButton.isTrue) {
                  setState(() {
                    controller.enableButton.value = false;
                  });
                  Timer(Duration(seconds: 4),(){
                    setState(() {
                      controller.enableButton.value = true;
                    });
                  });
                  switch (_selectedLocation) {
                    case jobNumber:{
                      saveSuggestion(controller.jobEditingController.text.trim());
                      break;
                    }
                    case showNumber:{
                      saveShowNumberSuggestions(controller.jobEditingController.text.trim());
                      break;
                    }
                    case showName:{
                      saveShowNameHistory(controller.jobEditingController.text.trim());
                      break;
                    }
                    case exhibitorName:{
                      saveExhibitorNameHistory(controller.jobEditingController.text.trim());
                      break;
                    }
                  }
                  controller.selectedFieldIssue.value = _selectedLocation;
                  AnalyticsFireEvent(FieldIssueCategory, input: {
                    category: _selectedLocation,
                    value: controller.jobEditingController.text.trim(),
                    user:(sp?.getString(Preference.FIRST_NAME)??"")
                  });
                  if (_selectedLocation == jobNumber) {
                    controller.getJobDetails(controller.jobEditingController.text, false, true);
                  } else {
                    controller.getDetailsByShowNumber(
                        controller.jobEditingController.text.toString(),
                        _selectedLocation);
                  }
                }
              },
              child: Container(
                height: Dimensions.height50,
                margin: EdgeInsets.only(left: Dimensions.height20, right: Dimensions.height20, bottom: Dimensions.height35),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(Dimensions.height8)),
                    color: controller.enableButton.isTrue ? ColourConstants
                        .primary : ColourConstants.grey),
                child: Center(
                    child: Text(
                      next,
                      style: TextStyle(
                          color: ColourConstants.white,
                          fontWeight: FontWeight.w400,
                          fontSize: Dimensions.font16),
                    )),
              ),
            ),),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.height20),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        controller.value.value = 1;
                        controller.update();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/7),
                        child: Image.asset(
                          Assets.illFieldIssues,
                          width: Dimensions.height300,
                          height: MediaQuery.of(context).size.height/4.3,
                        ),
                      )
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height/20),
                  Obx(
                        () =>
                        Column(
                          children: [
                            dropdownContainer(),
                            SizedBox(
                              height: Dimensions.height30,
                            ),
                            GestureDetector(
                              onTap: (){
                                controller.value.value = 1;
                                controller.update();
                              },
                              child: BaseTypeAhead(
                                  controller: controller.jobEditingController,
                                  focusNode: jobFocusNode,
                                  onTap: (){
                                    _scrollDown();
                                  },
                                  onChanged: (val) {
                                    _scrollDown();
                                    print(val);
                                    if (val.toString().trim().isNotEmpty) {
                                      controller.value.value = 0;
                                      controller.isValidJobNumber.value = true;
                                      controller.update();
                                      if (_validate()) {
                                        if (controller.enableButton.isFalse) {
                                          controller.enableButton.value =
                                          true;
                                          controller.update();
                                        }
                                      } else {
                                        controller.enableButton.value = false;
                                        controller.update();
                                      }
                                      if (val.length > 4) {
                                        controller.enableButton.value = true;
                                        controller.update();
                                      } else {
                                        controller.enableButton.value = false;
                                        controller.update();
                                      }
                                    }else{
                                      controller.jobEditingController.text = "";
                                    }
                                  },
                                    labelText: "Enter "+_selectedLocation.toString(),
                                    floatingLabelStyle: TextStyle(
                                        color: controller.isValidJobNumber.isFalse
                                            ? ColourConstants.red
                                            : Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,
                                    ),
                                    errorText: controller.isValidJobNumber.isFalse
                                        ? detailsInvalid
                                        : null,
                                suggestionsCallback:getSuggestions,
                                onSuggestionSelected: (String? suggestion) {
                                  final user = suggestion!;
                                  controller.jobEditingController.text = user;
                                  controller.update();
                                  if(_validate()){
                                    if(!controller.enableButton.value ){
                                      setState(() {
                                        controller.enableButton.value = true;
                                      });
                                    }
                                  }else{
                                    setState(() {
                                      controller.enableButton.value = false;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                  ),
                  SizedBox(height: Dimensions.height100),
                ],
              ),
            )
        ));
  }

  List<String> getSuggestions(input){
    List<String> list = [];

    switch (_selectedLocation) {
      case jobNumber:{
        list = getSuggestion(input);
        break;
      }
      case showNumber:{
        list = getShowNumberSuggestion(input);
        break;
      }
      case showName:{
        list = getShowNameSuggestion(input);
        break;
      }
      case exhibitorName:{
        list = getExhibitorNameSuggestion(input);
        break;
      }
      default :{
        list = getSuggestion(input);
        break;
      }
    }

    return list;
  }

  _validate() {
    if (controller.jobEditingController.text.isEmpty) {
      controller.enableButton.value = false;
      controller.update();
      return false;
    } else if (controller.jobEditingController.text.length < 3) {
      controller.enableButton.value = false;
      controller.update();
      return false;
    } else {
      controller.enableButton.value = true;
      controller.updateisValid(true);
    }

    return true;
  }

  Widget dropdownContainer() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CustomDropdownButton(
          value: _selectedLocation,
          underline: SizedBox.shrink(),
          items: _locations.map((location) {
            return DropdownMenuItem(
              value: location,
              child: Text(location),
            );
          }).toList(),
          onChanged: (newValue) {
            getSuggestions("");
            controller.isValidJobNumber.value = true;
            controller.update();
            controller.jobEditingController.clear();
            setState(() {
              _selectedLocation = newValue.toString();
            });
            _validate();
            controller.update();
            setState(() {});
          },
        ),
        Positioned(
          left: 10, top: -7,
          child: Container(
            color: Get.isDarkMode ? ColourConstants.black : ColourConstants.labelBgColor,
            padding: EdgeInsets.symmetric(horizontal: Dimensions.height3, vertical: Dimensions.height2),
            child: Text(
              selectStr, style: TextStyle(color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary, fontSize: Dimensions.font11)),
          ),
        ),
      ],
    );
  }
}

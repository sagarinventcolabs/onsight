import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/screens/onboarding/view_model/onboarding_controller.dart';
import 'package:on_sight_application/screens/onboarding/view_model/onboarding_photos_controller.dart';
import 'package:on_sight_application/screens/onboarding/view_model/onboarding_resource_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/functions/SearchFunctions.dart';
import 'package:on_sight_application/utils/functions/functions.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:on_sight_application/utils/widgets/base_typeahead.dart';
import 'package:on_sight_application/utils/widgets/custom_drop_down.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  OnBoardingScreenState createState() => OnBoardingScreenState();
}

class OnBoardingScreenState extends State<OnBoardingScreen> with SearchFunctions{

  TextEditingController jobEditingController = TextEditingController(text: "");
  FocusNode jobFocusNode = FocusNode();
  bool buttonEnable = false;
  String selectedCategory = oasisEntry;
  OnboardingController controller = Get.put(OnboardingController());
  SuggestionsBoxController suggestionsBoxController = SuggestionsBoxController();
  OnboardingResourceController onboardingResourceController = Get.put(OnboardingResourceController());
  OnBoardingPhotosController onboardingPhotosController = Get.put(OnBoardingPhotosController());

  final List<String> optionList = [oasisEntry, fileDocuments];


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
          title: Text(onBoardingStr,
              style: TextStyle(
                  color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: Dimensions.font16)),
        ),
        bottomNavigationBar: Obx(()=>GestureDetector(
          onTap: () async {
            FocusScope.of(context).unfocus();
            if (controller.submitButton.isTrue) {
              saveShowNumberSuggestions(controller.showNumberController.text.trim());
              controller.submitButton.value = false;
              controller.isValidShowNumber.value = true;
              controller.update();
              Timer(const Duration(seconds: 3),(){
                controller.submitButton.value = true;
              });
              controller.update();
              await controller.getSheetDetails(controller.showNumberController.text, true);
            }
          },
          child: Container(
            height: Dimensions.height50,
            margin: EdgeInsets.only(left: Dimensions.height20, right: Dimensions.height20, bottom: Dimensions.height35),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(Dimensions.radius8)),
                color: controller.submitButton.isTrue ? ColourConstants.primary : ColourConstants.grey),
            child: Center(
                child: Text(
                  next,
                  style: TextStyle(
                      color: ColourConstants.white,
                      fontWeight: FontWeight.w400,
                      fontSize: Dimensions.font16),
                ),
            ),
          ),
        ),),
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.height20),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/14),
                    child: Image.asset(
                      Get.isDarkMode ? Assets.ilOnBoardingDark :Assets.illOnBoarding,
                      height: MediaQuery.of(context).size.height/4.3,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height/14),
                  Obx(
                        () => Column(
                      children: [
                        BaseTypeAhead(
                            controller: controller.showNumberController,
                            focusNode: jobFocusNode,
                            onTap: (){
                              _scrollDown();
                            },
                            onChanged: (val) {
                              _scrollDown();
                              controller.validate();
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp("[ ]")),
                            ],
                              labelText: showHash,
                              floatingLabelStyle: TextStyle(color: controller.isValidShowNumber.isFalse
                                      ? Colors.red
                                      : Get.isDarkMode ? ColourConstants.white : ColourConstants.primary),
                              errorText: controller.isValidShowNumber.isFalse
                                  ? showNumberValidation
                                  : null,
                          suggestionsCallback : getShowNumberSuggestion,
                          onSuggestionSelected: (String? suggestion) {
                            final user = suggestion!;
                            controller.showNumberController.text = user;
                            controller.update();
                            if(controller.validate()){
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
                        SizedBox(height: MediaQuery.of(context).size.height/35),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CustomDropdownButton(
                              underline: const SizedBox(),
                              value: selectedCategory,
                              style: TextStyle(color: Get.isDarkMode ? ColourConstants.white : ColourConstants.black),
                              onChanged: (newValue) {
                                controller.selectedOption.value = newValue.toString();
                                setState(() {
                                  selectedCategory = newValue.toString();
                                  controller.validate();
                                  controller.update();
                                });
                              },
                              items: optionList.map((location) {
                                return DropdownMenuItem(
                                  value: location,
                                  child: Text(location),
                                );
                              }).toList(),
                            ),
                            Positioned(
                              left: 10,top: -7,
                              child: Container(
                                color: Get.isDarkMode ? ColourConstants.black : ColourConstants.labelBgColor,
                                padding: EdgeInsets.symmetric(horizontal: 3,vertical: 2),
                                child: Text(selectCategory,style: TextStyle(color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary
                                    ,fontSize: Dimensions.font11)),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: Dimensions.height100,)
                ],
              ),
            )
          ),
        ));
  }
}

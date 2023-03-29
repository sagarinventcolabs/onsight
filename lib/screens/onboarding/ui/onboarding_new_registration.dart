import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/screens/onboarding/view_model/onboarding_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dialogs.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/functions/functions.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:on_sight_application/utils/widgets/base_text_field.dart';

class OnboardingNewRegistration extends StatefulWidget {
  const OnboardingNewRegistration({Key? key}) : super(key: key);

  @override
  State<OnboardingNewRegistration> createState() =>
      _OnboardingNewRegistrationState();
}

class _OnboardingNewRegistrationState extends State<OnboardingNewRegistration> {
  OnboardingController controller = Get.find<OnboardingController>();
  SuggestionsBoxController _suggestionsBoxController =
      SuggestionsBoxController();
  var unionSelected = 0;
  var lengthUnion = 0;


  FocusNode focusNodeFirstName = FocusNode();
  FocusNode focusNodeCity = FocusNode();
  FocusNode focusNodeLastName = FocusNode();
  FocusNode focusNodeSSN = FocusNode();
  FocusNode focusNodeMobile = FocusNode();
  FocusNode focusNodeUnion = FocusNode();
  FocusNode focusNodeClassification = FocusNode();

  @override
  void initState() {
    super.initState();
    controller.enableButton.value = false;
    controller.getUnionSuggestions();
    controller.initSpeech();
    controller.isValidFirstName.value = true;
    controller.isValidLastName.value = true;
    controller.isValidSSN.value = true;
    controller.isValidCity.value = true;
    controller.isValidMobileNumber.value = true;
    controller.corporateSupport.value = false;
    controller.validateFunc();
    controller.update();


  }

  @override
  Widget build(BuildContext context) {

    return Obx(() => GestureDetector(
          onTap: () {
            controller.value.value = 1;
            controller.update();
            FocusScope.of(context).unfocus();
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
                onPressed: () {
                  Get.back();
                },
              ),
              elevation: 0.0,
              backgroundColor: Get.isDarkMode
                  ? ColourConstants.black
                  : ColourConstants.white,
              title: Text(onboarding,
                  style: TextStyle(
                      color: Get.isDarkMode
                          ? ColourConstants.white
                          : ColourConstants.primaryLight,
                      fontWeight: FontWeight.bold,
                      fontSize: Dimensions.font16)),
            ),
            bottomNavigationBar: GestureDetector(
              onTap: () async {
                controller.value.value = 1;
                controller.update();
                if (controller.enableButton.value) {
                  controller.enableButton.value = false;
                  controller.update();
                  Future.delayed(Duration(seconds: 2), () {
                    controller.enableButton.value = true;
                    controller.update();
                  });
                  controller.update();
                  controller.validsubmit(context);
                  if (controller.validsubmit(context)) {

                   await controller.checkSSN().then((value) {
                     controller.enableButton.value = false;
                     controller.update();
                   });

                  } else {
                    controller.validsubmit(context);
                  }
                } else {
                  controller.validsubmit(context);
                }
              },
              child: Container(
                height: Dimensions.height50,
                margin: EdgeInsets.only(
                    left: Dimensions.height35,
                    right: Dimensions.height35,
                    bottom: Dimensions.height16,
                    top: Dimensions.height10),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.all(Radius.circular(Dimensions.radius8)),
                    color: controller.enableButton.value
                        ? ColourConstants.primary
                        : ColourConstants.grey),
                child: Center(
                  child: Text(
                    createResource,
                    style: TextStyle(
                        color: ColourConstants.white,
                        fontWeight: FontWeight.w300,
                        fontSize: Dimensions.font16),
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  BaseTextField(
                    focusNode: focusNodeCity,
                    controller: controller.cityController,
                    onTap: () {
                      controller.value.value = 1;
                      controller.update();
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp("[0-9]")),
                    ],
                    keyboardType: TextInputType.text,
                    onChanged: (val) {
                      controller.isValidCity.value = true;
                      controller.validateFunc();
                    },
                    label: Text.rich(TextSpan(children: [
                      TextSpan(
                          text: baseCity,
                          style: TextStyle(color: ColourConstants.black)),
                      TextSpan(text: "*", style: TextStyle(color: Colors.red))
                    ])),
                    floatingLabelStyle: TextStyle(
                      color: controller.isValidCity.isFalse
                          ? Colors.red
                          : Get.isDarkMode
                              ? ColourConstants.white
                              : Colors.black54,
                    ),
                    errorText:
                        controller.isValidCity.isFalse ? cityValidation : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: BaseTextField(
                      focusNode: focusNodeFirstName,
                      controller: controller.firstNameController,
                      onTap: () {
                        controller.value.value = 1;
                        controller.update();
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")),
                      ],
                      maxLength: 20,
                      keyboardType: TextInputType.text,
                      onChanged: (val) {
                        controller.isValidFirstName.value = true;
                        controller.validateFunc();
                      },
                      label: Text.rich(TextSpan(children: [
                        TextSpan(
                            text: firstName,
                            style: TextStyle(color: ColourConstants.black)),
                        TextSpan(text: "*", style: TextStyle(color: Colors.red))
                      ])),
                      floatingLabelStyle: TextStyle(
                          color: controller.isValidFirstName.isFalse
                              ? Colors.red
                              : Get.isDarkMode
                                  ? ColourConstants.primary
                                  : Colors.black54),
                      errorText: controller.isValidFirstName.isFalse
                          ? firstNameValidation
                          : null,
                    ),
                  ),
                  BaseTextField(
                    focusNode: focusNodeLastName,
                    controller: controller.lastNameController,
                    onTap: () {
                      controller.value.value = 1;
                      controller.update();
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")),
                    ],
                    maxLength: 20,
                    keyboardType: TextInputType.text,
                    onChanged: (val) {
                      // if (val.isNotEmpty) {
                      //   controller.isValidLastName.value = true;
                      // } else {
                      //   controller.isValidLastName.value = false;
                      // }
                      controller.isValidLastName.value = true;
                      controller.validateFunc();
                    },
                    label: Text.rich(TextSpan(children: [
                      TextSpan(
                          text: lastName,
                          style: TextStyle(color: ColourConstants.black)),
                      TextSpan(text: "*", style: TextStyle(color: Colors.red))
                    ])),
                    floatingLabelStyle: TextStyle(
                        color: controller.isValidLastName.isFalse
                            ? Colors.red
                            : Get.isDarkMode
                                ? ColourConstants.primary
                                : Colors.black54),
                    errorText: controller.isValidLastName.isFalse
                        ? lastNameValidation
                        : null,
                  ),
                  BaseTextField(
                    maxLength: 9,
                    focusNode: focusNodeSSN,
                    controller: controller.ssnController,
                    onTap: () {
                      controller.value.value = 1;
                      controller.update();
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                    ],
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      if (val.length == 0) {
                        controller.isValidSSN.value = true;
                      } else if (val.length != 9) {
                        controller.isValidSSN.value = false;
                      } else {
                        controller.isValidSSN.value = true;
                      }
                      controller.validateFunc();
                    },
                    label: Text.rich(TextSpan(children: [
                      TextSpan(
                          text: ssn,
                          style: TextStyle(color: ColourConstants.black)),
                      TextSpan(text: "*", style: TextStyle(color: Colors.red))
                    ])),
                    floatingLabelStyle: TextStyle(
                        color: controller.isValidSSN.isFalse
                            ? Colors.red
                            : Get.isDarkMode
                                ? ColourConstants.primary
                                : Colors.black54),
                    errorText:
                        controller.isValidSSN.isFalse ? ssnValidation : null,
                  ),
                  BaseTextField(
                    focusNode: focusNodeMobile,
                    maxLength: 10,
                    onTap: () {
                      controller.value.value = 1;
                      controller.update();
                    },
                    controller: controller.mobileNumberController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                    ],
                    keyboardType: TextInputType.phone,
                    onChanged: (val) {
                      if (val.length != 10 && val.length > 0) {
                        controller.isValidMobileNumber.value = false;
                      } else {
                        controller.isValidMobileNumber.value = true;
                      }
                      controller.validateFunc();
                      controller.update();
                    },
                    label: Text.rich(TextSpan(children: [
                      TextSpan(
                          text: mobileNumber,
                          style: TextStyle(color: ColourConstants.black)),
                      TextSpan(text: "*", style: TextStyle(color: Colors.red))
                    ])),
                    floatingLabelStyle: TextStyle(
                        color: controller.isValidMobileNumber.isFalse
                            ? Colors.red
                            : Get.isDarkMode
                                ? ColourConstants.primary
                                : Colors.black54),
                    errorText: controller.isValidMobileNumber.isFalse
                        ? mobileNumberValidation
                        : null,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(Dimensions.height20, Dimensions.height5, Dimensions.height20, Dimensions.height10),
                    child: GestureDetector(
                      onTap: () {
                        controller.corporateSupport.value =
                            !controller.corporateSupport.value;
                        controller.validsubmit(context);
                        controller.update();
                        print(controller.corporateSupport.value);
                      },
                      child: Row(
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                color: controller.corporateSupport.value == true
                                    ? ColourConstants.greenColor
                                    : ColourConstants.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: controller.corporateSupport.value == true
                                        ? ColourConstants.greenColor
                                        : ColourConstants.grey)),
                            child: Center(
                              child: Visibility(
                                  visible: controller.corporateSupport.value == true
                                      ? true
                                      : false,
                                  child: const FittedBox(
                                    child: Icon(
                                      Icons.check,
                                      color: ColourConstants.white,
                                    ),
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(corporateSupport,
                              style: TextStyle(
                                  color: ColourConstants.black, fontSize: 14))
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: controller.corporateSupport.value,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: Dimensions.height20,
                          right: Dimensions.height20,
                          bottom: 10,
                          top: Dimensions.height10),
                      child: TypeAheadField<String>(
                        hideSuggestionsOnKeyboardHide: false,
                        hideOnEmpty: false,
                        getImmediateSuggestions: true,
                        keepSuggestionsOnSuggestionSelected: false,
                        hideOnError: false,
                        suggestionsBoxController: _suggestionsBoxController,
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: controller.unionController,
                          onChanged: (value) {
                            controller.value.value = 0;
                            controller.update();
                            if (unionSelected == 1) {
                              if (value.length < lengthUnion) {
                                controller.unionController.clear();
                                controller.update();
                                lengthUnion = 0;
                                unionSelected = 0;
                              }
                            }
                          },
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp("[ a-zA-Z]")),
                          ],
                          style: TextStyle(
                              color: Get.isDarkMode
                                  ? ColourConstants.white
                                  : ColourConstants.black),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            label: Text.rich(TextSpan(children: [
                              TextSpan(
                                  text: union,
                                  style: TextStyle(color: ColourConstants.black)),
                              TextSpan(
                                  text: "*", style: TextStyle(color: Colors.red))
                            ])),
                            isDense: true,
                            floatingLabelStyle: TextStyle(
                                color:controller.isValidUnion.isFalse
                                    ? Colors.red
                                    : Get.isDarkMode
                                    ? ColourConstants.primary
                                    : Colors.black54),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: ColourConstants.grey),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: ColourConstants.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1,
                                  color: Get.isDarkMode
                                      ? ColourConstants.primary
                                      : Colors.blue),
                            ),
                            errorText: controller.isValidUnion.isFalse
                                ? unionValidation
                                : null,
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Colors.red),
                            ),
                          ),
                        ),
                        suggestionsCallback: (val) {
                          List<String> filteredList = [];
                          controller.unionSuggestionsList.forEach((element) {
                            if ((element)
                                .toLowerCase()
                                .contains(val.toLowerCase())) {
                              filteredList.add(element);
                            }
                          });
                          return filteredList;
                        },
                        itemBuilder: (context, String? suggestion) {
                          final unionName = suggestion ?? "";
                          return Visibility(
                              visible: controller.value.value == 0,
                              child: ListTile(
                                title: Text(unionName),
                              ));
                        },
                        noItemsFoundBuilder: (context) {
                          return Visibility(
                            visible: controller.value.value == 0,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.height6,
                                  vertical: Dimensions.height8),
                              child: Text(
                                noResultFound,
                              ),
                            ),
                          );
                        },
                        onSuggestionSelected: (String? suggestion) {
                          controller.unionController.text = suggestion ?? "";
                          unionSelected = 1;
                          lengthUnion = controller.unionController.text.length;
                          controller.isValidUnion.value = true;
                          controller.update();
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: controller.corporateSupport.value,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: BaseTextField(
                        focusNode: focusNodeClassification,
                        controller: controller.classificationController,
                        onTap: () {
                          controller.value.value = 1;
                          controller.update();
                        },
                        inputFormatters: [
                          NoLeadingSpaceFormatter(),
                          FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                        ],
                        onChanged: (val){
                          controller.isValidClassification.value = true;
                          controller.validateFunc();
                        },
                        keyboardType: TextInputType.text,
                        label: Text.rich(TextSpan(children: [
                          TextSpan(
                              text: classification,
                              style: TextStyle(color: ColourConstants.black)),
                          TextSpan(text: "*", style: TextStyle(color: Colors.red))
                        ])),
                        floatingLabelStyle: TextStyle(
                            color:controller.isValidClassification.isFalse
                                ? Colors.red
                                : Get.isDarkMode
                                ? ColourConstants.primary
                                : Colors.black54),
                        errorText: controller.isValidClassification.isFalse
                            ? classificationValidation
                            : null,

                      ),
                    ),
                  ),
                  textField(),
                ],
              ),
            ),
          ),
        ));
  }

  dispose() {
    controller.stopListening();
    super.dispose();
    controller.firstNameController.clear();
    controller.lastNameController.clear();
    controller.mobileNumberController.clear();
    controller.unionController.clear();
    controller.ssnController.clear();
    controller.cityController.clear();
    controller.classificationController.clear();
    controller.noteController.clear();
    controller.enableButton.value = false;
    controller.update();
  }

  /// Note text field widget
  Widget textField() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          Dimensions.height20, 15, Dimensions.height20, Dimensions.height20),
      child: TextField(
        maxLines: null,
        onTap: () {
          controller.value.value = 1;
          controller.update();
        },
        keyboardType: TextInputType.text,
        cursorColor: ColourConstants.primary,
        controller: controller.noteController,
        // textInputAction: TextInputAction.newline,

        style: TextStyle(
            color:
                Get.isDarkMode ? ColourConstants.white : ColourConstants.black,
            fontWeight: FontWeight.w400,
            fontSize: Dimensions.font13),
        decoration: InputDecoration(
          isDense: true,
          // Added this
          contentPadding: EdgeInsets.symmetric(
              horizontal: Dimensions.height10, vertical: Dimensions.height13),
          labelText: notes,
          labelStyle: TextStyle(
              fontSize: Dimensions.font15,
              color: Get.isDarkMode
                  ? ColourConstants.white
                  : ColourConstants.greyText,
              fontWeight: FontWeight.w400),
          suffixIconConstraints: BoxConstraints(
              minHeight: Dimensions.height25, minWidth: Dimensions.height25),
          suffixIcon: GestureDetector(
            onTap: () {
              if (controller.speechToText.value.isNotListening) {
                controller.startListening();
                Future.delayed(Duration(milliseconds: 2750), () async {
                  controller.isListening.value = false;
                  controller.update();
                  setState(() {});
                });
              } else {
                controller.stopListening();
              }
              setState(() {});
            },
            child: Padding(
              padding: EdgeInsets.only(
                  right: Dimensions.height11, left: Dimensions.height8),
              child: controller.isListening.isTrue
                  ? Image.asset(
                      Assets.icMic,
                      height: Dimensions.height20,
                      width: Dimensions.height20,
                      color: Colors.blue,
                    )
                  : Image.asset(
                      Assets.icMic,
                      height: Dimensions.height25,
                      width: Dimensions.height25,
                      color: Get.isDarkMode ? ColourConstants.white : null,
                    ),
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: ColourConstants.primary)),
          border: const UnderlineInputBorder(
              borderSide: BorderSide(color: ColourConstants.primary)),
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: ColourConstants.primary)),
          disabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: ColourConstants.primary)),
          errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: ColourConstants.primary)),
          focusedErrorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: ColourConstants.primary)),
          filled: true,
          fillColor: Get.isDarkMode
              ? ColourConstants.grey900
              : ColourConstants.textFieldFillColor,
        ),
      ),
    );
  }
}

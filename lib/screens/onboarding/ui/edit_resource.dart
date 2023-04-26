

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/repository/web_service_response/all_oasis_resources_response.dart';
import 'package:on_sight_application/screens/onboarding/view_model/edit_resource_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/functions/functions.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:on_sight_application/utils/widgets/base_text_field.dart';

class EditResource extends StatefulWidget {
  const EditResource({Key? key}) : super(key: key);

  @override
  State<EditResource> createState() => _EditResourceState();
}

class _EditResourceState extends State<EditResource> {
  EditResourceController editResourceController =  Get.put(EditResourceController());
  SuggestionsBoxController _suggestionsBoxController =
  SuggestionsBoxController();
  var unionSelected = 0;
  var lengthUnion = 0;

  FocusNode focusNodeMobile = FocusNode();
  FocusNode focusNodeUnion = FocusNode();
  FocusNode focusNodeClassification = FocusNode();
  FocusNode focusNodeCity = FocusNode();


  @override
  void initState() {
    super.initState();
    editResourceController.getUnionSuggestions();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      editResourceController.data?.value = Get.arguments;
      if(editResourceController.data!=null) {
        editResourceController.mobileNumberController.text =
            editResourceController.data!.value.mobilePhone.toString();
        editResourceController.cityController.text =
            editResourceController.data!.value.city.toString();
        editResourceController.unionController.text =
            editResourceController.data!.value.union.toString();
        editResourceController.classificationController.text =
            editResourceController.data!.value.classification.toString();
        if(editResourceController.data!.value.union!=null){
          if(editResourceController.data!.value.classification!=null){
            if (editResourceController.data!.value.union!.isNotEmpty ||
                editResourceController.data!.value.classification!.isNotEmpty) {
              editResourceController.corporateSupport.value = true;
            } else {
              editResourceController.corporateSupport.value = false;
            }
          }
        }


        setState(() {

        });
      }
    });


  }

  @override
  Widget build(BuildContext context) {
    print(editResourceController.enableButton.value);
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
        setState(() {

        });
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
            title: Text(editResource,
                style: TextStyle(
                    color: Get.isDarkMode
                        ? ColourConstants.white
                        : ColourConstants.primaryLight,
                    fontWeight: FontWeight.bold,
                    fontSize: Dimensions.font16)),
          ),
          bottomNavigationBar: Obx(() =>GestureDetector(
            onTap: () async {
              editResourceController.value.value = 1;
              editResourceController.update();
              if (editResourceController.enableButton.value) {

                editResourceController.enableButton.value = false;
                editResourceController.update();
                Future.delayed(Duration(seconds: 2), () {
                  editResourceController.enableButton.value = true;
                  editResourceController.update();
                });
                editResourceController.update();
                print(editResourceController.validSubmit(context));
                if (editResourceController.validSubmit(context)) {

                  editResourceController.editResourceSubmit();
                }
              } else {

                editResourceController.validSubmit(context);
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
                  color: editResourceController.enableButton.value
                      ? ColourConstants.primary
                      : ColourConstants.grey),
              child: Center(
                child: Text(
                  applyChanges,
                  style: TextStyle(
                      color: ColourConstants.white,
                      fontWeight: FontWeight.w300,
                      fontSize: Dimensions.font16),
                ),
              ),
            ),
          )),
        body: Obx(() => SingleChildScrollView(
          child: Column(
            children: [
              BaseTextField(
                focusNode: focusNodeMobile,
                maxLength: 10,
                onTap: () {
                  editResourceController.value.value = 1;
                  editResourceController.update();
                },
                controller: editResourceController.mobileNumberController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                ],
                keyboardType: TextInputType.phone,
                onChanged: (val) {
                  if (val.length != 10 && val.length > 0) {
                    editResourceController.isValidMobileNumber.value = false;
                  } else {
                    editResourceController.isValidMobileNumber.value = true;
                  }
                  editResourceController.validateFunc();
                  editResourceController.update();
                },
                label: Text.rich(TextSpan(children: [
                  TextSpan(
                      text: mobileNumber,
                      style: TextStyle(color:  Get.isPlatformDarkMode?ColourConstants.white:ColourConstants.black)),
                  TextSpan(text: " *", style: TextStyle(color: Colors.red))
                ])),
                floatingLabelStyle: TextStyle(
                    color: editResourceController.isValidMobileNumber.isFalse
                        ? Colors.red
                        : Get.isDarkMode
                        ? ColourConstants.primary
                        : Colors.black54),
                errorText: editResourceController.isValidMobileNumber.isFalse
                    ? mobileNumberValidation
                    : null,
              ),
              BaseTextField(
                focusNode: focusNodeCity,
                controller: editResourceController.cityController,
                maxLength: 28,
                onTap: () {
                  editResourceController.value.value = 1;
                  editResourceController.update();
                },
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp("[0-9]")),
                ],
                keyboardType: TextInputType.text,
                onChanged: (val) {
                  if(val.length>0) {
                    editResourceController.cityController.text = val.capitalizeFirst.toString();
                    editResourceController.cityController.selection = TextSelection.fromPosition(TextPosition(offset: editResourceController.cityController.text.length));

                  }
                  editResourceController.isValidCity.value = true;
                  editResourceController.validateFunc();
                },
                label: Text.rich(TextSpan(children: [
                  TextSpan(
                      text: baseCity,
                      style: TextStyle(color: Get.isPlatformDarkMode?ColourConstants.white: ColourConstants.black)),
                  TextSpan(text: " *", style: TextStyle(color: Colors.red))
                ])),
                floatingLabelStyle: TextStyle(
                  color: editResourceController.isValidCity.isFalse
                      ? Colors.red
                      : Get.isDarkMode
                      ? ColourConstants.white
                      : Colors.black54,
                ),
                errorText:
                editResourceController.isValidCity.isFalse ? cityValidation : null,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(Dimensions.height20, Dimensions.height5, Dimensions.height20, Dimensions.height10),
                child: GestureDetector(
                  onTap: () {
                    editResourceController.corporateSupport.value =
                    !editResourceController.corporateSupport.value;
                    editResourceController.validSubmit(context);
                    editResourceController.update();
                    print(editResourceController.corporateSupport.value);
                    editResourceController.unionController.text=   "";
                    editResourceController.classificationController.text=   "";
                    editResourceController.update();

                  },
                  child: Row(
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            color: editResourceController.corporateSupport.value == true
                                ? ColourConstants.greenColor
                                : ColourConstants.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: editResourceController.corporateSupport.value == true
                                    ? ColourConstants.greenColor
                                    : ColourConstants.grey)),
                        child: Center(
                          child: Visibility(
                              visible: editResourceController.corporateSupport.value == true
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
                              color:Get.isPlatformDarkMode?ColourConstants.white:ColourConstants.black, fontSize: 14))
                    ],
                  ),
                ),
              ),
              Visibility(
                visible:editResourceController.corporateSupport.value,
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
                      controller: editResourceController.unionController,
                      onChanged: (value) {
                        editResourceController.value.value = 0;
                        editResourceController.update();
                        if (unionSelected == 1) {
                          if (value.length < lengthUnion) {
                            editResourceController.unionController.clear();
                            editResourceController.update();
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
                              style: TextStyle(color: Get.isPlatformDarkMode?ColourConstants.white: ColourConstants.black)),
                          TextSpan(
                              text: " *", style: TextStyle(color: Colors.red))
                        ])),
                        isDense: true,
                        floatingLabelStyle: TextStyle(
                            color:editResourceController.isValidUnion.isFalse
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
                        errorText: editResourceController.isValidUnion.isFalse
                            ? unionValidation
                            : null,
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.red),
                        ),
                      ),
                    ),
                    suggestionsCallback: (val) {
                      List<String> filteredList = [];
                      editResourceController.unionSuggestionsList.forEach((element) {
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
                          visible: editResourceController.value.value == 0,
                          child: ListTile(
                            title: Text(unionName),
                          ));
                    },
                    noItemsFoundBuilder: (context) {
                      return Visibility(
                        visible: editResourceController.value.value == 0,
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
                      editResourceController.unionController.text = suggestion ?? "";
                      unionSelected = 1;
                      lengthUnion = editResourceController.unionController.text.length;
                      editResourceController.isValidUnion.value = true;
                      editResourceController.update();
                    },
                  ),
                ),
              ),
              Visibility(
                visible:editResourceController.corporateSupport.value,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: BaseTextField(
                    focusNode: focusNodeClassification,
                    controller: editResourceController.classificationController,
                    onTap: () {
                      editResourceController.value.value = 1;
                      editResourceController.update();
                    },
                    inputFormatters: [
                      NoLeadingSpaceFormatter(),
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                    ],
                    onChanged: (val){
                      editResourceController.isValidClassification.value = true;
                      editResourceController.validateFunc();
                    },
                    keyboardType: TextInputType.text,
                    label: Text.rich(TextSpan(children: [
                      TextSpan(
                          text: classification,
                          style: TextStyle(color: Get.isPlatformDarkMode?ColourConstants.white: ColourConstants.black)),
                      TextSpan(text: " *", style: TextStyle(color: Colors.red))
                    ])),
                    floatingLabelStyle: TextStyle(
                        color:editResourceController.isValidClassification.isFalse
                            ? Colors.red
                            : Get.isDarkMode
                            ? ColourConstants.primary
                            : Colors.black54),
                    errorText: editResourceController.isValidClassification.isFalse
                        ? classificationValidation
                        : null,

                  ),
                ),
              ),
            ],
          ),
        )
      )),
    );
  }

  @override
  void dispose() {
    super.dispose();
    editResourceController.dispose();
  }
}

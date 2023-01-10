import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/repository/web_service_response/lead_sheet_response.dart';
import 'package:on_sight_application/screens/lead_sheet/view_model/exhibitor_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/strings.dart';

class ExhibitorScreen extends StatefulWidget {
  const ExhibitorScreen({Key? key}) : super(key: key);

  @override
  State<ExhibitorScreen> createState() => _ExhibitorScreenState();
}

class _ExhibitorScreenState extends State<ExhibitorScreen> {

  TextEditingController boothSizeController = TextEditingController();
  TextEditingController widthController = TextEditingController();
  TextEditingController heigthController = TextEditingController();
  TextEditingController boothNumberController = TextEditingController();
  TextEditingController shopController = TextEditingController();
  TextEditingController setUpCompanyController = TextEditingController();

  bool isHighPriorityLead = false;
  ExhibitorController controller = ExhibitorController();

  Exhibitors? data;
  bool isUpdating = false;
  SuggestionsBoxController suggestionsBoxController = SuggestionsBoxController();

  @override
  void initState() {
    super.initState();

    controller.initSpeech();
    // Is Editing the existing exhibitor.
    if (Get.arguments[2]) {
      isUpdating = Get.arguments[2];
      data = Get.arguments[1];
      if(data != null){
        // Setting the existing data.
        setData();
      }
    }
    controller.getShopListApi();
    controller.getBoothSizeApi();
    controller.getCompaniesApi();
  }

  setData(){
    controller.nameController.text = data?.exhibitorName??"";
    boothNumberController.text = data?.boothNumber??"";
    shopController.text = data?.shop??"";
    setUpCompanyController.text = data?.setupCompany??"";
    controller.explainController.text = data?.notes??"";
      if ((data?.boothSize??"").isNotEmpty) {
        List<String> size = (data?.boothSize??"").split("*");
        if (size[0].isNotEmpty) {
          widthController.text = size[0];
        }
        if (size[1].isNotEmpty) {
          heigthController.text = size[1];
        }
      }
    isHighPriorityLead = data?.isHighPriority??false;
    controller.isButtonEnable.value = false;
  }


  @override
  Widget build(BuildContext context) {
    Theme.of(context) == Brightness.dark;
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
          title: Text(isUpdating ? updateExhibitorSmall : addExhibitorSmall, style: TextStyle(
              color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,
              fontWeight: FontWeight.bold, fontSize: Dimensions.font16),
          ),
        ),
        bottomNavigationBar: Obx(()=> GestureDetector(
          onTap: () async {
            FocusScope.of(context).unfocus();
            if (controller.isButtonEnable.isTrue) {
              if (widthController.text.isNotEmpty && heigthController.text.isEmpty) {
                Get.snackbar(alert, invalidBoothSize);
              }else if(widthController.text.isEmpty && heigthController.text.isNotEmpty){
                Get.snackbar(alert, invalidBoothSize);
              }else{
                if (controller.nameController.text.isNotEmpty) {
                  if (!isUpdating) {
                    Exhibitors model = Exhibitors(exhibitorName: controller.nameController.text.trim(),
                        boothNumber: boothNumberController.text.trim(),shop: shopController.text.trim(),
                        notes: controller.explainController.text.trim(),setupCompany: setUpCompanyController.text.trim(),
                        boothSize: "${widthController.text.trim()}*${heigthController.text.trim()}",isHighPriority: isHighPriorityLead);
                    controller.addExhibitorApi(isLoading: true,model: model,leadNumber: Get.arguments[0]);
                  }else{
                    Exhibitors model = Exhibitors(exhibitorName: controller.nameController.text.trim(),
                      boothNumber: boothNumberController.text.trim(),shop: shopController.text.trim(),folderUrl: data?.folderUrl,
                      notes: controller.explainController.text.trim(),setupCompany: setUpCompanyController.text.trim(),
                      boothSize: "${widthController.text.trim()}*${heigthController.text.trim()}",
                      exhibitorGuid: data?.exhibitorGuid??"",exhibitorId: data?.exhibitorId??"",
                      showName: data?.showNumber??"",
                      isHighPriority: isHighPriorityLead,exhibitorImageCount: data?.exhibitorImageCount,);
                    controller.updateExhibitorApi(isLoading: true,model: model,leadNumber: Get.arguments[0]);
                  }
                }else{
                  controller.isButtonEnable.value = false;
                  controller.update();
                }
              }
            }
          },
          child: Container(
            height: Dimensions.height50,
            margin: EdgeInsets.only(left: Dimensions.height35,right: Dimensions.height35,bottom: Dimensions.height40),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(Dimensions.radius8)),
              color: controller.isButtonEnable.isTrue ? ColourConstants.primary : ColourConstants.grey,
            ),
            child: Center(child: Text(isUpdating ? updateExhibitor : addExhibitor, style: TextStyle(color: ColourConstants.white, fontWeight: FontWeight.w400, fontSize: Dimensions.font16),)),
          ),
        ),),
        body: Obx(()=>SingleChildScrollView(
          child: Column(children: [
            Container(
              margin: EdgeInsets.only(right: Dimensions.height20,left: Dimensions.height20,top: Dimensions.height15),
              child: TextField(
                enabled: !isUpdating,
                textAlignVertical: TextAlignVertical.center,
                controller: controller.nameController,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9' ]")),
                ],
                onChanged: (val){
                  if (controller.nameController.text == " ") {
                    controller.nameController.clear();
                  }else{
                    if(controller.validateName()){
                      if(controller.isButtonEnable.isFalse){
                        controller.isButtonEnable.value = true;
                      }
                    }else{
                      controller.isButtonEnable.value = false;
                    }
                    if(val.length > 1){
                      controller.isButtonEnable.value = true;
                    }else{
                      controller.isButtonEnable.value = false;
                    }
                  }
                  setState(() {});
                },
                style: TextStyle(color: Get.isDarkMode?ColourConstants.white: isUpdating ?  ColourConstants.grey : ColourConstants.black,fontSize: Dimensions.font14,fontWeight: isUpdating ? FontWeight.w500 : FontWeight.w400),
                decoration: InputDecoration(
                  labelText: nameString,
                  labelStyle: TextStyle(color: Get.isDarkMode ? ColourConstants.white : ColourConstants.greyText, fontWeight: FontWeight.w400),
                  isDense: true,
                  floatingLabelStyle: TextStyle(color: Get.isDarkMode?ColourConstants.white:ColourConstants.primary),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: ColourConstants.grey300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: ColourConstants.grey300),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 1, color: ColourConstants.red),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1, color: ColourConstants.grey300,),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 1, color: ColourConstants.red),
                  ),
                ),
              ),
            ),
            SizedBox(height: Dimensions.height16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                      margin: EdgeInsets.only(left: Dimensions.height20,right: Dimensions.height20),
                      child: TypeAheadField<String>(
                        hideSuggestionsOnKeyboardHide: true,
                        hideOnEmpty: true,
                        hideOnError: true,
                        // suggestionsBoxController: suggestionsBoxController,
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: this.boothSizeController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9*]")),
                          ],
                          textInputAction: TextInputAction.next,
                          style: TextStyle(color: Get.isDarkMode ? ColourConstants.white :  ColourConstants.black, fontSize: Dimensions.font14),
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: boothSize,
                            isDense: true,
                            labelStyle: TextStyle(color: Get.isDarkMode ? ColourConstants.white :  ColourConstants.greyText,fontSize: Dimensions.font14),
                            floatingLabelStyle: TextStyle(color: Get.isDarkMode?ColourConstants.white:ColourConstants.primary),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: ColourConstants.borderGreyColor),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: ColourConstants.primary),
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: ColourConstants.red),
                            ),
                            focusedErrorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: ColourConstants.red),
                            ),
                          ),
                        ),
                        suggestionsCallback: (val){
                          List<String> filteredList = [];
                          controller.boothSizesList.forEach((element) {
                            if((element.boothSize??"").toLowerCase().contains(val)){
                              filteredList.add(element.boothSize??"");
                            }
                          });
                          return filteredList;
                        },
                        itemBuilder: (context, String? suggestion) {
                          final shopName = suggestion??"";
                          return ListTile(
                            title: Text(shopName),
                          );
                        },
                        noItemsFoundBuilder: (context) => SizedBox(
                          height: 0,
                          child: Center(
                            child: Text(
                              noBoothSizesFound,
                              style: TextStyle(fontSize: Dimensions.font24),
                            ),
                          ),
                        ),
                        onSuggestionSelected: (String? suggestion) {
                          if(isUpdating){
                            controller.isButtonEnable.value = true;
                            controller.update();
                          }
                          var localList = (suggestion??"").split("*");
                          widthController.text = localList[0];
                          heigthController.text = localList[1];
                          this.boothSizeController.clear();
                        },
                      )
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 5,
                  margin: EdgeInsets.only(right: 0,left: 0),
                  child: TextField(
                    maxLength: 10,
                    textAlignVertical: TextAlignVertical.center,
                    controller: widthController,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    style: TextStyle(color: Get.isDarkMode ? ColourConstants.white :  ColourConstants.greyText,fontSize: Dimensions.font14),
                    keyboardType: TextInputType.number,
                    onChanged: (val){
                      if (widthController.text.trim().isNotEmpty || heigthController.text.trim().isNotEmpty) {
                      }else{boothSizeController.clear();}
                      if(isUpdating){
                        controller.isButtonEnable.value = true;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: widthStr,
                      counter: const SizedBox(),
                      labelStyle: TextStyle(color: Get.isDarkMode ? ColourConstants.white :  ColourConstants.greyText,fontSize: Dimensions.font14),
                      isDense: true,
                      floatingLabelStyle: TextStyle(color: Get.isDarkMode?ColourConstants.white:ColourConstants.primary),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: ColourConstants.grey300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: ColourConstants.grey300),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1, color: ColourConstants.red),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1, color: ColourConstants.red),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: Dimensions.height20, right: Dimensions.height5,left: Dimensions.height5),
                  child: Text("*"),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 5,
                  margin: EdgeInsets.only(right: Dimensions.height20,left: 0),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    controller: heigthController,
                    textInputAction: TextInputAction.next,
                    maxLength: 10,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                     style: TextStyle(color: Get.isDarkMode ? ColourConstants.white :  ColourConstants.greyText,fontSize: Dimensions.font14),

                  keyboardType: TextInputType.number,
                    onChanged: (value){
                      if (widthController.text.trim().isNotEmpty || heigthController.text.trim().isNotEmpty) {
                      }else{
                        boothSizeController.clear();
                      }
                      if(isUpdating){
                        controller.isButtonEnable.value = true;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: heightStr,
                      counterStyle: TextStyle(fontSize: 0),
                      counter: SizedBox.shrink(),
                      counterText: "",
                      labelStyle: TextStyle(color: Get.isDarkMode ? ColourConstants.white :  ColourConstants.greyText,fontSize: Dimensions.font14),
                      isDense: true,
                      floatingLabelStyle: TextStyle(color: Get.isDarkMode?ColourConstants.white:ColourConstants.primary),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: ColourConstants.grey300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: ColourConstants.grey300),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1, color: ColourConstants.red),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1, color: ColourConstants.red),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(right: Dimensions.height20,left: Dimensions.height20,top: Dimensions.height8),
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                controller: boothNumberController,
                textInputAction: TextInputAction.next,
                style: TextStyle(color: Get.isDarkMode ? ColourConstants.white :  ColourConstants.greyText,fontSize: Dimensions.font14),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9 ]")),
                ],
                onChanged: (val){
                  if(isUpdating){
                    controller.isButtonEnable.value = true;
                  }
                },
                decoration: InputDecoration(
                  labelText: boothNumber,
                  // counter: const SizedBox(),
                  // counterStyle: TextStyle(fontSize: 0),
                  labelStyle: TextStyle(color: Get.isDarkMode ? ColourConstants.white :  ColourConstants.greyText,fontSize: Dimensions.font14),
                  isDense: true,
                  floatingLabelStyle: TextStyle(color: Get.isDarkMode?ColourConstants.white:ColourConstants.primary),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: ColourConstants.grey300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: ColourConstants.grey300),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 1, color: ColourConstants.red),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 1, color: ColourConstants.red),
                  ),
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: Dimensions.height20,right: Dimensions.height20,top: Dimensions.height20),
                child: TypeAheadField<String>(
                  hideSuggestionsOnKeyboardHide: true,
                  hideOnEmpty: true,
                  hideOnError: true,
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: this.shopController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    onChanged: (val){
                      if(isUpdating){
                        controller.isButtonEnable.value = true;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: shop,
                      isDense: true,
                      labelStyle: TextStyle(color: Get.isDarkMode ? ColourConstants.white :  ColourConstants.greyText,fontSize: Dimensions.font14),
                      floatingLabelStyle: TextStyle(color: Get.isDarkMode?ColourConstants.white:ColourConstants.primary),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: ColourConstants.borderGreyColor),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: ColourConstants.primary),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1, color: ColourConstants.red),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1, color: ColourConstants.red),
                      ),
                    ),
                  ),
                  suggestionsCallback: getSuggestion,
                  itemBuilder: (context, String? suggestion) {
                    final shopName = suggestion??"";
                    return ListTile(
                      title: Text(shopName),
                    );
                  },
                  noItemsFoundBuilder: (context) => SizedBox(
                    height: 0,
                    child: Center(
                      child: Text(
                        noShopsFound,
                        style: TextStyle(fontSize: Dimensions.font24),
                      ),
                    ),
                  ),
                  onSuggestionSelected: (String? suggestion) {
                    this.shopController.text = suggestion??"";
                    if (isUpdating) {
                      controller.isButtonEnable.value = true;
                      controller.update();
                    }
                  },
                )
            ),
            Container(
                margin: EdgeInsets.only(left: Dimensions.height20,right: Dimensions.height20,top: Dimensions.height20),
                child: TypeAheadField(
                  hideSuggestionsOnKeyboardHide: true,
                  hideOnEmpty: true,
                  hideOnError: true,
                  suggestionsBoxController: suggestionsBoxController,
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: this.setUpCompanyController,
                    style: TextStyle(color: Get.isDarkMode ? ColourConstants.white :  ColourConstants.greyText,fontSize: Dimensions.font14),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    onChanged: (val){
                      if(isUpdating){
                        controller.isButtonEnable.value = true;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: setUpCompany,
                      isDense: true,
                      labelStyle: TextStyle(color: Get.isDarkMode ? ColourConstants.white :  ColourConstants.greyText,fontSize: Dimensions.font14),
                      floatingLabelStyle: TextStyle(color: Get.isDarkMode?ColourConstants.white:ColourConstants.primary),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: ColourConstants.borderGreyColor),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: ColourConstants.primary),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1, color: ColourConstants.red),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1, color: ColourConstants.red),
                      ),
                    ),
                  ),
                  suggestionsCallback: (val){
                    List<String> filteredList = [];
                    for(var element in controller.companiesList){
                      if ((element.setupCompany??"").toLowerCase().contains(val)) {
                        filteredList.add(element.setupCompany??"");
                      }
                    }
                    return filteredList;
                  },
                  itemBuilder: (context, String? suggestion) {
                    final shopName = suggestion??"";
                    return ListTile(
                      title: Text(shopName),
                    );
                  },
                  noItemsFoundBuilder: (context) => SizedBox(
                    height: 0,
                    child: Center(
                      child: Text(
                        noCompaniesFound,
                        style: TextStyle(fontSize: Dimensions.font24),
                      ),
                    ),
                  ),
                  onSuggestionSelected: (String? suggestion) {
                    this.setUpCompanyController.text = suggestion??"";
                    if (isUpdating) {
                      controller.isButtonEnable.value = true;
                      controller.update();
                    }
                  },
                )
            ),
            Container(
              margin: EdgeInsets.only(top: Dimensions.height20),
              padding: EdgeInsets.symmetric(horizontal: Dimensions.height20),
              child: textField(),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0,horizontal: Dimensions.height16),
              margin: EdgeInsets.only(bottom: Dimensions.height7,left: Dimensions.height10),
              child: Row(
                children: [
                  Text(highPriorityLead,
                      style: TextStyle(
                          color: Get.isDarkMode?ColourConstants.white: ColourConstants.greyText,
                          fontWeight: FontWeight.w400,
                          fontSize: Dimensions.font13)),
                  SizedBox(
                    height: Dimensions.height10,
                    child: Checkbox(
                        value: isHighPriorityLead,
                        checkColor: Get.isDarkMode?ColourConstants.black:ColourConstants.white,
                        activeColor:Get.isDarkMode?ColourConstants.white: ColourConstants.greenColor,
                        onChanged: (val){
                          if (controller.validateName()) {
                            controller.isButtonEnable.value = true;
                          }

                          setState(() {
                            isHighPriorityLead = val!;
                          });
                        }),
                  ),
                ],
              ),
            ),
            // SizedBox(height: MediaQuery.of(context).size.height / 8.5),
          ]),
        ),)
      ),
    );
  }

  List<String> getSuggestion(input){
    List<String> filter = [];
    for(var element in controller.shopList){
      if((element.shop??"").toLowerCase().contains(input)){
        filter.add(element.shop??"");
      }
    }
    return filter;
  }

  Widget textField() {
    return SizedBox(
      height: Dimensions.height100,
      child: TextField(
        maxLines: null,
        controller: controller.explainController,
        keyboardType: TextInputType.text,
        onChanged: (val){
          if(isUpdating){
            controller.isButtonEnable.value = true;
            controller.update();
          }
        },
        maxLength: null,
        cursorColor: ColourConstants.primary,
        style: TextStyle(
            color: Get.isDarkMode?ColourConstants.white:ColourConstants.black,
            fontWeight: FontWeight.w400,
            fontSize: Dimensions.font13),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: Dimensions.height10, vertical: Dimensions.height13),
          labelText: controller.explainController.text.isEmpty ? addNotes : noteStr,
          labelStyle: TextStyle(color: Get.isDarkMode?ColourConstants.white:ColourConstants.greyText, fontWeight: FontWeight.w400),
          suffixIconConstraints:
          BoxConstraints(minHeight: Dimensions.height25, minWidth: Dimensions.height25),
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
              child: controller.isListening.isTrue? Image.asset(
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
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary)),
          border: UnderlineInputBorder(borderSide: BorderSide(color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary)),
          disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary)),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary)),
          filled: true,
          fillColor: Get.isDarkMode ? ColourConstants.grey900 : ColourConstants.textFieldFillColor,
        ),
      ),
    );
  }
}

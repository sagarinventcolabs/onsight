


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/repository/web_service_response/all_oasis_resources_response.dart';
import 'package:on_sight_application/repository/web_services/web_service.dart';
import 'package:on_sight_application/utils/connectivity.dart';
import 'package:on_sight_application/utils/dialogs.dart';
import 'package:on_sight_application/utils/strings.dart';

class EditResourceController extends GetxController{

  /// City Controller
  TextEditingController cityController = TextEditingController();
  /// Classification Controller
  TextEditingController classificationController = TextEditingController();
  /// mobile number Controller
  TextEditingController mobileNumberController = TextEditingController();
  /// union Controller
  TextEditingController unionController = TextEditingController();

  Rx<AllOasisResourcesResponse>? data = AllOasisResourcesResponse().obs;
  /// variable for show hide suggestion below text field of union number
  RxInt value = 0.obs;
  RxBool isValidMobileNumber = true.obs;
  RxBool isValidUnion = true.obs;
  RxBool isValidClassification = true.obs;
  /// check valid city parameter
  RxBool isValidCity = true.obs;
  /// Submit button enable / disable
  RxBool enableButton = false.obs;
  /// Union Suggestions List
  RxList<String> unionSuggestionsList = <String>[].obs;
  /// corporateSupport checkbox variable
  RxBool corporateSupport = false.obs;



  /// API function for getting Union Suggestions
  Future<dynamic> getUnionSuggestions() async {
    bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
    if(isNetActive){
      var response = await WebService().getUnionSuggestionsList()as List;
      if (!response.toString().contains(error)) {
        List<String> localList = [];
        response.forEach((element) {
          localList.add(element);
        });
        localList.sort((a, b) => a.toString().compareTo(b.toString()));
        if (localList.length > 0) {
          unionSuggestionsList.value = localList;
          unionSuggestionsList.refresh();
          update();
        }
      }
      update();
      return response;
    }
  }


  validateFunc(){
    if (cityController.text.isEmpty) {
      enableButton.value = false;
      update();
      return false;
    } else {
      enableButton.value = true;
    }
    if(mobileNumberController.text.isEmpty){
      enableButton.value = false;
      update();
      return false;
    }
    if(mobileNumberController.text.length != 10 && mobileNumberController.text.length > 0){
      enableButton.value = false;
      update();
      return false;
    }else{
      enableButton.value = true;

    }
    if(corporateSupport.isTrue) {
      if (unionController.text.isEmpty) {
        enableButton.value = false;
        update();
        return false;
      } else {
        enableButton.value = true;
      }
      if (classificationController.text.isEmpty) {
        enableButton.value = false;
        update();
        return false;
      } else {
        enableButton.value = true;
      }
    }



    update();
    return true;
  }

  /// validation on submit button
  validSubmit(context){

    if(mobileNumberController.text.isEmpty){
      enableButton.value = false;
      isValidMobileNumber.value = false;
      // focusNodeMobile.value.requestFocus();
      update();
      return false;
    }
    else if (mobileNumberController.text.length != 10 && mobileNumberController.text.length > 0) {
      enableButton.value = false;
      isValidMobileNumber.value = false;
      // focusNodeMobile.value.requestFocus();
      update();
      return false;
    }  else {
      try{
        var value = int.parse(mobileNumberController.text.toString());
        if(value<=0){
          enableButton.value = false;
          isValidMobileNumber.value = false;
          // focusNodeMobile.value.requestFocus();
          update();
          return false;
        }
      }catch(e){
        debugPrint(e.toString());
      }
      isValidMobileNumber.value = true;
      enableButton.value = true;
    }

    if (cityController.text.isEmpty) {
      enableButton.value = false;
      isValidCity.value = false;
      // FocusScope.of(context).requestFocus(focusNodeCity.value);
      update();
      return false;
    } else {
      enableButton.value = true;
      isValidCity.value = true;
    }


    if(corporateSupport.isTrue) {
      if (unionController.text.isEmpty) {
        enableButton.value = false;
        isValidUnion.value = false;
        update();
        return false;
      } else {
        enableButton.value = true;
      }
      if (classificationController.text.isEmpty) {
        enableButton.value = false;
        isValidClassification.value = false;
        update();
        return false;
      } else {
        enableButton.value = true;
      }
    }
    update();
    return true;
  }


  Future<dynamic> editResourceSubmit() async {

      data!.value.city = cityController.text.trim();
      data!.value.union = unionController.text.trim();
      data!.value.mobilePhone = mobileNumberController.text;
      data!.value.classification = classificationController.text.trim();
    var requestJson = data!.value.toJson();
    print(requestJson);
    bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
    if(isNetActive){
      WebService service = WebService();
      var response = await service.updateResourceOnboarding(requestJson);
      if(response!=null) {
        if (response.toString().toLowerCase().contains("success")) {

          defaultDialog(Get.context!, title: response.toString(),cancelable: false, onTap: (){
            Get.back();
            Get.back();
          });


        }

      }
      update();
      return response;
    }else{
      Get.snackbar(alert,noInternet);
    }
  }
}
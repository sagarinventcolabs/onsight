import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/repository/web_service_response/fetch_profile_response.dart';
import 'package:on_sight_application/repository/web_services/web_service.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';
import 'package:on_sight_application/utils/strings.dart';


class ProfileController extends GetxController{
  /// First name Text editing controller
  TextEditingController firstNameController = TextEditingController(text: "");
  /// Last name Text editing controller
  TextEditingController lastNameController = TextEditingController(text: "");
  /// Email Text editing controller
  TextEditingController emailController = TextEditingController(text: "");

  //Api service variable for api call........
  WebService service = WebService();
  /// isUpdate variable
  RxBool isUpdate = false.obs;

  // Api for Get profile.......................

  Future<dynamic> getProfile({showValue = true}) async{
    var response = await service.getProfile(showValue);
    if(response!=null) {
      print(response);
      if (response.containsKey(error)) {
        return response;
      }
      FetchProfileResponse responseModel = FetchProfileResponse.fromJson(response);
      sp!.putString(Preference.FIRST_NAME, responseModel.firstName.toString());
      sp!.putString(Preference.LAST_NAME, responseModel.lastName.toString());
      sp!.putString(Preference.USER_EMAIL, responseModel.emailAddress.toString());
      firstNameController.text = responseModel.firstName.toString();
      lastNameController.text = responseModel.lastName.toString();
      emailController.text = responseModel.emailAddress.toString();
      update();
    }
    return response;
  }


  // Api for Update profile.......................

  Future<dynamic> updateProfile() async{
    FetchProfileResponse fetchProfileResponse = FetchProfileResponse();
    fetchProfileResponse.firstName = firstNameController.text.toString();
    fetchProfileResponse.lastName = lastNameController.text.toString();
    fetchProfileResponse.emailAddress = emailController.text.toString();
    print(fetchProfileResponse.toJson());
    var response = await service.updateProfileRequest(fetchProfileResponse.toJson());
    if(response!=null) {
      print(response);
      if (response.containsKey(error)) {
        return response;
      }else{
        Get.snackbar(success, profileUpdatedSuccessfully);
        // getProfile();
      }


    }
    return response;
  }


  validate(){
    if(firstNameController.text.isEmpty){
      return false;
    }else if(lastNameController.text.isEmpty){
      return false;
    }else if(!EmailValidator.validate(emailController.text)){
      return false;
    }else{
      return true;
    }
  }



}
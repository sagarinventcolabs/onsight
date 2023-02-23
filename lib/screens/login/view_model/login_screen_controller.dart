import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/repository/web_service_response/error_model.dart';
import 'package:on_sight_application/repository/web_service_response/error_response.dart';
import 'package:on_sight_application/repository/web_service_response/get_otp_response.dart';
import 'package:on_sight_application/repository/web_services/web_service.dart';
import 'package:on_sight_application/screens/verify_otp/ui/verify_email_otp_screen.dart';
import 'package:on_sight_application/screens/verify_otp/ui/verify_otp_screen.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dialogs.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';
import 'package:on_sight_application/utils/strings.dart';


class LoginScreenController extends GetxController {
  //Api service variable for api call........
  WebService service = WebService();
  //phonevalidation check...........
  RxBool isValidphone = true.obs;
  //emailValidation check...........
  RxBool isValidEmail = true.obs;
  //button show hide................
  RxBool enableButton = false.obs;
  //EditTet controller for email
  TextEditingController emailController = TextEditingController(text: "");


// Api for Get Otp.......................
  Future<dynamic> getOtpRequest(phoneNumber, selectedCountryCode) async {
    var response = await service.getOtp(phoneNumber, selectedCountryCode/*.replaceAll("+", "").toString().trim()*/);
    if (response != null) {
      if (response.containsKey(error)) {
        return response;
      }
      GetOtpResponse responseModel = GetOtpResponse.fromJson(response);
      sp!.putString(Preference.ACCESS_TOKEN, responseModel.accessToken.toString());
      sp!.putString(Preference.USER_MOBILE, phoneNumber.toString());
      sp!.putString(Preference.COUNTRY_CODE, selectedCountryCode.toString());
      Get.to(() => VerifyOtpScreen(number: phoneNumber, selectedContryCode: selectedCountryCode, expires: responseModel.expiresIn,));
    }
    return response;
  }


  // Api for Email Flow.......................
  Future<dynamic> getOtpWithEmail(email) async {
    var response = await service.getOtpForEmail(email.toString().trim(), /*.replaceAll("+", "").toString().trim()*/);
    if (response != null) {
      if (response.toString().toLowerCase().contains(error)) {
        return response;
      }
      GetOtpResponse responseModel = GetOtpResponse.fromJson(response);
      sp!.putString(Preference.ACCESS_TOKEN, responseModel.accessToken.toString());
      sp!.putString(Preference.USER_EMAIL, email.toString().trim());
      Get.to(() => VerifyEmailOtpScreen(email: email, number:responseModel.userName,accessToken: responseModel.accessToken, expires: responseModel.expiresIn,));
    }
    return response;
  }



// TextInput Validation Check.......................

  validate(phoneNumber) {
    if (phoneNumber.isEmpty) {
      isValidphone.value = false;
      enableButton.value = false;
      update();
      return false;
    } else if (phoneNumber.length < 10) {
      isValidphone.value = false;
      enableButton.value = false;
      update();
      return false;
    } else {
      isValidphone.value = true;
      enableButton.value = true;
      update();
    }
    return true;
  }

  validateEmail(email) {
     if (!EmailValidator.validate(email)) {
      isValidEmail.value = false;
      enableButton.value = false;
      update();
      return false;
    } else {
       isValidEmail.value = true;
      enableButton.value = true;
      update();
    }
    return true;
  }
}

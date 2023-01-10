import 'package:get/get.dart';
import 'package:on_sight_application/repository/web_service_response/get_otp_response.dart';
import 'package:on_sight_application/repository/web_services/web_service.dart';
import 'package:on_sight_application/screens/verify_otp/ui/verify_otp_screen.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';
import 'package:on_sight_application/utils/strings.dart';


class LoginScreenController extends GetxController {
  //Api service variable for api call........
  WebService service = WebService();
  //phonevalidation check...........
  RxBool isValidphone = true.obs;
  //button show hide................
  RxBool enableButton = false.obs;


// Api for Get Otp.......................
  Future<dynamic> getOtpRequest(phoneNumber, selectedCountryCode) async {
    var response = await service.getOtp(phoneNumber, selectedCountryCode);
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
}

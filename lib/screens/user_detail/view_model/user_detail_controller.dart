import 'package:email_validator/email_validator.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/repository/web_service_response/get_otp_response.dart';
import 'package:on_sight_application/repository/web_services/web_service.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/screens/update_profile/view_model/profile_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/functions/functions.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';
import 'package:on_sight_application/utils/strings.dart';


class RegisterScreenController extends GetxController {
  WebService service = WebService();
  RxBool isValidEmail = true.obs;
  RxBool isValidFirstName = true.obs;
  RxBool isValidLastName = true.obs;
  RxBool enableButton = false.obs;


  //Register User Api.......................................................
  Future<dynamic> registerUser(clientId, firstName, lastName, email) async {
    var response = await service.registerUser(clientId, firstName, lastName, email);
    if (response.containsKey(error)) {
      return response;
    }
    GetOtpResponse responseModel = GetOtpResponse.fromJson(response);
    sp!.putString(
        Preference.ACCESS_TOKEN, responseModel.accessToken.toString());
    sp!.putBool(Preference.IS_LOGGED_IN, true);
    ProfileController profileController = ProfileController();
    await profileController.getProfile();
    if (response != null) {
      AnalyticsFireEvent(LoginOrSignUp, input: {
        type: signUp,
        user:sp?.getString(Preference.FIRST_NAME)??""/* +" "+sp?.getString(Preference.LAST_NAME)??""*/
      });
      Get.offAllNamed(Routes.dashboardScreen);
    }
    return response;
  }

/// TextInput Validations......................................................

  validateFunc(firstName, lastName, email){
    if (firstName.isEmpty) {
      enableButton.value = false;
      update();
      return false;
    } else {
      enableButton.value = true;
      update();
    }
    if (lastName.isEmpty) {
      enableButton.value = false;
      update();
      return false;
    } else {
      enableButton.value = true;
      update();
    }
    if (email.isEmpty) {
      enableButton.value = false;
      update();
      return false;
    } else if (!EmailValidator.validate(email.toString())) {
      enableButton.value = false;
      update();
      return false;
    } else {
      enableButton.value = true;
      update();
    }
    return true;
  }
}

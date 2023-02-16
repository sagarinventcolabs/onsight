import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/repository/web_service_response/error_response.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/screens/verify_otp/view_model/verify_screen_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/strings.dart';

import 'package:sms_autofill/sms_autofill.dart';

class VerifyEmailOtpScreen extends StatefulWidget {
  final email;
  final number;
  final accessToken;
  final expires;

  VerifyEmailOtpScreen(
      {Key? key,
      this.number,
      this.email,
      this.accessToken,
      this.expires})
      : super(key: key);

  @override
  _VerifyEmailOtpScreenState createState() => _VerifyEmailOtpScreenState();
}

class _VerifyEmailOtpScreenState extends State<VerifyEmailOtpScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController textEditingController = TextEditingController(text: "");
  TextEditingController phoneController = new TextEditingController(text: "");
  var selectedContryCode = "+1";

  VerifyScreenController controller = Get.put(VerifyScreenController());

  @override
  void initState() {
    phoneController.text = widget.number;
    super.initState();
    initSms();
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context) == Brightness.dark;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Obx(() => Scaffold(
          key: _scaffoldKey,
          bottomNavigationBar: GestureDetector(
              onTap: () async {
                if (controller.validate(
                    phoneController.text, textEditingController.text)) {
                  FocusScope.of(context).unfocus();


                  var dateTime = await DateTime.now().toIso8601String();
                  sp?.putString(Constants.secureValidation, dateTime);
                  print("DateTime " + dateTime.toString());
                  // Get.toNamed(Routes.dashboardScreen);
                      var response = await controller.verifyOtp(
                          textEditingController.text.toString());
                      if (response.toString().toLowerCase().contains("error")) {
                        ErrorResponse errorModel = ErrorResponse.fromJson(
                            response);
                        if (errorModel.errorDescription
                            .toString()
                            .contains(verificationCodeIsIncorrect)) {
                          controller.isValidOtp.value = false;
                        }
                      }
                }
              },
              child: Padding(
                padding: EdgeInsets.only(
                    left: Dimensions.height30,
                    right: Dimensions.height30,
                    bottom: Dimensions.height50),
                child: Container(
                  height: Dimensions.height45,
                  width: Dimensions.height250,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(Dimensions.height10)),
                      color: controller.enableButton.isTrue
                          ? ColourConstants.primary
                          : Colors.grey),
                  child: Center(
                      child: Text(
                    verify,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: Dimensions.font21),
                  )),
                ),
              )),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: Dimensions.height80,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Get.isDarkMode
                        ? Image.asset(Assets.logoTextDark,
                            height: Dimensions.height63)
                        : Image.asset(Assets.logoText,
                            height: Dimensions.height63)
                  ],
                ),
                SizedBox(
                  height: Dimensions.height70,
                ),
                Text(
                  enterVerificationCode +
                      "xxxx xxxx" +
                      widget.number
                          .toString()
                          .substring(widget.number.toString().length - 2),
                  style: TextStyle(
                      fontSize: Dimensions.font20,
                      color: Get.isDarkMode
                          ? ColourConstants.darkModeWhite
                          : Colors.black),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: Dimensions.height60,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.height25,
                      vertical: Dimensions.height20),
                  child: TextFieldPinAutoFill(
                    // controller: textEditingController,
                    codeLength: 4,
                    onCodeChanged: (val) {
                      print(val.toString());
                      textEditingController.text = val.toString();
                      controller.validate(
                          phoneController.text, textEditingController.text);
                      setState(() {});
                    },
                    onCodeSubmitted: (val) {
                      textEditingController.text = val.toString();
                      controller.validate(
                          phoneController.text, textEditingController.text);
                      setState(() {});
                    },
                    currentCode: textEditingController.text,
                    // onChanged: (val) {
                    //   controller.validate(
                    //       phoneController.text, textEditingController.text);
                    // },
                    // keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: verificationCode,
                      counterText: "",
                      labelStyle: TextStyle(
                          color: Get.isDarkMode
                              ? ColourConstants.darkModeWhite
                              : Colors.black54),
                      floatingLabelStyle: TextStyle(
                          color: Get.isDarkMode ? Colors.blue : Colors.black54),
                      /*errorText: controller.isValidOtp.isFalse
                          ? verificationCodeInvalid
                          : null,*/
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            color:
                                Get.isDarkMode ? Colors.white70 : Colors.grey),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.blue),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.red),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.red),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    controller.resendOtpEmail(widget.email);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: Dimensions.height25),
                        child: Text(resendCode,
                            style: TextStyle(
                                fontSize: Dimensions.font15,
                                color: Get.isDarkMode
                                    ? Colors.blue
                                    : ColourConstants.primary,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ))),
    );
  }

  void initSms() async {
    await SmsAutoFill().listenForCode;
  }
}

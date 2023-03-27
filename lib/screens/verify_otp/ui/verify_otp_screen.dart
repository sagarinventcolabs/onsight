
//import 'package:alt_sms_autofill/alt_sms_autofill.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/repository/web_service_response/error_response.dart';
import 'package:on_sight_application/screens/verify_otp/view_model/verify_screen_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/strings.dart';

import 'package:sms_autofill/sms_autofill.dart';

class VerifyOtpScreen extends StatefulWidget {
  final number;
  final selectedContryCode;
  final accessToken;
  final expires;

  VerifyOtpScreen(
      {Key? key, this.number, this.selectedContryCode, this.accessToken, this.expires})
      : super(key: key);

  @override
  _VerifyOtpScreenState createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController textEditingController = TextEditingController(text: "");
  TextEditingController phoneController = new TextEditingController(text: "");
  var selectedContryCode = "+1";

  VerifyScreenController controller = Get.put(VerifyScreenController());

  @override
  void initState() {
    phoneController.text = widget.number;
    selectedContryCode = widget.selectedContryCode;
    super.initState();
    //initSmsListener();
    initSms();
  }

/*  Future<void> initSmsListener() async {

    String commingSms;
    try {
      if (await Permission.sms.request().isGranted) {
        // Either the permission was already granted before or the user just granted it.
        commingSms = (await AltSmsAutofill().listenForSms)!;
        var string = commingSms.replaceAll(new RegExp(r'[^0-9]'),'');
        //var aStr = commingSms.substring(commingSms.length-5);
        if(string.isNotEmpty){
          if(string.length>3){
            textEditingController.text = string.toString().substring(0,4);
            controller.enableButton.value = true;
            Future.delayed(const Duration(seconds: 2),(){
              controller.verifyOtp(textEditingController.text.toString().trim());
            });
          }
        }



      }else{
        await Permission.sms.request().then((value) {
          if(value.isGranted){
            initSmsListener();
          }
        });
      }
    } catch(e){
      print(e);
    }

    if (!mounted) return;


  }*/

  @override
  void dispose() {
    // AltSmsAutofill().unregisterListener();
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Obx(() =>
          Scaffold(
              key: _scaffoldKey,
              bottomNavigationBar: GestureDetector(
                  onTap: () async {
                    if (controller.validate(
                        phoneController.text, textEditingController.text)) {
                      FocusScope.of(context).unfocus();
                      //    Get.to(() => UserDetailScreen());
                      var response = await controller.verifyOtp(widget.number,
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
                    padding: EdgeInsets.only(left: Dimensions.height30,
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
                            ? Image.asset(
                            Assets.logoTextDark, height: Dimensions.height63)
                            :
                        Image.asset(
                            Assets.logoText, height: Dimensions.height63)
                      ],
                    ),
                    SizedBox(
                      height: Dimensions.height70,
                    ),
                    Text(
                      entermobilenumbertitle,
                      style: TextStyle(fontSize: Dimensions.font20,
                          color: Get.isDarkMode ? ColourConstants
                              .darkModeWhite : Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: Dimensions.height60,
                    ),
                    Container(
                      height: 75,
                      padding: EdgeInsets.only(left: Dimensions.height25,
                          right: Dimensions.height25),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right: Dimensions.height4,
                                  top: Dimensions.height4,
                                  bottom: Dimensions.height4),
                              child: Container(
                                height: 59,
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(Dimensions.height5)),
                                    border: Border.all(
                                        width: 1.0, color: Colors.grey)),
                                child: CountryCodePicker(
                                  enabled: false,
                                  textStyle: TextStyle(
                                      color: Get.isDarkMode ? ColourConstants
                                          .darkModeWhite : Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: Dimensions.font16),
                                  showFlagMain: false,
                                  padding: EdgeInsets.zero,
                                  dialogBackgroundColor: Get.isDarkMode ? Colors
                                      .black : Colors.white,
                                  dialogTextStyle: TextStyle(
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black),
                                  searchDecoration: InputDecoration(),
                                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                  initialSelection: selectedContryCode,
                                  favorite: const ['+91', 'in'],
                                  // optional. Shows only country name and flag
                                  showCountryOnly: false,
                                  // optional. Shows only country name and flag when popup is closed.
                                  showOnlyCountryWhenClosed: false,
                                  showFlag: false,
                                  // optional. aligns the flag and the Text left
                                  alignLeft: true,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: Container(
                              padding: const EdgeInsets.only(left: 2.0),
                              child: TextField(
                                onChanged: (val) {
                                  phoneController.text = widget.number;
                                },
                                keyboardType: TextInputType.number,
                                controller: phoneController,
                                decoration: InputDecoration(
                                  labelText: mobileNumber,
                                  labelStyle: TextStyle(
                                      color: Get.isDarkMode ? ColourConstants
                                          .darkModeWhite : Colors.black54),
                                  floatingLabelStyle: TextStyle(
                                      color: controller.isValidphone.isFalse
                                          ? Colors.red
                                          : Get.isDarkMode
                                          ? Colors.blue
                                          : Colors.black54),
                                  errorText: controller.isValidphone.isFalse
                                      ? phoneNumberValidation
                                      : null,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1,
                                        color: Get.isDarkMode
                                            ? Colors.white70
                                            : Colors.grey),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide:
                                    BorderSide(width: 1, color: Colors.blue),
                                  ),
                                  errorBorder: const OutlineInputBorder(
                                    borderSide:
                                    BorderSide(width: 1, color: Colors.red),
                                  ),
                                  focusedErrorBorder: const OutlineInputBorder(
                                    borderSide:
                                    BorderSide(width: 1, color: Colors.red),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
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
                          controller.validate(phoneController.text, textEditingController.text);
                          setState(() {});
                          // if(valid){
                          //
                          //   Future.delayed(const Duration(seconds: 1),(){
                          //     controller.verifyOtp(textEditingController.text.toString().trim());
                          //   });
                          // }
                        },
                        onCodeSubmitted: (val) {
                          textEditingController.text = val.toString();
                          controller.validate(
                              phoneController.text, textEditingController.text);
                          setState(() {

                          });
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
                              color: Get.isDarkMode ? ColourConstants
                                  .darkModeWhite : Colors.black54),
                          floatingLabelStyle: TextStyle(
                              color: Get.isDarkMode ? Colors.blue : Colors
                                  .black54),
                          /*errorText: controller.isValidOtp.isFalse
                          ? verificationCodeInvalid
                          : null,*/
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Get
                                .isDarkMode ? Colors.white70 : Colors.grey),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors
                                .blue),
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
                        controller.resendOtp(
                            phoneController.text.toString(),
                            selectedContryCode);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                right: Dimensions.height25),
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


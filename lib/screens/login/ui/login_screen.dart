import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_root_jailbreak/flutter_root_jailbreak.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/repository/database_managers/app_internet_manager.dart';
import 'package:on_sight_application/repository/web_service_response/error_response.dart';
import 'package:on_sight_application/screens/login/view_model/login_screen_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:on_sight_application/utils/dialogs.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/strings.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneNumberController = TextEditingController(text: "");
  var selectedContryCode = "+1";
  TextEditingController textEditingController = new TextEditingController(text: "");
  FocusNode focusphone = FocusNode();
  LoginScreenController loginScreenController = Get.put(LoginScreenController());

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      AppInternetManager appInternetManager = AppInternetManager();
      await appInternetManager.updateAppInternetStatus(appInternetStatus: 1);
      await appInternetManager.updateUploadNotifyStatus(uploadCompleteNotify: 1);
      await appInternetManager.updateBatterySaverStatus(val: 1);
      await appInternetManager.updateCameraShutterStatus(val: 1);
    });
  }
  @override
  void didChangeDependencies() {
    /// Checking Security for Root & Jailbreak for both IOS & Android.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (Platform.isAndroid) {
        var isRooted = await FlutterRootJailbreak.isRooted;
        if (isRooted) {
          sp?.clearImportantKeys();
          sp?.clear();
          securityDialog(context,cancelable: false,onTap: (){
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          });
        }
      }else{
        var isJailBroken = await FlutterRootJailbreak.isJailBroken;
        if (isJailBroken) {
          sp?.clearImportantKeys();
          sp?.clear();
          securityDialog(context,cancelable: false,onTap: (){
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          },
          );
        }
      }
    },
    );
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return Obx(() =>  GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: Dimensions.height80),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Get.isDarkMode?Image.asset(Assets.logoTextDark, height: Dimensions.height63):
                      Image.asset(Assets.logoText, height: Dimensions.height63)
                    ]
                ),
                SizedBox(height: Dimensions.height70),
                Text(entermobilenumbertitle, style: TextStyle(fontSize: Dimensions.font20, color:Get.isDarkMode?ColourConstants.white: ColourConstants.black),textAlign: TextAlign.center,),
                SizedBox(height: Dimensions.height60),
                Container(
                  padding: EdgeInsets.only(left: Dimensions.height20, right: Dimensions.height20),
                  height: 75,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          height: 59,
                          padding: EdgeInsets.only(bottom: Dimensions.height5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(Dimensions.height5)),
                            border: Border.all(width: 1.0, color: Get.isDarkMode?Colors.white70:ColourConstants.grey),
                          ),
                          child: CountryCodePicker(
                            textStyle: TextStyle(color: Get.isDarkMode?ColourConstants.darkModeWhite: ColourConstants.black, fontWeight: FontWeight.bold, fontSize: Dimensions.font16),
                            showFlagMain: false,
                            padding: EdgeInsets.zero,
                            // barrierColor: Get.isDarkMode ? Colors.grey.shade900.withOpacity(0.3) : Colors.grey.shade300.withOpacity(0.3),
                            dialogBackgroundColor: Get.isDarkMode?ColourConstants.black:ColourConstants.white,
                            dialogTextStyle: TextStyle(color: Get.isDarkMode?ColourConstants.white:ColourConstants.black),
                            searchDecoration: InputDecoration(),
                            onChanged: (val){

                              selectedContryCode = val.toString();
                              FocusScope.of(context).unfocus();
                            },
                            showFlag: false,
                            // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                            initialSelection: selectedContryCode,
                            favorite: ['US','in','+91',],
                            // optional. Shows only country name and flag
                            showCountryOnly: false,
                            // optional. Shows only country name and flag when popup is closed.
                            showOnlyCountryWhenClosed: false,
                            // optional. aligns the flag and the Text left
                            alignLeft: true,
                          ),
                        ),
                      ),
                      SizedBox(width: Dimensions.width10),
                      Expanded(
                        flex: 10,
                        child: TextField(
                          controller: phoneNumberController,
                          focusNode: focusphone,
                          maxLength: 12,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (val){
                            if(val.isEmpty){
                              loginScreenController.isValidphone.value = false;
                              loginScreenController.enableButton.value = false;
                            }else{
                              loginScreenController.isValidphone.value = true;
                              loginScreenController.enableButton.value = true;
                            }
                            loginScreenController.validate(val);
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: mobileNumber,
                            counterText: "",
                            labelStyle: TextStyle(color: Get.isDarkMode?ColourConstants.darkModeWhite:Colors.black54),
                            floatingLabelStyle: TextStyle(color: Get.isDarkMode? ColourConstants.blue:Colors.black54),
                            // errorText: phoneNumberController.text.isEmpty ? null : loginScreenController.validate(phoneNumberController.text) ? phoneNumberValidation : null,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color:  Get.isDarkMode?Colors.white70:ColourConstants.grey),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: ColourConstants.blue),
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
                      )
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height/3),
                GestureDetector(
                    onTap: (){
                      if(loginScreenController.validate(phoneNumberController.text)) {
                        showAlertDialog();
                      }
                    },
                    child:Padding(
                      padding: EdgeInsets.only(left: Dimensions.height30, right: Dimensions.height30, bottom: Dimensions.height35),
                      child: Container(
                        height: Dimensions.height45,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(Dimensions.height10)),
                            color:loginScreenController.enableButton.isTrue? ColourConstants.primary:ColourConstants.grey
                        ),
                        child: Center(child: Text(sendCode, style: TextStyle(color: ColourConstants.white, fontWeight: FontWeight.w500, fontSize: Dimensions.font21),)),
                      ),
                    )
                ),
              ],
            ),
          )
      ),
    ));
  }



// Show Dialog when click on submit button...........
  showAlertDialog(){
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context){
          return AlertDialog(
            backgroundColor: Get.isDarkMode?Color(0xFF1C1C1C):ColourConstants.white,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(Dimensions.height10),
                  child: Text(alert, style:TextStyle(color:  Get.isDarkMode?ColourConstants.blue:ColourConstants.primary, fontSize: Dimensions.font20, fontWeight: FontWeight.w700  )),
                ),
                Divider(color: ColourConstants.black,),
              ],
            ),
            titlePadding: const EdgeInsets.all(0),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: Dimensions.height10,),
                Text(weWillverify, style:TextStyle(color: Get.isDarkMode?ColourConstants.white:ColourConstants.black, fontSize: Dimensions.font15, fontWeight: FontWeight.w400)),
                SizedBox(height: Dimensions.height5,),
                Text(selectedContryCode+phoneNumberController.text.toString(), style: TextStyle(color:   Get.isDarkMode?ColourConstants.blue:ColourConstants.primary, fontSize: Dimensions.font15, fontWeight: FontWeight.w700)),
                SizedBox(height: Dimensions.height15,),
                Text(isItOk, style:TextStyle(color: Get.isDarkMode?ColourConstants.white:ColourConstants.black, fontSize: Dimensions.font15, fontWeight: FontWeight.w400), textAlign: TextAlign.center,),
              ],
            ),
            contentPadding: EdgeInsets.all(Dimensions.height10),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: (){
                      Get.back();
                    },
                    child:  SizedBox(
                      height: Dimensions.height30,
                      width: Dimensions.height50,
                      child: Center(child: Text(edit, style: TextStyle(color:Get.isDarkMode?ColourConstants.blue: ColourConstants.primary, fontWeight: FontWeight.w400, fontSize: Dimensions.font15),)),
                    ),
                  ),
                  GestureDetector(
                    onTap: ()async{
                      FocusScope.of(context).unfocus();
                      Get.back();
                      // Get.to(() => VerifyOtpScreen(number: "8440077455", selectedContryCode: "91"));

                      var response = await loginScreenController.getOtpRequest(phoneNumberController.text.toString(), selectedContryCode);

                      if(response!=null) {
                        if (response.containsKey(error)) {
                          ErrorResponse errorModel = ErrorResponse.fromJson(
                              response);
                          if (errorModel.errorDescription.toString().contains(
                              phoneValidation)) {
                            loginScreenController.isValidphone.value = false;
                          }
                        }
                      }
                    },
                    child:  SizedBox(
                      height: Dimensions.height50,
                      width: Dimensions.height50,
                      child: Center(child: Text(ok, style: TextStyle(color: Get.isDarkMode?ColourConstants.blue:ColourConstants.primary, fontWeight: FontWeight.w400, fontSize: Dimensions.font15),)),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }
}
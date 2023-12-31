import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_root_jailbreak/flutter_root_jailbreak.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/repository/database_managers/app_internet_manager.dart';
import 'package:on_sight_application/screens/login/view_model/login_screen_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dialogs.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/strings.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({Key? key}) : super(key: key);

  @override
  EmailLoginScreenState createState() => EmailLoginScreenState();
}

class EmailLoginScreenState extends State<EmailLoginScreen> {
  FocusNode focusEmail = FocusNode();
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
    Theme.of(context) == Brightness.dark;

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
                Text(enterEmailTitle, style: TextStyle(fontSize: Dimensions.font20, color:Get.isDarkMode?ColourConstants.white: ColourConstants.black),textAlign: TextAlign.center,),
                SizedBox(height: Dimensions.height60),
                Container(
                  padding: EdgeInsets.only(left: Dimensions.height20, right: Dimensions.height20),
                  height: Dimensions.height75,
                  child:TextField(

                    controller: loginScreenController.emailController,
                    focusNode: focusEmail,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(" ")
                    ],
                    onChanged: (val){
                      loginScreenController.isValidEmail.value = true;
                      if(!EmailValidator.validate(val.toString())){
                        loginScreenController.enableButton.value = false;
                      }else{
                        loginScreenController.isValidEmail.value = true;
                        loginScreenController.enableButton.value = true;
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: email,
                      counterText: "",
                      labelStyle: TextStyle(color: Get.isDarkMode?ColourConstants.darkModeWhite:Colors.black54),
                      floatingLabelStyle: TextStyle(color: Get.isDarkMode? ColourConstants.blue:Colors.black54),
                      errorText: loginScreenController.isValidEmail.value==false?loginScreenController.emailController.text.isEmpty?pleaseEnterYourEmail:invalidEmail:null,
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
                ),
               // SizedBox(height: MediaQuery.of(context).size.height/3),

              ],
            ),
          ),
        bottomNavigationBar: GestureDetector(
            onTap: (){
              loginScreenController.enableButton.value = false;
              loginScreenController.update();
              if(loginScreenController.validateEmail(loginScreenController.emailController.text)) {
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
      ),
    ));
  }



// Show Dialog when click on submit button...........
  showAlertDialog(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
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
                  Text(weWillVerifyEmail, style:TextStyle(color: Get.isDarkMode?ColourConstants.white:ColourConstants.black, fontSize: Dimensions.font15, fontWeight: FontWeight.w400)),
                  SizedBox(height: Dimensions.height5,),
                  Text(loginScreenController.emailController.text.toString(), style: TextStyle(color:   Get.isDarkMode?ColourConstants.blue:ColourConstants.primary, fontSize: Dimensions.font15, fontWeight: FontWeight.w700)),
                  SizedBox(height: Dimensions.height15,),
                  Text(isItOkEmail, style:TextStyle(color: Get.isDarkMode?ColourConstants.white:ColourConstants.black, fontSize: Dimensions.font15, fontWeight: FontWeight.w400), textAlign: TextAlign.center,),
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
                        if(loginScreenController.validate(loginScreenController.emailController.text))
                        await loginScreenController.getOtpWithEmail(loginScreenController.emailController.text.toString());
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
            ),
          );
        });
  }

}
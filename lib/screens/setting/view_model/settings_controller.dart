import 'package:battery_info/battery_info_plugin.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/repository/database_managers/app_internet_manager.dart';
import 'package:on_sight_application/repository/web_services/web_service.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dialogs.dart';
import 'package:on_sight_application/utils/functions/functions.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';
import 'dart:io' show Platform;
import 'package:on_sight_application/utils/strings.dart';

class SettingsController extends GetxController {

  //Api service variable for api call........
  WebService service = WebService();

  RxBool mobileDataSwitch = true.obs;
  RxBool batterySaverSwitch = false.obs;
  RxBool poorNetworkAlertSwitch = false.obs;
  RxBool notifyUploadSwitch = false.obs;
  RxBool authMode = false.obs;
  RxBool cameraShutter = false.obs;
  int batteryPercentage = 0;
  late AppInternetManager appInternetManager;
  @override
  void onInit() {
    super.onInit();
    setupData();
    getBatteryPercentage();
    checkIsInternetAvailable();
  }

  setMobileDataSwitch({val}) async {
    mobileDataSwitch.value = val ?? true;
    AppInternetManager appInternetManager = AppInternetManager();
    await appInternetManager.updateAppInternetStatus(appInternetStatus: val == true ? 1 : 0);
    await appInternetManager.getSettingsTable() as List;
    update();
  }


  setBatterySwitch({val}) async {
    batterySaverSwitch.value = val ?? false;
    AppInternetManager appInternetManager = AppInternetManager();
    await appInternetManager.updateBatterySaverStatus(val: val == true ? 1 : 0);
    await appInternetManager.getSettingsTable() as List;
    update();
  }

  setCameraSoundSwitch({val}) async {
    cameraShutter.value = val ?? false;
    setCameraShutterOnOrOff(val);
    AppInternetManager appInternetManager = AppInternetManager();
    await appInternetManager.updateCameraShutterStatus(val: val == true ? 1 : 0);
    await appInternetManager.getSettingsTable() as List;
    update();
  }

  setNotifyUploadSwitch({val}) async {
    notifyUploadSwitch.value = val ?? true;
    AppInternetManager appInternetManager = AppInternetManager();
    await appInternetManager.updateUploadNotifyStatus(
        uploadCompleteNotify: val == true ? 1 : 0);
    await appInternetManager.getSettingsTable() as List;

    update();
  }

  setAuthMode({val}) async {
    authMode.value = val ?? true;
    AppInternetManager appInternetManager = AppInternetManager();
    await appInternetManager.updateAuthenticationMode(
        value: val == true ? 1 : 0);
    await appInternetManager.getSettingsTable() as List;

    update();
  }

  getBatteryPercentage() async {
    print(Platform.isAndroid.toString());
    batteryPercentage = Platform.isAndroid
        ? (await BatteryInfoPlugin().androidBatteryInfo)?.batteryLevel ?? 0
        : (await BatteryInfoPlugin().iosBatteryInfo)?.batteryLevel ?? 0;
    print(batteryPercentage.toString());
    if (batteryPercentage <= 15) {
      batterySaverSwitch.value = true;
    } else {
      batterySaverSwitch.value = false;
    }
    update();
  }

  checkIsInternetAvailable() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      mobileDataSwitch.value = true;
      print(mobileDataSwitch);
    } else if (connectivityResult == ConnectivityResult.wifi) {
      mobileDataSwitch.value = true;
      print(mobileDataSwitch);
    } else {
      mobileDataSwitch.value = false;
      print(mobileDataSwitch);
    }
    update();
  }

  /// set the camera shutter sound ON or OFF
  setCameraShutterOnOrOff(bool isOn) async {
    try {
      const platform = MethodChannel(channelID);
      await platform.invokeMethod(cameraShutterAction, {isCameraShutterOn: isOn});
    } on PlatformException catch (e) {
      debugPrint("Failed : '${e.message}'.");
    }
  }



  /// get the camera shutter volume level
  /// if the value is greater than 0 refer to camera sound ON
  getCameraShutterVolume() async {
    try {
      const platform = MethodChannel(channelID);
      var result = await platform.invokeMethod(cameraShutterVolume);
      debugPrint("Volume result = $result");
      if (result != null && result) {
        debugPrint("Volume result not null $result");
      }
    } on PlatformException catch (e) {
      debugPrint("Failed : '${e.message}'.");
    }
  }

  void setupData() async {
    appInternetManager = AppInternetManager();
    var a = await appInternetManager.getSettingsTable() as List;
    if(a.isNotEmpty) {
      mobileDataSwitch.value = a[0]["AppInternetStatus"] == 1 ? true : false;
      notifyUploadSwitch.value = a[0]["UploadCompleteStatus"] == 1 ? true : false;
      batterySaverSwitch.value = a[0]["BatterySaverStatus"] == 1 ? true : false;
      poorNetworkAlertSwitch.value = a[0]["PoorNetworkAlert"] == 1 ? true : false;
      authMode.value = a[0]["AuthenticationMode"] == 1 ? true : false;
    }
    update();
  }

  //Api for delete user......................................

  Future<dynamic> deleteUserApi() async{
    var mobile = sp?.getString(Preference.USER_MOBILE)??"";
    var code = sp?.getString(Preference.COUNTRY_CODE)??"";
    var response = await service.deleteUserRequest(mobile, code);
    if(response!=null) {
      if(response.toString().contains(mobile.toString())){
         defaultDialog(Get.context!, title: accountDeletedSuccessfully, alert: disclaimerMessage, onTap: (){
                      logoutFun();
                      Get.offAllNamed(Routes.loginScreen);
                    }, cancelable: false);
      }else{
        Get.showSnackbar(GetSnackBar(message: response.toString(), duration: Duration(seconds: 2),));

      }
    }
   // return response;
  }

}

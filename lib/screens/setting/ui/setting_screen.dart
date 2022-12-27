import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/repository/database_managers/app_internet_manager.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/screens/setting/view_model/settings_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dialogs.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/functions/functions.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:on_sight_application/utils/widgets/base_app_bar.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  bool cameraShutterSwitch = false;
  // int batteryPercentage = 0;
  late AppInternetManager appInternetManager;

  SettingsController controller = Get.find<SettingsController>();

  @override
  void initState() {
    appInternetManager = AppInternetManager();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context) == Brightness.dark;
    return Obx(()=> Scaffold(
      appBar: const BaseAppBar(title: settingsString),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.height20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Dimensions.height16),
            Text(performance,style: TextStyle(fontSize: Dimensions.font16,fontWeight: FontWeight.w600,color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,)),
            Container(
              margin: EdgeInsets.only(top: Dimensions.height10),
              decoration: BoxDecoration(
                  color: Get.isDarkMode ? ColourConstants.grey900 : null,
                  border: Border.all(color: Get.isDarkMode ? ColourConstants.transparent : ColourConstants.grey200,width: 1,),
                  borderRadius: BorderRadius.circular(Dimensions.height4)
              ),
              child: SwitchListTile(
                value: controller.mobileDataSwitch.value,
                title: Text(enableMobileData,style: TextStyle(color: controller.mobileDataSwitch.value ? Get.isDarkMode ? ColourConstants.white : ColourConstants.black : ColourConstants.grey,fontSize: Dimensions.font17),),
                activeColor: ColourConstants.green,
                onChanged: (val) async {
                  await controller.setMobileDataSwitch(val: val);
                  setState(()  {});
                  AnalyticsFireEvent(EnableMobileData, input: {
                    value:val.toString(),
                    user:sp?.getString(Preference.FIRST_NAME)??""
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: Dimensions.height10),
              decoration: BoxDecoration(
                  color: Get.isDarkMode ? ColourConstants.grey900 : null,
                  border: Border.all(color: Get.isDarkMode ? ColourConstants.transparent : ColourConstants.grey200,width: 1,),
                  borderRadius: BorderRadius.circular(Dimensions.height4)
              ),
              child: SwitchListTile(
                value: controller.batterySaverSwitch.value,
                activeColor: ColourConstants.green,
                title: Text(batterySaver,style: TextStyle(color: controller.batterySaverSwitch.value ? Get.isDarkMode ? ColourConstants.white : ColourConstants.black : ColourConstants.grey,fontSize: Dimensions.font17)),
                subtitle: Text(pauseUpload,style: TextStyle(fontSize: Dimensions.font11,color: controller.batterySaverSwitch.value ? Get.isDarkMode ? ColourConstants.white : ColourConstants.black : ColourConstants.grey),),
                onChanged: (valuee) async {
                  await controller.setBatterySwitch(val: valuee);
                  setState((){});
                  AnalyticsFireEvent(BatterySaver, input: {
                    value:valuee.toString(),
                    user:sp?.getString(Preference.FIRST_NAME)??""
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: Dimensions.height10),
              decoration: BoxDecoration(
                  color: Get.isDarkMode ? ColourConstants.grey900 : null,
                  border: Border.all(color: Get.isDarkMode ? ColourConstants.transparent : ColourConstants.grey200,width: 1,),
                  borderRadius: BorderRadius.circular(Dimensions.height4)
              ),
              child: SwitchListTile(
                value: controller.poorNetworkAlertSwitch.isTrue,
                activeColor: ColourConstants.green,
                title: Text(poorNetworkAlert,style: TextStyle(color: controller.poorNetworkAlertSwitch.isTrue ? Get.isDarkMode ? ColourConstants.white : ColourConstants.black : ColourConstants.grey,fontSize: Dimensions.font17)),
                subtitle: Text(alertOnPoorConnection,style: TextStyle(fontSize: Dimensions.font11, color: controller.poorNetworkAlertSwitch.isTrue ? Get.isDarkMode ? ColourConstants.white : ColourConstants.black : ColourConstants.grey)),
                onChanged: (val) async {
                  controller.poorNetworkAlertSwitch.value = val;
                  await controller.setCameraSoundSwitch(val: val);
                  setState((){});
                  AnalyticsFireEvent(PoorNetworkAlert, input: {
                    value:val.toString(),
                    user:sp?.getString(Preference.FIRST_NAME)??""/* +" "+sp?.getString(Preference.LAST_NAME)??""*/
                  });
                },
              ),
            ),
            SizedBox(height: Dimensions.height20),
            Text(utility,style: TextStyle(fontSize: Dimensions.font16,fontWeight: FontWeight.w600,color: Get.isDarkMode ? ColourConstants.white :  ColourConstants.primary,)),
            Container(
              margin: EdgeInsets.only(top: Dimensions.height10),
              decoration: BoxDecoration(
                  color: Get.isDarkMode ? ColourConstants.grey900 : null,
                  border: Border.all(color: Get.isDarkMode ? ColourConstants.transparent : ColourConstants.grey200,width: 1,),
                  borderRadius: BorderRadius.circular(Dimensions.height4)
              ),
              child: SwitchListTile(
                activeColor: ColourConstants.green,
                value: controller.cameraShutter.value,
                title: Text(cameraShutter,style: TextStyle(color: controller.cameraShutter.value ? Get.isDarkMode ? ColourConstants.white : ColourConstants.black : ColourConstants.grey, fontSize: Dimensions.font17)),
                onChanged: (val)async{
                  await controller.setCameraSoundSwitch(val: val);
                  setState((){});
                  AnalyticsFireEvent(CameraShutter, input: {
                    value:val.toString(),
                    user:sp?.getString(Preference.FIRST_NAME)??""/* +" "+sp?.getString(Preference.LAST_NAME)??""*/
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: Dimensions.height10),
              decoration: BoxDecoration(
                  color: Get.isDarkMode ? ColourConstants.grey900 : null,
                  border: Border.all(color: Get.isDarkMode ? ColourConstants.transparent : ColourConstants.grey200,width: 1,),
                  borderRadius: BorderRadius.circular(Dimensions.height4)
              ),
              child: SwitchListTile(
                activeColor: ColourConstants.green,
                value: controller.notifyUploadSwitch.value,
                title: Text(notifyUploadComplete,style: TextStyle(color: controller.notifyUploadSwitch.value ? Get.isDarkMode ? ColourConstants.white : ColourConstants.black : ColourConstants.grey,fontSize: Dimensions.font17)),
                onChanged: (val){
                  controller.setNotifyUploadSwitch(val: val);
                  setState(()  {});
                  AnalyticsFireEvent(NotifyComplete, input: {
                    value:val.toString(),
                    user:sp?.getString(Preference.FIRST_NAME)??""
                  },
                  );
                },
              ),
            ),
            SizedBox(height: Dimensions.height20),

            Text(securityAndAccount,style: TextStyle(fontSize: Dimensions.font16,fontWeight: FontWeight.w600,color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,)),

            // Container(
            //   margin: EdgeInsets.only(top: Dimensions.height10),
            //   decoration: BoxDecoration(
            //       color: Get.isDarkMode ? ColourConstants.grey900 : null,
            //       border: Border.all(color: Get.isDarkMode ? ColourConstants.transparent : ColourConstants.grey200,width: 1,),
            //       borderRadius: BorderRadius.circular(Dimensions.height4)
            //   ),
            //   child: SwitchListTile(
            //     activeColor: ColourConstants.green,
            //     value: controller.authMode.value,
            //     title: Text(screenLock,style: TextStyle(color: controller.authMode.value ? Get.isDarkMode ? ColourConstants.white : ColourConstants.black : ColourConstants.grey)),
            //     subtitle: Text(pinBioPattern,style: TextStyle(fontSize: Dimensions.height11, color: controller.poorNetworkAlertSwitch.isTrue ? Get.isDarkMode ? ColourConstants.white : ColourConstants.black : ColourConstants.grey)),
            //     onChanged: (val){
            //       controller.setAuthMode(val: val);
            //
            //     },
            //   ),
            // ),
            GestureDetector(
              onTap: (){
                dialogAction(context,
                  title: doYouWantDeleteAccount,
                  onTapYes: (){
                  controller.deleteUserApi();
                  Get.back();
                 /* defaultDialog(context, title: accountDeletedSuccessfully,onTap: (){
                    sp?.clear();
                    Get.offAllNamed(Routes.loginScreen);
                  });*/
                  },
                  onTapNo: (){
                  Get.back();
                  }
                );
              },
              child: Container(
                margin: EdgeInsets.only(top: Dimensions.height10),
                decoration: BoxDecoration(
                    color: Get.isDarkMode ? ColourConstants.grey900 : null,
                    border: Border.all(color: Get.isDarkMode ? ColourConstants.transparent : ColourConstants.grey200,width: 1,),
                    borderRadius: BorderRadius.circular(Dimensions.height4)
                ),
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: Dimensions.size18, vertical: Dimensions.size18),
                  child: Row(
                    children: [
                      Text(deleteMyAccount, style: TextStyle(color: ColourConstants.grey, fontSize: Dimensions.font17),),
                      Expanded(child: Container()),
                      Image.asset(Assets.image_delete, width: Dimensions.width22, height: Dimensions.height27,),
                      SizedBox(width: Dimensions.width15,)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

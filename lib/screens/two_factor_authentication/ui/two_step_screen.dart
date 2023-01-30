

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/repository/database_managers/app_internet_manager.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/screens/setting/view_model/settings_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/strings.dart';

class IntroductionTwoStep extends StatefulWidget {
  const IntroductionTwoStep({Key? key}) : super(key: key);

  @override
  State<IntroductionTwoStep> createState() => _IntroductionTwoStepState();
}

class _IntroductionTwoStepState extends State<IntroductionTwoStep> {
  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(900)),
                color: ColourConstants.ellipseColor
            ),
            child: Center(child: Image.asset(Assets.bioDarkMode,
              width: 180,
              height: 180,)),
          ),
          SizedBox(height: Dimensions.height100,),
          Text(screenLock, style: TextStyle(fontWeight: FontWeight.bold, fontSize: Dimensions.font21),),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(screenLockDesc, style: TextStyle(fontSize: Dimensions.font12,),textAlign: TextAlign.center,),
          ),
          SizedBox(
            height: Dimensions.height10,
          ),

          GestureDetector(
              onTap: ()async{
                AppInternetManager appInternetManager = AppInternetManager();
                await appInternetManager.updateAuthenticationMode(value: 1);
                if(Get.isRegistered<SettingsController>()){
                  SettingsController controller = Get.find<SettingsController>();
                  controller.onInit();
                  controller.update();
                }
                await appInternetManager.updateAuthAsking(value: 1).then((value) {
                  Get.offAllNamed(Routes.dashboardScreen);
                });
              },
              child:Padding(
                padding: EdgeInsets.only(left: Dimensions.height30, right: Dimensions.height30, bottom: Dimensions.height20),
                child: Container(
                  height: Dimensions.height55,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(Dimensions.height10)),
                      color:ColourConstants.primary,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text(confirmCaps, style: TextStyle(color: ColourConstants.white, fontWeight: FontWeight.w500, fontSize: Dimensions.font18),)),
                  ),
                ),
              )
          ),

          GestureDetector(
              onTap: ()async{
                AppInternetManager appInternetManager = AppInternetManager();
                await appInternetManager.updateAuthAsking(value: 1).then((value) {
                  Get.offAllNamed(Routes.dashboardScreen);
                });
              },
              child: Text(skipCaps, style: TextStyle(fontSize: Dimensions.font17),))
        ],
      ),
    );
  }
}

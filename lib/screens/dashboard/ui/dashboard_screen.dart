import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/main.dart';
import 'package:on_sight_application/repository/database_managers/app_internet_manager.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/screens/dashboard/view_model/app_update_controller.dart';
import 'package:on_sight_application/screens/setting/view_model/settings_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/functions/functions.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:on_sight_application/utils/widgets/dashboard_tile.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:on_sight_application/utils/dialogs.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  DashboardScreenState createState() => DashboardScreenState();
}
enum Availability { loading, available, unavailable }
class DashboardScreenState extends State<DashboardScreen>{

  List<Map<String, dynamic>> choices = [
    {title: settings, icon: Icons.settings},
    {title: profile, icon: Icons.person_off},
    {title: aboutUs, icon: Icons.abc_outlined},
    {title: logout, icon: Icons.logout},
  ];


  SettingsController settingsController = Get.put(SettingsController());
  AppUpdateController appUpdateController = Get.put(AppUpdateController());
  PackageInfo? packageInfo;
  // final InAppReview _inAppReview = InAppReview.instance;
  // Availability _availability = Availability.loading;



  @override
  initState() {
    super.initState();
    flutterLocalNotificationsPlugin.cancelAll();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setSettingsData();

    });
  }

  @override
  void didChangeDependencies() {
    /// Checking Security for Root & Jailbreak for both IOS & Android.
    checkRootJailBreakSecurity();
    DateTime dt1 = DateTime.parse((sp?.getString(Preference.DIALOG_TIMESTAMP)??DateTime(DateTime.now().year,DateTime.now().month-2,DateTime.now().day).toString()));
    DateTime dt2 = DateTime.parse(DateTime.now().toString());

    if (daysBetween(dt1,dt2) >= 30) {
      if((sp?.getInt(Preference.ACTIVITY_TRACKER)??0)>=3){
        sp?.putInt(Preference.ACTIVITY_TRACKER, 0);
        sp?.putString(Preference.DIALOG_TIMESTAMP, DateTime.now().toString());
        showRatingDialog(context);
      }
    }
    super.didChangeDependencies();
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inDays);
  }


  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    print(isDarkMode);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: Dimensions.height12,right: Dimensions.height12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
            Text("v${packageInfo?.version??"0"}"),
          ],),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Get.isDarkMode?ColourConstants.black:ColourConstants.white,
        leading:Visibility(
          visible: visibleRefresh,
          child: GestureDetector(
            onTap: () async {
              if(imageList.isNotEmpty){
                var service = FlutterBackgroundService();
                await service.startService();
                showLoader(context);
                await Future.delayed(const Duration(seconds: 5), () async {
                  Get.back();
                  var token = await sp!.getString(Preference.ACCESS_TOKEN);
                  service.invoke(failedJobDatabase, {
                    tokenString: token
                  });
                  setState(() {
                    visibleRefresh = false;
                  });
                });
              }
            },
            child: Padding(
              padding: EdgeInsets.only(left: Dimensions.height20),
              child: Image.asset(Assets.icRefresh, color: Get.isDarkMode?ColourConstants.white: ColourConstants.primary, height: Dimensions.height30, width: Dimensions.height30,),
            ),
          ),
        ),
        leadingWidth: Dimensions.width43,
        title: Text(dashboard, style: TextStyle(color: Get.isDarkMode?ColourConstants.white: ColourConstants.primary,fontWeight: FontWeight.bold, fontSize: Dimensions.font18)),
        actions: [

          PopupMenuButton<String>(
            color: Get.isPlatformDarkMode ? Colors.grey.shade800 : ColourConstants.primaryLight,
            onSelected: (value) async {
              handlePop(value);
            },
            child: Container(
                height: Dimensions.height36,
                width: Dimensions.width42,
                padding: EdgeInsets.only(right: Dimensions.height14),
                alignment: Alignment.centerRight,
                child:  SvgPicture.asset(Assets.icKebab, color: Get.isPlatformDarkMode?ColourConstants.white:ColourConstants.primary,)
            ),
            itemBuilder: (BuildContext context) {
              return choices.map((Map choice) {
                return PopupMenuItem<String>(
                  value: choice[title],
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(width: Dimensions.width2),
                            Text(
                              choice[title],
                              style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.height15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DashboardTile(title: jobPhotos,lightSvgIcon: Assets.icDashboardCam,darkSvgIcon: Assets.illJobPhotosDark,routeName: Routes.jobPhotosScreen),
            DashboardTile(title: projectEvaluation,lightSvgIcon: Assets.icProjectEvaluation,darkSvgIcon: Assets.icProjectEvaluationDark,routeName: Routes.projectEvaluationScreen),
            DashboardTile(title: leadSheet,lightSvgIcon: Assets.icLeadSheet,darkSvgIcon: Assets.icLeadSheetDark,routeName: Routes.leadSheetScreen,),
            DashboardTile(title: onboarding,lightSvgIcon: Assets.icOnBoarding,darkSvgIcon: Assets.icOnBoardingDark,routeName: Routes.onBoardingScreen),
            DashboardTile(title: promoPictures,lightSvgIcon: Assets.icPromoPic,darkSvgIcon: Assets.icPromoPicDark,routeName: Routes.promoPictureScreen),
            DashboardTile(title: fieldIssues,lightSvgIcon: Assets.icFieldIssue,darkSvgIcon: Assets.icFieldIssueDark,routeName: Routes.fieldIssues),
          ],
        ),
      ),
    );
  }



  setSettingsData() async {

    debugPrint(await sp?.getString(Preference.ACCESS_TOKEN));
    AppInternetManager appInternetManager = AppInternetManager();
    //
    // try{
    //   var isAsked = await appInternetManager.getAuthPop();
    //   debugPrint(isAsked.toString());
    //   if(isAsked!=1){
    //
    //     Get.toNamed(Routes.IntroductionTwoStep);
    //
    //   }
    // }catch(e){
    //   Get.toNamed(Routes.IntroductionTwoStep);
    // }


    var a = await appInternetManager.getSettingsTable() as List;

    if(a.isNotEmpty) {
      settingsController.setMobileDataSwitch(
          val: a[0][appInternetStatus] == 1 ? true : false);
      settingsController.setMobileDataSwitch(
            val: a[0][uploadCompleteStatus] == 1 ? true : false);
      settingsController.setMobileDataSwitch(
          val: a[0][appInternetStatus] == 1 ? true : false);
    }
    packageInfo = await PackageInfo.fromPlatform();
    setState(() {

    });
  }

  handlePop(String result) async {
    switch (result) {
      case settings:{
        Get.toNamed(Routes.settingScreen);
        break;}
      case profile:
        Get.toNamed(Routes.updateProfileScreen);
        break;
      case aboutUsStr:
        Get.toNamed(Routes.aboutUsScreen);
        break;
      case logout:
        dialogAction(context, title: "Are you sure you want to logout?", onTapNo: (){
          Get.back();
        },
        onTapYes: (){
          logoutFun();
        }
        );
        break;
    }
  }


}



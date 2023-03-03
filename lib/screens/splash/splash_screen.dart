import 'dart:io';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/env.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/main.dart';
import 'package:on_sight_application/repository/database_managers/app_internet_manager.dart';
import 'package:on_sight_application/repository/database_managers/image_manager.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/utils/analytics_methods.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/functions/functions.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<Offset>? _animation;
  Animation<Offset>? _animation2;
  late AnimationController _controller;

  @override
  void initState() {
    AnalyticsMethods().onSplash();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _controller.forward();
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation =
        Tween<Offset>(begin: const Offset(-1.0, 0.01), end: Offset.zero)
            .animate(_animationController!);
    _animation2 = Tween<Offset>(begin: const Offset(1.0, 0.1), end: Offset.zero)
        .animate(_animationController!);
    _animationController!.forward().whenComplete(() {});

    Future.delayed(const Duration(seconds: 4), () async {
      //  FlutterBackgroundService().invoke("stopService");


     // await setTempData();
     // print(isLogin);
      if (isLogin) {
        if(await sp?.getString(Constants.secureValidation)!=null) {
          try {
            var timeDate = sp?.getString(Constants.secureValidation) ?? "00";
            //var timeDate = "2023-01-15T15:11:51.676344";
            var ff = DateTime.parse(timeDate);
            print(ff);
            if (timeDate != "00") {
              print("TimeDate " + timeDate);
              var dateTime = DateTime.now();
              print("DateTime " + dateTime.toString());
              var diff =
                  dateTime
                      .difference(ff)
                      .inDays;
              print("Diff is " + diff.toString());
              if (diff > 14) {
                logoutFun();
                Get.offAllNamed(Routes.emailLoginScreen);
              } else {
                Get.offAllNamed(Routes.dashboardScreen);
              }
            }else{
              Get.offAllNamed(Routes.emailLoginScreen);
            }
          } catch (e) {

          }


          // var a = await AppInternetManager().getSettingsTable() as List;
          //
          //   if(a.isNotEmpty) {
          //     if (a[0]["AuthenticationMode"] == 1) {
          //       await authenticateUser();
          //     } else {
          //       Get.offAllNamed(Routes.dashboardScreen);
          //     }
          //   }else{
          //     Get.offAllNamed(Routes.dashboardScreen);
          //   }

        }else{
          Get.offAllNamed(Routes.emailLoginScreen);
        }
      } else {
        Get.offAllNamed(Routes.appInfoSlideScreen);
      }
    });
    super.initState();

    getRefresh();
    // print("Current Build Flavor --> "+(AppEnvironment.title));
    // print("Current Base URL --> "+(AppEnvironment.baseApiUrl));
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);

    return WillPopScope(child: Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(Assets.splash3), fit: BoxFit.fill),
            /*    gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                  Color(0xFF34006C),
                  Color(0xFF592F86),
                  Color(0xFF8251B7),
                  Color(0xFF2C1842),
                  ])*/
          ),
          child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SlideTransition(
                    position: _animation!,
                    child: AnimatedContainer(
                      alignment: Alignment.centerLeft,
                      duration: const Duration(seconds: 0),
                      child: RotationTransition(
                          turns: Tween(begin: 0.5, end: 1.0).animate(_controller),
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(40)),
                              boxShadow: [
                                BoxShadow(
                                  color: ColourConstants.primary,
                                  blurRadius: 2.0,
                                  spreadRadius: 0.0,
                                  offset: Offset(
                                      2.0, 2.0), // shadow direction: bottom right
                                )
                              ],
                            ),
                            child: const Image(
                              image: AssetImage(Assets.imagesLogo),
                            ),
                          )),
                    ),
                  ),
                  SlideTransition(
                    position: _animation2!,
                    child: AnimatedContainer(
                      alignment: Alignment.centerRight,
                      duration: const Duration(seconds: 0),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Image(
                              image: AssetImage(Assets.imagesIcOnSight),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ))),
    ),
        onWillPop: (){
      if(authorized=="Authorized"){
        Get.offAllNamed(Routes.dashboardScreen);
        return Future.value(true);
      }else{
        exit(0);
      }
    });
  }

  setTempData() async {


    var data =
        "vSwAb7uJYoaHKljhETRflYZZLqfPn0osMVwHcr_I_HiNqswJZ7fQMg9TvTTu8pbIxBHg7pJhGe2zr8JLEjeTw2Y60pEyy0mug1ZvPWmeLFVU9ZWEUNoHMkG6VN3rOmIlXGv003_JyA3nmVdQTXhFhjuSMFpYpBDBAoyGdfLba-nytTmnq8F-PteDPMwzycP1ARq8f-St8QGKRme0jRKAjFH68An0X-OLWbZuaAAttteJmVeZsBRpJFc_QbFsvxkhlxDPsDbxf0hRcPOrpkNexSF2d1E_zDAyzCpqJdzEZY1eMlpAbk2htU0O_l8EhzrTQqYO1kqjypOkJGYPDzM5nuRSjXYeABnphVjj9IJMVDm1AkjG-FyrrDGNbiubJF1NL5Izxg6Fls30CAgqAIbCSuFq1zDmm-UdW2g1IMzUbAzijT9-NiJ4YK4j42YHQi_x7YuOk1UvZeKo_Fbo3CUfEj4CHEOGHwGV8ZtFEgPMzUt-Nw8QpPmctP0a1_XNcAulo_yzr2h8x_o4JMt7uRT6CdGSpP1pd8ZBnL_fIzHX6tQM8DRzkKRZATaeHoEbyOfglZolpvYdfut87Nc9K6se5AO1pC71xba6GVwWhpJvGQFlC_K03M3fiCnhvLyJrIEqX70isfOFA0-2s6-wE6jp-oinYnvDxkkXgDiq5iSUjoQ9Ex9cFjhcFQ4rYKeyVROOvqxD9TTvUZFXbZ-2ypLyHg";
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(Preference.ACCESS_TOKEN, data);
    preferences.setString(Preference.USER_EMAIL, "sagar.s@dreamorbit.com");
    preferences.setString(Constants.secureValidation, DateTime.now().toIso8601String());
    isLogin = true;

  }

  Future<void> getRefresh() async {
      ImageManager imageManager = ImageManager();
      imageList = await imageManager.getFailedImageList();

      await WidgetsFlutterBinding.ensureInitialized();
      AppInternetManager appInternetManager = AppInternetManager();
      await appInternetManager.updateFlavor(val: AppEnvironment.currentBuildFlavor);
      setState(() {
        if (imageList.isNotEmpty) {
          visibleRefresh = true;
        } else {
          visibleRefresh = false;
        }
      });

  }
}

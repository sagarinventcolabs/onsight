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


    //  await setTempData();
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
        "1B2prfhhA9f9pftoHc3btywUqcp3-NdXsVqDufuUwOYwO6L4fQjiCcMisv0kD5QggPByNlUwVV8AxiPABw7xdVYZOnqVIfFL3ZqFLm9LUQ6wGoKRXbGDaFWecWUyyH9oYOd1Bi-JfS-Vjp-a8ShuUbpoOki1r0EYQvbq_gea6DcBpt-mu8l_1Jv4HpxAX6G-WZiufE1blggDS8x_LtGWaDx8qAsCjF5JYZh7cRslniXwq4hBeU0J2Wh96sMrcTCjDPToVZUnSQ8HhTU8Zoyd2Z3NfMB1l_CCZHWddSPV-pEPNmBgtKiY4Xman5CeZMEu1TdDZftSYMCzGDXmHgr5Dvk_hNjhAq2sV04kUcTAcApOwGomEfEE1A54bs6-y4nkOpKHNzJYS6kZL1FYWNe4pePF0JU36ZC7mGYm7eP7zkrvHCZlgTN2K5R7n4-GLzMS3N9325LOWECxJx-HLKvE5hLgrLiPc_ldQV8uk_mFDVJJjR1NV60xYQTwyKlV7MyIYUiC6-EJGe4HfhFmsUyRPL3w1m3cQZqZf78a_t499CUJ807ohMbHrZ8YsydbmjJfewokVVeI4kx_XZes4V7vCzbkvSyC5AvOeC0pif7Mof_Zr5qP86sDq-mGVA05kqqDSyMMIdPEvQdY2Mr_USKLq9vZxDdHZB_3omZ_QSzpexwtFdwSpi_sabKH-AtCcQuF_oKIfjiRRU8UV4nnB5Y77A";
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

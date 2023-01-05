import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/main.dart';
import 'package:on_sight_application/repository/database_managers/app_internet_manager.dart';
import 'package:on_sight_application/repository/database_managers/image_manager.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/utils/analytics_methods.dart';
import 'package:on_sight_application/utils/constants.dart';
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
        Get.offAllNamed(Routes.dashboardScreen);
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


      } else {
        Get.offAllNamed(Routes.appInfoSlideScreen);
      }
    });
    super.initState();

    getRefresh();
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context) == Brightness.dark;

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
        "Wc67CgvP2fn5PrXA0j-ASvP7rClaLUu-upwmyANnMEPjNDGkaoAUlAkI77W-tcX0CEv0AYqmDvrAFDDf_e7SZqz-0K9raJmA4ejz0ipIj8SZhSkRvaN-zBVvoTvKr9fxQARS2vNZhQSvL9XhecjvBQBLBKgTOXP5x1dA0MpZ6bGBvo8O4Oz0oQV697wr-xXX3vDhNeGNjUFzPOrrecUZ416A_ox9uYIoWFbKZnnbo2tRiK4AReVFYbPDhuQhPHMOg9SVeCsA555RLuMm6RRKK7vFwnwCAo7Z7yffiYxfiwkY2gMgDCGGr8mQdbse_QSbThioWMHkj9iBqjyvLmDYDe90PLUYATS_d0qf0RnqhQZtLHU8znRfVYKhtGvL3YEcQYBpI0TB9zyETqkkOCssaA0KwygdYXvQYUfVh-N-TF-TSLZfDkVdVv4UAncNmeUkD3x4W9FT_QzOoaYg70M5p43pVDyxrU8Ff0ldYCzplVw-qUHbrKTMXXG5vpk_j8fJcANHhW74DkWrfyiwZXhxvWqCqXzRiypAR98CGXWlSyr-D0ebKbedsf7zLAXR0rAULPbNsGor2zAHlG4lNqTdE66Ef_TXr8GajAwggldGU752gK73EEIY17MJhnNdBybbV1vgueVH-pwKo0uNI8aJCKrPosqcYzFZVzgSKFNFfTvOypt1sRU4LZ1pCL9kmqO4";
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(Preference.ACCESS_TOKEN, data);
    isLogin = true;

  }

  Future<void> getRefresh() async {
      ImageManager imageManager = ImageManager();
      imageList = await imageManager.getFailedImageList();

      await WidgetsFlutterBinding.ensureInitialized();
      AppInternetManager appInternetManager = AppInternetManager();
      await appInternetManager.updateFlavor(val: currentBuildFlavor??"");
      setState(() {
        if (imageList.isNotEmpty) {
          visibleRefresh = true;
        } else {
          visibleRefresh = false;
        }
      });

  }
}

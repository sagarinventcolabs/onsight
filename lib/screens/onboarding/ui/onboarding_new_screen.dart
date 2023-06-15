import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/screens/onboarding/view_model/onboarding_controller.dart';
import 'package:on_sight_application/screens/onboarding/view_model/onboarding_photos_controller.dart';
import 'package:on_sight_application/screens/onboarding/view_model/onboarding_resource_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/functions/SearchFunctions.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:on_sight_application/utils/widgets/onboarding_tile.dart';

class OnBoardingNewScreen extends StatefulWidget {
  const OnBoardingNewScreen({Key? key}) : super(key: key);

  @override
  OnBoardingNewScreenState createState() => OnBoardingNewScreenState();
}

class OnBoardingNewScreenState extends State<OnBoardingNewScreen> with SearchFunctions{

  TextEditingController jobEditingController = TextEditingController(text: "");
  FocusNode jobFocusNode = FocusNode();
  bool buttonEnable = false;
  String selectedCategory = oasisEntry;
  OnboardingController controller = Get.put(OnboardingController());
  SuggestionsBoxController suggestionsBoxController = SuggestionsBoxController();
  OnboardingResourceController onboardingResourceController = Get.put(OnboardingResourceController());
  OnBoardingPhotosController onboardingPhotosController = Get.put(OnBoardingPhotosController());

  final List<String> optionList = [oasisEntry, fileDocuments];


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  final ScrollController _scrollController = ScrollController();

  void _scrollDown() {
    Future.delayed(const Duration(seconds: 1), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200),
        curve: Curves.fastOutSlowIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return WillPopScope(
      onWillPop: ()async{
        Get.offNamedUntil(Routes.dashboardScreen, (route) => false);
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              icon: Image.asset(
                Assets.appBarLeadingButton,
                color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,
                height: Dimensions.height25,
                width: Dimensions.height25,
              ),
              onPressed: () {
                Get.offNamedUntil(Routes.dashboardScreen, (route) => false);
              },
            ),
            elevation: 0.0,
            backgroundColor: Get.isDarkMode ? ColourConstants.black : ColourConstants.white,
            title: Text(onBoardingStr,
                style: TextStyle(
                    color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: Dimensions.font16)),
          ),

          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.height20),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/14),
                    child: Image.asset(
                      Get.isDarkMode ? Assets.ilOnBoardingDark :Assets.illOnBoarding,
                      height: MediaQuery.of(context).size.height/4.3,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height/14),
                  Column(
                    children: [
                    OnboardingTile(title: addNewHire,
                      lightSvgIcon: Assets.ic_job_photoss,
                      darkSvgIcon: Assets.icJobPhotosDark,
                    routeName: Routes.onBoardingRegistration,),

                      OnboardingTile(title: addSupportingDocuments,
                        lightSvgIcon: Assets.ic_Projecxt_Evaluation,
                        darkSvgIcon: Assets.Ic_OnboardingEvaluation_dark,
                          routeName: Routes.onBoardingResourceScreenNew),
                    ],
                  ),
                  SizedBox(height: Dimensions.height100,)
                ],
              ),
            )
          )),
    );
  }
}

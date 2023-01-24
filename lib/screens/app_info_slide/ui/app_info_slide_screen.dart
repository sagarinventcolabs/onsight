import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/screens/app_info_slide/controller/app_info_slide_controller.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/slider_ui/simple_slider.dart';
import 'package:on_sight_application/utils/slider_ui/simple_slider_controller.dart';
import 'package:on_sight_application/utils/strings.dart';

class AppInfoSlideScreen extends StatelessWidget {
  AppInfoSlideScreen({Key? key}) : super(key: key);

  final sliderController = Get.put(AppInfoSlideController());
  final simpleSliderController = Get.put(SimpleSliderController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Theme.of(context);
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,

      bottomNavigationBar: Obx(() => Padding(
          padding: EdgeInsets.only(left: Dimensions.height25, right: Dimensions.height25, bottom: Dimensions.height50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: sliderController.currentIndex.value<2,
                child: GestureDetector(
                  onTap: (){
                    sliderController.navigateToLogin();
                  },
                  child: Text(skip, style: TextStyle(fontSize: Dimensions.font15)))),

              GestureDetector(
                  onTap: (){
                    print(sliderController.currentIndex.value);
                    if(sliderController.currentIndex.value<2){
                      var n = sliderController.currentIndex.value+1;
                      simpleSliderController.pageController.jumpToPage(n);
                    }else{
                      sliderController.navigateToLogin();
                    }
                  },
                  child: Image.asset(Assets.rightArrow,width: Dimensions.height55, height: Dimensions.height55,)
              )
            ],
          )
      ),

      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height*.08,),
          Expanded(
            flex: 2,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(Dimensions.height16),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Get.isDarkMode?Image.asset(Assets.logoTextDark, height: Dimensions.height63):
                    Image.asset(Assets.logoText, height: Dimensions.height63)
                  ],
                ),
              ),
            ),
          ),
          Expanded(
              flex: 8,
              child: Container(
                alignment: Alignment.center,
                child: ImageSliderWidget(
                  imageUrls: sliderController.slideImages,
                  imageTitle: sliderController.slideTitle,
                  imageSubTitle: sliderController.slideSubTitle,
                  imageHeight: size.height / 3.5,
                ),
              )),

        ],
      ),
    );
  }
}

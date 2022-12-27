import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/screens/app_info_slide/controller/app_info_slide_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/slider_ui/dot_indicator.dart';
import 'package:on_sight_application/utils/slider_ui/simple_slider_controller.dart';

class ImageSliderWidget extends StatefulWidget {
  final simpleSliderController = Get.find<SimpleSliderController>();


  ImageSliderWidget({
    Key? key,
    required List<String> imageUrls,
    required List<String> imageTitle,
    required List<String> imageSubTitle,
    double imageHeight = 200.0,
  }) : super(key: key) {
    simpleSliderController.imageHeight = imageHeight;
    simpleSliderController.imageUrls = imageUrls;
    simpleSliderController.imageTitle = imageTitle;
    simpleSliderController.imageSubTitle = imageSubTitle;
  }

  @override
  ImageSliderWidgetState createState() {
    return ImageSliderWidgetState();
  }
}

class ImageSliderWidgetState extends State<ImageSliderWidget>
    with SingleTickerProviderStateMixin {

  AppInfoSlideController controller = Get.find<AppInfoSlideController>();
  @override
  void initState() {
    super.initState();
    for(var i = 0; i<widget.simpleSliderController.imageUrls.length; i++){
      widget.simpleSliderController.pages.add(_buildImagePageItem(widget.simpleSliderController.imageUrls[i], widget.simpleSliderController.imageTitle[i], widget.simpleSliderController.imageSubTitle[i]));
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.simpleSliderController.pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildingImageSlider();
  }

  Widget _buildingImageSlider() {
    return Container(
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildPagerViewSlider(),
          _buildDotsIndicatorOverlay(),
          const SizedBox(height:50),
        ],
      ),
    );
  }

  Widget _buildPagerViewSlider() {
    return Expanded(
      child: getPageViewer(),
    );
  }

  Widget getPageViewer() {
    return PageView.builder(
      controller: widget.simpleSliderController.pageController,
      itemCount: widget.simpleSliderController.pages.length,
      itemBuilder: (BuildContext context, int index) {
        return widget.simpleSliderController
            .pages[index % widget.simpleSliderController.pages.length];
      },
      onPageChanged: (int p) {
        print(p);
        controller.updateCurrentIndex(p);

        print( controller.currentIndex.value);
      },
    );
  }

  Widget _buildDotsIndicatorOverlay() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DotsIndicator(
        widget.simpleSliderController.pageController,
        widget.simpleSliderController.pages.length,
        (int page) {
          widget.simpleSliderController.pageController.animateToPage(
            page,
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        },
      ),
    );
  }
  Widget _buildImagePageItem(String imgUrl,String title,String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(right: 1, left: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(imgUrl,
            height: 200,
            width: 200,
          ),
          Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Get.isDarkMode?ColourConstants.white:ColourConstants.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          const SizedBox(height: 20),
          Text(subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: ColourConstants.sliderColor,
                  fontWeight: FontWeight.w300,
                  fontSize: 14)),
        ],
      ),
    );
  }
}

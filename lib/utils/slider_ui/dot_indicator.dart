import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/slider_ui/dot_indicator_controller.dart';

class DotsIndicator extends AnimatedWidget {
  final _dotIndicatorController = DocIndicatorController();

  DotsIndicator(PageController controller, int itemCount,
      ValueChanged<int> onPageSelected,
      {Key? key})
      : super(listenable: controller, key: key) {
    _dotIndicatorController.controller = controller;
    _dotIndicatorController.itemCount = itemCount;
    _dotIndicatorController.onPageSelected = onPageSelected;
  }

  Widget _buildDot(int index) {
    return SizedBox(
      width: _dotIndicatorController.kDotSpacing,
      child: Center(
        child: Material(
          color:
          Get.isDarkMode?
          index == (_dotIndicatorController.controller.page ?? 0)
              ? ColourConstants.white
              : ColourConstants.sliderColor:index == (_dotIndicatorController.controller.page ?? 0)
              ? ColourConstants.black
              : ColourConstants.sliderColor,
          type: MaterialType.button,
          child: SizedBox(
            width: _dotIndicatorController.kDotSize,
            height: 5,
            child: InkWell(
              onTap: () => _dotIndicatorController.onPageSelected(index),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          List<Widget>.generate(_dotIndicatorController.itemCount, _buildDot),
    );
  }
}

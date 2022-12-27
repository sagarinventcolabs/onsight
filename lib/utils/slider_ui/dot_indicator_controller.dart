import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

// Manage all DotsIndicator business logic here
class DocIndicatorController extends GetxController {
  /// The PageController that this DotsIndicator is representing.
  late PageController controller;

  /// The number of items managed by the PageController
  late int itemCount;

  /// Called when a dot is tapped
  late ValueChanged<int> onPageSelected;

  // The base size of the dots
  double kDotSize = 13.0;

  // The distance between the center of each dot
  double kDotSpacing = 15.0;
}

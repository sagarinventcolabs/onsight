import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';

enum DashboardMenuItems { settings, profile, about }
Preference? sp;
bool isLogin = false;
final LocalAuthentication auth = LocalAuthentication();
String authorized = 'Not Authorized';

enum DrawerMenu {
  dashboard,
  jobPhotos,
  projectEvaluation,
  leadSheet,
  onboarding,
  promoPictures,
  fieldIssues,
}

class Constants {
  static const keyName = 'key_name';
  static const secureValidation = 'secure_validation';
}

class ColourConstants {
  //#583083
  static const Color primary1 = Color(0xFF00A6CA);
  static const Color primary = Color(0xFF583083);
  static const Color primaryLight = Color(0xFF6F63C7);
  static const Color borderColor = Colors.grey;
  static const Color white = Color(0xFFFFFFFF);
  static const Color darkModeWhite = Color(0xFFFFFFFF);
  static const Color textColour = Color(0xFF575757);
  static const Color ellipseColor = Color(0xFFF8F5FC);
  static const Color textFieldBG = Color(0xFFF7F7F7);
  static const Color textFieldHint = Color(0xFF575757);
  static const Color nonHighlightedColor = Color(0xFFF2EFEF);
  static const Color accent = Color(0xFFFCD800);
  static const Color textDeclinedTitle = Color(0xFF5DBD1F);
  static const Color textDeclinedSubTitle = Color(0xFF646464);
  static const Color textAcceptTitled = Color(0xFFEB5D1E);
  static const Color progressPercentage = Color(0xFFFCAF47);
  static const Color progressShadow = Color(0x4A000000);
  static const Color textFieldBg = Color(0xFFF7F7F7);
  static const Color yellowBg = Color(0xFFF7D849);
  static const Color gradientColor1 = Color(0xFFE7F7E5);
  static const Color gradientColor2 = Color(0xFFC0F49E);
  static const Color checkBoxUnSelect = Color(0xFFE0E0E0);
  static const Color greyText = Color(0xFF707070);
  static const Color greyTextDarkMode = Color(0xFFE6E6E6);
  static const Color lightPink = Color(0xFFE8DCF6);
  static const Color bottomSheetGrey = Color(0xFFD9D9D9);
  static const Color black = Colors.black;
  static const Color blue = Colors.blue;
  static Color labelBgColor = Theme.of(Get.context!).scaffoldBackgroundColor;
  static const Color sliderColor = Color(0xFF999999);
  static const Color textFieldFillColor = Color(0xFFF1F0F0);
  static const Color greenColor = Color(0xFF00BB06);
  static const Color lightPurple = Color(0xFFF8F5FC);
  static const Color green = Colors.green;
  static const Color red = Colors.red;
  static Color grey = Colors.grey;
  static const Color black54 = Color(0x8A000000);
  static Color grey100 = Colors.grey.shade100;
  static Color grey200 = Colors.grey.shade200;
  static Color grey300 = Colors.grey.shade300;
  static Color grey400 = Colors.grey.shade400;
  static Color grey500 = Colors.grey.shade500;
  static Color grey600 = Colors.grey.shade600;
  static Color grey700 = Colors.grey.shade700;
  static Color grey800 = Colors.grey.shade800;
  static Color grey900 = Colors.grey.shade900;
  static const Color orangeColor = Color(0xFFFF5D5D);
  static const Color borderGreyColor = Color(0xFFE6E6E6);
  static const Color unselectContainerColor = Color(0xFFF8F5FC);
  static const Color unselectedContainerColorDarkMode = Color(0xFF191919);
  static const Color transparent = Color(0x00000000);
  static const Color white70 = Colors.white70;
}

class NumberConstants {
  static const double kDefaultPadding = 20.0;
}





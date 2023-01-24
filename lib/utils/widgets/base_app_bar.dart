import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dimensions.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;

  const BaseAppBar({Key? key, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return AppBar(
      centerTitle: true,
      elevation: 0.0,
      backgroundColor: Get.isDarkMode ? ColourConstants.black : ColourConstants.white,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,
          size: Dimensions.height25,
        ),
        onPressed: () {
          Get.back();
        },
      ),
      title: Text(title??"",style: TextStyle(color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,fontWeight: FontWeight.bold, fontSize: Dimensions.font16),),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
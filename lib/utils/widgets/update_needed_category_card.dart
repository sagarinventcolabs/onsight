

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dimensions.dart';

class UpdateNeededCatCard extends StatefulWidget {
  final title;
  final lightSvgIcon;
  final darkSvgIcon;
  const UpdateNeededCatCard({
    this.title,
    this.darkSvgIcon,
    this.lightSvgIcon,
    super.key,
  });

  @override
  State<UpdateNeededCatCard> createState() => _UpdateNeededCatCardState();
}

class _UpdateNeededCatCardState extends State<UpdateNeededCatCard> {
  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return GestureDetector(
      onTap: (){
        Get.toNamed(Routes.missingDailyTime);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: Get.height * 0.03, vertical: Get.height*0.01),
        height: Get.height * 0.09,
        width: double.infinity,
        decoration: BoxDecoration(
         // color: Get.isPlatformDarkMode? ColourConstants.primaryLight:Color(0XFF6E63C7).withOpacity(0.05),
          color: Theme.of(context).hoverColor,
          borderRadius: BorderRadius.circular(Get.width * 0.02),
          border: Border.all(
            color: const Color(0XFF6F63C7).withOpacity(0.4),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: Dimensions.width10),
            SvgPicture.asset(Get.isDarkMode ? widget.darkSvgIcon??"" : widget.lightSvgIcon??"", height: Dimensions.height40),
            Padding(
              padding: EdgeInsets.only(left: Dimensions.width10),
              child: Text(widget.title??"", style: TextStyle(fontWeight: FontWeight.w500, fontSize: Dimensions.font17, color: Get.isPlatformDarkMode?ColourConstants.white:ColourConstants.primaryLight)),
            ),
            Spacer(),
            Visibility(
              visible: true,
              child: Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: Center(
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(30))
                    ),
                    child: Center(
                      child: Text(
                        "3",style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
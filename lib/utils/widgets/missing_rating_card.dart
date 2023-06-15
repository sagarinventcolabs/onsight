
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/utils/dimensions.dart';

class MissingStarRattingCard extends StatelessWidget {
  const MissingStarRattingCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.toNamed(Routes.dailyTimeDescription);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: Get.height * 0.03, vertical: Get.height*0.01),
        height:  Get.height * 0.09,
        width: double.infinity,
        decoration: BoxDecoration(
          color:Get.isPlatformDarkMode? Color(0xFF333333).withOpacity(0.5):const Color(0XFF6F63C7).withOpacity(0.05),
          borderRadius: BorderRadius.circular(Get.width * 0.02),
          border: Border.all(
            color:Get.isPlatformDarkMode?Colors.transparent: const Color(0XFF6F63C7).withOpacity(0.4),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                height: Get.height * 0.1,
                width: Get.height * 0.09,
                decoration: BoxDecoration(
                  color: const Color(0XFF6F63C7),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Get.width * 0.01),
                    bottomLeft: Radius.circular(Get.width * 0.01),
                  ),
                ),
                child: Center(
                  child: SvgPicture.asset(Assets.calender),
                )),
            SizedBox(
              width: Get.width * 0.05,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "04/27/2024",
                  style: TextStyle(
                    fontSize: Get.width * 0.045,
                    fontWeight: FontWeight.w500,
                    color: Get.isPlatformDarkMode?Colors.white:const Color(0XFF6F63C7),
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.005,
                ),
                Text(
                  "Wednesday",
                  style: TextStyle(
                    fontSize: Dimensions.font12,
                      color: Get.isPlatformDarkMode?Colors.white:const Color(0XFF707070),
                  ),
                )
              ],
            ),
            const Spacer(),
            Padding(
                padding: EdgeInsets.only(right: Get.width * 0.035),
                child: CircleAvatar(
                  maxRadius: Get.width * 0.04,
                  backgroundColor: Color(0xFFFF5D5D),
                  child: Center(
                    child: Text(
                      "2",
                      style: TextStyle(
                        fontSize: Get.width * 0.04,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
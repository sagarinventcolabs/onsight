

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/utils/constants.dart';

class JobPhotoGridContainer extends StatelessWidget {
  final title, lightIcon, darkIcon;
  const JobPhotoGridContainer({Key? key, this.title, this.lightIcon, this.darkIcon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: ColourConstants.primaryLight,
          borderRadius: BorderRadius.all(Radius.circular(10.0))
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(Get.isPlatformDarkMode?darkIcon:lightIcon),
            SizedBox(height: 12,),
            Text(
              title,
              style: TextStyle(color: ColourConstants.white, fontSize: 18 , fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}

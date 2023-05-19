

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/screens/onboarding/view_model/onboarding_resource_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:on_sight_application/utils/widgets/text_row.dart';

class ResourceCard extends StatefulWidget {
  final index, firstNameValue, lastNameValue, mobileValue;
  const ResourceCard({Key? key, this.index, this.firstNameValue, this.lastNameValue, this.mobileValue}) : super(key: key);

  @override
  State<ResourceCard> createState() => _ResourceCardState();
}

class _ResourceCardState extends State<ResourceCard> {


  @override
  Widget build(BuildContext context) {
    print(Get.find<OnboardingResourceController>().selectedResource.value);
    return Container(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(Dimensions.height10),
            color: Get.isDarkMode ? ColourConstants.black :ColourConstants.lightPurple,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.firstNameValue+" "+widget.lastNameValue, style: TextStyle(color: ColourConstants.primary, fontSize: Dimensions.font14),),
                  Obx(() =>Container(
                    height: 15,
                    width: 15,

                    decoration: BoxDecoration(
                      color: Get.find<OnboardingResourceController>().selectedResource.value==widget.index?Colors.green: Colors.transparent,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: Colors.black, width: 1)
                    ),
                  )
                  ),
                ],
              ),
            ),
          ),
          TextRow(title: firstName, value: widget.firstNameValue,),
          TextRow(title: lastName, value: widget.lastNameValue,),
          TextRow(title: mobileNumber, value: widget.mobileValue,)
        ],
      ),
    );
  }
}

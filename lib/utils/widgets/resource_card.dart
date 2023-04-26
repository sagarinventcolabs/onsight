

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:on_sight_application/utils/widgets/text_row.dart';

class ResourceCard extends StatefulWidget {
  final firstNameValue, lastNameValue, mobileValue;
  const ResourceCard({Key? key, this.firstNameValue, this.lastNameValue, this.mobileValue}) : super(key: key);

  @override
  State<ResourceCard> createState() => _ResourceCardState();
}

class _ResourceCardState extends State<ResourceCard> {

  @override
  Widget build(BuildContext context) {
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
                  Container(
                    height: 15,
                    width: 15,

                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: Colors.black, width: 1)
                    ),
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

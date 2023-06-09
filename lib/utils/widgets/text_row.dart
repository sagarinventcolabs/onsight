import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/main.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/strings.dart';

class TextRow extends StatefulWidget {
  final String? title;
  final String? value;
  final String? isEmail;
  const TextRow({Key? key,this.title,this.value,this.isEmail}) : super(key: key);

  @override
  State<TextRow> createState() => _TextRowState();
}

class _TextRowState extends State<TextRow> {

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height11, horizontal: Dimensions.width20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Text(widget.title??"",
              style: TextStyle(
                  color: Get.isDarkMode ? ColourConstants.white : ColourConstants.greyText,
                  fontWeight: FontWeight.w400,
                  fontSize: Dimensions.font12),
            ),
          ),
          SizedBox(width: Dimensions.width10),
          Expanded(
            flex: 2,
            child: Text(widget.value??naStr,
                textAlign: TextAlign.end,
                style: TextStyle(
                    color: (widget.isEmail??"") != ""
                        ? (widget.value??naStr) == naStr ? Get.isDarkMode ? ColourConstants.white : ColourConstants.black
                        : ColourConstants.blue : Get.isDarkMode ? ColourConstants.white : ColourConstants.black,
                    fontWeight: FontWeight.w500,
                    fontSize: Dimensions.font12),
            ),
          )
        ],
      ),
    );
  }
}

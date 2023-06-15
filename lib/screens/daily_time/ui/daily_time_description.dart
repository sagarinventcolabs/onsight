


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/screens/daily_time/view_model/daily_time_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:on_sight_application/utils/widgets/base_app_bar.dart';
import 'package:on_sight_application/utils/widgets/base_text_field.dart';

class DailyTimeDescription extends StatelessWidget {
  DailyTimeDescription({Key? key}) : super(key: key);

  final DailyTimeController controller = Get.put(DailyTimeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isPlatformDarkMode?Colors.black: Colors.white,
      appBar: BaseAppBar(title: testJobNumber,),
      body: Obx(() =>  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(21),
            child: Text(missingDailyTime, style: TextStyle(fontWeight: FontWeight.w500, fontSize: Dimensions.font16),),
          ),
          BaseTextField(
            focusNode: controller.focusBillOfLadding,
            controller: controller.billOfLadingController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")),
            ],
            maxLength: 20,
            keyboardType: TextInputType.text,
            onChanged: (val) {
              controller.isValidBillOfLading.value = true;
              controller.validateFunc();
            },
            label: Text.rich(TextSpan(children: [
              TextSpan(
                  text: billOfLading,
                  style: TextStyle(color: Get.isPlatformDarkMode?ColourConstants.white: ColourConstants.black)),
              TextSpan(text: " *", style: TextStyle(color: Colors.red))
            ])),
            floatingLabelStyle: TextStyle(
                color: controller.isValidBillOfLading.isFalse
                    ? Colors.red
                    : Get.isPlatformDarkMode
                    ? ColourConstants.primary
                    : Colors.black54),
            errorText: controller.isValidBillOfLading.isFalse
                ? pleaseEnterValidBillNumber
                : null,
          ),

          textField()


        ],
      )),
    );
  }

  /// Note text field widget
  Widget textField() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          Dimensions.height20, 15, Dimensions.height20, Dimensions.height20),
      child: TextField(
        maxLines: null,
        keyboardType: TextInputType.text,
        cursorColor: ColourConstants.primary,
        controller: controller.summaryController,
        // textInputAction: TextInputAction.newline,

        style: TextStyle(
            color:
            Get.isPlatformDarkMode ? ColourConstants.white : ColourConstants.black,
            fontWeight: FontWeight.w400,
            fontSize: Dimensions.font13),
        decoration: InputDecoration(
          isDense: true,
          // Added this
          contentPadding: EdgeInsets.symmetric(
              horizontal: Dimensions.height10, vertical: Dimensions.height13),
          labelText: summary,
          labelStyle: TextStyle(
              fontSize: Dimensions.font15,
              color: Get.isPlatformDarkMode
                  ? ColourConstants.white
                  : ColourConstants.greyText,
              fontWeight: FontWeight.w400),

          suffixIconConstraints: BoxConstraints(
              minHeight: Dimensions.height25, minWidth: Dimensions.height25),
          suffixIcon: GestureDetector(
            onTap: () {
              if (controller.speechToText.value.isNotListening) {
                controller.startListening();
                Future.delayed(Duration(milliseconds: 2750), () async {
                  controller.isListening.value = false;
                  controller.update();
                });
              } else {
                controller.stopListening();
              }

            },
            child: Padding(
              padding: EdgeInsets.only(
                  right: Dimensions.height11, left: Dimensions.height8),
              child: controller.isListening.isTrue
                  ? Image.asset(
                Assets.icMic,
                height: Dimensions.height20,
                width: Dimensions.height20,
                color: Colors.blue,
              )
                  : Image.asset(
                Assets.icMic,
                height: Dimensions.height25,
                width: Dimensions.height25,
                color: Get.isPlatformDarkMode ? ColourConstants.white : null,
              ),
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: ColourConstants.primary)),
          border: const UnderlineInputBorder(
              borderSide: BorderSide(color: ColourConstants.primary)),
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: ColourConstants.primary)),
          disabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: ColourConstants.primary)),
          errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: ColourConstants.primary)),
          focusedErrorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: ColourConstants.primary)),
          filled: true,
          fillColor: Get.isPlatformDarkMode
              ? ColourConstants.grey900
              : ColourConstants.textFieldFillColor,
        ),
      ),
    );
  }
}

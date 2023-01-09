import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/screens/lead_sheet/view_model/exhibitor_controller.dart';
import 'package:on_sight_application/screens/lead_sheet/view_model/lead_sheet_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/functions/SearchFunctions.dart';
import 'package:on_sight_application/utils/functions/functions.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:on_sight_application/utils/widgets/base_typeahead.dart';

class LeadSheetScreen extends StatefulWidget {
  const LeadSheetScreen({Key? key}) : super(key: key);

  @override
  LeadSheetState createState() => LeadSheetState();
}

class LeadSheetState extends State<LeadSheetScreen> with SingleTickerProviderStateMixin, SearchFunctions{

  FocusNode jobFocusNode = FocusNode();
  bool buttonEnable = false;
  LeadSheetController controller = Get.put(LeadSheetController());
  ExhibitorController exhibitorController = ExhibitorController();
  bool checkedValue= false;
  SuggestionsBoxController suggestionsBoxController = SuggestionsBoxController();

  final ScrollController _scrollController = ScrollController();

  void _scrollDown() {
    Future.delayed(const Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200),
        curve: Curves.fastOutSlowIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context) == Brightness.dark;
    return  Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(icon:  Image.asset(Assets.appBarLeadingButton,color: Get.isDarkMode?ColourConstants.white:ColourConstants.primary,height: Dimensions.height25,width: Dimensions.height25,), onPressed: () {
            Get.back();
          },),
          elevation: 0.0,
          backgroundColor:Get.isDarkMode?ColourConstants.black:ColourConstants.white,
          title: Text(leadSheet, style: TextStyle(color:Get.isDarkMode?ColourConstants.white:ColourConstants.primary,fontWeight: FontWeight.bold, fontSize: Dimensions.font16)),
        ),
        bottomNavigationBar: Obx(()=> GestureDetector(
          onTap: () async {
            // Get.toNamed(Routes.leadSheetDetailScreen);
            FocusScope.of(context).unfocus();
            saveShowNumberSuggestions(controller.showController.text.trim());
            controller.buttonSubmit.value = false;
            if(controller.enableButton.isTrue) {
              setState(() {
                controller.enableButton.value = false;
              });
              Timer(Duration(seconds: 4),(){
                setState(() {
                  controller.enableButton.value = true;
                });
              });
              var response = await controller.getSheetDetails(Routes.leadSheetScreen,controller.showController.text.toString(), true);
              if(response!=null){
                if(response.toString().contains(showNumberNotFound)){
                  controller.updateIsValid(false);
                }
              }
            }
          },

          child: Container(
            height: Dimensions.height50,
            margin: EdgeInsets.only(bottom: Dimensions.height35,right: Dimensions.height20,left: Dimensions.height20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(Dimensions.radius8)),
                color:controller.enableButton.isTrue? ColourConstants.primary:ColourConstants.grey
            ),
            child: Center(child: Text(submit, style: TextStyle(color: ColourConstants.white, fontWeight: FontWeight.w400, fontSize: Dimensions.font16),)),
          ),
        ),
        ),
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.height20),
            child: ListView(
              controller: _scrollController,
              children: [
                SizedBox(height: Dimensions.height120),
                GestureDetector(
                  onTap: (){
                    FocusScope.of(context).unfocus();
                  },
                  child: Get.isDarkMode?Image.asset(Assets.imageLeadSheetDarkMode,height: MediaQuery.of(context).size.height/4.3)
                  :Image.asset(Assets.il_leadsheet,height: MediaQuery.of(context).size.height/4.3),
                ),

                SizedBox(height: Dimensions.height30),
                Obx(() => BaseTypeAhead(
                  onTap: (){
                      _scrollDown();
                    },
                    controller: controller.showController,
                    focusNode: jobFocusNode,
                    inputFormatters: [FilteringTextInputFormatter.deny(" "), FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9-]"))],
                    onChanged: (val){
                      _scrollDown();
                      if(controller.validate()){
                        if(controller.enableButton.isFalse ){
                          controller.enableButton.value = true;
                        }
                      }else{
                        controller.enableButton.value = false;
                      }
                      if(val.length>4){
                        controller.enableButton.value = true;
                      }else{
                        controller.enableButton.value = false;
                      }
                    },
                  labelText: showLabel,
                  floatingLabelStyle: TextStyle(color: controller.isValidShowNumber.isFalse ? ColourConstants.red : Get.isDarkMode ? ColourConstants.white :ColourConstants.primary),
                  errorText: controller.isValidShowNumber.isFalse ? showNumberValidation : null,
                  suggestionsCallback:getShowNumberSuggestion,
                  onSuggestionSelected: (String? suggestion) {
                    final user = suggestion!;
                    controller.showController.text = user;
                    controller.update();
                    if(controller.validate()){
                      if(!controller.enableButton.value ){
                        setState(() {
                          controller.enableButton.value = true;
                        });
                      }
                    }else{
                      setState(() {
                        controller.enableButton.value = false;
                       },
                      );
                    }
                  },
                 ),
                ),
                SizedBox(height: Dimensions.height200),
              ],
            ),
          ),
        )
    );
  }


}

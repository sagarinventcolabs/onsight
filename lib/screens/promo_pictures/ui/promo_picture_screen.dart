import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/screens/promo_pictures/view_model/promo_pictures_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dialogs.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/functions/SearchFunctions.dart';
import 'package:on_sight_application/utils/functions/functions.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:on_sight_application/utils/widgets/base_typeahead.dart';

class PromoPictureScreen extends StatefulWidget {
  const PromoPictureScreen({Key? key}) : super(key: key);

  @override
  PromoPictureState createState() => PromoPictureState();
}

class PromoPictureState extends State<PromoPictureScreen> with SearchFunctions{

  FocusNode jobFocusNode = FocusNode();
  bool buttonEnable = false;
  PromoPicturesController controller = Get.put(PromoPicturesController());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

  }

  final ScrollController _scrollController = ScrollController();

  void _scrollDown() {
    Future.delayed(const Duration(seconds: 1), () {
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
          leading: IconButton(icon:  Image.asset(Assets.appBarLeadingButton,
            color: Get.isDarkMode?ColourConstants.white:ColourConstants.primary,
            height: Dimensions.height25,width: Dimensions.height25,), onPressed: () {
            Get.back();
          },
          ),
          elevation: 0.0,
          backgroundColor: Get.isDarkMode?ColourConstants.black:ColourConstants.white,
          title: Text(promoPictures, style: TextStyle(color:Get.isDarkMode?ColourConstants.white:ColourConstants.primary,fontWeight: FontWeight.bold, fontSize: Dimensions.font16)),
        ),
        bottomNavigationBar: Obx(() => GestureDetector(
          onTap: () async {
            if(controller.radioButtonValue.value==1){
              if(controller.showController.text.isNotEmpty && controller.showController.text.length>4) {
                setState(() {
                  controller.enableButton.value = false;
                });
                Timer(Duration(seconds: 4),(){
                  setState(() {
                    controller.enableButton.value = true;
                  });
                });
                FocusScope.of(context).unfocus();
                saveShowNumberSuggestions(controller.showController.text.trim());
                await controller.getSheetDetails(controller.showController.text, true).then((value) {
                  if(value.toString().contains(showNumberNotFound)){
                    controller.isValidShowNumber.value = false;
                    controller.update();
                  }
                });
              }
            }else {
              showModalBottomSheet(
                //  backgroundColor: Get.isPlatformDarkMode ? ColourConstants.grey900 : ColourConstants.white,
                  //backgroundColor: Color.fromARGB(255, 0, 0, 0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(Dimensions.radius10),
                          topRight: Radius.circular(Dimensions.radius10))),
                  isScrollControlled: true,
                  context: context,
                  builder: (context) =>
                      bottomSheetImagePickerPromoPictures(Routes.PromoPictureScreen)).then((
                  value) {
                setState(() {});
              });
            }
          },
          child: Container(
            height: Dimensions.height50,
            margin: EdgeInsets.only(right: Dimensions.height20,left: Dimensions.height20,bottom: Dimensions.height35),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(Dimensions.radius8)),
                color:controller.enableButton.isTrue? ColourConstants.primary:ColourConstants.grey
            ),
            child: Center(child: Text(next, style: TextStyle(color: ColourConstants.white, fontWeight: FontWeight.w400, fontSize: Dimensions.font16),)),
          ),
        ),),
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.height20),
              child: Obx(()=>Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height/9),
                  GestureDetector(
                    onTap: (){
                      FocusScope.of(context).unfocus();
                    },
                    child:
                   Get.isDarkMode? Image.asset(Assets.promo_pictures,width: Dimensions.height300,height: MediaQuery.of(context).size.height/4.3):
                    Image.asset(Assets.ill_promo_pictures,height: MediaQuery.of(context).size.height/4.3),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height/25),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio<int>(value: 1, groupValue: controller.radioButtonValue.value, onChanged: (val){
                          controller.validate();

                            controller.radioButtonValue.value = val!;
                            controller.update();

                        },activeColor: ColourConstants.green),
                        Text(showStr,style: TextStyle(fontWeight: FontWeight.w600,fontSize: Dimensions.font15)),
                        SizedBox(width: Dimensions.height30),
                        Radio<int>(value: 2, groupValue: controller.radioButtonValue.value, onChanged: (val){
                          controller.enableButton.value = true;
                            controller.radioButtonValue.value = val!;
                            controller.update();

                        },activeColor: ColourConstants.green),
                        Text(notAtShow,style: TextStyle(fontWeight: FontWeight.w600,fontSize: Dimensions.font15),),
                      ]),
                  SizedBox(height: MediaQuery.of(context).size.height/45),
                  Visibility(
                    visible: controller.radioButtonValue.value == 1 ? true : false,
                    child: BaseTypeAhead(
                          controller: controller.showController,
                          focusNode: jobFocusNode,
                          onTap: (){
                            _scrollDown();
                          },
                          inputFormatters: [FilteringTextInputFormatter.deny(" "), FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9-]"))],
                          onChanged: (val){
                            _scrollDown();
                            controller.isValidShowNumber.value = true;
                            controller.update();
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
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(height: Dimensions.height100),
                ],
              ),)
            ),
          ),
        )
    );
  }
}

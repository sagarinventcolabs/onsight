import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/screens/job_photos/view_model/job_photos_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/functions/SearchFunctions.dart';
import 'package:on_sight_application/utils/functions/functions.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:on_sight_application/utils/widgets/base_typeahead.dart';

class JobPhotosScreen extends StatefulWidget{
  const JobPhotosScreen({Key? key}) : super(key: key);

  @override
  JobPhotosState createState() => JobPhotosState();
}

class JobPhotosState extends State<JobPhotosScreen>  with SearchFunctions {
  TextEditingController jobEditingController =  TextEditingController(text: "");
  bool _enableButton = false;
  FocusNode jobFocusNode = FocusNode();
  bool buttonEnable = false;
  JobPhotosController controller = Get.find<JobPhotosController>();
  bool checkedValue= false;
  SuggestionsBoxController suggestionsBoxController = SuggestionsBoxController();

  final ScrollController _scrollController = ScrollController();
  void _scrollDown() {
    Future.delayed(const Duration(milliseconds: 400), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200),
        curve: Curves.fastOutSlowIn,
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    controller.isValidJobNumber.value = true;
    controller.update();
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
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
          title: Text(jobPhotos, style: TextStyle(color: Get.isDarkMode?ColourConstants.white:ColourConstants.primary,fontWeight: FontWeight.bold, fontSize: Dimensions.font16)),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.height20),
          child: GestureDetector(
            onTap: ()async{
              FocusScope.of(context).unfocus();
              saveSuggestion(jobEditingController.text);
              controller.value.value=1;
              controller.update();
              if(_enableButton) {
                setState(() {
                  _enableButton = false;
                });
                Timer(Duration(seconds: 3),(){
                  setState(() {
                    _enableButton = true;
                  });
                });
                controller.categoryList.clear();
                await controller.getCategoryList();
                controller.tabCurrentIndex.value = 0;
                var response = await controller.getJobDetails(jobEditingController.text.toString(), false /*checkedValue*/, true, fromMain);
                analyticsFireEvent(jobPhotosModuleKey, input: {
                  jobNumber2:jobEditingController.text.toString().trim(),
                  user:(sp?.getString(Preference.FIRST_NAME)??"")/*+"_"+(sp?.getString(Preference.LAST_NAME)??"")*/
                });
                if(response!=null){
                  if(!response.toString().contains(smallErrorStr) & !response.toString().contains(noInternetStr)){
                    Get.toNamed(Routes.jobPhotosDetailsScreen, arguments: false /*checkedValue*/);
                  }
                }
                if(response.toString().contains(jobNumberIsNotFound)){
                  controller.updateIsValid(false);
                }
              }
            },
            child: Container(
              height: Dimensions.height50,
              margin: EdgeInsets.only(bottom: Dimensions.height35),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(Dimensions.radius8)),
                  color:_enableButton? ColourConstants.primary:ColourConstants.grey
              ),
              child: Center(child: Text(submit, style: TextStyle(color: ColourConstants.white, fontWeight: FontWeight.w400, fontSize: Dimensions.font16),)),
            ),
          ),
        ),
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.height20),
              child: Column(

                children: [
                  SizedBox(height: Dimensions.height120),

                  GestureDetector(
                    onTap: (){
                      FocusScope.of(context).unfocus();
                      controller.value.value=1;
                      controller.update();
                      setState((){});
                    },
                    child: Get.isDarkMode?Image.asset(Assets.icJobPhotoDark,height:Dimensions.height180)
                    :Image.asset(Assets.icTeamWork,height: MediaQuery.of(context).size.height/4.3)
                  ),
                  SizedBox(height: Dimensions.height40),
                  Obx(() => BaseTypeAhead(
                  onSuggestionSelected: (String? suggestion) {
                      final user = suggestion!;
                      jobEditingController.text = user;
                      controller.update();
                      if(_validate()){
                        if(!_enableButton ){
                          setState(() {
                            _enableButton = true;
                          });
                        }
                      }else{
                        setState(() {
                          _enableButton = false;
                        });
                      }
                    },
                    onTap: (){controller.update();
                    _scrollDown();},
                    errorText: controller.isValidJobNumber.isFalse ? jobNumberValidation : null,
                    floatingLabelStyle: TextStyle(color: controller.isValidJobNumber.isFalse ? ColourConstants.red : Get.isDarkMode ? ColourConstants.white : ColourConstants.primary),
                    labelText: jobLabel,

                    suggestionsCallback: getSuggestion,
                    onChanged: (val){
                      _scrollDown();
                      controller.update();
                      if(_validate()){
                        if(!_enableButton ){
                          setState(() {
                            _enableButton = true;
                          });
                        }
                      }else{
                        setState(() {
                          _enableButton = false;
                        });
                      }
                      if(val.length>4){
                        setState(() {
                          _enableButton = true;
                        });
                      }else{
                        setState(() {
                          _enableButton = false;
                        });
                      }
                    },
                    inputFormatters: [FilteringTextInputFormatter.deny(" "), FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9-]"))],
                    focusNode: jobFocusNode,
                    suggestionsBoxController: suggestionsBoxController,
                    controller: jobEditingController,

                   ),
                  ),
                  SizedBox(height: Dimensions.height15),
                  Row(
                    children: [
                      SizedBox(
                        height: Dimensions.height20,
                        width: Dimensions.height20,
                        child: Theme(
                          data: ThemeData(
                            unselectedWidgetColor: ColourConstants.grey.withOpacity(.5), // Your color
                          ),
                          child: Checkbox(
                            value: checkedValue,
                            checkColor: Get.isDarkMode ? ColourConstants.black : ColourConstants.white,
                            activeColor: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,
                            onChanged: (newValue) {
                              setState((){
                                checkedValue = newValue!;
                                },
                              );
                            },
                          ),
                        ),
                      ),

                      SizedBox(width: Dimensions.height10),
                      Text(downloadJobsRelatedShow,style:TextStyle(color: Get.isDarkMode? Colors.white:ColourConstants.textColour, fontFamily: 'SFUI', fontWeight: FontWeight.normal, fontSize: Dimensions.font12)),
                    ],
                  ),
                  SizedBox(height: Dimensions.height100),
                ],
              ),
            ),
          ),
        )
    );
  }


  _validate() {
    if (jobEditingController.text.isEmpty) {
      setState(() {
        _enableButton = false;
      });
      return false;
    }else if(jobEditingController.text.length<4){
      setState(() {
        _enableButton = false;
      });
      return false;
    }else {
      controller.updateIsValid(true);

    }

    return true;
  }

  @override
  void dispose() {
    super.dispose();
    controller.isValidJobNumber.value = true;
    controller.update();
  }
}
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
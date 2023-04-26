import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/repository/web_service_response/all_oasis_resources_response.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/screens/onboarding/view_model/onboarding_photos_controller.dart';
import 'package:on_sight_application/screens/onboarding/view_model/onboarding_resource_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:on_sight_application/utils/widgets/resource_card.dart';
import 'package:on_sight_application/utils/widgets/text_row.dart';

class ResourceDetailsNew extends StatefulWidget {
  const ResourceDetailsNew({Key? key}) : super(key: key);

  @override
  State<ResourceDetailsNew> createState() => _ResourceDetailsNewState();
}

class _ResourceDetailsNewState extends State<ResourceDetailsNew> {

  OnboardingResourceController onboardingResourceController = Get.find<OnboardingResourceController>();
  OnBoardingPhotosController? onBoardingPhotosController ;

  AllOasisResourcesResponse data = AllOasisResourcesResponse();
  var title = "";

  @override
  void initState() {
    data = Get.arguments;
    super.initState();
    if(Get.isRegistered<OnBoardingPhotosController>()){
      onBoardingPhotosController = Get.find<OnBoardingPhotosController>();
    }else{
      onBoardingPhotosController = Get.put(OnBoardingPhotosController());
    }
    var first = data.firstName??"";
    var last = data.lastName??"";
    title = first+" "+last;
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);

    return WillPopScope(
      onWillPop: ()async{
        if(data.route==Routes.onBoardingResourceScreen || data.route == Routes.onBoardingResourceScreenNew){
          Get.back();
        }else{
          Get.back();
          Get.back();
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,
              size: Dimensions.height25,
            ),
            onPressed: () {
              if(data.route==Routes.onBoardingResourceScreen){
                Get.back();
              }else{
                Get.back();
                Get.back();
              }
            },
          ),
          elevation: 0.0,
          backgroundColor: Get.isDarkMode ? ColourConstants.black : ColourConstants.white,
          title:Text(resourceDetails,
              style: TextStyle(
                  color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: Dimensions.font16,
              ),
          ),
        ),
          bottomNavigationBar:  data.route==Routes.onBoardingResourceScreen  ||  data.route==Routes.onBoardingResourceScreenNew? GestureDetector(
            onTap: () async{
              await onBoardingPhotosController?.getCategory(itemId: data.itemId);
            },
            child: Container(
              height: Dimensions.height50,
              margin: EdgeInsets.only(left: Dimensions.height35, right: Dimensions.height35, bottom: Dimensions.height16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(Dimensions.radius8)),
                  color: ColourConstants.primary),
              child: Center(
                  child: Text(
                    addDocuments,
                    style: TextStyle(
                        color: ColourConstants.white,
                        fontWeight: FontWeight.w300,
                        fontSize: Dimensions.font16),
                  )),
            ),

          ):SizedBox(height: 10,),

        body:  Container(
          color: Get.isDarkMode ? ColourConstants.black :ColourConstants.lightPurple,
          child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(Dimensions.height10),
                    color: ColourConstants.primary,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(title, style: TextStyle(color: ColourConstants.white, fontSize: Dimensions.font13),),
                        Visibility(
                          visible: onboardingResourceController.loginFlag.value.toLowerCase()=="employee",
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: GestureDetector(
                              onTap: (){
                                Get.toNamed(Routes.editResource, arguments: data)!.then((value) {
                                  onboardingResourceController.update();
                                  setState(() {

                                  });
                                });
                              },
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                    child: Icon(Icons.edit, color: Colors.white, size: 15,),
                                  ),
                                  Text(edit, style: TextStyle(color: ColourConstants.white, fontSize: Dimensions.font13, decoration: TextDecoration.underline),),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextRow(title: firstName,value:data.firstName.toString().isEmpty?"N/A": data.firstName??"N/A"),
                  TextRow(title: lastName,value: data.lastName.toString().isEmpty?"N/A":data.lastName??"N/A"),
                  Visibility(
                      visible: onboardingResourceController.loginFlag.value.toLowerCase()=="employee",
                      child: TextRow(title: ssn,value: "XXX-XX-"+((data.ssn??"N/A").characters.takeLast(4).toString()))),
                  TextRow(title: mobileNumber,value:data.mobilePhone.toString().isEmpty?"N/A": data.mobilePhone??"N/A"),
                  TextRow(title: baseCity,value: data.city.toString().isEmpty?"N/A":data.city.toString().capitalizeFirst??"N/A"),
                  TextRow(title: union,value:data.union.toString().isEmpty?"N/A": data.union??"N/A"),
                  TextRow(title: classification,value:data.classification.toString().isEmpty?"N/A": data.classification??"N/A"),
                  //TextRow(title: lastWorkDate,value: data.classification??"N/A"),
                  TextRow(title: notes,value: data.notes.toString().isEmpty?"N/A":data.notes??"N/A"),


                ],
            ),
          ),
        )
      ),
    );
  }

  @override
  dispose(){
    super.dispose();
  }
}

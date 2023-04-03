import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/repository/web_service_response/all_oasis_resources_response.dart';
import 'package:on_sight_application/screens/onboarding/view_model/onboarding_photos_controller.dart';
import 'package:on_sight_application/screens/onboarding/view_model/onboarding_resource_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/strings.dart';
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,
            size: Dimensions.height25,
          ),
          onPressed: () {
            Get.back();
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

      body:  Container(
        color: ColourConstants.lightPurple,
        child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(Dimensions.height10),
                  color: ColourConstants.primary,
                  child: Text(title, style: TextStyle(color: ColourConstants.white, fontSize: Dimensions.font13),),
                ),
                TextRow(title: firstName,value: data.firstName??"N/A"),
                TextRow(title: lastName,value: data.lastName??"N/A"),
                TextRow(title: ssn,value: "XXX-XX-"+((data.ssn??"N/A").characters.takeLast(4).toString())),
                TextRow(title: mobileNumber,value: data.mobilePhone??"N/A"),
                TextRow(title: city,value: data.city.toString().capitalizeFirst??"N/A"),
                TextRow(title: union,value: data.union??"N/A"),
                TextRow(title: classification,value: data.classification??"N/A"),
                TextRow(title: lastWorkDate,value: data.classification??"N/A"),
                TextRow(title: notes,value: data.notes??"N/A"),
              ],
          ),
        ),
      )
    );
  }



  Container jobDetailsRow(key, value, [isEmailPhone]) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height11, horizontal: Dimensions.height16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Text(key,
                style: TextStyle(
                    color: Get.isDarkMode ? ColourConstants.white : ColourConstants.greyText,
                    fontWeight: FontWeight.w400,
                    fontSize: Dimensions.font12)),
          ),
          SizedBox(width: Dimensions.height20),
          Expanded(
            flex: 2,
            child: Text(value,
                textAlign: TextAlign.end,
                style: TextStyle(
                    color: isEmailPhone != null
                        ? value == "N/A"
                        ? Get.isDarkMode ? ColourConstants.white : ColourConstants.black
                        : ColourConstants.blue
                        : Get.isDarkMode ? ColourConstants.white : ColourConstants.black,
                    fontWeight: FontWeight.w500,
                    fontSize: Dimensions.font12,
                ),
            ),
          )
        ],
      ),
    );
  }

  @override
  dispose(){
    super.dispose();
  }
}

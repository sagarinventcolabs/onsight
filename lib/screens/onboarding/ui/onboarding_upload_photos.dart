import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/screens/onboarding/view_model/onboarding_photos_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dialogs.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/functions/functions.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';
import 'package:on_sight_application/utils/strings.dart';

class OnBoardingUploadPhotosScreen extends StatefulWidget {
  const OnBoardingUploadPhotosScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingUploadPhotosScreen> createState() => _OnBoardingUploadPhotosScreenState();
}

class _OnBoardingUploadPhotosScreenState extends State<OnBoardingUploadPhotosScreen> {
  late OnBoardingPhotosController controller;



  @override
  void initState() {
    if(Get.isRegistered<OnBoardingPhotosController>()){
      controller = Get.find<OnBoardingPhotosController>();
    }else{
      controller = Get.put(OnBoardingPhotosController());
    }


    super.initState();
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
            size: Dimensions.height20,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        elevation: 0.0,
        backgroundColor: Get.isDarkMode ? ColourConstants.black : ColourConstants.white,
      ),
      bottomNavigationBar: Obx(()=> GestureDetector(
        onTap: () async {
          if(controller.imageList.isNotEmpty) {
            if (controller.enableButton.isTrue) {
              controller.enableButton.value = false;
              controller.saveDocumentApiRequest(Get.arguments);
              print("ACTIVITY TRACKER COUNT --> ");
              sp?.putInt(Preference.ACTIVITY_TRACKER, ((sp?.getInt(Preference.ACTIVITY_TRACKER)??0)+1));
              print((sp?.getInt(Preference.ACTIVITY_TRACKER)??0).toString());
              defaultDialog(Get.context!, title: documentAddedSuccessfully, onTap: () {
                Get.back();
                Get.back();
                Get.back();
              });
            }
            checkBatteryStatus();
          }
        },
        child: Container(
          height: Dimensions.height50,
          margin: EdgeInsets.only(left: Dimensions.height35, right: Dimensions.height35, bottom: Dimensions.height16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(Dimensions.radius8)),
              color: controller.enableButton.isTrue?ColourConstants.primary:ColourConstants.grey),
          child: Center(
              child: Text(
                addDocument.toUpperCase(),
                style: TextStyle(
                    color: ColourConstants.white,
                    fontWeight: FontWeight.w300,
                    fontSize: Dimensions.font16),
              )),
        ),
      ),
      ),
      body: Obx(()=>ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.height16, vertical: Dimensions.height5),
            child: Text(chooseCategory,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Get.isDarkMode ? ColourConstants.white : ColourConstants.black,
                    fontWeight: FontWeight.w500,
                    fontSize: Dimensions.font15)),
          ),
          SizedBox(height: Dimensions.height10),
          ListView.builder(
              shrinkWrap: true,
              itemCount: controller.imageList.length,
              itemBuilder: (builder, index) {
                return categoryWidget(
                    controller.imageList[index].category.toString(),
                    index);
              })
        ],
      ),)
    );
  }

  Container categoryWidget(key, index) {

    return Container(
      margin: EdgeInsets.symmetric(vertical: Dimensions.height5, horizontal: Dimensions.height16),
      padding: EdgeInsets.symmetric(vertical: Dimensions.height10, horizontal: Dimensions.height10),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? ColourConstants.grey900 : null,
          border: Border.all(color: Get.isDarkMode ? ColourConstants.transparent : ColourConstants.borderGreyColor, width: 1)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(width: Dimensions.height8),
                  Text(key,
                      style: TextStyle(
                          color: Get.isDarkMode ? ColourConstants.white : ColourConstants.black,
                          fontWeight: FontWeight.w400,
                          fontSize: Dimensions.font12)),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                  onTap: (){
                    if ((controller.imageList[index].image?.length??0) > 0) {
                      controller.selectedCategory.value = controller.imageList[index].category??"";
                      controller.update();
                      Get.toNamed(Routes.onBoardingPhotoScreen);
                    }
                  },
                    child: Container(
                      color: ColourConstants.greenColor,
                      height: Dimensions.height25,
                      alignment: Alignment.center,
                      constraints: BoxConstraints(minWidth: Dimensions.height25),
                      padding: EdgeInsets.symmetric(vertical: Dimensions.height3, horizontal: Dimensions.height7),
                      child: Text(controller.imageList[index].itemCount.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: ColourConstants.white,
                              fontWeight: FontWeight.w400,
                              fontSize: Dimensions.font12)),
                    ),
                  ),
                  SizedBox(width: Dimensions.height8),
                  GestureDetector(
                    onTap: () {
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
                              //bottomSheetImagePickerOnBoardingPictures(Routes.onBoardingUploadPhotosScreen,index)).then((value) {
                              bottomSheetImagePicker(Routes.onBoardingUploadPhotosScreen)).then((value) {
                            ImagePickerOnboarding(Routes.onBoardingUploadPhotosScreen,index);

                      });
                    },
                    child: Image.asset(
                      Assets.icAdd2,
                      height: Dimensions.height25,
                      width: Dimensions.height25,
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }


  @override
  void dispose() {
    super.dispose();
    controller.enableButton.value = false;
    controller.update();
  }
  
}

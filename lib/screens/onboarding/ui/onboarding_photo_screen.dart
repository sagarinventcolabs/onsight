import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/repository/database_managers/onboarding_manager.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/screens/onboarding/view_model/onboarding_photos_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dialogs.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/functions/functions.dart';


class OnBoardingPhotoScreen extends StatefulWidget {
  const OnBoardingPhotoScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingPhotoScreen> createState() => _OnBoardingPhotoScreenState();
}

class _OnBoardingPhotoScreenState extends State<OnBoardingPhotoScreen> {


  OnBoardingPhotosController controller = Get.find<OnBoardingPhotosController>();
  var i = 0;
  @override
  initState(){
    super.initState();
    print(controller.selectedCategory.value);
    i = controller.imageList.indexWhere((element) => element.category == controller.selectedCategory.value);
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
              color:Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,
              size: Dimensions.height25,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          elevation: 0.0,
          backgroundColor: Get.isDarkMode ? ColourConstants.black : ColourConstants.white,
          title: Text(controller.selectedCategory.value,
              style: TextStyle(
                  color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: Dimensions.font16)),
          actions: [
           GestureDetector(
             onTap: (){
               showModalBottomSheet(
                 //  backgroundColor: Get.isDarkMode ? ColourConstants.grey900 : ColourConstants.white,
                   shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.only(
                           topLeft: Radius.circular(Dimensions.radius10),
                           topRight: Radius.circular(Dimensions.height10))),
                   isScrollControlled: true,
                   context: context,
                   builder: (context) =>
                       //bottomSheetImagePickerOnBoardingPictures(Routes.onBoardingPhotoScreen,i)).then((value) {
                       bottomSheetImagePicker(Routes.onBoardingPhotoScreen)).then((value) {
                 var resourceKey = Get.arguments;
                 ImagePickerOnboarding(Routes.onBoardingUploadPhotosScreen,i, resourceKey.toString(), controller.imageList[i].rowId, controller.imageList[i].itemCount,controller.selectedCategory.value);


                 setState((){});
               });
             },
               child:  Image.asset(
               Assets.icAdd2,
               height: Dimensions.height25,
               width: Dimensions.height25,
             ),
           ),
            SizedBox(width: Dimensions.height16)
          ],
        ),
        body: Obx(() =>
            photoWidget()
        ));
  }

  /// Photo Widget
  Widget photoWidget() {

    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.all(Dimensions.height20),
      itemCount: controller.imageList[i].image?.length??0,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      physics: AlwaysScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        return Stack(
          children: [
            GestureDetector(
              onTap: (){
                singleImageDialog(image: controller.imageList[i].image?[index].imagePath??"", context: context);
              },
              child: Padding(
                padding: EdgeInsets.all(Dimensions.height5),
                child: Container(
                  height: Dimensions.height60,
                  width: Dimensions.height60,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(File(controller.imageList[i].image?[index].imagePath??"")),
                          fit: BoxFit.fill),
                      borderRadius: BorderRadius.all(Radius.circular(Dimensions.height30))),
                ),
              ),
            ),
            Positioned(
              right: Dimensions.height17,
              top: Dimensions.height2,
              child: GestureDetector(
                onTap: () async {
                  await OnboardingImageManager().deleteImage(controller.imageList[i].image![index].imageName);
                  controller.imageList[i].image?.removeAt(index);
                  controller.imageList.refresh();
                  controller.update();

                 if((controller.imageList[i].image?.length??0)==0){
                   controller.enableButton.value = false;
                   controller.update();
                 }
                },
                child: Image.asset(
                  Assets.icClose2,
                  height: Dimensions.height18,
                  width: Dimensions.height18,
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

import 'dart:collection';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/main.dart';
import 'package:on_sight_application/repository/database_managers/onboarding_manager.dart';
import 'package:on_sight_application/repository/web_services/web_service.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/screens/onboarding/model/cat_model.dart';
import 'package:on_sight_application/screens/onboarding/model/category_response_model.dart';
import 'package:on_sight_application/screens/onboarding/model/onboarding_category_model.dart';
import 'package:on_sight_application/screens/onboarding/model/onboarding_document_image_model.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';

class OnBoardingPhotosController extends GetxController{

  RxString selectedCategory = "".obs;

  /// value of Next Button
  RxBool enableButton = false.obs;

  RxList<OnBoardingDocumentModel> imageList = <OnBoardingDocumentModel>[].obs;



  
/*
  getCategory({required itemId})async{
    WebService webService = WebService();
    dynamic response = await webService.getCategoryDocumentType();
    if(!response.toString().contains("error")){
      imageList.clear();
      List<dynamic> listTemp = response as List;
      listTemp.forEach((element) {
        imageList.add(OnBoardingDocumentModel(category: element, image: []));
      });
      imageList.refresh();
      update();
      Get.toNamed(Routes.onBoardingUploadPhotosScreen, arguments: itemId);
    }
  }
*/

/*  getCategory({required itemId})async{
    WebService webService = WebService();
    dynamic response = await webService.getCategoryDocumentType();
    if(!response.toString().contains("error")){

      imageList.clear();
      List<dynamic> listTemp = response as List;


      dynamic responseCategory = await webService.getPhotoCountOnboardingService(itemId);
    for(int i =0; i<listTemp.length; i++){
      CatModel catModel =  CatModel.fromJson(listTemp[i]);
      imageList.add(OnBoardingDocumentModel(category: catModel.name,
          image: [],rowId:catModel.rowId,
          itemCount: responseCategory!=null?responseCategory[catModel.name.toString().replaceAll(" ", "")].toString()=="null"?"0":responseCategory[catModel.name.toString().replaceAll(" ", "")].toString():"0"));
    }
      imageList.sort((a,b)=> a.rowId!.compareTo(b.rowId!));
      imageList.refresh();
      update();
      Get.toNamed(Routes.onBoardingUploadPhotosScreen, arguments: itemId);
    }
  }*/

  getCategory({required itemId})async{
    WebService webService = WebService();
    dynamic response = await webService.getPhotoCountOnboardingService(itemId.itemId);
    if(response!=null) {
      if (!response.toString().contains("error")) {
        imageList.clear();
        List<dynamic> listTemp = response as List;

        for (int i = 0; i < listTemp.length; i++) {
          CategoryResponseModel catModel = CategoryResponseModel.fromJson(listTemp[i]);
          var  result = await OnboardingImageManager().getYetToSubmitCount(catModel.name,itemId.itemId);
          List<OnBoardingDocumentImageModel> dbImage = await OnboardingImageManager().getImageListNotSubmitted(itemId.itemId, catModel.name);
          var count =  result[0]['COUNT(*)'];
          print("Count is "+count.toString());
          imageList.add(OnBoardingDocumentModel(category: catModel.name,
              image: dbImage, rowId: int.parse(catModel.rowId==null?"0":catModel.rowId.toString()),
              itemCount: catModel.photoCount.toString(), UploadURL:catModel.uploadURL,
              yetToSubmit: count.toString()

          ));
          print(catModel.photoCount.toString());
        }
        imageList.sort((a, b) => a.rowId!.compareTo(b.rowId!));
        imageList.refresh();
        update();
        setButtonEnable();
        Get.toNamed(Routes.onBoardingUploadPhotosScreen, arguments: itemId);
      }
    }
  }

  saveDocumentApiRequest(resourceId,{var i=0})async{
    for(var i = 0; i<imageList.length; i++){
      List imageLiist = await OnboardingImageManager().getImageListNotSubmitted(resourceId, imageList[i].category);

       for(var k = 0; k<imageLiist.length; k++){
         OnBoardingDocumentImageModel model =imageLiist[k];
         model.isSubmitted = 1;
         await OnboardingImageManager().insertImage(model);
       }

    }
    final service = FlutterBackgroundService();
    await service.startService();
    var token = await sp!.getString(Preference.ACCESS_TOKEN)??"";
   Map<String, dynamic> map = HashMap();
   map["imageList"] = imageList.map((element) => element.toJson()).toList();
   map["token"] = token;
   map["resourceId"] = resourceId;
   print(map);
    Future.delayed(Duration(seconds: 3),(){
      service.invoke("onboarding",map);
    });

  }


  setButtonEnable(){
    var  count  = 0;
    imageList.forEach((element) {
      if(element.yetToSubmit!=null) {
        count += int.parse(element.yetToSubmit.toString());
      }
    });
   print(count);
   if(count>0){
     enableButton.value  = true;
     update();
   }else{
     enableButton.value  = false;
     update();
   }
  }

}
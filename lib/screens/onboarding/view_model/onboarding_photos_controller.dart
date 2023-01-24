import 'dart:collection';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/repository/web_services/web_service.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/screens/onboarding/model/onboarding_category_model.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';

class OnBoardingPhotosController extends GetxController{

  RxString selectedCategory = "".obs;

  /// value of Next Button
  RxBool enableButton = false.obs;

  RxList<OnBoardingDocumentModel> imageList = <OnBoardingDocumentModel>[].obs;



  
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



  saveDocumentApiRequest(resourceId,{var i=0})async{
    final service = FlutterBackgroundService();
    await service.startService();
    var token = await sp!.getString(Preference.ACCESS_TOKEN)??"";
   Map<String, dynamic> map = HashMap();
   map["imageList"] = imageList.map((element) => element.toJson()).toList();
   map["token"] = token;
   map["resourceId"] = resourceId;
    Future.delayed(Duration(seconds: 3),(){
      service.invoke("onboarding",map);
    });

  }

}
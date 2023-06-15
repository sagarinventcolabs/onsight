import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/repository/database_model/image_model_promo_pictures.dart';
import 'package:on_sight_application/repository/web_services/web_service.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/utils/connectivity.dart';
import 'package:on_sight_application/utils/dialogs.dart';
import 'package:on_sight_application/utils/functions/functions.dart';
import 'package:on_sight_application/utils/strings.dart';


class PromoPicturesController extends GetxController{

  /// value of Next Button
  RxBool enableButton = false.obs;

  /// check show number is valid or not
  RxBool isValidShowNumber = true.obs;

  /// radio button for show selection
  RxInt radioButtonValue = 1.obs;
  /// Selected show number variable
  RxString selectedShow = "".obs;
  /// Photo List
  RxList<PromoImageModel> photoList = <PromoImageModel>[].obs;
  /// Webservice Instance to call API Functions
  WebService service = WebService();


  TextEditingController showController =  TextEditingController();

/// validate function for button enable/disable
  validate() {
    if (showController.text.isEmpty) {
      enableButton.value = false;
      update();
      return false;
    }else if(showController.text.length<4){
      enableButton.value = false;
      update();
      return false;
    }else {
      updateIsValid(true);
    }

    return true;
  }

  updateIsValid(value) {
    isValidShowNumber.value = value;
    update();
  }


  Future<dynamic> getSheetDetails(show, isLoading) async {
    selectedShow.value = show;
    bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
    if(isNetActive){
      var response = await service.getLeadSheetDetails(show, isLoading);
      if(response!=null) {
        if (!response.toString().contains(error) && !response.toString().contains(noInternetStr)) {

          showModalBottomSheet(
             // backgroundColor: Get.isPlatformDarkMode ? Colors.grey.shade900 : ColourConstants.white,
              //backgroundColor: Color.fromARGB(255, 0, 0, 0),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              isScrollControlled: true,
              context: Get.context!,
              builder: (context) =>
                  bottomSheetImagePickerPromo(Routes.promoPictureScreen)).then((value) {
                 // bottomSheetImagePickerPromoPictures(Routes.promoPictureScreen)).then((value) {
            ImagePickerPromoPictures(Routes.promoPictureScreen);
                        update();
          });
        }else{
          if(response.toString().contains(showNumberNotFound)){
            isValidShowNumber.value = false;
            update();
          }
        }

      }
      enableButton.value = true;
      update();
      return response;
    }else{
      Get.closeCurrentSnackbar();
      Get.closeAllSnackbars();
      Get.snackbar(alert,noInternet);
    }
  }

}
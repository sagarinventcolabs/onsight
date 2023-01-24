import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/repository/web_service_response/all_oasis_resources_response.dart';
import 'package:on_sight_application/repository/web_service_response/lead_sheet_response.dart';
import 'package:on_sight_application/repository/web_services/web_service.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/utils/connectivity.dart';
import 'package:on_sight_application/utils/strings.dart';

class OnboardingResourceController extends GetxController{

  /// enable/disable button variable
  RxBool enableButton = false.obs;
  /// check show number is valid or not
  RxBool isValidShowNumber = true.obs;
  /// controller for showNumber Field
  TextEditingController showController =  TextEditingController(text: "");
  /// Webservice Instance to call API Functions
  WebService service = WebService();
  /// model Lead Sheet Details
  ShowDetails? detailsModel;

  RxList<AllOasisResourcesResponse> oasisResourceList = <AllOasisResourcesResponse>[].obs;
  RxList<AllOasisResourcesResponse> searchedResourceList = <AllOasisResourcesResponse>[].obs;

  /// Show Number
  RxString showNumber = "".obs;
  /// Selected Exhibitor
  RxInt selectedResource = 111111.obs;
  RxList<Exhibitors> selectedExhibitorModel = <Exhibitors>[].obs;

  /// Selected Exhibitor
  RxBool showExhibitor = false.obs;
  /// Show Hide Button
  RxBool buttonSubmit = false.obs;

  updateSelectedModel(Exhibitors element){

    selectedExhibitorModel.first = element;
    selectedExhibitorModel.refresh();
    update();

  }

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


  /// API function for getting Lead details
  Future<dynamic> getSheetDetails(route, show, isLoading) async {
    showNumber.value = show;
    bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
    if(isNetActive){
      var response = await service.getLeadSheetDetails(showNumber.value, isLoading);
      if(response!=null) {
        if (!response.toString().contains(error)) {

        }
      }
      return response;
    }
  }

  /// API function for getting Lead details
  Future<dynamic> getOasisResourcesApi() async {
    oasisResourceList.clear();
    /// For making list reversed.
    List<AllOasisResourcesResponse> localReversedList = [];
    bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
    if(isNetActive){
      var response = await service.getOasisResourcesService();
      if(response!=null) {
        if (!response.toString().contains(error)) {

          for (var i = 0; i < response.length; i++) {
            AllOasisResourcesResponse responseModel = AllOasisResourcesResponse.fromJson(response,i);
            localReversedList.add(responseModel);
          }
          oasisResourceList.addAll(localReversedList.reversed.toList());
          oasisResourceList.refresh();
          update();
          Get.toNamed(Routes.onBoardingResourceScreen);
        }
      }
      return response;
    }else{
      Get.snackbar(alert, noInternet);
    }
  }


}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:on_sight_application/repository/database_managers/exhibitor_manager.dart';
import 'package:on_sight_application/repository/database_managers/leadsheet_image_manager.dart';
import 'package:on_sight_application/repository/database_managers/show_manager.dart';
import 'package:on_sight_application/repository/web_service_response/lead_sheet_response.dart';
import 'package:on_sight_application/repository/web_services/web_service.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/utils/connectivity.dart';
import 'package:on_sight_application/utils/strings.dart';

class LeadSheetController extends GetxController{

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
  /// List of Exhibitors
  RxList<Exhibitors> list = <Exhibitors>[].obs;
  /// List of Searched Exhibitors
  RxList<Exhibitors> searchedExhibitorsList = <Exhibitors>[].obs;
  /// Show Number
  RxString showNumber = "".obs;
  /// Selected Exhibitor
  RxInt selectedExhibitor = 111111.obs;
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
/// Format Date Function.......
  formatTime(input){
    final f = DateFormat('MM/dd/yyyy');
    var result = "";
    try{
      result = f.format(DateTime.parse(input));
    }catch(e){

    }

    return result;
  }

  /// API function for getting Lead details
  Future<dynamic> getSheetDetails(route, show, isLoading) async {
    showNumber.value = show;
   // showExhibitor.value = false;

    ShowManager manager = ShowManager();
    var count = await manager.getCount();
    bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
    if(isNetActive){
      var response = await service.getLeadSheetDetails(showNumber.value, isLoading);
      if(response!=null) {
        if (!response.toString().contains(error)) {
          list.clear();
         LeadSheetResponse leadSheetResponse = LeadSheetResponse.fromJson(response);
          LeadSheetImageManager leadSheetImageManager = LeadSheetImageManager();
          ExhibitorManager exhibitorManager = ExhibitorManager();
          leadSheetResponse.showDetails?.showNumber = showNumber.value;
          detailsModel = leadSheetResponse.showDetails;
          if(leadSheetResponse.exhibitors!=null) {
            list.value = leadSheetResponse.exhibitors!;
            list.sort((a,b)=>a.exhibitorName.toString().toLowerCase().compareTo(b.exhibitorName.toString().toLowerCase()));
            list.refresh();
            for (var element in list) {
              if (selectedExhibitorModel.isNotEmpty) {
                if (selectedExhibitorModel.first.exhibitorId != null) {
                  if (selectedExhibitorModel.first.exhibitorId ==
                      element.exhibitorId) {
                    selectedExhibitorModel.first = element;
                    update();
                  }
                }
              }
              element.yetToSubmit =
              await leadSheetImageManager.getYetToSubmitCount(
                  element.exhibitorId,
                  leadSheetResponse.showDetails?.showNumber);
            }
            list.refresh();
            update();
            manager.insertShow(leadSheetResponse).then((value) async {
              for (var element in leadSheetResponse.exhibitors!) {
                element.showNumber =
                    leadSheetResponse.showDetails?.showNumber;

                exhibitorManager.insertExhibitors(element);
              }
            });
          }
          if(route==Routes.leadSheetScreen) {
            Get.toNamed(
                Routes.leadSheetDetailScreen, arguments: showController.text);
          }
        }
      }
      return response;
    }
    else{
      if(count>0){
        list.clear();
        detailsModel = await manager.getShow(showNumber.value);
        ExhibitorManager exhibitorManager = ExhibitorManager();
        list.value = await exhibitorManager.getExhibitors(showNumber.value);

        list.refresh();
        if(detailsModel!=null){
          if(route==Routes.leadSheetScreen) {
            Get.toNamed(
                Routes.leadSheetDetailScreen, arguments: showController.text);
          }
        }

      }
    }
  }


}
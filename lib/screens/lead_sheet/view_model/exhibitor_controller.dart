import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:on_sight_application/repository/web_service_response/add_exhibitor_response.dart';
import 'package:on_sight_application/repository/web_service_response/booth_size_response.dart';
import 'package:on_sight_application/repository/web_service_response/companies_name_response.dart';
import 'package:on_sight_application/repository/web_service_response/lead_sheet_response.dart';
import 'package:on_sight_application/repository/web_service_response/shop_request_response.dart';
import 'package:on_sight_application/repository/web_services/web_service.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/screens/lead_sheet/view_model/lead_sheet_controller.dart';
import 'package:on_sight_application/utils/connectivity.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dialogs.dart';
import 'package:on_sight_application/utils/functions/functions.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ExhibitorController extends GetxController{

  WebService service = WebService();
  RxBool isButtonEnable = false.obs;
  AddExhibitorResponse? addExhibitorResponse;
  TextEditingController nameController = TextEditingController();
  TextEditingController explainController = TextEditingController();
  // List for containing & updating all the exhibitors.
  RxList<Exhibitors> list = <Exhibitors>[].obs;
  // List for containing all the Shops.
  RxList<ShopRequestResponse> shopList = <ShopRequestResponse>[].obs;
  RxList<BoothSizeResponse> boothSizesList = <BoothSizeResponse>[].obs;
  RxList<String> boothSizesString = <String>[].obs;
  RxList<CompaniesNameResponse> companiesList = <CompaniesNameResponse>[].obs;
  /// Listening variable for comment controller
  RxBool isListening = false.obs;
  /// instance of speech to text
  Rx<SpeechToText> speechToText = SpeechToText().obs;

  /// checking speech to text status
  final _speechEnabled = false.obs;

  /// define speech text for using in app
  var speechTextResult = "".obs;


  /// Name TextInput Validations......................................................
  validateName(){
    if (nameController.text.toString().trim().isEmpty) {
      isButtonEnable.value = false;
      update();
      return false;
    }else{
      isButtonEnable.value = true;
      update();
      return true;
    }
  }
  /// API function for Adding Exhibitor
  Future<dynamic> addExhibitorApi({required Exhibitors model, isLoading,leadNumber}) async {
    list.clear();
    list.refresh();
    bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
    if(isNetActive){
      isButtonEnable.value = false;
      update();
      var response;
        if ((model.boothSize?.length??0) == 1) {
          model.boothSize = "";
          response = await service.addExhibitor(model: model,leadNumber: leadNumber??"");
        }else{
          response = await service.addExhibitor(model: model,leadNumber: leadNumber??"");
        }
      if(response != null){
        if (!response.toString().contains("error")) {
          AnalyticsFireEvent(AddExhibitor, input: {
            added_exhibitor_name: model.exhibitorName??"",
            user:sp?.getString(Preference.FIRST_NAME)??"" /*+" "+sp?.getString(Preference.LAST_NAME)??""*/
          });
          LeadSheetController controller = Get.find<LeadSheetController>();
          controller.list.clear();
          List<dynamic> listt = response as List;
          listt.forEach((element) {
            Exhibitors exhibitors = Exhibitors.fromJson(element);
            controller.list.add(exhibitors);
            controller.showExhibitor.value = true;
              controller.selectedExhibitorModel.clear();
              controller.selectedExhibitorModel.add(exhibitors);
              controller.selectedExhibitorModel.refresh();

          });
          sp?.putInt(Preference.ACTIVITY_TRACKER, ((sp?.getInt(Preference.ACTIVITY_TRACKER)??0)+1));
          print((sp?.getInt(Preference.ACTIVITY_TRACKER)??0).toString());
          controller.list.refresh();
          controller.update();
          defaultDialog(Get.context!,title: exhibitoraddedSuccessfully,onTap: (){
            Get.back();
            Get.back();
          },cancelable: false);
        }else{
          isButtonEnable.value = true;
          update();
          Get.snackbar(alert, somethingWentWrong);
        }
      }else{
        isButtonEnable.value = true;
        update();
        Get.snackbar(alert, somethingWentWrong);
      }
    }else{
      isButtonEnable.value = false;
      update();
      Get.snackbar(alert, pleaseCheckInternet);
      Timer(const Duration(seconds: 4),(){
        isButtonEnable.value = true;
        update();
      });
    }
  }

  /// API function for Updating Exhibitor
  Future<dynamic> updateExhibitorApi({required Exhibitors model, isLoading,leadNumber}) async {
    list.clear();
    list.refresh();
    bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
    if(isNetActive){
      isButtonEnable.value = false;
      update();
      var response;
      if ((model.boothSize?.length??0) == 1) {
        model.boothSize = "";
        response = await service.addExhibitor(model: model,leadNumber: leadNumber??"");
      }else{
        response = await service.addExhibitor(model: model,leadNumber: leadNumber??"");
      }
      if(response != null){

        if (!response.toString().contains(error)) {
          AnalyticsFireEvent(UpdateExhibitor, input: {
            updated_exhibitor_name: model.exhibitorName??"",
            user:sp?.getString(Preference.FIRST_NAME)??"" /*+" "+sp?.getString(Preference.LAST_NAME)??""*/
          });
          LeadSheetController controller = Get.find<LeadSheetController>();
          await controller.getSheetDetails(Routes.addExhibitorScreen, controller.showNumber.value, true).then((value) {
            sp?.putInt(Preference.ACTIVITY_TRACKER, ((sp?.getInt(Preference.ACTIVITY_TRACKER)??0)+1));
            print((sp?.getInt(Preference.ACTIVITY_TRACKER)??0).toString());
            controller.update();
            defaultDialog(Get.context!,title: exhibitorDetailsUpdatedSuccessfully,onTap: (){
              Get.back();
              Get.back();
            },cancelable: false);
          });

        }else{
          isButtonEnable.value = true;
          update();
          Get.snackbar(alert, somethingWentWrong);
        }
      }else{
        isButtonEnable.value = true;
        update();
        Get.snackbar(alert, somethingWentWrong);
      }
    }else{
      isButtonEnable.value = false;
      update();
      Get.snackbar(alert, pleaseCheckInternet);
      Timer(const Duration(seconds: 4),(){
        isButtonEnable.value = true;
        update();
      });
    }
  }

  /// This has to happen only once per app
  void initSpeech() async {
    _speechEnabled.value = await speechToText.value.initialize();
    log(_speechEnabled.value.toString());
    update();
  }

  /// Each time to start a speech recognition session
  void startListening() async {
    log("_startListening");
    isListening.value = true;
    update();
    Future.delayed(const Duration(seconds: 3), () {
      isListening.value = false;
      update();
    });
    await speechToText.value.listen(onResult: (result) {
      onSpeechResult(result);
    }).catchError((onError) {
      log(onError);
    });

    update();
  }

  /// Manually stop the active speech recognition session
  void stopListening() async {

    log("_stopListening");
    await speechToText.value.stop();
    update();
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  onSpeechResult(SpeechRecognitionResult result) {
    log(speechTextResult.value);
    if(nameController.text.isNotEmpty){
      isButtonEnable.value = true;
    }else{
      isButtonEnable.value = false;
    }
    speechTextResult.value = result.recognizedWords;
    explainController.text = result.recognizedWords;
    update();
  }

  /// API function for getting the shop list
  Future<dynamic> getShopListApi() async {
    shopList.clear();
    shopList.refresh();
    bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
    if(isNetActive){
      var response = await service.getShopList();
      if(response != null){
        if (!response.toString().contains(error)) {
          List<dynamic> localShopList = response as List;
          localShopList.forEach((element) {
            ShopRequestResponse shops = ShopRequestResponse.fromJson(element);
            shopList.add(shops);
          });
          shopList.refresh();
          update();
        }else{
          Get.snackbar(alert, somethingWentWrong);
        }
      }else{
        Get.snackbar(alert,somethingWentWrong);
      }
    }else{
      Get.snackbar(alert, pleaseCheckInternet);
    }
  }

  /// API function for getting the booth size list
  Future<dynamic> getBoothSizeApi() async {
    boothSizesList.clear();
    boothSizesList.refresh();
    bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
    if(isNetActive){
      var response = await service.getBoothSizeList();
      if(response != null){
        if (!response.toString().contains(error)) {
          List<dynamic> localList = response as List;
          localList.forEach((element) {
            BoothSizeResponse boothSizes = BoothSizeResponse.fromJson(element);
            boothSizesList.add(boothSizes);
            boothSizesString.add(boothSizes.boothSize??"");
          });
          boothSizesString.refresh();
          boothSizesList.refresh();
          update();
        }else{
          Get.snackbar(alert, somethingWentWrong);
        }
      }else{
        Get.snackbar(alert,somethingWentWrong);
      }
    }else{
      Get.snackbar(alert, pleaseCheckInternet);
    }
  }

  /// API function for getting the companies name list
  Future<dynamic> getCompaniesApi() async {
    companiesList.clear();
    companiesList.refresh();
    bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
    if(isNetActive){
      var response = await service.getCompaniesList();
      if(response != null){
        if (!response.toString().contains(error)) {
          List<dynamic> localList = response as List;
          localList.forEach((element) {
            CompaniesNameResponse companiesName = CompaniesNameResponse.fromJson(element);
            companiesList.add(companiesName);
          });
          companiesList.refresh();
          update();
        }else{
          Get.snackbar(alert, somethingWentWrong);
        }
      }else{
        Get.snackbar(alert, somethingWentWrong);
      }
    }else{
      Get.snackbar(alert, pleaseCheckInternet);
    }
  }

}
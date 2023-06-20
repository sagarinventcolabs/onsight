import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/repository/web_service_requests/create_resource_request.dart';
import 'package:on_sight_application/repository/web_service_response/all_oasis_resources_response.dart';
import 'package:on_sight_application/repository/web_service_response/create_resource_response.dart';
import 'package:on_sight_application/repository/web_service_response/lead_sheet_response.dart';
import 'package:on_sight_application/repository/web_services/web_service.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/screens/onboarding/view_model/onboarding_photos_controller.dart';
import 'package:on_sight_application/screens/onboarding/view_model/onboarding_resource_controller.dart';
import 'package:on_sight_application/utils/connectivity.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dialogs.dart';
import 'package:on_sight_application/utils/functions/functions.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';


class OnboardingController extends GetxController{

  // Rx<FocusNode> focusNodeCity = FocusNode().obs;
  // Rx<FocusNode> focusNodeFirstName = FocusNode().obs;
  // Rx<FocusNode> focusNodeLastName = FocusNode().obs;
  // Rx<FocusNode> focusNodeSSN = FocusNode().obs;
  // Rx<FocusNode> focusNodeMobile = FocusNode().obs;
  // Rx<FocusNode> focusNodeUnion = FocusNode().obs;
  // Rx<FocusNode> focusNodeClassification = FocusNode().obs;

  /// Show Number Controller
  TextEditingController showNumberController = TextEditingController();
  /// First Name Controller
  TextEditingController firstNameController = TextEditingController();
  /// last Name Controller
  TextEditingController lastNameController = TextEditingController();
  /// mobile number Controller
  TextEditingController mobileNumberController = TextEditingController();
  /// union Controller
  TextEditingController unionController = TextEditingController();
  /// ssn Controller
  TextEditingController ssnController = TextEditingController();
  /// City Controller
  TextEditingController cityController = TextEditingController();
  /// Classification Controller
  TextEditingController classificationController = TextEditingController();
  /// Note Controller
  TextEditingController noteController = TextEditingController();
  /// check valid first name parameter
  RxBool isValidShowNumber = true.obs;
  /// check valid first name parameter
  RxBool isValidFirstName = true.obs;
  /// check valid last name parameter
  RxBool isValidLastName = true.obs;
  /// check valid mobile number parameter
  RxBool isValidMobileNumber = true.obs;
  /// check valid ssn parameter
  RxBool isValidSSN = true.obs;
  RxBool isValidUnion = true.obs;
  RxBool isValidClassification = true.obs;
  /// Document value
    RxString dropDownDocumentValue = "Document Type".obs;
  /// check valid city parameter
  RxBool isValidCity = true.obs;
  /// Submit button enable / disable
  RxBool enableButton = false.obs;
  /// Submit button enable / disable
  RxBool submitButton = false.obs;
  /// Union Suggestions List
  RxList<String> unionSuggestionsList = <String>[].obs;
  /// checking speech to text status
  final _speechEnabled = false.obs;
  /// instance of speech to text
  Rx<SpeechToText> speechToText = SpeechToText().obs;
  /// Listening variable for comment controller
  RxBool isListening = false.obs;
  /// corporateSupport checkbox variable
  RxBool corporateSupport = false.obs;
  /// Selected show number variable
  RxString selectedShow = "".obs;
  /// Webservice Instance to call API Functions
  WebService service = WebService();
  /// variable for selectedOption of entrance type
  RxString selectedOption = selectCategory.obs;
  /// request model for
  Rx<CreateResourceRequest> requestModel = CreateResourceRequest().obs;
  /// variable for show hide suggestion below text field of union number
  RxInt value = 0.obs;


  /// TextInput Validations......................................................

  validateFunc(){
    if (cityController.text.isEmpty) {
      enableButton.value = false;
      update();
      return false;
    } else {
      enableButton.value = true;
    }
    if (firstNameController.text.isEmpty) {
      enableButton.value = false;
      update();
      return false;
    } else {
      enableButton.value = true;
    }
    if (lastNameController.text.isEmpty) {
      enableButton.value = false;
      update();
      return false;
    } else {
      enableButton.value = true;
    }
    if (ssnController.text.isEmpty) {
      enableButton.value = false;
      update();
      return false;
    } else if(ssnController.text.length != 9){
      enableButton.value = false;
      update();
      return false;
    }else {
    enableButton.value = true;
    }
    if(mobileNumberController.text.length != 10 && mobileNumberController.text.length > 0){
      enableButton.value = false;
      update();
      return false;
    }else{
      enableButton.value = true;

    }

    if(corporateSupport.isTrue){
      if (unionController.text.isEmpty) {
        enableButton.value = false;
        update();
        return false;
      }else {
        enableButton.value = true;
      }
      if (classificationController.text.isEmpty) {
        enableButton.value = false;
        update();
        return false;
      }else {
        enableButton.value = true;
      }

    }

    update();
    return true;
  }

  /// validation on submit button
  validsubmit(context){
    if (cityController.text.isEmpty) {
      enableButton.value = false;
      isValidCity.value = false;
      // FocusScope.of(context).requestFocus(focusNodeCity.value);
      update();
      return false;
    } else {
      enableButton.value = true;
      isValidCity.value = true;
    }
    if (firstNameController.text.isEmpty) {
      enableButton.value = false;
      isValidFirstName.value = false;
     // focusNodeFirstName.value.requestFocus();
      update();
      return false;
    } else {
      enableButton.value = true;
      isValidFirstName.value = true;
    }
    if (lastNameController.text.isEmpty) {
      enableButton.value = false;
      isValidLastName.value = false;
     // focusNodeLastName.value.requestFocus();
      update();
      return false;
    } else {
      isValidLastName.value = true;
      enableButton.value = true;
    }
    if (ssnController.text.isEmpty) {
      enableButton.value = false;
      isValidSSN.value = false;
      //focusNodeSSN.value.requestFocus();
      update();
      return false;
    } else if(ssnController.text.length != 9){
      isValidSSN.value = false;
      enableButton.value = false;
      //  focusNodeSSN.value.requestFocus();
      update();
      return false;
    }else {
      try{
        var value = int.parse(ssnController.text.toString());
        if(value<=0){
          enableButton.value = false;
          isValidSSN.value = false;
          // focusNodeMobile.value.requestFocus();
          update();
          return false;
        }
      }catch(e){
        debugPrint(e.toString());
      }
      isValidSSN.value = true;
      enableButton.value = true;
    }
    if(mobileNumberController.text.isEmpty){
      enableButton.value = false;
      isValidMobileNumber.value = false;
      // focusNodeMobile.value.requestFocus();
      update();
      return false;
    }
    else if (mobileNumberController.text.length != 10 && mobileNumberController.text.length > 0) {
      enableButton.value = false;
      isValidMobileNumber.value = false;
     // focusNodeMobile.value.requestFocus();
      update();
      return false;
    }  else {
      try{
        var value = int.parse(mobileNumberController.text.toString());
        if(value<=0){
          enableButton.value = false;
          isValidMobileNumber.value = false;
          // focusNodeMobile.value.requestFocus();
          update();
          return false;
        }
      }catch(e){
        debugPrint(e.toString());
      }
      isValidMobileNumber.value = true;
      enableButton.value = true;
    }



    if(corporateSupport.isTrue){
      if (unionController.text.isEmpty) {
        enableButton.value = false;
        isValidUnion.value = false;
        update();
        return false;
      }else {
        enableButton.value = true;
      }
      if (classificationController.text.isEmpty) {
        enableButton.value = false;
        isValidClassification.value = false;
        update();
        return false;
      }else {
        enableButton.value = true;
      }

    }
    update();
    return true;
  }


  ///Validate Show Number
  validate(){
    if(showNumberController.text.isEmpty){
      submitButton.value = false;
    }else if(showNumberController.text.length<5){
      submitButton.value = false;
    }else{
      submitButton.value = true;
    }
    update();
  }


  /// This has to happen only once per app
  void initSpeech() async {
    _speechEnabled.value = await speechToText.value.initialize();
    update();
  }



  /// Each time to start a speech recognition session
  void startListening() async {
    isListening.value = true;
    update();

    await speechToText.value.listen(onResult: (result) {
      stopListening();
      onSpeechResult(result);
    }).catchError((onError) {
      stopListening();
      log(onError.toString());
      isListening.value = false;
      update();
    });

    update();
  }

  /// Manually stop the active speech recognition session
  void stopListening() async {
    isListening.value = false;
    await speechToText.value.stop();
    update();
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  onSpeechResult(SpeechRecognitionResult result) {
    isListening.value = false;
    noteController.text = result.recognizedWords;
    update();
  }


  Future<dynamic> getSheetDetails(show, isLoading) async {

    OnboardingResourceController onboardingResourceController = Get.find<OnboardingResourceController>();
    selectedShow.value = show;
    bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
    if(isNetActive){
      var response = await service.getLeadSheetDetails(show, isLoading);
      if(response!=null) {
        if (!response.toString().contains(error)) {

          LeadSheetResponse leadSheetResponse = LeadSheetResponse.fromJson(response);

          if(leadSheetResponse.showDetails!=null) {
            cityController.text = leadSheetResponse.showDetails!.showCity.toString();
            update();
          }

          if(selectedOption==fileDocuments){
            onboardingResourceController.getOasisResourcesApi();
          }else{
            Get.toNamed(Routes.onBoardingRegistration);
          }
        }else{
          if(response.toString().contains(showNumberNotFound)){
            isValidShowNumber.value = false;
            update();
          }
        }

      }
      submitButton.value = true;
      update();
      return response;
    }else{
      Get.snackbar(alert,noInternet);
    }
  }
  /// API function for creating resource
  Future<dynamic> checkSSN() async {

    requestModel.value.firstName = firstNameController.text.trim();
    requestModel.value.lastName = lastNameController.text.trim();
    try {
      requestModel.value.mobilePhone = mobileNumberController.text;
    }catch(e){
      requestModel.value.mobilePhone = '';
    }
    requestModel.value.union = unionController.text.trim();
    requestModel.value.ssn = ssnController.text.trim();
    requestModel.value.city = cityController.text.trim();
    requestModel.value.classification = classificationController.text.trim();
    requestModel.value.notes = noteController.text.trim();
    requestModel.value.show = selectedShow.value;
    bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
    if(isNetActive){
      var response = await service.checkSSNValidate(requestModel.value.ssn);

      if(response==null) {
        createResourceApi();
      }else if(response.length>1){
        // AllOasisResourcesResponse responseModel = AllOasisResourcesResponse.fromJson(response, 0);
        // responseModel.route = Routes.onBoardingRegistration;
        defaultDialog(
            Get.context!,
            alert: ssnMoreThenOne,
            title: multipleSSNFound,
            onTap: (){
              Get.back();
              },);

      }else{
        AllOasisResourcesResponse responseModel = AllOasisResourcesResponse.fromJson(response, 0);
        responseModel.route = Routes.onBoardingRegistration;
        dialogWithHyperLink(Get.context!, alert: resourceCanNotBeEntered, title: recordContainingSSNAlreadyExists, colour: ColourConstants.red, hyperLink: viewRecords, onTap: (){Get.back();}, model: responseModel);

      }
      update();
      return response;
    }else{
      Get.snackbar(alert,noInternet);
    }
  }
  /// API function for creating resource
  Future<dynamic> createResourceApi() async {
    OnBoardingPhotosController onBoardingPhotosController;
    requestModel.value.firstName = firstNameController.text.trim();
    requestModel.value.lastName = lastNameController.text.trim();
    try {
      requestModel.value.mobilePhone = mobileNumberController.text;
    } catch (e) {
      requestModel.value.mobilePhone = '';
    }
    if (corporateSupport.isTrue){
      requestModel.value.union = unionController.text.trim();
    requestModel.value.classification = classificationController.text.trim();
  }else{
      requestModel.value.union = null;
      requestModel.value.classification = null;
    }
    requestModel.value.ssn = ssnController.text.trim();
    requestModel.value.city = cityController.text.trim();

    requestModel.value.notes = noteController.text.trim();
    requestModel.value.show = selectedShow.value;
    bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
    if(isNetActive){
      var response = await service.createResourceOnboarding(requestModel.toJson());
      if(response!=null) {

        if (response.toString().contains("ItemId")) {
        CreateResourceResponse createResourceResponse = CreateResourceResponse.fromJson(response);
        analyticsFireEvent(oasisResourceCreatedKey, input: {
          "ssn":createResourceResponse.ssn??"",
          user:sp?.getString(Preference.FIRST_NAME)??"" /*+" "+sp?.getString(Preference.LAST_NAME)??""*/
        });
        requestModel.value.itemId = num.parse(createResourceResponse.itemId.toString());
        sp?.putInt(Preference.ACTIVITY_TRACKER, ((sp?.getInt(Preference.ACTIVITY_TRACKER)??0)+1));
          dialogAction(Get.context!,
              alert: resourceCreatedSuccessfully,
              title: doYouWantToAddDocument,
              onTapYes: () {
                firstNameController.clear();
                lastNameController.clear();
                mobileNumberController.clear();
                unionController.clear();
                ssnController.clear();
                cityController.clear();
                classificationController.clear();
                noteController.clear();
                enableButton.value = false;

                update();
                Get.back();
                if(Get.isRegistered<OnBoardingPhotosController>()){
                  onBoardingPhotosController = Get.find<OnBoardingPhotosController>();
                }else{
                  onBoardingPhotosController = Get.put(OnBoardingPhotosController());
                }
                AllOasisResourcesResponse model = AllOasisResourcesResponse.fromJsonn(response);
                model.route = Routes.onBoardingRegistration;
                print("Model is  ${model.route}");
                print("ModelName is  ${model.firstName}");
                print("ModelUnion is  ${model.union}");
                print("ModelClassification is  ${model.classification}");
                onBoardingPhotosController.getCategory(itemId: model);
                },
              onTapNo: () {
                firstNameController.clear();
                lastNameController.clear();
                mobileNumberController.clear();
                unionController.clear();
                ssnController.clear();
                cityController.clear();
                classificationController.clear();
                noteController.clear();
                enableButton.value = false;
                update();
                Get.back();
                Get.back();
              });

        }else{
          if(response.toString().contains(showNumberNotFound)){
            isValidShowNumber.value = false;
            update();
          }
        }

      }
      update();
      return response;
    }else{
      Get.snackbar(alert,noInternet);
    }
  }

  /// API function for getting Union Suggestions
  Future<dynamic> getUnionSuggestions() async {

    bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
    if(isNetActive){
      var response = await service.getUnionSuggestionsList()as List;
      if (!response.toString().contains(error)) {
        List<String> localList = [];
        response.forEach((element) {
          localList.add(element);
        });
        localList.sort((a, b) => a.toString().compareTo(b.toString()));
        if (localList.length > 0) {
          unionSuggestionsList.value = localList;
          unionSuggestionsList.refresh();
          update();
        }
      }
      var args = Get.arguments;
      if(args!=null){
        cityController.text = args.city;
        unionController.text = args.union;
        classificationController.text = args.classification;
        if(args.union!=null && args.classification!=null){
          corporateSupport.value = true;
        }else{
          corporateSupport.value = false;
        }
      }
      update();
      return response;
    }
  }
}
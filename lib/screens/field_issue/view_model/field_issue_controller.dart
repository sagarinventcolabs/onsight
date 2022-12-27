
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/repository/web_service_requests/submit_field_issue_request.dart';
import 'package:on_sight_application/repository/web_service_response/error_response.dart';
import 'package:on_sight_application/repository/web_service_response/get_job_details.dart';
import 'package:on_sight_application/repository/web_service_response/get_reposne_field_issue.dart';
import 'package:on_sight_application/repository/web_service_response/job_details_response.dart';
import 'package:on_sight_application/repository/web_services/web_service.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/screens/field_issue/model/category_model.dart';
import 'package:on_sight_application/screens/field_issue/view_model/photo_comment_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dialogs.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart' as http;

class FieldIssueController extends GetxController{

  /// Webservice Instance to call API Functions
  WebService service = WebService();
  /// Is Valid Job Number Variable
  RxBool isValidJobNumber= true.obs;
  /// Is Valid title Variable
  RxBool isValidTitle= true.obs;
  /// Email Validation variable to check email is valid or not
  RxBool isValidEmail = true.obs;
  /// variable to enable or disable submit button
  RxBool enableButton = false.obs;
  /// variable to enable or disable submit button
  RxBool enableButtonCategory = false.obs;
  /// variable for suggestion box controller
  Rx<SuggestionsBoxController> suggestionsBoxController =  SuggestionsBoxController().obs;
  /// variable for show hide suggestion below text field of job number
  RxInt value = 0.obs;
  /// variable for job number
  RxString JobNumber = "".obs;
  /// Category List
  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;
  /// Variable for selected Category
  RxInt selectedCat = 111111.obs;
  /// selected option
  RxString selectedOption = "0".obs;
  RxString selectedFieldIssue = "".obs;
  RxString fieldIssueChosedCategory = "".obs;
  /// controller for number input
  TextEditingController jobEditingController = TextEditingController(text: "");
  /// controller for title input
  TextEditingController titleController = TextEditingController(text: "");
  /// controller for description input
  TextEditingController descriptionController = TextEditingController(text: "");
  /// checking speech to text status
  final _speechEnabled = false.obs;
  /// instance of speech to text
  Rx<SpeechToText> speechToText = SpeechToText().obs;
  /// Listening variable for comment controller
  RxBool isListening = false.obs;
  /// Request Model
  Rx<SubmitFieldIssueRequest> requestModel = SubmitFieldIssueRequest().obs;
  ///list Job details
  RxList<GetJobDetails> list = <GetJobDetails>[].obs;

  @override
  void onInit() {
    super.onInit();
    value.value = 1;
    categoryList.add(CategoryModel(freight,961360000));
    categoryList.add(CategoryModel(missingDamage,961360001));
    categoryList.add(CategoryModel(injury,961360002));
    categoryList.add(CategoryModel(lateServices,961360003));
    categoryList.add(CategoryModel(initiateClaim,961360004));
    categoryList.refresh();

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
    Future.delayed(const Duration(seconds: 3), () {
      stopListening();
      isListening.value = false;
      update();
    });
    await speechToText.value.listen(onResult: (result) {
      onSpeechResult(result);
    }).catchError((onError) {
      stopListening();
      log(onError);
    });
    update();
  }

  /// Manually stop the active speech recognition session
  void stopListening() async {

    await speechToText.value.stop();
    update();
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  onSpeechResult(SpeechRecognitionResult result) {
    isListening.value = false;
    descriptionController.text = result.recognizedWords;
    update();
  }




  /// API function for getting job detail
  Future<dynamic> getJobDetails(jobNumber, downloadJobs, isLoading) async {
    var response = await service.getJobDetailsRequest(
        jobNumber, downloadJobs, isLoading);
    if (response != null) {
      if (response.toString().contains(error)) {

        updateisValid(false);

      }else if(response.toString().toLowerCase().contains(noInternetStrSmall)){

      }else{
        if(response.length>0) {
          for(var i =0; i<response.length; i++){
            JobDetailsResponse responseModel = JobDetailsResponse.fromJson(response,i);
            if((responseModel.jobNumber.toString().trim().toLowerCase())==(jobNumber.toString().trim().toLowerCase())) {

              requestModel.value.showNumber = responseModel.showNumber;
              requestModel.value.workOrderNumber = responseModel.woNumber;
              requestModel.refresh();
              Get.toNamed(Routes.fieldIssueDetailScreen);
              break;
            }
          }


        }



    }
      return response;
    }

  }


  /// API function for create case with comment only
  Future<dynamic> createCaseWithComment() async {
    PhotoCommentController photoCommentController = Get.find<PhotoCommentController>();

    http.Response response = await service.createCaseWithCommentOnly(requestModel.toJson());
    var responseJson = json.decode(response.body.toString());

    if(response.statusCode==200){


      GetReposneFieldIssue responseFieldIssue = GetReposneFieldIssue.fromJson(responseJson);

      print(responseFieldIssue.incidentid);
      if(responseFieldIssue.incidentid!=null){
        sp?.putInt(Preference.ACTIVITY_TRACKER, ((sp?.getInt(Preference.ACTIVITY_TRACKER)??0)+1));
        dialogAction(Get.context!,
            title: doYouWantAddMoreComment,
            alert: commentSubmittedSuccessfully,
            onTapYes: () {
              photoCommentController.commentController.clear();

              Get.back();
              Get.back();
              Get.back();
            }, onTapNo: () {

              Get.offAllNamed(Routes.dashboardScreen);

            });
      }
    }else if(response.statusCode==500){
      var responseJson = json.decode(response.body.toString());
      ErrorResponse errorModel =  ErrorResponse.fromJson(responseJson);
      Get.showSnackbar(GetSnackBar(message: errorModel.errorDescription,duration: Duration(seconds: 2),));
      photoCommentController.enableButton.value = true;
      photoCommentController.update();
      update();
    }else{
      var responseJson = json.decode(response.body.toString());
      ErrorResponse errorModel =  ErrorResponse.fromJson(responseJson);
      Get.showSnackbar(GetSnackBar(message: errorModel.errorDescription,duration: Duration(seconds: 2),));
      photoCommentController.enableButton.value = true;
      photoCommentController.update();
      update();
    }
    return responseJson;

  }


  /// API function for get details by show number
  Future<dynamic> getDetailsByShowNumber(input, type) async {
    list.clear();
    http.Response response = await service.getDetailsByShowNumber(input, type);

    var responseJson = json.decode(response.body.toString());

    if(response.statusCode==200){
      if(responseJson.length>0){
      for(var i = 0; i<responseJson.length; i++){

        GetJobDetails getJobDetails = GetJobDetails.fromJson(responseJson, i);
        list.add(getJobDetails);

      }
      if(list.length>0){
        requestModel.value.showNumber = list.first.showNumber;
        requestModel.value.workOrderNumber = list.first.woNumber;
       requestModel.refresh();
      }
      list.refresh();
      update();
      }
      Get.toNamed(Routes.selectJobScreen);
    } else {
      var responseJson = json.decode(response.body.toString());
      ErrorResponse errorModel =  ErrorResponse.fromJson(responseJson);
      Get.showSnackbar(GetSnackBar(message: errorModel.error,duration: Duration(seconds: 2),));
      enableButton.value = false;
      update();
    }
    return responseJson;
  }


  updateisValid(value){
    isValidJobNumber.value = value;
    update();

  }

  checkValidTitle(){
    if(titleController.text.toString().trim().isEmpty){
      isValidTitle.value = false;
      update();
      return false;
    }else{

      isValidTitle.value = true;
      update();
      return true;
    }
  }



}
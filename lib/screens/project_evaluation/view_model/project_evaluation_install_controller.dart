import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/repository/database_managers/email_manager.dart';
import 'package:on_sight_application/repository/database_managers/questions_manager.dart';
import 'package:on_sight_application/repository/database_model/email.dart';
import 'package:on_sight_application/repository/web_service_requests/save_evaluation_request.dart';
import 'package:on_sight_application/repository/web_service_requests/temp.dart';
import 'package:on_sight_application/repository/web_service_response/get_project_evaluation_questions_response.dart';
import 'package:on_sight_application/repository/web_service_response/is_evaluation_exist_response.dart';
import 'package:on_sight_application/repository/web_services/web_service.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/screens/project_evaluation/view_model/project_evaluation_controller.dart';
import 'package:on_sight_application/utils/connectivity.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dialogs.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ProjectEvaluationInstallController extends GetxController {
  /// instance of speech to text
  Rx<SpeechToText> speechToText = SpeechToText().obs;

  /// checking speech to text status
  final _speechEnabled = false.obs;

  /// define speech text for using in app
  var speechTextResult = "".obs;

  /// select category variable
  RxInt selectedCat = 2.obs;

  /// Webservice object to run apis
  WebService service = WebService();

  /// define QuestionList
  RxList<QuestionnaireDataList> questionList = <QuestionnaireDataList>[].obs;

  /// define ResponseModel
  GetProjectEvaluationQuestionsResponse? model ;

  /// Button Enable Variable for final submit button
  RxBool enableButton = false.obs;
  /// Additional controller listening for speechToText
  RxBool isListening = false.obs;
  /// additional comments text controller
  TextEditingController additionalTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    enableButton.value = false;

    update();
  }

/// initialize Speech to Text
  void initSpeech() async {
    _speechEnabled.value = await speechToText.value.initialize();
    log(_speechEnabled.value.toString());
    update();
  }

  /// Each time to start a speech recognition session
  void startListening(photoIndex) async {
    log("_startListening");
    questionList[photoIndex].isListening = true;
    questionList.refresh();
    update();
    Future.delayed(const Duration(seconds: 3), () {
      stopListening();
      questionList[photoIndex].isListening = false;
      questionList.refresh();
      update();
    });
    await speechToText.value.listen(onResult: (result) {
      onSpeechResult(result, photoIndex);
    }).catchError((onError) {
      stopListening();
      log(onError);
    });

    update();
  }

  /// Each time to start a speech recognition session for additional controller
  void startListeningAdditional() async {
    isListening.value = true;
    log("_startListening");
    Future.delayed(const Duration(seconds: 3), () {
      stopListening();
      isListening.value = false;
      update();
    });
    await speechToText.value.listen(onResult: (result) {
      model?.comments = result.recognizedWords;
      additionalTextController.text = result.recognizedWords;
    }).catchError((onError) {
      stopListening();
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

  /// This is the callback that the SpeechToText plugin calls when the platform returns recognized words.
  onSpeechResult(SpeechRecognitionResult result, i) {
    log(speechTextResult.value);
    speechTextResult.value = result.recognizedWords;
    questionList[i].explainController!.text = result.recognizedWords;
    questionList[i].details = result.recognizedWords.toString();
    validate();
    update();
  }

/// getting speech text into text field
  void getSpeechResult(controller) {
    controller.text = speechTextResult.value;
    update();
  }

/// Api request for getting Questions Details
  Future<dynamic> getProjectEvaluationQuestionsDetails(jobNumber, categoryName, {var route = Routes.projectEvaluationScreen}) async {

    ProjectEvaluationController controller = Get.find<ProjectEvaluationController>();
    bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
   if(isNetActive){
    var response = await service.getProjectEvaluationQuestions(jobNumber, categoryName);
    if (response != null) {
      if (!response.toString().contains(error)) {
        questionList.clear();
        model = GetProjectEvaluationQuestionsResponse.fromJson(response);
        model?.jobID =controller.jobPhotosModellist.first.jobNumber;
        questionList.value = model!.questionnaireDataList!;
        QuestionsManager manager = QuestionsManager();

        //  Get.toNamed(Routes.ProjectEvaluationDetailsScreen, arguments: projectEvaluationDetialsResponse);

        if (questionList.isNotEmpty) {

          await manager.insertAdditionalInfo(model!);

          for (var i = 0; i<questionList.length; i++) {
            questionList[i].categoryName = categoryName;
            if(questionList[i].detailsRequiredFor!=null){
              if(questionList[i].detailsRequiredFor==true){
                if(questionList[i].answer==true){
                  questionList[i].visible = true;
                }else{
                  questionList[i].visible = false;
                }
              }else{

                if(questionList[i].answer==true){
                  questionList[i].visible = false;
                }else{
                  questionList[i].visible = true;
                }
              }
            }
            manager.insertQuestions(questionList[i]);
          }
          questionList.refresh();
          if(route==Routes.jobPhotosDetailsScreen){
            Get.back();
            Get.back();
            Get.toNamed(Routes.projectEvaluationInstallScreen);
          }else {
            Get.toNamed(Routes.projectEvaluationInstallScreen);
          }
        } else {
          Get.showSnackbar(const GetSnackBar(
            message: noQuestionaire,
            duration: Duration(seconds: 3),));
        }

        update();
      }
    }
    return response;
    }else{
     QuestionsManager manager = QuestionsManager();
      model =  await manager.getModel(categoryName);
     var a =await manager.getCount();
     if(a>0){
       model?.jobID =
           controller.jobPhotosModellist.first.jobNumber.toString();
       model?.questionnaireDataList = await manager.getQuestionsList(categoryName);
       questionList.value = model!.questionnaireDataList!;
     }
     if(route==Routes.jobPhotosDetailsScreen){
       Get.back();
       Get.back();
       Get.toNamed(Routes.projectEvaluationInstallScreen);
     }else {
       Get.toNamed(Routes.projectEvaluationInstallScreen);
     }
   }

  }


/// Api request for submit Questions and answer Details
  Future<dynamic> submitProjectEvaluationQuestionsDetails(context, body, jobNumber) async {
    log(body.toString());
    var response = await service.submitProjectEvaluationQuestions(body);
    if (response != null) {
      if (!response.toString().contains(error)) {
        selectedCat.value = 2;
        update();
        try{
          List<Email> listEmail = await EmailManager().getEmailRecord(jobNumber);
          listEmail.forEach((element) async {

            await EmailManager().updateEmail(element.additionalEmail.toString(), 2);
          });
        }catch(e){

        }

        defaultDialog(context, title:detailsSubmittedSuccessfully,cancelable: false, onTap: (){
          Get.back();
          Get.back();
          ProjectEvaluationController projectEvaluationController = Get.find<ProjectEvaluationController>();
          projectEvaluationController.getProjectEvaluation(jobNumber, false);
          Get.offAndToNamed(Routes.projectEvaluationDetailsScreen);
        });
      }
    }
    return response;
  }

/// Create Json request body for final submit of Questions and answer
  createFinalJson(){
    for(var el in questionList){
      if(!el.visible){
        if(el.explainController!=null) {
          el.explainController!.text = "";
        }
        el.details = "";
      }
    }
    ProjectEvaluationController controller = Get.find<ProjectEvaluationController>();
    model!.questionnaireDataList = questionList;

    QuestionnaireDocument document = QuestionnaireDocument();
    document.showName = controller.jobPhotosModellist.first.showName;
    document.exhibitorName = controller.jobPhotosModellist.first.exhibitorName;
    document.showCity = controller.jobPhotosModellist.first.showCity;
    document.startDate = controller.jobPhotosModellist.first.showStartDate;
    document.endDate = controller.jobPhotosModellist.first.showEndDate;
    document.jobID = controller.jobPhotosModellist.first.jobNumber!;

    RequestModelQuestionarie modelQuestionarie = RequestModelQuestionarie();
    var listt = (controller.emailList.map((e) => e.additionalEmail??"").toList()).join(",");
    modelQuestionarie.additionalEmail = listt;
    modelQuestionarie.categoryDetails = model;
    modelQuestionarie.document = document;
    var map = modelQuestionarie.toJson();
  log("Created map ${map}");
    return map;
  }

/// API request for check that evaluation is already submitted or not
  Future<dynamic> checkEvaluationExistornot(context,jobNumber, categoryName, body) async {

    var response = await service.checkProjectEvaluationQuestions(jobNumber, categoryName);
    if (response != null) {
      if (!response.toString().contains(error)) {
        IsEvaluationExistResponse isEvaluationExistResponse = IsEvaluationExistResponse.fromJson(response);

        if(isEvaluationExistResponse.isExist!){
          sp?.putInt(Preference.ACTIVITY_TRACKER, ((sp?.getInt(Preference.ACTIVITY_TRACKER)??0)+1));
          dialogAction(context, title:anEvaluationHasAlreadyBeenSubmitted+" $jobNumber"+wouldYouLikeToSubmitAgain, onTapNo: (){
            Get.back();
          }, onTapYes: (){
            Get.back();
            submitProjectEvaluationQuestionsDetails(context,body, jobNumber);
          });
        }else{
          dialogAction(context, title:areYouSureSubmitEvaluation,
              onTapNo: (){
            Get.back();

          }, onTapYes: (){
            Get.back();

            submitProjectEvaluationQuestionsDetails(context,body, jobNumber);

          });

        }
      }
    }
    return response;
  }

  /// toggle visibility of Text field for explanation on the basis of validations
  toggleVisibility(index, selected){

      switch(questionList[index].detailsRequiredFor){
        case true:
          if(selected==false){
              questionList[index].visible = false;


          }else{
            questionList[index].visible = true;
          }


          break;
        case false:

          if(selected==false){
            questionList[index].visible = true;
          }else{
            questionList[index].visible = false;
          }
          break;

    }
      enableButton.value = true;
    questionList.refresh();
    update();
  }

  /// Validate form for enable submit button

  validate(){
    for (var element in questionList) {
      if(element.selected== null){

        enableButton.value = false;
        update();
        return false;
      }
      else if(element.visible==true){
        if(element.explainController!.text.toString().isEmpty){

          enableButton.value = false;
          update();
          return false;
        }
      }
    }
    enableButton.value = true;
    update();
    return true;

  }

}

import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/repository/database_model/field_issue_image_model.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/screens/field_issue/view_model/field_issue_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dialogs.dart';
import 'package:on_sight_application/utils/functions/functions.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class PhotoCommentController extends GetxController {

  /// instance of speech to text
  Rx<SpeechToText> speechToText = SpeechToText().obs;

  /// checking speech to text status
  final _speechEnabled = false.obs;

  /// define speech text for using in app
  var speechTextResult = "".obs;

  /// Add Photos button status...........
  RxBool enableButton = true.obs;
  /// Add Comment button status...........
  RxBool commentButton = false.obs;
  /// Listening variable for comment controller
  RxBool isListening = false.obs;

  /// additional comments text controller
  TextEditingController commentController = TextEditingController();

  /// Photo List
  RxList<FieldIssueImageModel> photoList = <FieldIssueImageModel>[].obs;

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
    FieldIssueController controller = Get.find<FieldIssueController>();

    isListening.value = false;
    log(speechTextResult.value);
    speechTextResult.value = result.recognizedWords;
   // jobPhotosList[photoIndex].controller?.text = result.recognizedWords;
    commentController.text = result.recognizedWords;
    commentButton.value = true;
    validate();
    controller.requestModel.value.comment = commentController.text.toString();
    if(commentController.text.isEmpty){
      commentButton.value = false;
    }
    update();
  }

  /// getting speech text into text field
  void getSpeechResult(controller) {
    controller.text = speechTextResult.value;
    update();
  }

  /// Validate comment Field and enable disable button according to it

  validate(){
    if(commentController.text.isEmpty){
      commentButton.value = false;
      update();
      return false;
    }else{
      commentButton.value = true;
      update();
      return true;
    }
  }


/// Final Submit Api invoke through background service for photo module in Field Issue
  submitApi({bool showSnackBar = false}) async{
    FieldIssueController controller = Get.find<FieldIssueController>();
    var service = FlutterBackgroundService();
    service.startService();
    showLoader(Get.context);

    Future.delayed(Duration(seconds: 3),() async {

      Map<String, dynamic> map = HashMap();
      map["request"]= controller.requestModel.toJson();
      map["token"] = sp!.getString(Preference.ACCESS_TOKEN)??"";
      map["imageList"] = photoList.map((val) => val.toMap()).toList();
      print(map);

      service.invoke(fieldIssue, map);
      Get.back();
      AnalyticsFireEvent(FieldIssueCategory, input: {
        field_issue_type: controller.selectedFieldIssue.value.trim(),
        number_name: controller.jobEditingController.text.trim(),
        field_issue_category: controller.fieldIssueChosedCategory.value,
        photo_count: photoList.length.toString(),
        user:(sp?.getString(Preference.FIRST_NAME)??"")/*+"_"+sp?.getString(Preference.LAST_NAME)??""*/
      });
      sp?.putInt(Preference.ACTIVITY_TRACKER, ((sp?.getInt(Preference.ACTIVITY_TRACKER)??0)+1));
      print((sp?.getInt(Preference.ACTIVITY_TRACKER)??0).toString());
      dialogAction(Get.context!, title: doYouWantAddMorePhoto,
                alert:photosSubmittedSuccessfully,
                onTapYes: (){
        commentController.clear();
        controller.requestModel.value.comment = "";
        photoList.clear();
                Get.back();
                Get.back();
                Get.back();
        checkBatteryStatus();
        if (showSnackBar) {
          Get.snackbar(alert, settingsInternetMsg,duration: Duration(seconds: 4));
        }
            }, onTapNo: (){
              Get.offAllNamed(Routes.dashboardScreen);
              if (showSnackBar) {
                Get.snackbar(alert, settingsInternetMsg,duration: Duration(seconds: 4));
              }
              checkBatteryStatus();
                });

    });
  }

}

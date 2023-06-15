

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class DailyTimeController  extends GetxController{

  ///focus node bill of lading
  FocusNode focusBillOfLadding = FocusNode();
  /// bill of lading Controller
  TextEditingController billOfLadingController = TextEditingController();
  /// summary Controller
  TextEditingController summaryController = TextEditingController();
  /// check valid bill of lading parameter
  RxBool isValidBillOfLading = true.obs;
  /// Submit button enable / disable
  RxBool enableButton = false.obs;
  /// checking speech to text status
  final _speechEnabled = false.obs;
  /// instance of speech to text
  Rx<SpeechToText> speechToText = SpeechToText().obs;
  /// Listening variable for comment controller
  RxBool isListening = false.obs;



  @override
  void onInit(){
    super.onInit();
    initSpeech();
  }

  /// TextInput Validations......................................................

  validateFunc(){
    if (billOfLadingController.text.isEmpty) {
      enableButton.value = false;
      update();
      return false;
    } else {
      enableButton.value = true;
    }



    update();
    return true;
  }


  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  onSpeechResult(SpeechRecognitionResult result) {
    isListening.value = false;
    summaryController.text = result.recognizedWords;
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

  /// This has to happen only once per app
  void initSpeech() async {
    _speechEnabled.value = await speechToText.value.initialize();
    update();
  }

}
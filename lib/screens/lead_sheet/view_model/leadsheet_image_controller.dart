import 'dart:developer';
import 'package:get/get.dart';
import 'package:on_sight_application/repository/database_managers/leadsheet_image_manager.dart';
import 'package:on_sight_application/repository/database_model/lead_sheet_image_model.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class LeadSheetImageController extends GetxController {

  /// instance of speech to text
  Rx<SpeechToText> speechToText = SpeechToText().obs;

  /// checking speech to text status
  final _speechEnabled = false.obs;

  /// define speech text for using in app
  var speechTextResult = "".obs;

  /// Add Photos button status...........
  RxBool enableButton = true.obs;

  /// Listening variable for comment controller
  RxBool isListening = false.obs;

  /// Photo List
  RxList<LeadSheetImageModel> photoList = <LeadSheetImageModel>[].obs;

  /// This has to happen only once per app
  void initSpeech() async {
    _speechEnabled.value = await speechToText.value.initialize();
    log(_speechEnabled.value.toString());
    update();
  }



  /// Each time to start a speech recognition session
  void startListening(index) async {
    log("_startListening");
    photoList[index].isListening = true;
    photoList.refresh();
    update();
    Future.delayed(const Duration(seconds: 3), () {
      stopListening();
      photoList[index].isListening = false;
      photoList.refresh();
      update();
    });
    await speechToText.value.listen(onResult: (result) {
      onSpeechResult(result,index);
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

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  onSpeechResult(SpeechRecognitionResult result, index) {
    photoList[index].isListening = false;
    log(speechTextResult.value);
    speechTextResult.value = result.recognizedWords;
   // jobPhotosList[photoIndex].controller?.text = result.recognizedWords;
    photoList[index].controller!.text = result.recognizedWords;
    photoList[index].imageNote = result.recognizedWords;
    photoList.refresh();
    update();
  }

  Future<void> setupData(id, showNumber) async {
    LeadSheetImageManager manager = LeadSheetImageManager();
    photoList.addAll(await manager.getImageByExhibitorIdandShowNumber(id, showNumber));
    photoList.refresh();
    update();
  }

}

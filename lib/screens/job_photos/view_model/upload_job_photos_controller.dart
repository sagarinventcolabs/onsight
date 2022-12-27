import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:on_sight_application/repository/database_managers/image_manager.dart';
import 'package:on_sight_application/repository/database_model/image_model.dart';
import 'package:on_sight_application/screens/job_photos/view_model/job_photos_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:path/path.dart';

class UploadJobPhotosController extends GetxController {
  /// instance of speech to text
  Rx<SpeechToText> speechToText = SpeechToText().obs;

  /// checking speech to text status
  final _speechEnabled = false.obs;

  /// define speech text for using in app
  var speechTextResult = "".obs;

  /// define job photos list
  RxList<ImageModel> jobPhotosList = <ImageModel>[].obs;

  /// Add Photos button status...........
  RxBool enableButton = true.obs;

  /// isListining var
  RxBool isListening = false.obs;

  /// This has to happen only once per app
  void initSpeech() async {
    _speechEnabled.value = await speechToText.value.initialize();
    log(_speechEnabled.value.toString());
    update();
  }



  /// Each time to start a speech recognition session
  void startListening(photoIndex, i) async {
    log("_startListening");

    jobPhotosList[photoIndex].isListening = true;
    jobPhotosList.refresh();
    update();
    Future.delayed(const Duration(seconds: 3), () {
      stopListening();
      jobPhotosList[photoIndex].isListening = false;
      jobPhotosList.refresh();
      update();
    });
    await speechToText.value.listen(onResult: (result) {

      onSpeechResult(result, photoIndex, i);
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
  onSpeechResult(SpeechRecognitionResult result, photoIndex, i) {
    jobPhotosList[photoIndex].isListening = false;
    speechTextResult.value = result.recognizedWords;
    jobPhotosList[photoIndex].controller!.text = "${result.recognizedWords}";
    jobPhotosList[photoIndex].imageNote ="${result.recognizedWords}";
    jobPhotosList.refresh();
    enableButton.value = true;
    update();
  }

  /// getting speech text into text field
  void getSpeechResult(controller) {
    controller.text = speechTextResult.value;
    update();
  }


  Future<String> createFolderInAppDocDir(String folderName) async {
    //Get this App Document Directory

    final Directory appDocDir = await getApplicationDocumentsDirectory();
    //App Document Directory + folder name
    final Directory appDocDirFolder =
    Directory('${appDocDir.path}/$folderName/');

    if (await appDocDirFolder.exists()) {
      //if folder already exists return path
      return appDocDirFolder.path;
    } else {
      //if folder not exists create folder and then return its path
      final Directory appDocDirNewFolder =
      await appDocDirFolder.create(recursive: true);
      return appDocDirNewFolder.path;
    }
  }

  Future<dynamic> saveImage(i, jobNumber) async{
    ImageManager imageManager = ImageManager();
    JobPhotosController controller = Get.find<JobPhotosController>();
    if(controller.categoryList[i].listPhotos!=null){
      if(controller.categoryList[i].listPhotos!.isNotEmpty){
        controller.categoryList[i].listPhotos!.forEach((element) {
          ImageModel imageModel = ImageModel();
          imageModel.categoryId = controller.categoryList[i].id.toString();
          imageModel.categoryName = controller.categoryList[i].name.toString();
          imageModel.jobNumber = jobNumber;
          imageModel.imageName = basename(element.imagePath!);
          imageModel.imageNote = element.imageNote;
          imageModel.imagePath = element.imagePath;
          imageModel.isSubmitted = 0;
          imageManager.insertImage(imageModel);
        });
      }
    }
  }


  Future<void> setupData(id, jobNumber) async {
    ImageManager manager = ImageManager();
    jobPhotosList.addAll(await manager.getImageByCategoryIdandJobNumber(id, jobNumber));
    jobPhotosList.refresh();
    update();
  }

}

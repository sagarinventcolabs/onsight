import 'dart:collection';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/repository/database_managers/image_manager.dart';
import 'package:on_sight_application/repository/database_model/image_model.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/screens/job_photos/view_model/job_photos_controller.dart';
import 'package:on_sight_application/screens/promo_pictures/view_model/promo_pictures_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dialogs.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:path/path.dart';


class UploadPromoPicturesController extends GetxController {
  /// instance of speech to text
  Rx<SpeechToText> speechToText = SpeechToText().obs;

  /// checking speech to text status
  final _speechEnabled = false.obs;

  /// define speech text for using in app
  var speechTextResult = "".obs;


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
    PromoPicturesController controller = Get.find<PromoPicturesController>();
    controller.photoList[photoIndex].isListening = true;
    controller.photoList.refresh();
    update();
    Future.delayed(const Duration(seconds: 3), () {
      stopListening();
      controller.photoList[photoIndex].isListening = false;
      controller.photoList.refresh();
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
    PromoPicturesController controller = Get.find<PromoPicturesController>();

    controller.photoList[photoIndex].isListening = false;
    log(speechTextResult.value);
    speechTextResult.value = result.recognizedWords;
    // promoPicturesPhotosList[photoIndex].controller?.text = result.recognizedWords;
    controller.photoList[photoIndex].controller!.text = result.recognizedWords;
    controller.photoList[photoIndex].imageNote = result.recognizedWords;
    controller.photoList.refresh();
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


  // Future<void> setupData(id, jobNumber) async {
  //   ImageManager manager = ImageManager();
  //   promoPicturesPhotosList.value.addAll(await manager.getImageByCategoryIdandJobNumber(id, jobNumber));
  //   promoPicturesPhotosList.refresh();
  //   update();
  // }


  ///run api for Promo Pictures upload photo
  runApiPromoPicturs(token,i) async {

    var service = FlutterBackgroundService();
    service.startService();
    showLoader(Get.context);


    Future.delayed(Duration(seconds: 5),() async {

      PromoPicturesController controller = Get.find<PromoPicturesController>();
      Map<String, dynamic> map = HashMap();
      map[tokenString] = sp?.getString(Preference.ACCESS_TOKEN)??"";
      dynamic value = controller.photoList.map((element) => element.toMap()).toList();
      map["photoList"] = value;

      service.invoke("promoApi", map);
      controller.photoList.clear();
      controller.selectedShow.value = "";
      controller.showController.clear();
      controller.update();
      controller.refresh();
      Get.back();
      sp?.putInt(Preference.ACTIVITY_TRACKER, ((sp?.getInt(Preference.ACTIVITY_TRACKER)??0)+1));
      print((sp?.getInt(Preference.ACTIVITY_TRACKER)??0).toString());
      dialogAction(Get.context!,alert: photosSubmittedSuccessfully,title: wantToAddMorePhoto,
          onTapNo: (){
        Get.back();
        Get.back();
        checkBatteryStatus();
      },onTapYes: (){
        Get.back();
        showModalBottomSheet(
            backgroundColor: Get.isDarkMode ? ColourConstants.grey900 : ColourConstants.white,
            //backgroundColor: Color.fromARGB(255, 0, 0, 0),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            isScrollControlled: true,
            context: Get.context!,
            builder: (context) =>  bottomSheetImagePickerPromoPictures(Routes.UploadPromoPictureScreen)).then((value) {
          if(controller.photoList.isNotEmpty){
            enableButton.value = true;
          }
          update();
        });
        // checkBatteryStatus();
      });

    });

  }
}

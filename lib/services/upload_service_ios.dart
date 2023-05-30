
import 'dart:convert';
import 'dart:async';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:on_sight_application/repository/database_managers/app_internet_manager.dart';
import 'package:on_sight_application/repository/database_managers/email_manager.dart';
import 'package:on_sight_application/repository/database_managers/image_count_manager.dart';
import 'package:on_sight_application/repository/database_managers/image_manager.dart';
import 'package:on_sight_application/repository/database_model/email.dart';
import 'package:on_sight_application/repository/database_model/image_count.dart';
import 'package:on_sight_application/repository/database_model/image_model.dart';
import 'package:on_sight_application/repository/web_service_response/job_categories_response.dart';
import 'package:on_sight_application/repository/web_services/web_service.dart';
import 'package:on_sight_application/screens/job_photos/model/job_key_model.dart';
import 'package:on_sight_application/screens/job_photos/model/notes_model.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/end_point.dart';
import 'package:on_sight_application/utils/functions/functions.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:uuid/uuid.dart';

Future<void> jobPhotosIos(jobNumber) async{

  var token = sp?.getString(Preference.ACCESS_TOKEN);
  showNotificationUploading();
  AppInternetManager appInternetManager = AppInternetManager();
  var appManager = await appInternetManager.getSettingsTable();
  if (appManager[0]["BatterySaverStatus"] == 1) {
    int? batteryLevel = await Battery().batteryLevel;
    if ((batteryLevel) > 15) {
      jobPhotosSubmethod(token, jobNumber);
    }
    else{
      Timer.periodic(const Duration(minutes: 1), (timer) async {
        batteryLevel = await Battery().batteryLevel;

        debugPrint("Battery Level: ${batteryLevel.toString()}");

        if((batteryLevel??100) > 15){
          jobPhotosIos(jobNumber);
        }
      });
    }
  }else{
    jobPhotosSubmethod(token, jobNumber);
  }
}


jobPhotosSubmethod(token, jobNumber) async {
  ImageManager imageManager = ImageManager();
  List<ImageModel> imageList =
  await imageManager.getImageListByJobNumber(jobNumber);
  if (imageList.isNotEmpty) {
    ImageModel model = imageList.first;
    List<JobCategoriesResponse> listJobCat = [];

    imageList.forEach((element) {
      JobCategoriesResponse responseModel = JobCategoriesResponse();
      responseModel.id = model.categoryId ?? "";
      responseModel.name = model.categoryName ?? "";
      responseModel.listPhotos = [];
      responseModel.listPhotos?.add(element);
      if (element.isEmailRequired == 1) {
        responseModel.sendEmail = true;
      } else {
        responseModel.sendEmail = false;
      }
      listJobCat.add(responseModel);
    });

    print(listJobCat.length);
   List<Email> emailList = await EmailManager().getEmailRecord(jobNumber);

    List<http.MultipartFile> listImage = [];
    List<String> pathList = [];
    List<String> nameList = [];
    final f = DateFormat('MM-dd-yyyy HH:mm:ss');
    var dateTime = await f.format(DateTime.now());
    String emailString =
    await (emailList.map((e) => e.additionalEmail ?? "").toList())
        .join(",");
    JobKeyModel jobKeyModel = JobKeyModel(
        jobNumber: jobNumber.toString(),
        takenDateTime: dateTime,
        additionalEmail: emailString);
    Map<String, String> map = Map();
    map['jobkey'] = await jsonEncode(jobKeyModel);
    print("Map is " + map.toString());

    if (listJobCat.isNotEmpty) {
      for (var k = 0; k < listJobCat.length; k++) {
        var element = listJobCat[k];
        if (element.listPhotos != null) {
          String requestId = await Uuid().v4();
          ImageCount response = await ImageCountManager()
              .getCountByCategoryName(element.id.toString(), jobNumber);
          var count = element.listPhotos!.length;
          if (response.totalImageCountServer != null) {
            count =
                response.totalImageCountServer! + element.listPhotos!.length;
          }

          try {
            for (var l = 0; l < element.listPhotos!.length; l++) {
              var e = element.listPhotos![l];
              NotesModel notesModel = NotesModel(
                  notes: e.imageNote.toString(),
                  categoryName: e.categoryName,
                  categoryId: e.categoryId,
                  imageTotalCount: count.toString(),
                  isEmailRequired: element.sendEmail ?? true,
                  requestId: requestId,
                  isPromoPictures: e.promoFlag == 1 ? true : false);
              var tempName = await e.imageName!.split(".").first;
              map[tempName] = await jsonEncode(notesModel);
              //
              // File image = await File(await createFileFromString(e.imageString));
              // String dirr = await path.dirname(image.path);
              // String newPath = await path.join(dirr,
              //     '${e.imageName}');
              // print('NewPath  At Ios Service Class: ${newPath}');
              // image.renameSync(newPath);
              pathList.add(e.imagePath!);
              nameList.add(e.imageName!);
              // listImage.add(
              //   http.MultipartFile(
              //       'FileName',
              //       File(e.imagePath!).readAsBytes().asStream(),
              //       File(e.imagePath!).lengthSync(),
              //       contentType: MediaType.parse('image/jpeg'),
              //       filename: e.imagePath!.split("/").last),
              // );
            }
          } catch (v) {
            print(v.toString());
            // ImageManager manager = ImageManager();
            // await manager.deleteImage(e.imageName!);
          }
        }
      }
    }
    print("Final Map ${map}");
    List<FileItem> listFileIteem =  [];
    for(var l in pathList){
      print(l);
      listFileIteem.add(FileItem(path: l, field: "FileName"));
    }
    var url = "";
    var a = await AppInternetManager().getSettingsTable() as List;
    if(a.isNotEmpty){
      var flavorr = a[0][flavor]??prod;
      if(flavorr==prod){
        url = EndPoint.uploadCategory;
      }else{
        url = EndPoint.uploadCategoryStage;
      }
    }
    await FlutterUploader().enqueue(
      MultipartFormDataUpload(
        url: url, //required: url to upload to
        files: listFileIteem, // required: list of files that you want to upload
        method: UploadMethod.POST, // HTTP method  (POST or PUT or PATCH)
        headers: {EndPointMessages.AUTHORIZATION_KEY: "${EndPointMessages.BEARER_VALUE} $token"},
        data: map, // any data you want to send in upload request
        tag: 'IOS Upload', // custom tag which is returned in result/progress
      ),
    );
  }


}
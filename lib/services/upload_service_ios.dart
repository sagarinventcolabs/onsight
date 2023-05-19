
import 'dart:collection';
import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http_parser/http_parser.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:on_sight_application/main.dart';
import 'package:on_sight_application/repository/api_base_helper.dart';
import 'package:on_sight_application/repository/database_managers/app_internet_manager.dart';
import 'package:on_sight_application/repository/database_managers/email_manager.dart';
import 'package:on_sight_application/repository/database_managers/image_count_manager.dart';
import 'package:on_sight_application/repository/database_managers/image_manager.dart';
import 'package:on_sight_application/repository/database_model/email.dart';
import 'package:on_sight_application/repository/database_model/image_count.dart';
import 'package:on_sight_application/repository/database_model/image_model.dart';
import 'package:on_sight_application/repository/web_service_response/job_categories_response.dart';
import 'package:on_sight_application/repository/web_service_response/upload_image_response.dart';
import 'package:on_sight_application/repository/web_services/web_service.dart';
import 'package:on_sight_application/screens/job_photos/model/job_key_model.dart';
import 'package:on_sight_application/screens/job_photos/model/notes_model.dart';
import 'package:on_sight_application/utils/connectivity.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/end_point.dart';
import 'package:on_sight_application/utils/functions/functions.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:uuid/uuid.dart';

@pragma('vm:entry-point')
Future<void> jobPhotosIos(service, jobNumber, token) async{

  showNotificationUploading();
  AppInternetManager appInternetManager = AppInternetManager();
  var appManager = await appInternetManager.getSettingsTable();
  if (appManager[0]["BatterySaverStatus"] == 1) {
    int? batteryLevel = await Battery().batteryLevel;
    debugPrint("-->  Battery Level: -->${batteryLevel.toString()}");
    if ((batteryLevel) > 15) {
      jobPhotosSubmethod(service, token, jobNumber);
    }
    else{
      Timer.periodic(const Duration(minutes: 1), (timer) async {
        batteryLevel = await Battery().batteryLevel;

        debugPrint("Battery Level: ${batteryLevel.toString()}");

        if((batteryLevel??100) > 15){
          jobPhotosIos(service, jobNumber, token);
        }
      });
    }
  }else{
    jobPhotosSubmethod(service, token, jobNumber);
  }
}

@pragma('vm:entry-point')
jobPhotosSubmethod(ServiceInstance service, token, jobNumber) async {
  ImageManager imageManager = ImageManager();
//  List<ImageModel> imageList = await imageManager.getImageListByJobNumber(jobNumber);
  print("Image Length is " + imageList.length.toString());
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
    //var jobNumber = model.jobNumber.toString();
    List<Email> emailList = await EmailManager().getEmailRecord(jobNumber);
    debugPrint("-->  Uploading Through Wifi !!  <--");
    WebService webService = WebService();
    //  var response = await webService.iosJobPhotosUploadImage(listJobCat, jobNumber, listEmail, token);

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
              print(e.categoryName);
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
              print("Map with  NotesModel is " + map.toString());
              pathList.add(e.imagePath!);
              nameList.add(e.imageName!);

            //  Uint8List decoded = base64Decode(e.ImageBinary!);
              listImage.add(
                http.MultipartFile(
                    'FileName',
                    File(e.imagePath!).readAsBytes().asStream(),
                    File(e.imagePath!).lengthSync(),
                    contentType: MediaType.parse('image/jpeg'),
                    filename: e.imagePath!.split("/").last),
              );
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

    /*
    const platformChannel = MethodChannel('test.flutter.methodchannel/iOS');
    String _model;
    print(listImage.length);
    print(pathList);

    Map<String, dynamic>  mapWithResponse =  HashMap();
    mapWithResponse["RequestBody"] = map;
   // mapWithResponse["imageList"] = listImage;
    mapWithResponse["pathList"] = pathList;
    print(mapWithResponse);
    try {
      final String result = await platformChannel.invokeMethod('jobPhotoUploads', mapWithResponse);

      // 2
      _model = result;
      print(_model);
      nameList.forEach((element) {
        ImageManager().deleteImage(element);
      });
    } catch (e) {

      // 3
      _model = "Can't fetch the method: '$e'.";
    }
  }
*/



    print("Code at line 188");
    var url = "";
    var a = await AppInternetManager().getSettingsTable() as List;
    if(a.isNotEmpty){
      var flavor = a[0]["Flavor"]??"prod";
      if(flavor=="prod"){
        url = EndPoint.uploadCategory;
      }else{
        url = EndPoint.uploadCategoryStage;
      }
    }
    print(url);
   var response = await ApiBaseHelper().multiPartRequest(url, map, listImage, token);
   log("response is "+response.toString()+"^^");

    try{
      if(response.toString().contains("error")){
      showNotificationFailedJob(service);
      }else{
        print("Upload Success");
          for(var k in imageList){
            if(k.imageName!=null) {
              ImageModel model = await ImageManager().getImageByImageName(
                  k.imageName!);

              model.isSubmitted  =  2;
             await ImageManager().updateImageData(model);
            }

          }

          const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails('channel1', 'channelone',
              channelDescription: 'channelDescription',
              importance: Importance.max,
              priority: Priority.high,
              color: ColourConstants.primary,
              ticker: 'ticker');
          const IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails(
              presentAlert: true, presentBadge: false, presentSound: true);
          const NotificationDetails platformChannelSpecifics =
          NotificationDetails(
              android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);
          await flutterLocalNotificationsPlugin.show(
              10, appName, notificationSuccessMsg,
              platformChannelSpecifics,
              payload: 'item x');

      }
    }catch(e){

    }

    try{
      List<Email> listEmail = await EmailManager().getEmailRecord(jobNumber);
      listEmail.forEach((element) async {
        await EmailManager().updateEmail(element.additionalEmail.toString(), 2);
      });
    }catch(e){

    }

  }
}

Image imageFromBase64String(String base64String) {
  return Image.memory(base64Decode(base64String));
}

Future<dynamic> iosJobPhotosUploadImage(List<JobCategoriesResponse> list, String jobNumber, token ) async {
  List<Email> emailList = await EmailManager().getEmailRecord(jobNumber);
  print("WebService:  iosJobPhotosUploadImage");
  List<http.MultipartFile> listImage = [];
  final f = DateFormat('MM-dd-yyyy HH:mm:ss');
  var dateTime = await f.format(DateTime.now());
  String emailString = await (emailList.map((e) => e.additionalEmail??"").toList()).join(",");
  JobKeyModel jobKeyModel = JobKeyModel(
      jobNumber:jobNumber.toString(),
      takenDateTime: dateTime,
      additionalEmail: emailString
  );
  Map<String, String> map = Map();
  map['jobkey'] = await jsonEncode(jobKeyModel);
  print("Map is "+map.toString());

  if(list.isNotEmpty) {
    for (var k = 0; k < list.length; k++) {
      var element = list[k];
      if (element.listPhotos != null) {
        String requestId = await Uuid().v4();
        ImageCount response = await ImageCountManager()
            .getCountByCategoryName(element.id.toString(), jobNumber);
        var count = element.listPhotos!.length;
        if (response.totalImageCountServer != null) {
          count = response.totalImageCountServer! + element.listPhotos!.length;
        }


        /*   File file = File(e.imagePath!);
              var byte = await file.readAsBytes();
              log(byte);
*/
        // listImage.add(http.MultipartFile.fromBytes('FileName', byte,contentType: MediaType.parse('image/jpeg'),filename: e.imagePath!.split("/").last));

        try {
          for(var l=0; l<element.listPhotos!.length; l++){
            var e = element.listPhotos![l];
            print(e.categoryName);
            NotesModel notesModel = NotesModel(
                notes: e.imageNote.toString(),
                categoryName: e.categoryName,
                categoryId: e.categoryId,
                imageTotalCount: count.toString(),
                isEmailRequired: element.sendEmail ?? true,
                requestId: requestId,
                isPromoPictures: e.promoFlag == 1 ? true : false
            );
            var tempName = await e.imageName!.split(".").first;
            map[tempName] = await jsonEncode(notesModel);
            print("Map with  NotesModel is " + map.toString());
            listImage.add(

              http.MultipartFile(
                  'FileName',
                  File(e.imagePath!).readAsBytes().asStream(),
                  File(e.imagePath!).lengthSync(),
                  contentType: MediaType.parse('image/jpeg'),
                  filename: e.imagePath!.split("/").last),


            );
          }

        } catch (v) {
          print(v.toString());
          // ImageManager manager = ImageManager();
          // await manager.deleteImage(e.imageName!);
        }
      }
    }
  }

  print("Code at line 833");
  log("Map "+map.toString());
  var url = "";
  var a = await AppInternetManager().getSettingsTable() as List;
  if(a.isNotEmpty){
    var flavor = a[0]["Flavor"]??"prod";
    if(flavor=="prod"){
      url = EndPoint.uploadCategory;
    }else{
      url = EndPoint.uploadCategoryStage;
    }
  }
  var response = await ApiBaseHelper().multiPartRequest(url, map, listImage, token);
  log("response is "+response.toString()+"^^");
  try{
    List<Email> listEmail = await EmailManager().getEmailRecord(jobNumber);
    listEmail.forEach((element) async {
      await EmailManager().updateEmail(element.additionalEmail.toString(), 2);
    });
  }catch(e){

  }

  return null;
}
import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'dart:io' show Platform;
import 'package:battery_info/battery_info_plugin.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:on_sight_application/repository/database_managers/app_internet_manager.dart';
import 'package:on_sight_application/repository/database_managers/email_manager.dart';
import 'package:on_sight_application/repository/database_managers/image_manager.dart';
import 'package:on_sight_application/repository/database_managers/leadsheet_image_manager.dart';
import 'package:on_sight_application/repository/database_model/email.dart';
import 'package:on_sight_application/repository/database_model/field_issue_image_model.dart';
import 'package:on_sight_application/repository/database_model/image_model.dart';
import 'package:on_sight_application/repository/database_model/image_model_promo_pictures.dart';
import 'package:on_sight_application/repository/database_model/lead_sheet_image_model.dart';
import 'package:on_sight_application/repository/web_service_requests/save_exhibitor_images_request.dart';
import 'package:on_sight_application/repository/web_service_requests/submit_field_issue_request.dart';
import 'package:on_sight_application/repository/web_service_response/error_response.dart';
import 'package:on_sight_application/repository/web_service_response/job_categories_response.dart';
import 'package:on_sight_application/repository/web_service_response/saveLeadSheetResponse.dart';
import 'package:on_sight_application/repository/web_service_response/upload_image_response.dart';
import 'package:on_sight_application/repository/web_services/web_service.dart';
import 'package:on_sight_application/screens/onboarding/model/onboarding_category_model.dart';
import 'package:on_sight_application/utils/connectivity.dart';
import 'package:on_sight_application/utils/functions/functions.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';


@pragma('vm:entry-point')
Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,
      // auto start service
      autoStart: false,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: false,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
 // service.startService();

}

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch
bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();

  return true;
}


@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {

  List<JobCategoriesResponse> list = [];
  List<Email> emailList = [];
  String JobNumber = "";

  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually


  SharedPreferences preferences = await SharedPreferences.getInstance();
  var token =  await preferences.getString(Preference.ACCESS_TOKEN);

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });


    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('custom').listen((event) async {
    AppInternetManager appInternetManager = AppInternetManager();
    var a = await appInternetManager.getSettingsTable() as List;
    int b = 0;

    if(a.isNotEmpty) {
      debugPrint("Task in progress " + a[0]["TaskInProgress"].toString());
      debugPrint("Task in progress");
      b = a[0]["TaskInProgress"] ?? 0;
    }
    b = b+1;
    await appInternetManager.updateTaskProgress(val: b);
    var aa = await appInternetManager.getSettingsTable();
    debugPrint("Task in progress" + aa[0]["TaskInProgress"].toString());
    debugPrint("custom services started");
    if(event!=null) {
      List<dynamic> listDynamic = event['list'];
      list.clear();
      for(var i=0; i<listDynamic.length; i++){
        list.add(JobCategoriesResponse.fromJson(listDynamic, i));
      }
      JobNumber = event["jobNumber"];
      List<dynamic> listDynamicEmail = event['list'];
      listDynamicEmail = event["emailList"];
      for(var i=0; i<listDynamicEmail.length; i++){
        emailList.add(Email.fromJson(listDynamicEmail[i]));
      }
      var token = event["token"];
      showNotificationUploading();
      runApi(list, JobNumber, emailList, token,event, 0,0, service);

    }
  });




  service.on('failedJobDatabase').listen((event) async {
    debugPrint("FailedJobPhotoMethodCalled");
    AppInternetManager appInternetManager = AppInternetManager();
    var a = await appInternetManager.getSettingsTable() as List;
    int b = 0;

    if(a.isNotEmpty) {
      debugPrint("Task in progress " + a[0]["TaskInProgress"].toString());
      debugPrint("Task in progress");
      b = a[0]["TaskInProgress"] ?? 0;
    }
    b = b+1;
    await appInternetManager.updateTaskProgress(val: b);
    var aa = await appInternetManager.getSettingsTable();
    debugPrint("Task in progress" + aa[0]["TaskInProgress"].toString());
    debugPrint("Failed Job services Database started Failed Job");
    if(event!=null) {

      var token = event["token"];
      showNotificationUploading();
      runApiFromDatabaseMainMethod(service, token);

    }
  });

  service.on('JobPhotosApi').listen((event) async {
    debugPrint("JobPhotoMethodCalled");
    AppInternetManager appInternetManager = AppInternetManager();
    var a = await appInternetManager.getSettingsTable() as List;
    int b = 0;

    if(a.isNotEmpty) {
      debugPrint("Task in progress " + a[0]["TaskInProgress"].toString());
      debugPrint("Task in progress");
      b = a[0]["TaskInProgress"] ?? 0;
    }
    b = b+1;
    await appInternetManager.updateTaskProgress(val: b);
    var aa = await appInternetManager.getSettingsTable();
    debugPrint("Task in progress" + aa[0]["TaskInProgress"].toString());
    debugPrint("Job services Database started Main Method");
    if(event!=null) {

      var token = event["token"];
      showNotificationUploading();
      JobPhotosMainMethod(service, token);

    }
  });

  service.on('leadSheet').listen((event) async {
    AppInternetManager appInternetManager = AppInternetManager();
    var a = await appInternetManager.getSettingsTable();
    int b = 0;

    if(a.isNotEmpty) {
      debugPrint("Task in progress " + a[0]["TaskInProgress"].toString());
      debugPrint("Task in progress");
      b = a[0]["TaskInProgress"] ?? 0;
    }
    b = b+1;
    await appInternetManager.updateTaskProgress(val: b);
    var aa = await appInternetManager.getSettingsTable();
    debugPrint("Task in progress" + aa[0]["TaskInProgress"].toString());

    if(event!=null) {
      SaveExhibitorImagesRequest request2 = SaveExhibitorImagesRequest.fromJson(event['request']);
      var priority = event['isHighPriority'];
      var finalToken = event['token'];

      LeadSheetImageManager leadSheetImageManager = LeadSheetImageManager();
      List<LeadSheetImageModel> finalList = await leadSheetImageManager.getImageByExhibitorIdandShowNumber(request2.exhibitorInput!.exhibitorId.toString(), request2.showNumber.toString());
      showNotificationUploading();
      runApiLeadSheet(request2, finalToken, finalList, 0, priority, service);
    }
  });

  service.on('fieldIssue').listen((event) async {
    AppInternetManager appInternetManager = AppInternetManager();
    var a = await appInternetManager.getSettingsTable();
    int b = 0;

    if(a.isNotEmpty) {
      debugPrint("Task in progress " + a[0]["TaskInProgress"].toString());
      debugPrint("Task in progress");
      b = a[0]["TaskInProgress"] ?? 0;
    }
    b = b+1;
    await appInternetManager.updateTaskProgress(val: b);
    var aa = await appInternetManager.getSettingsTable();
    debugPrint("Task in progress" + aa[0]["TaskInProgress"].toString());
    if(event!=null) {
      SubmitFieldIssueRequest request = SubmitFieldIssueRequest.fromJson(event['request']);
      var finalToken = event['token'];
      List<FieldIssueImageModel> list = (event["imageList"].map((data) => FieldIssueImageModel.fromJson(data)).toList()).cast<FieldIssueImageModel>() ;
      showNotificationUploading();
      runApiFieldIssue(request, finalToken,list);
    }

  });

  service.on('onboarding').listen((event) async {
    AppInternetManager appInternetManager = AppInternetManager();
    var a = await appInternetManager.getSettingsTable();
    int b = 0;

    if(a.isNotEmpty) {
      debugPrint("Task in progress " + a[0]["TaskInProgress"].toString());
      debugPrint("Task in progress");
      b = a[0]["TaskInProgress"] ?? 0;
    }
    b = b+1;
    await appInternetManager.updateTaskProgress(val: b);
    var aa = await appInternetManager.getSettingsTable();
    debugPrint("Task in progress" + aa[0]["TaskInProgress"].toString());
    if(event!=null) {

      var resourceId = event['resourceId'];
      var finalToken = event['token'];
      List<OnBoardingDocumentModel> list = (event["imageList"].map((data) => OnBoardingDocumentModel.fromJson(data)).toList()).cast<OnBoardingDocumentModel>();
      showNotificationUploading();
      runApiOnboarding(resourceId, finalToken,list,0);
    }

  });


  service.on("promoApi").listen((event) async {
    AppInternetManager appInternetManager = AppInternetManager();
    var a = await appInternetManager.getSettingsTable();
    int b = 0;

    if(a.isNotEmpty) {
      debugPrint("Task in progress " + a[0]["TaskInProgress"].toString());
      debugPrint("Task in progress");
      b = a[0]["TaskInProgress"] ?? 0;
    }
    b = b+1;
    await appInternetManager.updateTaskProgress(val: b);
    var aa = await appInternetManager.getSettingsTable();
    debugPrint("Task in progress" + aa[0]["TaskInProgress"].toString());
    List<PromoImageModel> list= (event!["photoList"].map((data) => PromoImageModel.fromJson(data)).toList()).cast<PromoImageModel>();
    debugPrint(list.first.imageNote);
    var token = event["token"];
    showNotificationUploading();
    runApiPromoPicturs(list, token);
  });

  service.on('stopService').listen((event) {

    service.stopSelf();
  });
  // bring to foreground
  /* Timer.periodic(const Duration(seconds: 1), (timer) async {
      final hello = preferences.getString("hello");
      debugPrint(hello);

      if (service is AndroidServiceInstance) {
        service.setForegroundNotificationInfo(
          title: "My App Service",
          content: "Updated at ${DateTime.now()}",
        );
      }

      /// you can see this log in logcat
      debugPrint('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

      // test using external plugin
      final deviceInfo = DeviceInfoPlugin();
      String? device;
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        device = androidInfo.model;
      }

      if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        device = iosInfo.model;
      }

      service.invoke(
        'update',
        {
          "current_date": DateTime.now().toIso8601String(),
          "device": device,
        },
      );
    });*/



  // uploadImg();

    Timer.periodic(const Duration(minutes: 30), (timer) async{
      ImageManager imageManager = ImageManager();
      List<ImageModel>imageList = await imageManager.getFailedImageList();

      if(imageList.isNotEmpty){
        var service = FlutterBackgroundService();

          List<JobCategoriesResponse> listImage = [];

          imageList.forEach((element) {
            JobCategoriesResponse response = JobCategoriesResponse();
            response.id = element.categoryId??"";
            response.name = element.categoryName??"";
            if(listImage.isNotEmpty) {
              for (var j = 0; j < listImage.length; j++) {
                if (listImage[j].id == element.categoryId) {
                  listImage[j].listPhotos?.add(element);
                } else {
                  response.listPhotos = [];
                  response.listPhotos?.add(element);
                  listImage.add(response);
                }
              }
            }else{
              response.listPhotos = [];
              response.listPhotos?.add(element);
              listImage.add(response);
            }

          });
          List<dynamic> listdynamic = [];
          debugPrint("ListLENGTH "+listImage.toString());

          for(var k =0; k<listImage.length; k++){
            listdynamic.add(listImage[k].toJson());
          }


          debugPrint("ListDynamic "+listdynamic.toString());
          service.invoke(
              "failedJob", {
            "list": listdynamic,
            "jobNumber": listImage.first.listPhotos?.first.jobNumber,
            "token": token
          });
      }


    });
}

runApi(List<JobCategoriesResponse> list, JobNumber, emailList, token,event, index, imageIndex, service) async {

  AppInternetManager appInternetManager = AppInternetManager();
  var a = await appInternetManager.getSettingsTable();
  debugPrint("Lower One - BatterySaverStatus From Background Service" + a[0]["BatterySaverStatus"].toString());
  if (a[0]["BatterySaverStatus"] == 1) {
    int? batteryLevel;
    if (Platform.isAndroid) {
      debugPrint("-->  Android Battery Level: -->${(await BatteryInfoPlugin().androidBatteryInfo)?.batteryLevel.toString()??""}");
      batteryLevel = (await BatteryInfoPlugin().androidBatteryInfo)?.batteryLevel;
    }
    else if(Platform.isIOS){
      debugPrint("-->  IOS Battery Level: -->${(await BatteryInfoPlugin().iosBatteryInfo)?.batteryLevel.toString()??""}");
      batteryLevel = (await BatteryInfoPlugin().iosBatteryInfo)?.batteryLevel;
    }
    if ((batteryLevel??100) > 15) {
      runApiSubMethod(list, JobNumber, emailList, token,event, index, imageIndex, service);
    }
    else{
      Timer.periodic(const Duration(seconds: 10), (timer) async {
        if (Platform.isAndroid) {
          debugPrint("Android Battery Level: ${(await BatteryInfoPlugin().androidBatteryInfo)?.batteryLevel.toString()??""}");
          batteryLevel = (await BatteryInfoPlugin().androidBatteryInfo)?.batteryLevel;
        }else if(Platform.isIOS){
          debugPrint("IOS Battery Level: ${(await BatteryInfoPlugin().iosBatteryInfo)?.batteryLevel.toString()??""}");
          batteryLevel = (await BatteryInfoPlugin().iosBatteryInfo)?.batteryLevel;
        }
        if((batteryLevel??100) > 15){
          runApi(list, JobNumber, emailList, token,event, index, imageIndex, service);
        }
      });
    }
  }else{
    runApiSubMethod(list, JobNumber, emailList, token,event, index, imageIndex, service);
  }
}

runApiSubMethod(List<JobCategoriesResponse> list, JobNumber, emailList, token,event, index, imageIndex, service)async{
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.wifi) {
    debugPrint("-->  Uploading Through Wifi !!  <--");
    WebService webService = WebService();
    var response = await webService.submitImages(list, JobNumber, emailList, token, index, imageIndex);
    if(response!=null){
      if(response.toString().contains("error")){
          Timer.periodic(const Duration(seconds: 10), (timer) async {
            bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
            if(isNetActive){
              timer.cancel();
              runApi(list, JobNumber, emailList, token,event, index, imageIndex, service);
            }
          });

  /*      else{
          ImageModel model = ImageModel();
          model =
          await ImageManager().getImageByImageName(
              list[index].listPhotos![imageIndex].imageName!);
          model.isSubmitted = 0;
          await ImageManager().updateImageData(model);
          ErrorResponse errorModel =  ErrorResponse.fromJson(response);
          if(errorModel.errorDescription!=null) {
            showErrorNotification(errorMsg:errorModel.errorDescription.toString());
          }else{
            showErrorNotification(errorMsg:errorModel.Message.toString());
          }
        }*/
      }else{
        if(!response.toString().contains("error")){
          debugPrint("Updating in Database");
          ImageModel model = ImageModel();
          model =
          await ImageManager().getImageByImageName(
              list[index].listPhotos![imageIndex].imageName!);
          model.isSubmitted = 2;
          ImageManager().updateImageData(model);
          imageIndex = imageIndex+1;
          try{
            UploadImageResponse uploadImageResponse = UploadImageResponse.fromJson(response);
            service.invoke("result",{
              "response": uploadImageResponse.toJson()
            });
          }catch(e){

          }
          log(imageIndex.toString());
          log(index.toString());
          if(imageIndex<list[index].listPhotos?.length){

            runApi(list, JobNumber, emailList, token, event, index, imageIndex, service);

          }else{
            index = index + 1;
            try{
              UploadImageResponse uploadImageResponse = UploadImageResponse.fromJson(response);
              service.invoke("result",{
                "response": uploadImageResponse.toJson()
              });
            }catch(e){

            }
            if(index<list.length){
              imageIndex = 0;
              runApi(list, JobNumber, emailList, token, event, index, imageIndex, service);
            }else{
              try{
                UploadImageResponse uploadImageResponse = UploadImageResponse.fromJson(response);
                service.invoke("result",{
                  "response": uploadImageResponse.toJson()
                });
              }catch(e){

              }
              showNotification();
            }
          }
        }
 /*
        else{
          ImageModel model = ImageModel();
          model =
          await ImageManager().getImageByImageName(
              list[index].listPhotos![imageIndex].imageName!);
          model.isSubmitted = 0;
          await ImageManager().updateImageData(model);
          ErrorResponse errorModel =  ErrorResponse.fromJson(response);
          if(errorModel.errorDescription!=null) {
            showErrorNotification(errorMsg:errorModel.errorDescription.toString());
          }else{
            showErrorNotification(errorMsg:errorModel.Message.toString());
          }
        }*/
      }
    }
    else{
      Timer.periodic(const Duration(seconds: 10), (timer) async {
        AppInternetManager appInternetManager = AppInternetManager();
        var a = await appInternetManager.getSettingsTable();
        debugPrint("Lower One - MOBILE_INTERNET_STATUS From Background Service" + a[0]["AppInternetStatus"].toString());
        if(a[0]["AppInternetStatus"] == 1){
          timer.cancel();
          runApi(list, JobNumber, emailList, token,event, index, imageIndex, service);
        }
      });
    }
  }
  else{
    debugPrint("-->  Uploading Through Mobile Internet !!  <--");
    AppInternetManager appInternetManager = AppInternetManager();
    var a = await appInternetManager.getSettingsTable();
    debugPrint("Upper One - MOBILE_INTERNET_STATUS From Background Service" + (a[0]["AppInternetStatus"].toString()));

    if (a[0]["AppInternetStatus"] == 1) {
      WebService webService = WebService();
      var response = await webService.submitImages(list, JobNumber, emailList, token, index, imageIndex);
      if(response!=null){
        if(response.toString().contains("error")){

            Timer.periodic(const Duration(seconds: 10), (timer) async {
              bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
              if(isNetActive){
                timer.cancel();
                runApi(list, JobNumber, emailList, token,event, index, imageIndex, service);
              }
            });


          /*      else{
                  ImageModel model = ImageModel();
                  model =
                  await ImageManager().getImageByImageName(
                      list[index].listPhotos![imageIndex].imageName!);
                  model.isSubmitted = 0;
                  await ImageManager().updateImageData(model);
                  ErrorResponse errorModel =  ErrorResponse.fromJson(response);
                  if(errorModel.errorDescription!=null) {
                    showErrorNotification(errorMsg:errorModel.errorDescription.toString());
                  }else{
                    showErrorNotification(errorMsg:errorModel.Message.toString());
                  }
                }*/

        }else{
          if(!response.toString().contains("error")){
            debugPrint("Updating in Database");
            ImageModel model = ImageModel();
            model =
            await ImageManager().getImageByImageName(
                list[index].listPhotos![imageIndex].imageName!);
            model.isSubmitted = 2;
            await ImageManager().updateImageData(model);
            imageIndex = imageIndex+1;
            try{
              UploadImageResponse uploadImageResponse = UploadImageResponse.fromJson(response);
              service.invoke("result",{
                "response": uploadImageResponse.toJson()
              });
            }catch(e){

            }
            if(imageIndex<list[index].listPhotos?.length){

              runApi(list, JobNumber, emailList, token, event, index, imageIndex, service);

            }else{
              index = index + 1;
              try{
                UploadImageResponse uploadImageResponse = UploadImageResponse.fromJson(response);
                service.invoke("result",{
                  "response": uploadImageResponse.toJson()
                });
              }catch(e){

              }

              if(index<list.length){
                imageIndex = 0;
                runApi(list, JobNumber, emailList, token, event, index, imageIndex, service);
              }else{
                try{
                  UploadImageResponse uploadImageResponse = UploadImageResponse.fromJson(response);
                  service.invoke("result",{
                    "response": uploadImageResponse.toJson()
                  });
                }catch(e){

                }
                showNotification();
              }
            }
          }

        }
      }
      else{
        Timer.periodic(const Duration(seconds: 10), (timer) async {
          AppInternetManager appInternetManager = AppInternetManager();
          var a = await appInternetManager.getSettingsTable();
          debugPrint("Lower One - MOBILE_INTERNET_STATUS From Background Service" + a[0]["AppInternetStatus"].toString());
          if(a[0]["AppInternetStatus"] == 1){
            timer.cancel();
            runApi(list, JobNumber, emailList, token,event, index, imageIndex, service);
          }
        });
      }
     // final internetSpeed = InternetSpeed();

    }
    else{
      Timer.periodic(
          const Duration(seconds : 10), (timer)async {
        AppInternetManager appInternetManager = AppInternetManager();
        var a = await appInternetManager.getSettingsTable();
        debugPrint("Lower One - MOBILE_INTERNET_STATUS From Background Service" +
            a[0]["AppInternetStatus"].toString());
        if (a[0]["AppInternetStatus"] == 1) {
          timer.cancel();
          runApi(list, JobNumber, emailList, token, event, index, imageIndex, service);
        }
      });
    }
  }
}


runApiLeadSheet(SaveExhibitorImagesRequest request, finalToken, List<LeadSheetImageModel> list, index, priority, service) async {

  AppInternetManager appInternetManager = AppInternetManager();
  var a = await appInternetManager.getSettingsTable();
  debugPrint("Lower One - BatterySaverStatus From Background Service" + a[0]["BatterySaverStatus"].toString());
  if (a[0]["BatterySaverStatus"] == 1) {
    int? batteryLevel;
    if (Platform.isAndroid) {
      debugPrint("-->  Android Battery Level: -->${(await BatteryInfoPlugin().androidBatteryInfo)?.batteryLevel.toString()??""}");
      batteryLevel = (await BatteryInfoPlugin().androidBatteryInfo)?.batteryLevel;
    }else if(Platform.isIOS){
      debugPrint("-->  IOS Battery Level: -->${(await BatteryInfoPlugin().iosBatteryInfo)?.batteryLevel.toString()??""}");
      batteryLevel = (await BatteryInfoPlugin().iosBatteryInfo)?.batteryLevel;
    }
    if ((batteryLevel??100) > 15) {
      runApiLeadSheetSubMethod(request, finalToken, list, index, priority, service);
    }
    else{
      Timer.periodic(const Duration(seconds: 10), (timer) async {
        if (Platform.isAndroid) {
          debugPrint("-->  Android Battery Level: -->${(await BatteryInfoPlugin().androidBatteryInfo)?.batteryLevel.toString()??""}");
          batteryLevel = (await BatteryInfoPlugin().androidBatteryInfo)?.batteryLevel;
        }else if(Platform.isIOS){
          debugPrint("-->  IOS Battery Level: -->${(await BatteryInfoPlugin().iosBatteryInfo)?.batteryLevel.toString()??""}");
          batteryLevel = (await BatteryInfoPlugin().iosBatteryInfo)?.batteryLevel;
        }
        if((batteryLevel??100) > 15){
          runApiLeadSheet(request, finalToken, list, index, priority, service);
        }
      });
    }
  }else{
    runApiLeadSheetSubMethod(request, finalToken, list, index, priority, service);
  }
}

runApiLeadSheetSubMethod(SaveExhibitorImagesRequest request, finalToken, List<LeadSheetImageModel> list, index, priority, service)async{

  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.wifi) {

    debugPrint("-->  Uploading Through Wifi !!  <--");
    WebService webService = WebService();
    await webService.submitImagesLeadSheet(request, list[index], finalToken, priority).then((value) async {
      if(value.toString().contains("error")){

          Timer.periodic(const Duration(seconds: 10), (timer) async {
            bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
            isNetActive = await ConnectionStatus.getInstance().checkConnection();
            if (isNetActive) {
              timer.cancel();
              runApiLeadSheet(request, finalToken, list, index, priority, service);
            }
          });


      }
      else{
        try{
          SaveLeadSheetResponse saveLeadSheetResponse = SaveLeadSheetResponse.fromJson(value);
          service.invoke("result",{
            "response": saveLeadSheetResponse.toJson()
          });
        }catch(c){

        }

        LeadSheetImageManager manager = LeadSheetImageManager();
        LeadSheetImageModel model = list[index];
        model.isSubmitted = 1;
        manager.updateImageData(model);
        index = index+1;
        if(list.length>index){
          runApiLeadSheet(request, finalToken, list, index, priority, service);
        }else{
          showNotification();
        }
      }
    });
  }
  else{
    debugPrint("-->  Uploading Through Mobile Internet !!  <--");
    AppInternetManager appInternetManager = AppInternetManager();
    var a = await appInternetManager.getSettingsTable() as List;
    debugPrint("Upper One - MOBILE_INTERNET_STATUS From Background Service" + (a[0]["AppInternetStatus"].toString()));
    if (a.isNotEmpty) {
      if (a[0]["AppInternetStatus"] == 1) {

        WebService webService = WebService();
        await webService.submitImagesLeadSheet(request, list[index], finalToken, priority).then((value) async {
          if(value.toString().contains("error")){

              Timer.periodic(const Duration(seconds: 10), (timer) async {
                bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
                isNetActive = await ConnectionStatus.getInstance().checkConnection();
                if (isNetActive) {
                  timer.cancel();
                  runApiLeadSheet(request, finalToken, list, index, priority, service);
                }
              });


          }
          else{
            try{
              SaveLeadSheetResponse saveLeadSheetResponse = SaveLeadSheetResponse.fromJson(value);
              service.invoke("result",{
                "response": saveLeadSheetResponse.toJson()
              });
            }catch(e){

            }

            LeadSheetImageManager manager = LeadSheetImageManager();
            LeadSheetImageModel model = list[index];
            model.isSubmitted = 1;
            manager.updateImageData(model);
            index = index+1;

            if(list.length>index){
              runApiLeadSheet(request, finalToken, list, index, priority, service);
            }else{
              showNotification();
            }
          }
        });
      }else{
        Timer.periodic(const Duration(seconds: 10), (timer) async {
          AppInternetManager appInternetManager = AppInternetManager();
          var a = await appInternetManager.getSettingsTable() as List;
          debugPrint("Lower One - MOBILE_INTERNET_STATUS From Background Service" + a[0]["AppInternetStatus"].toString());
          if (a.isNotEmpty) {
            if(a[0]["AppInternetStatus"] == 1){
              timer.cancel();
              runApiLeadSheet(request, finalToken, list, index, priority, service);
            }
          }
        });
      }
    }
  }
}

runApiFieldIssue(SubmitFieldIssueRequest request, finalToken, List<FieldIssueImageModel> list )async {
  AppInternetManager appInternetManager = AppInternetManager();
  var a = await appInternetManager.getSettingsTable();
  debugPrint("Lower One - BatterySaverStatus From Background Service" + a[0]["BatterySaverStatus"].toString());
  if (a[0]["BatterySaverStatus"] == 1) {
    int? batteryLevel;
    if (Platform.isAndroid) {
      debugPrint("-->  Android Battery Level: -->${(await BatteryInfoPlugin().androidBatteryInfo)?.batteryLevel.toString()??""}");
      batteryLevel = (await BatteryInfoPlugin().androidBatteryInfo)?.batteryLevel;
    }
    else if(Platform.isIOS){
      debugPrint("-->  IOS Battery Level: -->${(await BatteryInfoPlugin().iosBatteryInfo)?.batteryLevel.toString()??""}");
      batteryLevel = (await BatteryInfoPlugin().iosBatteryInfo)?.batteryLevel;
    }
    if ((batteryLevel??100) > 15) {
      fieldIssueSubMethod(request, finalToken, list);
    }else{
      Timer.periodic(Duration(seconds: 10),(timer) async {
        if (Platform.isAndroid) {
          debugPrint("-->  Android Battery Level: -->${(await BatteryInfoPlugin().androidBatteryInfo)?.batteryLevel.toString()??""}");
          batteryLevel = (await BatteryInfoPlugin().androidBatteryInfo)?.batteryLevel;
        }else if(Platform.isIOS){
        debugPrint("-->  IOS Battery Level: -->${(await BatteryInfoPlugin().iosBatteryInfo)?.batteryLevel.toString()??""}");
        batteryLevel = (await BatteryInfoPlugin().iosBatteryInfo)?.batteryLevel;
        }
        if ((batteryLevel??100) > 15) {
          runApiFieldIssue(request, finalToken, list);
        }
      },
      );
    }
  }
  else{
    fieldIssueSubMethod(request, finalToken, list);
  }
}

fieldIssueSubMethod(SubmitFieldIssueRequest request, finalToken, List<FieldIssueImageModel> list)async{
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.wifi) {
    WebService webService = WebService();
    await webService.submitImagesFieldIssue(request, list, finalToken).then((value) async {

      if (!value.toString().contains("incidentid")) {
        bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
        if (isNetActive) {
          debugPrint("Error Notification");
          showErrorNotification(errorMsg: value["error"]);
        } else {
          Timer.periodic(const Duration(seconds: 10), (timer) async {
            isNetActive =
            await ConnectionStatus.getInstance().checkConnection();
            if (isNetActive) {
              timer.cancel();
              runApiFieldIssue(request, finalToken, list);
            }
          });
        }
      }
      else {
        /* FlutterBackgroundService().invoke("response",{
          "response":value.toString()
        });*/
        showNotification();
        //  FlutterBackgroundService().invoke("stopService");
      }
    });
  }
  else {
    AppInternetManager appInternetManager = AppInternetManager();
    var a = await appInternetManager.getSettingsTable() as List;
    debugPrint("Upper One - MOBILE_INTERNET_STATUS From Background Service" + (a[0]["AppInternetStatus"].toString()));
    if (a.isNotEmpty) {
      if (a[0]["AppInternetStatus"] == 1) {

        WebService webService = WebService();
        await webService.submitImagesFieldIssue(request, list, finalToken).then((value) async {
          if (!value.toString().contains("incidentid")) {
            bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
            if (isNetActive) {
              debugPrint("Error Notification");
              showErrorNotification(errorMsg: value["error"]);
            } else {
              Timer.periodic(const Duration(seconds: 10), (timer) async {
                isNetActive = await ConnectionStatus.getInstance()
                    .checkConnection();
                if (isNetActive) {
                  timer.cancel();
                  runApiFieldIssue(request, finalToken, list);
                }
              });
            }
          }
          else {
            /*     FlutterBackgroundService().invoke("response",{
                    "response":value.toString()
                  });*/
            showNotification();
            //   FlutterBackgroundService().invoke("stopService");
          }
        });
      } else {
        Timer.periodic(const Duration(seconds: 10), (timer) async {
          AppInternetManager appInternetManager = AppInternetManager();
          var a = await appInternetManager.getSettingsTable() as List;
          debugPrint("Lower One - MOBILE_INTERNET_STATUS From Background Service" +
              a[0]["AppInternetStatus"].toString());
          if (a.isNotEmpty) {
            if (a[0]["AppInternetStatus"] == 1) {
              timer.cancel();
              runApiFieldIssue(request, finalToken, list);
            }
          }
        });
      }
    }
  }
}

///run api for onboarding upload photo
runApiOnboarding(resourceId, finalToken, list,i) async {

  WebService webService = WebService();
  if(list[i].image!.isNotEmpty) {
    dynamic response = await webService.submitImagesOnboarding(
        list[i].image!,list[i].category, resourceId, finalToken);
    debugPrint("Response is "+response.toString()+"");
    if(response==null){
      list[i].image!.clear();
      i = i+1;
      if(i<list.length){

        runApiOnboarding(resourceId, finalToken, list,i);
      }else{
        showNotification();


      }
    }else{

    }
  }else{
    i = i+1;
    if(i<list.length) {
      runApiOnboarding(resourceId, finalToken, list,i);
    }else{
      showNotification();
    }
  }
}


///run api for Promo Pictures upload photo
runApiPromoPicturs(photoList, token) async {
  AppInternetManager appInternetManager = AppInternetManager();
  var a = await appInternetManager.getSettingsTable();
  debugPrint("Lower One - BatterySaverStatus From Background Service" + a[0]["BatterySaverStatus"].toString());
  if (a[0]["BatterySaverStatus"] == 1) {
    int? batteryLevel;
    if (Platform.isAndroid) {
      debugPrint("-->  Android Battery Level: -->${(await BatteryInfoPlugin().androidBatteryInfo)?.batteryLevel.toString()??""}");
      batteryLevel = (await BatteryInfoPlugin().androidBatteryInfo)?.batteryLevel;
    }
    else if(Platform.isIOS){
      debugPrint("-->  IOS Battery Level: -->${(await BatteryInfoPlugin().iosBatteryInfo)?.batteryLevel.toString()??""}");
      batteryLevel = (await BatteryInfoPlugin().iosBatteryInfo)?.batteryLevel;
    }
    if ((batteryLevel??100) > 15) {
      promoPictureSubMethod(photoList, token);
    }else{
      Timer.periodic(Duration(seconds: 10),(timer) async {
        if (Platform.isAndroid) {
          debugPrint("-->  Android Battery Level: -->${(await BatteryInfoPlugin().androidBatteryInfo)?.batteryLevel.toString()??""}");
          batteryLevel = (await BatteryInfoPlugin().androidBatteryInfo)?.batteryLevel;
        }else if(Platform.isIOS){
          debugPrint("-->  IOS Battery Level: -->${(await BatteryInfoPlugin().iosBatteryInfo)?.batteryLevel.toString()??""}");
          batteryLevel = (await BatteryInfoPlugin().iosBatteryInfo)?.batteryLevel;
        }
        if ((batteryLevel??100) > 15) {
          promoPictureSubMethod(photoList, token);
        }
      },
      );
    }
  }else{
    promoPictureSubMethod(photoList, token);
  }
}

promoPictureSubMethod(photoList, token) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.wifi) {
    debugPrint("-->  Uploading Through Wifi !!  <--");

    WebService webService = WebService();
    if(photoList.isNotEmpty) {
      dynamic response = await webService.submitImagesPromoPictures(photoList, token);
      debugPrint("Response is "+response.toString()+"");
      if(response=="200"){
        photoList.clear();
        showNotification();
      }else{
        bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
        if (isNetActive) {
          debugPrint("Error Notification");
          ErrorResponse errorModel =  ErrorResponse.fromJson(response);
          if(errorModel.errorDescription!=null) {
            showErrorNotification(errorMsg:errorModel.errorDescription.toString());
          }else{
            showErrorNotification(errorMsg:errorModel.Message.toString());
          }
        } else {
          Timer.periodic(const Duration(seconds: 10), (timer) async {
            isNetActive = await ConnectionStatus.getInstance()
                .checkConnection();
            if (isNetActive) {
              timer.cancel();
              promoPictureSubMethod(photoList, token);
            }
          });
        }
      }
    }
  }else{
    debugPrint("-->  Uploading Through Mobile Internet !!  <--");
    AppInternetManager appInternetManager = AppInternetManager();
    var a = await appInternetManager.getSettingsTable() as List;
    debugPrint("Upper One - MOBILE_INTERNET_STATUS From Background Service" + (a[0]["AppInternetStatus"].toString()));
    if(a[0]["AppInternetStatus"] == 1){
      WebService webService = WebService();
      if(photoList.isNotEmpty) {
        dynamic response = await webService.submitImagesPromoPictures(photoList, token);
        debugPrint("Response is "+response.toString()+"");
        if(response=="200"){
          photoList.clear();
          showNotification();
        }else{
          bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
          if (isNetActive) {
            debugPrint("Error Notification");
            ErrorResponse errorModel =  ErrorResponse.fromJson(response);
            if(errorModel.errorDescription!=null) {
              showErrorNotification(errorMsg:errorModel.errorDescription.toString());
            }else{
              showErrorNotification(errorMsg:errorModel.Message.toString());
            }
          } else {
            Timer.periodic(const Duration(seconds: 10), (timer) async {
              isNetActive = await ConnectionStatus.getInstance()
                  .checkConnection();
              if (isNetActive) {
                timer.cancel();
                promoPictureSubMethod(photoList, token);
              }
            });
          }
        }
      }
    }else{
      Timer.periodic(const Duration(seconds: 10), (timer) async {
        AppInternetManager appInternetManager = AppInternetManager();
        var a = await appInternetManager.getSettingsTable() as List;
        debugPrint("Lower One - MOBILE_INTERNET_STATUS From Background Service" + a[0]["AppInternetStatus"].toString());
        if (a.isNotEmpty) {
          if(a[0]["AppInternetStatus"] == 1){
            timer.cancel();
            runApiPromoPicturs(photoList, token);
          }
        }
      },
      );
    }
  }
}
runApiFromDatabaseMainMethod(service, token) async {

  AppInternetManager appInternetManager = AppInternetManager();
  var a = await appInternetManager.getSettingsTable();
  debugPrint("Lower One - BatterySaverStatus From Background Service" + a[0]["BatterySaverStatus"].toString());
  if (a[0]["BatterySaverStatus"] == 1) {
    int? batteryLevel;
    if (Platform.isAndroid) {
      debugPrint("-->  Android Battery Level: -->${(await BatteryInfoPlugin().androidBatteryInfo)?.batteryLevel.toString()??""}");
      batteryLevel = (await BatteryInfoPlugin().androidBatteryInfo)?.batteryLevel;
    }
    else if(Platform.isIOS){
      debugPrint("-->  IOS Battery Level: -->${(await BatteryInfoPlugin().iosBatteryInfo)?.batteryLevel.toString()??""}");
      batteryLevel = (await BatteryInfoPlugin().iosBatteryInfo)?.batteryLevel;
    }
    if ((batteryLevel??100) > 15) {
      runApiFromDatabaseJobPhotos(service, token);
    }
    else{
      Timer.periodic(const Duration(seconds: 10), (timer) async {
        if (Platform.isAndroid) {
          debugPrint("Android Battery Level: ${(await BatteryInfoPlugin().androidBatteryInfo)?.batteryLevel.toString()??""}");
          batteryLevel = (await BatteryInfoPlugin().androidBatteryInfo)?.batteryLevel;
        }else if(Platform.isIOS){
          debugPrint("IOS Battery Level: ${(await BatteryInfoPlugin().iosBatteryInfo)?.batteryLevel.toString()??""}");
          batteryLevel = (await BatteryInfoPlugin().iosBatteryInfo)?.batteryLevel;
        }
        if((batteryLevel??100) > 15){
          runApiFromDatabaseMainMethod(service, token);
        }
      });
    }
  }else{
    runApiFromDatabaseJobPhotos(service, token);
  }
}


runApiFromDatabaseJobPhotos(service, token)async{
  ImageManager imageManager = ImageManager();
  List<ImageModel>imageList = await imageManager.getFailedImageList();
  debugPrint("Image List length" + imageList.length.toString());

  if(imageList.isNotEmpty) {
    ImageModel model = imageList.first;
    JobCategoriesResponse responseModel = JobCategoriesResponse();
    responseModel.id = model.categoryId??"";
    responseModel.name = model.categoryName??"";
    responseModel.listPhotos = [];
    responseModel.listPhotos?.add(model);
    var jobNumber = model.jobNumber.toString();
    List<Email> listEmail = await EmailManager().getEmailRecord(jobNumber);
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi) {
      debugPrint("-->  Uploading Through Wifi !!  <--");
      WebService webService = WebService();
      var response = await webService.submitImagesFromDatabase(responseModel, jobNumber, listEmail, token);
      if(response!=null){
        if(response.toString().contains("error")){
          bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
          if(!isNetActive){
            Timer.periodic(const Duration(seconds: 10), (timer) async {
              bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
              if(isNetActive){
                timer.cancel();
                runApiFromDatabaseMainMethod(service, token);
              }
            });
          }else{
            FlutterBackgroundService().invoke("stopService");

          }
          /*      else{
          ImageModel model = ImageModel();
          model =
          await ImageManager().getImageByImageName(
              list[index].listPhotos![imageIndex].imageName!);
          model.isSubmitted = 0;
          await ImageManager().updateImageData(model);
          ErrorResponse errorModel =  ErrorResponse.fromJson(response);
          if(errorModel.errorDescription!=null) {
            showErrorNotification(errorMsg:errorModel.errorDescription.toString());
          }else{
            showErrorNotification(errorMsg:errorModel.Message.toString());
          }
        }*/
        }else{
          if(!response.toString().contains("error")){
            debugPrint("Updating in Database");

            model.isSubmitted = 2;
            ImageManager().updateImageData(model);

            try{
              UploadImageResponse uploadImageResponse = UploadImageResponse.fromJson(response);
              service.invoke("result",{
                "response": uploadImageResponse.toJson()
              });
            }catch(e){

            }


              runApiFromDatabaseMainMethod(service, token);


          }
          /*
        else{
          ImageModel model = ImageModel();
          model =
          await ImageManager().getImageByImageName(
              list[index].listPhotos![imageIndex].imageName!);
          model.isSubmitted = 0;
          await ImageManager().updateImageData(model);
          ErrorResponse errorModel =  ErrorResponse.fromJson(response);
          if(errorModel.errorDescription!=null) {
            showErrorNotification(errorMsg:errorModel.errorDescription.toString());
          }else{
            showErrorNotification(errorMsg:errorModel.Message.toString());
          }
        }*/
        }
      }
      else{
        Timer.periodic(const Duration(seconds: 10), (timer) async {
          AppInternetManager appInternetManager = AppInternetManager();
          var a = await appInternetManager.getSettingsTable();
          debugPrint("Lower One - MOBILE_INTERNET_STATUS From Background Service" + a[0]["AppInternetStatus"].toString());
          if(a[0]["AppInternetStatus"] == 1){
            timer.cancel();
            runApiFromDatabaseMainMethod(service, token);
          }
        });
      }
    }
    else{
      debugPrint("-->  Uploading Through Mobile Internet !!  <--");
      AppInternetManager appInternetManager = AppInternetManager();
      var a = await appInternetManager.getSettingsTable();
      debugPrint("Upper One - MOBILE_INTERNET_STATUS From Background Service" + (a[0]["AppInternetStatus"].toString()));

      if (a[0]["AppInternetStatus"] == 1) {
        WebService webService = WebService();
        var response = await webService.submitImagesFromDatabase(responseModel, jobNumber, listEmail, token);
        if(response!=null){
          if(response.toString().contains("error")){
            if(!response.toString().contains("Something went wrong")) {
              Timer.periodic(const Duration(seconds: 10), (timer) async {
                bool isNetActive = await ConnectionStatus.getInstance()
                    .checkConnection();
                if (isNetActive) {
                  timer.cancel();
                  runApiFromDatabaseMainMethod(service, token);
                }
              });
            }else{
              FlutterBackgroundService().invoke("stopService");

            }

            /*      else{
                  ImageModel model = ImageModel();
                  model =
                  await ImageManager().getImageByImageName(
                      list[index].listPhotos![imageIndex].imageName!);
                  model.isSubmitted = 0;
                  await ImageManager().updateImageData(model);
                  ErrorResponse errorModel =  ErrorResponse.fromJson(response);
                  if(errorModel.errorDescription!=null) {
                    showErrorNotification(errorMsg:errorModel.errorDescription.toString());
                  }else{
                    showErrorNotification(errorMsg:errorModel.Message.toString());
                  }
                }*/

          }else{
            if(!response.toString().contains("error")){

              model.isSubmitted = 2;
              await ImageManager().updateImageData(model);
              try{
                UploadImageResponse uploadImageResponse = UploadImageResponse.fromJson(response);
                service.invoke("result",{
                  "response": uploadImageResponse.toJson()
                });
              }catch(e){

              }

                runApiFromDatabaseMainMethod(service, token);


            }
            /*        else{
                  ImageModel model = ImageModel();
                  model =
                  await ImageManager().getImageByImageName(
                      list[index].listPhotos![imageIndex].imageName!);
                  model.isSubmitted = 0;
                  await ImageManager().updateImageData(model);
                  ErrorResponse errorModel =  ErrorResponse.fromJson(response);
                  if(errorModel.errorDescription!=null) {
                    showErrorNotification(errorMsg:errorModel.errorDescription.toString());
                  }else{
                    showErrorNotification(errorMsg:errorModel.Message.toString());
                  }
                }*/
          }
        }
        else{
          Timer.periodic(const Duration(seconds: 10), (timer) async {
            AppInternetManager appInternetManager = AppInternetManager();
            var a = await appInternetManager.getSettingsTable();
            debugPrint("Lower One - MOBILE_INTERNET_STATUS From Background Service" + a[0]["AppInternetStatus"].toString());
            if(a[0]["AppInternetStatus"] == 1){
              timer.cancel();
              runApiFromDatabaseMainMethod(service, token);
            }
          });
        }
        // final internetSpeed = InternetSpeed();
        // debugPrint("!!!Checking Internet Speed!!!");
/*      internetSpeed.startUploadTesting(
        fileSize: 10000,
        onDone: (double transferRate, SpeedUnit unit) async {
          debugPrint('the final transfer rate ---> $transferRate, and unit  --> ${unit.name}');
          if(transferRate > 0.005){

          }else{
            runApi(list, JobNumber, emailList, token,event, index, imageIndex, service);
          }
        },
        onProgress: (double percent, double transferRate, SpeedUnit unit) {
          debugPrint('continues transferring rate --> $transferRate, and percent  --> $percent, and unit  --> ${unit.name}');
        },
        onError: (String errorMessage, String speedTestError) {
          debugPrint('Error ---> $speedTestError');
          runApi(list, JobNumber, emailList, token,event, index, imageIndex, service);
        },
      );*/
      }
      else{
        Timer.periodic(
            const Duration(seconds : 10), (timer)async {
          AppInternetManager appInternetManager = AppInternetManager();
          var a = await appInternetManager.getSettingsTable();
          debugPrint("Lower One - MOBILE_INTERNET_STATUS From Background Service" +
              a[0]["AppInternetStatus"].toString());
          if (a[0]["AppInternetStatus"] == 1) {
            timer.cancel();
            runApiFromDatabaseMainMethod(service, token);
          }
        });
      }
    }
  }else{
    showNotificationFailedJob();
  }
}


JobPhotosMainMethod(service, token) async {
    debugPrint("Code JobPhotosMainMethod");
  AppInternetManager appInternetManager = AppInternetManager();
  var a = await appInternetManager.getSettingsTable();
  debugPrint("Lower One - BatterySaverStatus From Background Service" + a[0]["BatterySaverStatus"].toString());
  if (a[0]["BatterySaverStatus"] == 1) {
    int? batteryLevel;
    if (Platform.isAndroid) {
      debugPrint("-->  Android Battery Level: -->${(await BatteryInfoPlugin().androidBatteryInfo)?.batteryLevel.toString()??""}");
      batteryLevel = (await BatteryInfoPlugin().androidBatteryInfo)?.batteryLevel;
    }
    else if(Platform.isIOS){
      debugPrint("-->  IOS Battery Level: -->${(await BatteryInfoPlugin().iosBatteryInfo)?.batteryLevel.toString()??""}");
      batteryLevel = (await BatteryInfoPlugin().iosBatteryInfo)?.batteryLevel;
    }
    if ((batteryLevel??100) > 15) {
      JobPhotosSubmethod(service, token);
    }
    else{
      Timer.periodic(const Duration(seconds: 10), (timer) async {
        if (Platform.isAndroid) {
          debugPrint("Android Battery Level: ${(await BatteryInfoPlugin().androidBatteryInfo)?.batteryLevel.toString()??""}");
          batteryLevel = (await BatteryInfoPlugin().androidBatteryInfo)?.batteryLevel;
        }else if(Platform.isIOS){
          debugPrint("IOS Battery Level: ${(await BatteryInfoPlugin().iosBatteryInfo)?.batteryLevel.toString()??""}");
          batteryLevel = (await BatteryInfoPlugin().iosBatteryInfo)?.batteryLevel;
        }
        if((batteryLevel??100) > 15){
          JobPhotosMainMethod(service, token);
        }
      });
    }
  }else{
    JobPhotosSubmethod(service, token);
  }
}


JobPhotosSubmethod(service, token)async{
  ImageManager imageManager = ImageManager();
  List<ImageModel>imageList = await imageManager.getFailedImageList();
  debugPrint("Image List length" + imageList.length.toString());
  if(imageList.isNotEmpty) {
    ImageModel model = imageList.first;
    JobCategoriesResponse responseModel = JobCategoriesResponse();
    responseModel.id = model.categoryId??"";
    responseModel.name = model.categoryName??"";
    responseModel.listPhotos = [];
    responseModel.listPhotos?.add(model);
    if(model.isEmailRequired==1){
      responseModel.sendEmail = true;
    }else{
      responseModel.sendEmail = false;
    }
    var jobNumber = model.jobNumber.toString();
    List<Email> listEmail = await EmailManager().getEmailRecord(jobNumber);
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi) {
      debugPrint("-->  Uploading Through Wifi !!  <--");
      WebService webService = WebService();
      var response = await webService.submitImagesFromDatabase(responseModel, jobNumber, listEmail, token);
      if(response!=null){
        if(response.toString().contains("error")){
            if(!response.toString().contains("Something went wrong")) {
              Timer.periodic(const Duration(seconds: 10), (timer) async {
                bool isNetActive = await ConnectionStatus.getInstance()
                    .checkConnection();
                if (isNetActive) {
                  timer.cancel();
                  JobPhotosMainMethod(service, token);
                }
              });
            }else{
              FlutterBackgroundService().invoke("stopService");

            }

          /*      else{
          ImageModel model = ImageModel();
          model =
          await ImageManager().getImageByImageName(
              list[index].listPhotos![imageIndex].imageName!);
          model.isSubmitted = 0;
          await ImageManager().updateImageData(model);
          ErrorResponse errorModel =  ErrorResponse.fromJson(response);
          if(errorModel.errorDescription!=null) {
            showErrorNotification(errorMsg:errorModel.errorDescription.toString());
          }else{
            showErrorNotification(errorMsg:errorModel.Message.toString());
          }
        }*/
        }else{
          if(!response.toString().contains("error")){
            debugPrint("Updating in Database");

            model.isSubmitted = 2;
            ImageManager().updateImageData(model);

            try{
              UploadImageResponse uploadImageResponse = UploadImageResponse.fromJson(response);
              service.invoke("result",{
                "response": uploadImageResponse.toJson()
              });
            }catch(e){

            }


            JobPhotosMainMethod(service, token);


          }
          /*
        else{
          ImageModel model = ImageModel();
          model =
          await ImageManager().getImageByImageName(
              list[index].listPhotos![imageIndex].imageName!);
          model.isSubmitted = 0;
          await ImageManager().updateImageData(model);
          ErrorResponse errorModel =  ErrorResponse.fromJson(response);
          if(errorModel.errorDescription!=null) {
            showErrorNotification(errorMsg:errorModel.errorDescription.toString());
          }else{
            showErrorNotification(errorMsg:errorModel.Message.toString());
          }
        }*/
        }
      }
      else{
        Timer.periodic(const Duration(seconds: 10), (timer) async {
          AppInternetManager appInternetManager = AppInternetManager();
          var a = await appInternetManager.getSettingsTable();
          debugPrint("Lower One - MOBILE_INTERNET_STATUS From Background Service" + a[0]["AppInternetStatus"].toString());
          if(a[0]["AppInternetStatus"] == 1){
            timer.cancel();
            JobPhotosMainMethod(service, token);
          }
        });
      }
    }
    else{
      debugPrint("-->  Uploading Through Mobile Internet !!  <--");
      AppInternetManager appInternetManager = AppInternetManager();
      var a = await appInternetManager.getSettingsTable();
      debugPrint("Upper One - MOBILE_INTERNET_STATUS From Background Service" + (a[0]["AppInternetStatus"].toString()));

      if (a[0]["AppInternetStatus"] == 1) {
        WebService webService = WebService();
        var response = await webService.submitImagesFromDatabase(responseModel, jobNumber, listEmail, token);
        log(response.toString());
        if(response!=null){
          if(response.toString().contains("error")){

            if(!response.toString().contains("Something went wrong")) {
              Timer.periodic(const Duration(seconds: 10), (timer) async {
                bool isNetActive = await ConnectionStatus.getInstance()
                    .checkConnection();
                if (isNetActive) {
                  timer.cancel();
                  JobPhotosMainMethod(service, token);
                }
              });
            }else{
              FlutterBackgroundService().invoke("stopService");

            }

            /*      else{
                  ImageModel model = ImageModel();
                  model =
                  await ImageManager().getImageByImageName(
                      list[index].listPhotos![imageIndex].imageName!);
                  model.isSubmitted = 0;
                  await ImageManager().updateImageData(model);
                  ErrorResponse errorModel =  ErrorResponse.fromJson(response);
                  if(errorModel.errorDescription!=null) {
                    showErrorNotification(errorMsg:errorModel.errorDescription.toString());
                  }else{
                    showErrorNotification(errorMsg:errorModel.Message.toString());
                  }
                }*/

          }else{
            if(!response.toString().contains("error")){
              debugPrint("Updating in Database");

              model.isSubmitted = 2;
              await ImageManager().updateImageData(model);
              try{
                UploadImageResponse uploadImageResponse = UploadImageResponse.fromJson(response);
                service.invoke("result",{
                  "response": uploadImageResponse.toJson()
                });
              }catch(e){

              }

              JobPhotosMainMethod(service, token);


            }
            /*        else{
                  ImageModel model = ImageModel();
                  model =
                  await ImageManager().getImageByImageName(
                      list[index].listPhotos![imageIndex].imageName!);
                  model.isSubmitted = 0;
                  await ImageManager().updateImageData(model);
                  ErrorResponse errorModel =  ErrorResponse.fromJson(response);
                  if(errorModel.errorDescription!=null) {
                    showErrorNotification(errorMsg:errorModel.errorDescription.toString());
                  }else{
                    showErrorNotification(errorMsg:errorModel.Message.toString());
                  }
                }*/
          }
        }
        else{
          Timer.periodic(const Duration(seconds: 10), (timer) async {
            AppInternetManager appInternetManager = AppInternetManager();
            var a = await appInternetManager.getSettingsTable();
            debugPrint("Lower One - MOBILE_INTERNET_STATUS From Background Service" + a[0]["AppInternetStatus"].toString());
            if(a[0]["AppInternetStatus"] == 1){
              timer.cancel();
              JobPhotosMainMethod(service, token);
            }
          });
        }
        // final internetSpeed = InternetSpeed();
        // debugPrint("!!!Checking Internet Speed!!!");
/*      internetSpeed.startUploadTesting(
        fileSize: 10000,
        onDone: (double transferRate, SpeedUnit unit) async {
          debugPrint('the final transfer rate ---> $transferRate, and unit  --> ${unit.name}');
          if(transferRate > 0.005){

          }else{
            runApi(list, JobNumber, emailList, token,event, index, imageIndex, service);
          }
        },
        onProgress: (double percent, double transferRate, SpeedUnit unit) {
          debugPrint('continues transferring rate --> $transferRate, and percent  --> $percent, and unit  --> ${unit.name}');
        },
        onError: (String errorMessage, String speedTestError) {
          debugPrint('Error ---> $speedTestError');
          runApi(list, JobNumber, emailList, token,event, index, imageIndex, service);
        },
      );*/
      }
      else{
        Timer.periodic(
            const Duration(seconds : 10), (timer)async {
          AppInternetManager appInternetManager = AppInternetManager();
          var a = await appInternetManager.getSettingsTable();
          debugPrint("Lower One - MOBILE_INTERNET_STATUS From Background Service" +
              a[0]["AppInternetStatus"].toString());
          if (a[0]["AppInternetStatus"] == 1) {
            timer.cancel();
            JobPhotosMainMethod(service, token);
          }
        });
      }
    }
  }else{
    showNotification();
  }
}


LeadSheetMainMethod(service, token) async {
  debugPrint("Code LeadSheetMainMethod");
  AppInternetManager appInternetManager = AppInternetManager();
  var a = await appInternetManager.getSettingsTable();
  debugPrint("Lower One - BatterySaverStatus From Background Service" + a[0]["BatterySaverStatus"].toString());
  if (a[0]["BatterySaverStatus"] == 1) {
    int? batteryLevel;
    if (Platform.isAndroid) {
      debugPrint("-->  Android Battery Level: -->${(await BatteryInfoPlugin().androidBatteryInfo)?.batteryLevel.toString()??""}");
      batteryLevel = (await BatteryInfoPlugin().androidBatteryInfo)?.batteryLevel;
    }
    else if(Platform.isIOS){
      debugPrint("-->  IOS Battery Level: -->${(await BatteryInfoPlugin().iosBatteryInfo)?.batteryLevel.toString()??""}");
      batteryLevel = (await BatteryInfoPlugin().iosBatteryInfo)?.batteryLevel;
    }
    if ((batteryLevel??100) > 15) {
      LeadSheetSubmethod(service, token);
    }
    else{
      Timer.periodic(const Duration(seconds: 10), (timer) async {
        if (Platform.isAndroid) {
          debugPrint("Android Battery Level: ${(await BatteryInfoPlugin().androidBatteryInfo)?.batteryLevel.toString()??""}");
          batteryLevel = (await BatteryInfoPlugin().androidBatteryInfo)?.batteryLevel;
        }else if(Platform.isIOS){
          debugPrint("IOS Battery Level: ${(await BatteryInfoPlugin().iosBatteryInfo)?.batteryLevel.toString()??""}");
          batteryLevel = (await BatteryInfoPlugin().iosBatteryInfo)?.batteryLevel;
        }
        if((batteryLevel??100) > 15){
          LeadSheetMainMethod(service, token);
        }
      });
    }
  }else{
    LeadSheetSubmethod(service, token);
  }
}


LeadSheetSubmethod(service, token)async{
  ImageManager imageManager = ImageManager();
  List<ImageModel>imageList = await imageManager.getFailedImageList();
  debugPrint("Image List length" + imageList.length.toString());
  if(imageList.isNotEmpty) {
    ImageModel model = imageList.first;
    JobCategoriesResponse responseModel = JobCategoriesResponse();
    responseModel.id = model.categoryId??"";
    responseModel.name = model.categoryName??"";
    responseModel.listPhotos = [];
    responseModel.listPhotos?.add(model);
    var jobNumber = model.jobNumber.toString();
    List<Email> listEmail = await EmailManager().getEmailRecord(jobNumber);
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi) {
      debugPrint("-->  Uploading Through Wifi !!  <--");
      WebService webService = WebService();
      var response = await webService.submitImagesFromDatabase(responseModel, jobNumber, listEmail, token);
      if(response!=null){
        if(response.toString().contains("error")){
          Timer.periodic(const Duration(seconds: 10), (timer) async {
            bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
            if(isNetActive){
              timer.cancel();
              JobPhotosMainMethod(service, token);
            }
          });

          /*      else{
          ImageModel model = ImageModel();
          model =
          await ImageManager().getImageByImageName(
              list[index].listPhotos![imageIndex].imageName!);
          model.isSubmitted = 0;
          await ImageManager().updateImageData(model);
          ErrorResponse errorModel =  ErrorResponse.fromJson(response);
          if(errorModel.errorDescription!=null) {
            showErrorNotification(errorMsg:errorModel.errorDescription.toString());
          }else{
            showErrorNotification(errorMsg:errorModel.Message.toString());
          }
        }*/
        }else{
          if(!response.toString().contains("error")){
            debugPrint("Updating in Database");

            model.isSubmitted = 2;
            ImageManager().updateImageData(model);

            try{
              UploadImageResponse uploadImageResponse = UploadImageResponse.fromJson(response);
              service.invoke("result",{
                "response": uploadImageResponse.toJson()
              });
            }catch(e){

            }


            JobPhotosMainMethod(service, token);


          }
          /*
        else{
          ImageModel model = ImageModel();
          model =
          await ImageManager().getImageByImageName(
              list[index].listPhotos![imageIndex].imageName!);
          model.isSubmitted = 0;
          await ImageManager().updateImageData(model);
          ErrorResponse errorModel =  ErrorResponse.fromJson(response);
          if(errorModel.errorDescription!=null) {
            showErrorNotification(errorMsg:errorModel.errorDescription.toString());
          }else{
            showErrorNotification(errorMsg:errorModel.Message.toString());
          }
        }*/
        }
      }
      else{
        Timer.periodic(const Duration(seconds: 10), (timer) async {
          AppInternetManager appInternetManager = AppInternetManager();
          var a = await appInternetManager.getSettingsTable();
          debugPrint("Lower One - MOBILE_INTERNET_STATUS From Background Service" + a[0]["AppInternetStatus"].toString());
          if(a[0]["AppInternetStatus"] == 1){
            timer.cancel();
            JobPhotosMainMethod(service, token);
          }
        });
      }
    }
    else{
      debugPrint("-->  Uploading Through Mobile Internet !!  <--");
      AppInternetManager appInternetManager = AppInternetManager();
      var a = await appInternetManager.getSettingsTable();
      debugPrint("Upper One - MOBILE_INTERNET_STATUS From Background Service" + (a[0]["AppInternetStatus"].toString()));

      if (a[0]["AppInternetStatus"] == 1) {
        WebService webService = WebService();
        var response = await webService.submitImagesFromDatabase(responseModel, jobNumber, listEmail, token);
        log(response.toString());
        if(response!=null){
          if(response.toString().contains("error")){

            Timer.periodic(const Duration(seconds: 10), (timer) async {
              bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
              if(isNetActive){
                timer.cancel();
                JobPhotosMainMethod(service, token);
              }
            });


            /*      else{
                  ImageModel model = ImageModel();
                  model =
                  await ImageManager().getImageByImageName(
                      list[index].listPhotos![imageIndex].imageName!);
                  model.isSubmitted = 0;
                  await ImageManager().updateImageData(model);
                  ErrorResponse errorModel =  ErrorResponse.fromJson(response);
                  if(errorModel.errorDescription!=null) {
                    showErrorNotification(errorMsg:errorModel.errorDescription.toString());
                  }else{
                    showErrorNotification(errorMsg:errorModel.Message.toString());
                  }
                }*/

          }else{
              model.isSubmitted = 2;
              await ImageManager().updateImageData(model);
              try{
                UploadImageResponse uploadImageResponse = UploadImageResponse.fromJson(response);
                service.invoke("result",{
                  "response": uploadImageResponse.toJson()
                });
              }catch(e){

              }

              JobPhotosMainMethod(service, token);



            /*        else{
                  ImageModel model = ImageModel();
                  model =
                  await ImageManager().getImageByImageName(
                      list[index].listPhotos![imageIndex].imageName!);
                  model.isSubmitted = 0;
                  await ImageManager().updateImageData(model);
                  ErrorResponse errorModel =  ErrorResponse.fromJson(response);
                  if(errorModel.errorDescription!=null) {
                    showErrorNotification(errorMsg:errorModel.errorDescription.toString());
                  }else{
                    showErrorNotification(errorMsg:errorModel.Message.toString());
                  }
                }*/
          }
        }
        else{
          Timer.periodic(const Duration(seconds: 10), (timer) async {
            AppInternetManager appInternetManager = AppInternetManager();
            var a = await appInternetManager.getSettingsTable();
            debugPrint("Lower One - MOBILE_INTERNET_STATUS From Background Service" + a[0]["AppInternetStatus"].toString());
            if(a[0]["AppInternetStatus"] == 1){
              timer.cancel();
              JobPhotosMainMethod(service, token);
            }
          });
        }
        // final internetSpeed = InternetSpeed();
        // debugPrint("!!!Checking Internet Speed!!!");
/*      internetSpeed.startUploadTesting(
        fileSize: 10000,
        onDone: (double transferRate, SpeedUnit unit) async {
          debugPrint('the final transfer rate ---> $transferRate, and unit  --> ${unit.name}');
          if(transferRate > 0.005){

          }else{
            runApi(list, JobNumber, emailList, token,event, index, imageIndex, service);
          }
        },
        onProgress: (double percent, double transferRate, SpeedUnit unit) {
          debugPrint('continues transferring rate --> $transferRate, and percent  --> $percent, and unit  --> ${unit.name}');
        },
        onError: (String errorMessage, String speedTestError) {
          debugPrint('Error ---> $speedTestError');
          runApi(list, JobNumber, emailList, token,event, index, imageIndex, service);
        },
      );*/
      }
      else{
        Timer.periodic(
            const Duration(seconds : 10), (timer)async {
          AppInternetManager appInternetManager = AppInternetManager();
          var a = await appInternetManager.getSettingsTable();
          debugPrint("Lower One - MOBILE_INTERNET_STATUS From Background Service" +
              a[0]["AppInternetStatus"].toString());
          if (a[0]["AppInternetStatus"] == 1) {
            timer.cancel();
            JobPhotosMainMethod(service, token);
          }
        });
      }
    }
  }else{
    debugPrint("Now Showing Notification");
    showNotification();
  }
}

// runApiLeadSheet(SaveExhibitorImagesRequest request, finalToken, List<LeadSheetImageModel> list, index, priority) async {
//
//   WebService webService = WebService();
//   await webService.submitImagesLeadSheet(request, list[index], finalToken, priority).then((value) async {
//     debugPrint(value);
//     if(value.toString().contains("error")){
//       bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
//       if(isNetActive){
//       }else {
//         Timer.periodic(const Duration(seconds: 10), (timer) async {
//           isNetActive = await ConnectionStatus.getInstance().checkConnection();
//           if (isNetActive) {
//             timer.cancel();
//             runApiLeadSheet(request, finalToken, list, index, priority);
//           }
//         });
//       }
//
//     }else{
//
//       LeadSheetImageManager manager = LeadSheetImageManager();
//       LeadSheetImageModel model = list[index];
//       model.isSubmitted = 1;
//       manager.updateImageData(model);
//       index = index+1;
//       if(list.length>index){
//         runApiLeadSheet(request, finalToken, list, index, priority);
//       }else{
//         showNotification();
//         FlutterBackgroundService().invoke("stopService");
//       }
//     }
//   });
//
// }

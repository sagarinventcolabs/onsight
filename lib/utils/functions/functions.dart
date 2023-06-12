import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_root_jailbreak/flutter_root_jailbreak.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:get/get.dart';
// import 'package:local_auth/local_auth.dart';
import 'package:on_sight_application/main.dart';
import 'package:on_sight_application/repository/database_managers/image_manager.dart';
import 'package:on_sight_application/repository/web_service_response/upload_image_response.dart';
import 'package:on_sight_application/screens/field_issue/view_model/field_issue_controller.dart';
import 'package:on_sight_application/screens/lead_sheet/view_model/lead_sheet_controller.dart';
import 'package:path/path.dart' as path;
import 'package:path/path.dart';
import 'package:on_sight_application/repository/database_managers/app_internet_manager.dart';
import 'package:on_sight_application/repository/database_managers/dashboard_manager.dart';
import 'package:on_sight_application/repository/database_managers/onboarding_manager.dart';
import 'package:on_sight_application/repository/database_model/field_issue_image_model.dart';
import 'package:on_sight_application/repository/database_model/image_model.dart';
import 'package:on_sight_application/repository/database_model/image_model_promo_pictures.dart';
import 'package:on_sight_application/repository/database_model/lead_sheet_image_model.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/screens/field_issue/view_model/photo_comment_controller.dart';
import 'package:on_sight_application/screens/job_photos/view_model/job_photos_controller.dart';
import 'package:on_sight_application/screens/job_photos/view_model/upload_job_photos_controller.dart';
import 'package:on_sight_application/screens/lead_sheet/view_model/leadsheet_image_controller.dart';
import 'package:on_sight_application/screens/onboarding/model/onboarding_document_image_model.dart';
import 'package:on_sight_application/screens/onboarding/view_model/onboarding_photos_controller.dart';
import 'package:on_sight_application/screens/promo_pictures/view_model/promo_pictures_controller.dart';
import 'package:on_sight_application/screens/promo_pictures/view_model/upload_promo_pictures_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dialogs.dart';
import 'package:on_sight_application/utils/secure_storage.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

saveSuggestion(input) {
  List<String> list = [];
  list = sp!.getStringList(listAutoFill);

  int a = -1;
  a = list.indexWhere(
      (element) => element.toLowerCase() == input.toString().toLowerCase());

  if (list.length < 5) {
    if (a < 0) {
      list.add(input.toString().toUpperCase());
    }
  } else {
    list.removeAt(0);
    if (a < 0) {
      list.add(input.toString().toUpperCase());
    }
  }

  sp!.putStringList(listAutoFill, list);
}

saveShowNameHistory(input) {
  List<String> list = [];
  list = sp!.getStringList(showNameHistory);
  int a = -1;
  a = list.indexWhere(
      (element) => element.toLowerCase() == input.toString().toLowerCase());

  if (list.length < 5) {
    if (a < 0) {
      list.add(input);
    }
  } else {
    list.removeAt(0);
    if (a < 0) {
      list.add(input);
    }
  }

  sp!.putStringList(showNameHistory, list);
}

saveExhibitorNameHistory(input) {
  List<String> list = [];
  list = sp!.getStringList(exhibitorNameHistory);
  int a = -1;
  a = list.indexWhere(
      (element) => element.toLowerCase() == input.toString().toLowerCase());

  if (list.length < 5) {
    if (a < 0) {
      list.add(input);
    }
  } else {
    list.removeAt(0);
    if (a < 0) {
      list.add(input);
    }
  }

  sp!.putStringList(exhibitorNameHistory, list);
}

saveShowNumberSuggestions(input) {
  List<String> list = [];
  list = sp!.getStringList(showNumberAutoFill);

  int a = -1;
  a = list.indexWhere(
      (element) => element.toLowerCase() == input.toString().toLowerCase());

  debugPrint(list.toString());
  debugPrint(input.toString().toLowerCase());
  if (list.length < 5) {
    if (a < 0) {
      list.add(input.toString().toUpperCase());
    }
  } else {
    list.removeAt(0);
    if (a < 0) {
      list.add(input.toString().toUpperCase());
    }
  }

  sp!.putStringList(showNumberAutoFill, list);
}

Future<void> showNotification([ServiceInstance? service]) async {
  AppInternetManager appInternetManager = AppInternetManager();
  var a = await appInternetManager.getSettingsTable();
  print("Task in progress Notification " + a[0]["TaskInProgress"].toString());
  int b = a[0]["TaskInProgress"] ?? 1;

  b = b - 1;
  await appInternetManager.updateTaskProgress(val: b);
  var aa = await appInternetManager.getSettingsTable();
  print("Task in progress Notification " + aa[0]["TaskInProgress"].toString());
  if (b < 0) {
    await appInternetManager.updateTaskProgress(val: 0);
  }

  await flutterLocalNotificationsPlugin.cancel(11);

  print("Upper One - Notify Upload status From Background Service" +
      (a[0]["UploadCompleteStatus"].toString()));
// if (a[0]["UploadCompleteStatus"] == 1) {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('channel1', 'channelone',
          channelDescription: 'channelDescription',
          importance: Importance.max,
          priority: Priority.high,
          color: ColourConstants.primary,
          ticker: 'ticker');
  const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(presentSound: true, presentAlert: true, presentBadge: true);
  const NotificationDetails notificationDetails =
  NotificationDetails(android: androidPlatformChannelSpecifics, iOS: darwinNotificationDetails);
  await flutterLocalNotificationsPlugin.show(
      10, appName, notificationSuccessMsg, notificationDetails,
      payload: 'item x');
//    }
//  if(b<1) {
  Future.delayed(Duration(seconds: 5), () {
    if (service != null) {
      service.stopSelf();
    }
  });

//  }
}

void onDidReceiveLocalNotification(
    int? id, String? title, String? body, String? payload) async {
  // display a dialog with the notification details, tap ok to go to another page
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) =>
        CupertinoAlertDialog(
          title: Text(title ?? ""),
          content: Text(body ?? ""),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
              },
            )
          ],
        ),
  );
}
/// check internet speed
Future<int> checkInternetSpeedFunction() async {
  var result = 5;
  try {
    const platform = MethodChannel(channelID);
    result = await platform.invokeMethod(checkInternetSpeed);
  } on PlatformException catch (e) {
    print("Failed : '${e.message}'.");
  }

  return result;
}

Future<void> showNotificationFailedJob(ServiceInstance service) async {
  AppInternetManager appInternetManager = AppInternetManager();
  var a = await appInternetManager.getSettingsTable();
  print("Task in progress Notification " + a[0]["TaskInProgress"].toString());
  int b = a[0]["TaskInProgress"] ?? 1;

  b = 0;
  await appInternetManager.updateTaskProgress(val: b);
  var aa = await appInternetManager.getSettingsTable();
  print("Task in progress Notification " + aa[0]["TaskInProgress"].toString());
  if (b < 0) {
    await appInternetManager.updateTaskProgress(val: 0);
  }
  if (b < 1) {
    await flutterLocalNotificationsPlugin.cancel(11);

    print("Upper One - Notify Upload status From Background Service" +
        (a[0]["UploadCompleteStatus"].toString()));
    if (a[0]["UploadCompleteStatus"] == 1) {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails('channel1', 'channelone',
              channelDescription: 'channelDescription',
              importance: Importance.max,
              priority: Priority.high,
              color: ColourConstants.primary,
              ticker: 'ticker');
      const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(presentSound: true, presentAlert: true, presentBadge: true);

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: darwinNotificationDetails);
      await flutterLocalNotificationsPlugin.show(
          10, appName, notificationSuccessMsg, platformChannelSpecifics,
          payload: 'item x');
    }

    service.stopSelf();
  }
}

Future<void> showErrorNotification(ServiceInstance service,
    {required String errorMsg}) async {
  AppInternetManager appInternetManager = AppInternetManager();
  var a = await appInternetManager.getSettingsTable();
  print("Task in progress Notification " + a[0]["TaskInProgress"].toString());
  int b = a[0]["TaskInProgress"] ?? 1;

  b = b - 1;
  await appInternetManager.updateTaskProgress(val: b);
  var aa = await appInternetManager.getSettingsTable();
  print("Task in progress Notification " + aa[0]["TaskInProgress"].toString());
  if (b < 0) {
    await appInternetManager.updateTaskProgress(val: 0);
  }

  await flutterLocalNotificationsPlugin.cancel(11);

  print("Upper One - Notify Upload status From Background Service" +
      (a[0]["UploadCompleteStatus"].toString()));
  // if (a[0]["UploadCompleteStatus"] == 1) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('channel1', 'channelone',
            channelDescription: 'channelDescription',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
            color: ColourConstants.primary);
    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(presentSound: true, presentAlert: true, presentBadge: true);

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: darwinNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
        10, appName, errorMsg, platformChannelSpecifics,
        payload: 'item x');
 // }

  service.stopSelf();
}

Future<void> showNotificationUploading() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('channel1', 'channelone',
          channelDescription: 'channelDescription',
          importance: Importance.max,
          priority: Priority.high,
          autoCancel: false,
          showProgress: true,
          ticker: 'ticker',
          color: ColourConstants.primary);
  const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(presentSound: true, presentAlert: true, presentBadge: true);

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics, iOS: darwinNotificationDetails);
  await flutterLocalNotificationsPlugin.show(
      11, appName, uploadingImages, platformChannelSpecifics,
      payload: 'item x');
}

Future<String> createFolderInAppDocDir(String folderName) async {
  //Get this App Document Directory

  final Directory appDocDir = await getApplicationDocumentsDirectory();
  //App Document Directory + folder name
  final Directory appDocDirFolder = Directory('${appDocDir.path}/$folderName/');

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

void showFlutterNotification(RemoteMessage message) {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('onsight', 'onsight_channel',
          channelDescription: 'Onsight Firebase Channel',
          importance: Importance.max,
          priority: Priority.high,
          autoCancel: false,
          showProgress: true,
          ticker: 'ticker',
          icon: 'ic_stat_new_icon_notif',
          color: ColourConstants.primary);
  const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(presentSound: true, presentAlert: true, presentBadge: true);

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics, iOS: darwinNotificationDetails);
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(notification.hashCode,
        notification.title, notification.body, platformChannelSpecifics);
  }
}

checkRootJailBreakSecurity() {
  /// Checking Security for Root & Jailbreak for both IOS & Android.
  WidgetsBinding.instance.addPostFrameCallback(
    (_) async {
      if (Platform.isAndroid) {
        var isRooted = await FlutterRootJailbreak.isRooted;

        if (isRooted) {
          Get.offAllNamed(Routes.loginScreen);
        }
      } else {
        var isJailBroken = await FlutterRootJailbreak.isJailBroken;

        if (isJailBroken) {
          Get.offAllNamed(Routes.loginScreen);
        }
      }
    },
  );
}

analyticsFireEvent(eventName, {Map<String, dynamic>? input}) async {
  await FirebaseAnalytics.instance.logEvent(name: eventName, parameters: input);
}

// Future<void> authenticateUser() async {
//   bool authenticated = false;
//   authorized = 'Authenticating';
//   try {
//     authenticated = await auth.authenticate(
//       localizedReason: 'Please wait for authenticate yourself',
//       options:
//           const AuthenticationOptions(stickyAuth: true, useErrorDialogs: true),
//     );
//   } on PlatformException catch (e) {
//     authorized = 'Error - ${e.message}';
//
//     if (e.toString().contains("NotAvailable")) {
//       Get.offAllNamed(Routes.dashboardScreen);
//       return;
//     }
//   }
//
//   authorized = authenticated ? 'Authorized' : 'Not Authorized';
//
//   if (authorized == "Authorized") {
//     Get.offAllNamed(Routes.dashboardScreen);
//   } else {
//     exit(0);
//   }
// }

logoutFun() async {
  sp?.clear();
  SecureStorage().deleteAll();
  try {
    await DashboardManager().deleteAllData();
  } catch (e) {}
  if (isDialogOpen == true) {
    Get.back(closeOverlays: true);
  }

  Get.offNamedUntil(Routes.emailLoginScreen, (p) => false);
}

class NoLeadingSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.startsWith(' ')) {
      final String trimedText = newValue.text.trimLeft();

      return TextEditingValue(
        text: trimedText,
        selection: TextSelection(
          baseOffset: trimedText.length,
          extentOffset: trimedText.length,
        ),
      );
    }

    return newValue;
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
}

Future<void> ImagePickerJobPhoto(route, id, jobNumber, key) async {
  UploadJobPhotosController uploadJobPhotosC;
  if (Get.isRegistered<UploadJobPhotosController>()) {
    uploadJobPhotosC = Get.find<UploadJobPhotosController>();
  } else {
    uploadJobPhotosC = Get.put(UploadJobPhotosController());
  }
  JobPhotosController controller = Get.find<JobPhotosController>();
  var i = controller.categoryList.indexWhere((element) => element.id == id);

  for (var element in localList) {
    File image = await File(element.imagePath!);
    String _base64String = "";
    if(Platform.isIOS) {
      Uint8List _bytes = await image.readAsBytes();
      _base64String = base64.encode(_bytes);
      print(_base64String);
    }
      print('Original path: ${element.imagePath}');
    String dirr = await path.dirname(element.imagePath!);
    String newPath = await path.join(dirr,
        '${jobNumber.toString()}_${controller.categoryList[i].name.toString().replaceAll(" ", "-")}_${element.created_at}.jpg');
    print('NewPath: ${newPath}');
    await image.renameSync(newPath);
    String fileName = basename(newPath);
/*    Directory documents;
    if(Platform.isIOS) {
      documents = await getApplicationDocumentsDirectory();
      String dir = documents.path;
      final File newImage = await image.copy('$dir/${jobNumber.toString()}_${controller.categoryList[i].name.toString().replaceAll(" ", "-")}_${element.created_at}.jpg');
      fileName = basename(newImage.path);
      newPath = newImage.path;
      print('NewPathIs: ${newImage.path}');
    }*/

    ImageModel imageModel = ImageModel(
        imagePath: newPath,
        imageName: fileName,
        imageString: _base64String,
        isPhotoAdded: 0,
        jobNumber: jobNumber,
        categoryId: id,
        categoryName: controller.categoryList[i].name,
        isSubmitted: 0);
    uploadJobPhotosC.jobPhotosList.add(imageModel);
    uploadJobPhotosC.enableButton.value = true;
    uploadJobPhotosC.update();
  }
  uploadJobPhotosC.jobPhotosList.refresh();
  uploadJobPhotosC.update();
  if (localList.isEmpty) {
    // Get.back();
  } else {
    Get.toNamed(Routes.uploadJobPhotosNote, arguments: [id, jobNumber, key]);
  }
}

Future<void> ImagePickerPromoPictures(String route) async {
  var firstName = sp?.getString(Preference.FIRST_NAME) ?? "";
  var lastName = sp?.getString(Preference.LAST_NAME) ?? "";
  PromoPicturesController controller;
  UploadPromoPicturesController uploadPromoPicturesController;
  if (Get.isRegistered<PromoPicturesController>()) {
    controller = Get.find<PromoPicturesController>();
  } else {
    controller = Get.put(PromoPicturesController());
  }

  if (Get.isRegistered<UploadPromoPicturesController>()) {
    uploadPromoPicturesController = Get.find<UploadPromoPicturesController>();
  } else {
    uploadPromoPicturesController = Get.put(UploadPromoPicturesController());
  }

  if (localList.isNotEmpty) {
    for (var element in localList) {
      File image = await File(element.imagePath!);
      print('Original path: ${element.imagePath}');
      String dirr = await path.dirname(element.imagePath!);
      String newPath = await path.join(dirr,
          '${controller.showController.text.isNotEmpty ? controller.showController.text + "_PromoPictures" : "PromoPictures"}_${element.created_at}.jpg');
      print('NewPath: ${newPath}');
      image.renameSync(newPath);
      String fileName = basename(newPath);
      PromoImageModel model = PromoImageModel();
      model.imageName = fileName;
      model.imagePath = newPath;
      model.fullDate = "0001-01-01T00:00:00";
      model.showName = controller.showController.text.toString();
      model.year = DateTime.now().year.toString();
      model.user = firstName + lastName;
      controller.photoList.add(model);
    }

    print(controller.photoList.length);
    controller.photoList.refresh();
    controller.enableButton.value = true;
    controller.update();
    uploadPromoPicturesController.enableButton.value = true;
    uploadPromoPicturesController.update();
    if (controller.photoList.isEmpty) {
    } else {
      Get.toNamed(Routes.uploadPromoPictureScreen);
    }
  }
}

Future<void> ImagePickerLeadSheet(String route, String id, String s) async {
  LeadSheetImageController controller;
  if (Get.isRegistered<LeadSheetImageController>()) {
    controller = Get.find<LeadSheetImageController>();
  } else {
    controller = Get.put(LeadSheetImageController());
  }

  LeadSheetController leadSheetController;
  if (Get.isRegistered<LeadSheetController>()) {
    leadSheetController = Get.find<LeadSheetController>();
  } else {
    leadSheetController = Get.put(LeadSheetController());
  }
  for (var element in localList) {
    File image = await File(element.imagePath!);
    print('Original path: ${element.imagePath}');
    String dirr = await path.dirname(element.imagePath!);
    String newPath = await path.join(dirr,
        '${leadSheetController.showController.text.trim()}_${id}_${element.created_at}.jpg');
    print('NewPath: ${newPath}');
    image.renameSync(newPath);
    String fileName = basename(newPath);
    LeadSheetImageModel model = LeadSheetImageModel();
    model.imageName = fileName;
    model.imagePath = newPath;
    controller.photoList.add(model);
  }

  controller.photoList.refresh();
  controller.enableButton.value = true;
  controller.update();
  if (controller.photoList.isEmpty) {
    //Get.back();
  } else {
    if (route == Routes.leadSheetPhotosNote) {
      //Get.back();
    } else {
      // Get.back();
      Get.toNamed(Routes.leadSheetPhotosNote, arguments: [id, s]);
    }
  }
}

Future<void> ImagePickerFieldIssue(String s) async {
  print(s);
  PhotoCommentController controller = Get.find<PhotoCommentController>();
  FieldIssueController fieldIssueController;
  if (Get.isRegistered<FieldIssueController>()) {
    fieldIssueController = Get.find<FieldIssueController>();
  } else {
    fieldIssueController = Get.put(FieldIssueController());
  }
  for (var element in localList) {
    // File image = await File(element.imagePath!);
    // print('Original path: ${element.imagePath}');
    // String dirr = await path.dirname(element.imagePath!);
    // String newPath = await path.join(dirr,
    //     '${fieldIssueController.jobEditingController.text.toString().trim()}_${"FieldIssues"}_${element.created_at}.jpg');
    // print('NewPath: ${newPath}');
    // image.renameSync(newPath);
    // String fileName = basename(newPath);
    // print("File Name ${fileName.toString().split(".").first}");
    FieldIssueImageModel model = FieldIssueImageModel();
    model.imageName = element.imageName;
    model.imagePath = element.imagePath;
    controller.photoList.add(model);
  }

  controller.photoList.refresh();
  controller.enableButton.value = true;
  controller.update();
  if (localList.isNotEmpty) {
    if (s == add) {
      Get.toNamed(Routes.fieldIssueCategoryScreen, arguments: photoStr);
    } else {}
  }
}

Future<void> ImagePickerOnboarding(
    String route, index, resourceKey, rowId, count, categoryName) async {
  OnBoardingPhotosController controller =
      Get.find<OnBoardingPhotosController>();
  for (var element in localList) {
    File image = await File(element.imagePath!);
    print('Original path: ${element.imagePath}');
    String dirr = await path.dirname(element.imagePath!);
    String newPath = await path.join(dirr,
        '${resourceKey.toString()}_${categoryName}_${element.created_at}.jpg');
    print('NewPath: ${newPath}');
    image.renameSync(newPath);
    String fileName = basename(newPath);
    OnBoardingDocumentImageModel model = OnBoardingDocumentImageModel();
    model.imageName = fileName;
    model.imagePath = newPath;
    model.resourceKey = resourceKey;
    model.count = count;
    model.categoryName = categoryName;
    model.position = rowId;
    controller.imageList[index].image?.add(model);
    model.YetToSubmit = controller.imageList[index].image?.length.toString();
    //controller.imageList[index].image?.add(model);
    controller.imageList.refresh();
    controller.update();

    await OnboardingImageManager().insertImage(model);
  }

  controller.imageList.refresh();
  if(imageList.isNotEmpty) {
    controller.enableButton.value = true;
  }
  controller.update();
  controller.imageList.forEach((element) {
    if ((element.image?.length ?? 0) > 0) {
      controller.enableButton.value = true;
    }
  });
}

@pragma('vm:entry-point')
void backgroundHandler() {
  // Needed so that plugin communication works.
  WidgetsFlutterBinding.ensureInitialized();

  // This uploader instance works within the isolate only.
  FlutterUploader uploader = FlutterUploader();

  uploader.progress.listen((progress) {

    // upload progress
    print("Progress: $progress");
  });
  uploader.result.listen((result) async {

    var jobNumber  =  "";
    UploadTaskResponse response = result;
    print("Response at function is ${response}");

    if (response.statusCode == 200) {
      final JsonDecoder _decoder = new JsonDecoder();
      var responseJson = _decoder.convert(response.response.toString());
      UploadImageResponse uploadImageResponse =
          UploadImageResponse.fromJson(responseJson);
      jobNumber = uploadImageResponse.jobNumber.toString();
      for (var element in uploadImageResponse.categoryModelDetails!) {
        for (var k in element.photoUploadSummaryDetails!) {
          try{
            var imageName = k.fileName!;
            print("Image Name is  ${imageName}");
            ImageModel model =
            await ImageManager().getImageByImageName(imageName);
            print("Model Image  Name is  ${model.imageName}");
            model.isSubmitted = 2;
            await ImageManager().deleteImage(model.imageName);

          }catch(e){

          }

        }
      }
     // SharedPreferences pref = await SharedPreferences.getInstance();
     // List<String> listTask = pref.getStringList("taskList")??[];


      List<ImageModel> filteredList =
          await ImageManager().getImageListByJobNumber(jobNumber);
      print("Filtered List Length is ${filteredList.length}");
      if (filteredList.isEmpty) {
        showNotification();
        // bool isNotify = await pref.getBool("Notify")??false;
        // print("isNotify ${isNotify}");
        // FlutterUploader().clearUploads();
        //     if(isNotify==false) {
        //
        //     }
        //   await pref.setBool("Notify", true);


        FlutterUploader().cancelAll();
      }
      //  showNotification();
    }else{
      FlutterUploader().clearUploads();
    }
  });


}

/// Process the user tapping on a notification by printing a message
// void myNotificationTapCallback(Task task, NotificationType notificationType) {
//   debugPrint(
//       'Tapped notification $notificationType for taskId ${task.taskId}');
// }
Future<String> createFileFromString(encodedStr, imageName) async {
  print("${imageName} - ${encodedStr}");
  Uint8List bytes = base64.decode(encodedStr);
  String dir = (await getApplicationDocumentsDirectory()).path;
  File file = File(
      "$dir/" + imageName);
  await file.writeAsBytes(bytes);
  return file.path;
}

Uint8List convertBase64Image(String base64String) {
  return Base64Decoder().convert(base64String.split(',').last);
}




// Future<String> getSQFBaseUrl()async{
//   AppInternetManager appInternetManager = AppInternetManager();
//   var a = await appInternetManager.getSettingsTable() as List;
//   return a[0]["BaseUrl"];}
//

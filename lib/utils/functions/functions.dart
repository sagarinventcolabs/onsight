import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_root_jailbreak/flutter_root_jailbreak.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:on_sight_application/main.dart';
import 'package:on_sight_application/models/image_picker_model.dart';
import 'package:on_sight_application/repository/database_managers/app_internet_manager.dart';
import 'package:on_sight_application/repository/database_managers/dashboard_manager.dart';
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

Future<void> showNotification(ServiceInstance service) async {
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
      const IOSNotificationDetails iosNotificationDetails =
          IOSNotificationDetails(
              presentAlert: true, presentBadge: false, presentSound: true);
      const NotificationDetails platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iosNotificationDetails);
      await flutterLocalNotificationsPlugin.show(
          10, appName, notificationSuccessMsg, platformChannelSpecifics,
          payload: 'item x');
    }

    service.stopSelf();
  }
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
      const IOSNotificationDetails iosNotificationDetails =
          IOSNotificationDetails(
              presentAlert: true, presentBadge: false, presentSound: true);
      const NotificationDetails platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iosNotificationDetails);
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
  if (a[0]["UploadCompleteStatus"] == 1) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('channel1', 'channelone',
            channelDescription: 'channelDescription',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
            color: ColourConstants.primary);
    const IOSNotificationDetails iosNotificationDetails =
        IOSNotificationDetails(
            presentAlert: true, presentBadge: false, presentSound: true);
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
        10, appName, errorMsg, platformChannelSpecifics,
        payload: 'item x');
  }
  if (b < 1) {
    service.stopSelf();
  }
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
  const IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails(
      presentAlert: true, presentBadge: false, presentSound: true);
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);
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
  const IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails(
      presentAlert: true, presentBadge: true, presentSound: true);
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);
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

Future<void> authenticateUser() async {
  bool authenticated = false;
  authorized = 'Authenticating';
  try {
    authenticated = await auth.authenticate(
      localizedReason: 'Please wait for authenticate yourself',
      options:
          const AuthenticationOptions(stickyAuth: true, useErrorDialogs: true),
    );
  } on PlatformException catch (e) {
    authorized = 'Error - ${e.message}';

    if (e.toString().contains("NotAvailable")) {
      Get.offAllNamed(Routes.dashboardScreen);
      return;
    }
  }

  authorized = authenticated ? 'Authorized' : 'Not Authorized';

  if (authorized == "Authorized") {
    Get.offAllNamed(Routes.dashboardScreen);
  } else {
    exit(0);
  }
}

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

void ImagePickerJobPhoto(route, id, jobNumber, key) {
  UploadJobPhotosController uploadJobPhotosC;
  if (Get.isRegistered<UploadJobPhotosController>()) {
    uploadJobPhotosC = Get.find<UploadJobPhotosController>();
  } else {
    uploadJobPhotosC = Get.put(UploadJobPhotosController());
  }
  JobPhotosController controller = Get.find<JobPhotosController>();
  var i = controller.categoryList.indexWhere((element) => element.id == id);

  for (var element in localList) {
    ImageModel imageModel = ImageModel(
        imagePath: element.imagePath,
        imageName: element.imageName,
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

void ImagePickerPromoPictures(String route) {
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
    localList.forEach((element) {
      PromoImageModel model = PromoImageModel();
      model.imageName = element.imageName;
      model.imagePath = element.imagePath;
      model.fullDate = "0001-01-01T00:00:00";
      model.showName = controller.showController.text.toString();
      model.year = DateTime.now().year.toString();
      model.user = firstName + lastName;
      controller.photoList.add(model);
    });

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

void ImagePickerLeadSheet(String route, String id, String s) {
  LeadSheetImageController controller;
  if (Get.isRegistered<LeadSheetImageController>()) {
    controller = Get.find<LeadSheetImageController>();
  } else {
    controller = Get.put(LeadSheetImageController());
  }

  for (var element in localList) {
    LeadSheetImageModel model = LeadSheetImageModel();
    model.imageName = element.imageName;
    model.imagePath = element.imagePath;
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

void ImagePickerFieldIssue(String s) {
  PhotoCommentController controller = Get.find<PhotoCommentController>();
  for (var element in localList) {
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

void ImagePickerOnboarding(String route, index) {
  OnBoardingPhotosController controller =
      Get.find<OnBoardingPhotosController>();
  for (var element in localList) {
    OnBoardingDocumentImageModel model = OnBoardingDocumentImageModel();
    model.imageName = element.imageName;
    model.imagePath = element.imagePath;
    controller.imageList[index].image?.add(model);
    // controller.imageList[index].image?.add(model);
    // controller.imageList.refresh();
    controller.update();
  }

  controller.imageList.refresh();
  controller.enableButton.value = true;
  controller.update();
  controller.imageList.forEach((element) {
    if ((element.image?.length ?? 0) > 0) {
      controller.enableButton.value = true;
    }
  });
}

// Future<String> getSQFBaseUrl()async{
//   AppInternetManager appInternetManager = AppInternetManager();
//   var a = await appInternetManager.getSettingsTable() as List;
//   return a[0]["BaseUrl"];}
//

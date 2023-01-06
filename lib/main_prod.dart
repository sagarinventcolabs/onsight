import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/env.dart';
import 'package:on_sight_application/main.dart';
import 'package:on_sight_application/models/model_notification.dart';
import 'package:on_sight_application/screens/job_photos/view_model/job_photos_controller.dart';
import 'package:on_sight_application/screens/project_evaluation/view_model/project_evaluation_controller.dart';
import 'package:on_sight_application/screens/project_evaluation/view_model/project_evaluation_install_controller.dart';
import 'package:on_sight_application/screens/setting/view_model/settings_controller.dart';
import 'package:on_sight_application/services/service.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/functions/functions.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';


Future<void> main() async {
  AppEnvironment.setupEnv(Environment.prod);

  const bool isProduction = bool.fromEnvironment('dart.vm.product');
/*  final NotificationAppLaunchDetails? notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload = notificationAppLaunchDetails!.payload;
}*/

  if (isProduction) {
    // analyser does not like empty function body
    // debugPrint = (String message, {int wrapWidth}) {};
    // so i changed it to this:
    debugPrint = (String? message, {int? wrapWidth}) => null;

  }
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('ic_stat_new_icon_notif');
    final IOSInitializationSettings iosInitializationSettings =  IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,

        onDidReceiveLocalNotification: (
            int id,
            String? title,
            String? body,
            String? payload,
            ) async {
          didReceiveLocalNotificationSubject.add(
            ReceivedNotification(
              id: id,
              title: title,
              body: body,
              payload: payload,
            ),
          );
        });

    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: iosInitializationSettings);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification:  (String? payload) async {
          if (payload != null) {
            debugPrint('notification payload: $payload');
          }
          selectedNotificationPayload = payload;
          selectNotificationSubject.add(payload);
        });

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent
      // status bar color
    ));

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    sp = await Preference.getInstance();
    isLogin = await sp?.getBool(Preference.IS_LOGGED_IN)??false;
    initializeService();
    Get.put(JobPhotosController());
    Get.put(ProjectEvaluationController());
    Get.put(ProjectEvaluationInstallController());
    Get.put(SettingsController());
    // AppConfig devAppConfig = AppConfig(appName: 'On-Sight', flavor: 'dev');
    // Widget app = await initializeApp(devAppConfig);
    runApp(const MyApp());
  },(error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}
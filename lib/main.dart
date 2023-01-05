import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/repository/database_model/image_model.dart';
import 'package:on_sight_application/repository/database_model/secure_model.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/screens/job_photos/view_model/job_photos_controller.dart';
import 'package:on_sight_application/screens/project_evaluation/view_model/project_evaluation_controller.dart';
import 'package:on_sight_application/screens/project_evaluation/view_model/project_evaluation_install_controller.dart';
import 'package:on_sight_application/screens/setting/view_model/settings_controller.dart';
import 'package:on_sight_application/screens/splash/splash_screen.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/services/service.dart';
import 'package:on_sight_application/utils/functions/functions.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'models/model_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';



List<SecureModel> localStorage = [];
final storage = const FlutterSecureStorage();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject = BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String?> selectNotificationSubject = BehaviorSubject<String?>();
String? selectedNotificationPayload;
bool visibleRefresh = false;
List<ImageModel> imageList = [];

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  late FirebaseAnalyticsObserver observer;


  @override
  initState() {


    observer = FirebaseAnalyticsObserver(analytics: analytics);

    super.initState();
    _requestPermissions();
    FirebaseMessaging.onMessage.listen(showFlutterNotification);

    FirebaseMessaging.onMessageOpenedApp.listen(showFlutterNotification);
    // var brightness = SchedulerBinding.instance.window.platformBrightness;
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation < IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation < MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (Platform.isAndroid) {
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      //  final bool? granted = await androidImplementation?.requestPermission();
      setState(() {});
    }
  }





  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: appName,
      darkTheme: Themes.dark,
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          fontFamily: 'SFUI'
      ).copyWith(
          bottomSheetTheme: BottomSheetThemeData(backgroundColor: ColourConstants.white)
      ),
      themeMode: ThemeMode.system,
      navigatorObservers: <NavigatorObserver>[observer],
      home: SplashScreen(),
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
    );
  }
}

class Themes {

  static final light = ThemeData.light().copyWith(
    backgroundColor: Colors.white,
    bottomAppBarColor: Colors.cyan,
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.transparent,
    dividerColor: ColourConstants.grey,


    inputDecorationTheme: InputDecorationTheme(
        labelStyle:  const TextStyle(color: Colors.black54)
    ),
    textTheme: TextTheme(
        displayMedium: TextStyle(color: Colors.black, fontFamily: 'SFUI', fontWeight: FontWeight.bold, fontSize: 16),
        displaySmall: TextStyle(color: Colors.black, fontFamily: 'SFUI',fontWeight: FontWeight.normal,fontSize: 12)

    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.cyan,
      textTheme: ButtonTextTheme.primary,
    ),
  );

  static final dark = ThemeData.dark().copyWith(
    backgroundColor: Colors.black,
    scaffoldBackgroundColor: Colors.black,
    bottomAppBarColor: Colors.deepPurple,
    cardColor: ColourConstants.primary,
    dividerColor: ColourConstants.primary,
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: ColourConstants.grey900),

    textTheme: TextTheme(
        displayMedium: TextStyle(color: Colors.white, fontFamily: 'SFUI', fontWeight: FontWeight.w500, fontSize: 16),
        displaySmall: TextStyle(color: Colors.white, fontFamily: 'SFUI', fontWeight: FontWeight.normal, fontSize: 12)
    ),

    inputDecorationTheme:  InputDecorationTheme(
      labelStyle:TextStyle(color: Colors.white),

      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: ColourConstants.grey),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.blue),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(
            width: 1, color: Colors.red),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(
            width: 1, color: Colors.red),
      ),
    ),


    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.deepPurple,
      textTheme: ButtonTextTheme.primary,
    ),
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        // Load the local file
        String _localPem = 'CERTIFICATE_STRING';
        // Check the certificate
        if (_localPem == cert.pem)
          return true;
        else
          return false;
      };
  }
}
import 'dart:async';
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
import 'package:on_sight_application/models/model_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

List<SecureModel> localStorage = [];
final storage = const FlutterSecureStorage();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String?> selectNotificationSubject =
    BehaviorSubject<String?>();
String? selectedNotificationPayload;
bool visibleRefresh = false;
List<ImageModel> imageList = [];

Future<void> main() async {
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
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_stat_new_icon_notif');
    final IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings(
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

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: iosInitializationSettings);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
      selectedNotificationPayload = payload;
      selectNotificationSubject.add(payload);
    });

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
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
    isLogin = await sp?.getBool(Preference.IS_LOGGED_IN) ?? false;
    initializeService();
    Get.put(JobPhotosController());
    Get.put(ProjectEvaluationController());
    Get.put(ProjectEvaluationInstallController());
    Get.put(SettingsController());
    // AppConfig devAppConfig = AppConfig(appName: 'On-Sight', flavor: 'dev');
    // Widget app = await initializeApp(devAppConfig);
    runApp(const MyApp());
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
}

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
    // final window = WidgetsBinding.instance.window;
    // window.onPlatformBrightnessChanged = () {
    //   final brightness = window.platformBrightness;
    //   print("Brightness Name"+brightness.name);
    // };

    WidgetsBinding.instance.window.onPlatformBrightnessChanged = () {
      if (WidgetsBinding.instance.window.platformBrightness.name == "light") {
        Get.changeTheme(ThemeData.light());
        Get.changeThemeMode(ThemeMode.light);
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            statusBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.light,
            systemNavigationBarColor: Colors.white
            // status bar color
            ));
      } else {
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.black
            // status bar color
            ));
        Get.changeTheme(ThemeData.dark());
        Get.changeThemeMode(ThemeMode.dark);
      }

      setState(() {});
    };

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
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      //  final bool? granted = await androidImplementation?.requestPermission();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: appName,
      darkTheme: Themes.dark,
      builder: (context, child) {
        return MediaQuery(
          child: child!,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.1),
        );
      },
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'SFUI',
      ).copyWith(
        bottomSheetTheme:
            BottomSheetThemeData(backgroundColor: ColourConstants.white),
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
        labelStyle: const TextStyle(color: Colors.black54)),
    textTheme: TextTheme(
        displayMedium: TextStyle(
            color: Colors.black,
            fontFamily: 'SFUI',
            fontWeight: FontWeight.bold,
            fontSize: 16),
        displaySmall: TextStyle(
            color: Colors.black,
            fontFamily: 'SFUI',
            fontWeight: FontWeight.normal,
            fontSize: 12)),
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
    bottomSheetTheme:
        BottomSheetThemeData(backgroundColor: ColourConstants.grey900),
    textTheme: TextTheme(
      displayMedium: TextStyle(
          color: Colors.white,
          fontFamily: 'SFUI',
          fontWeight: FontWeight.w500,
          fontSize: 16),
      displaySmall: TextStyle(
          color: Colors.white,
          fontFamily: 'SFUI',
          fontWeight: FontWeight.normal,
          fontSize: 12),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.white),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: ColourConstants.grey),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.blue),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.red),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.red),
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

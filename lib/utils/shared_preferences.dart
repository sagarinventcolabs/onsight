import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Preference {
  //pref- value
  static const String IS_LOGGED_IN = 'is_logged_in';
  static const String IS_FIRST_TIME = 'is_first_time';
  static const String USER_TYPE = "user_type";
  static const String USER_FCM_TOKEN = "userFcmToken";
  static const String USER_ID = 'user_ID';
  static const String IS_VERIFIED = "is_verify";
  static const String REFERAL_ID = 'referral_id';
  static const String CATEGORY_ID = 'category-id';
  static const String USER_ADDRESS = 'user-address';
  static const String USER_NAME = 'user_name';
  static const String FIRST_NAME = 'first_name';
  static const String LAST_NAME = 'last_name';
  static const String USER_IMAGE = 'user_image';
  static const String USER_EMAIL = 'user_email';
  static const String USER_MOBILE = 'phone';
  static const String COUNTRY_CODE = 'country_code';
  static const String ADMINPHONE = 'adminPhone';
  static const String LANGUAGEKEY = "languageKey";
  static const String ACCESS_TOKEN = "access_token";
  static const String NOTIFY_UPLOAD_COMPLETE = "notify_upload_complete";
  static const String LOGIN_PHONE = "login_phone";
  static const String LOGIN_PASSWORD = "login_password";
  static const String SLUG = "slug";
  static const String ACTIVITY_TRACKER = "activity_tracker";
  static const String DIALOG_TIMESTAMP = "dialog_timestamp";
  static const String ListAutoFill = "listAutoFill";
  static const String ShowNumberAutoFill = "showNumberAutoFill";
  static const String ShowNameHistory = "showNameHistory";
  static const String ExhibitorNameHistory = "exhibitorNameHistory";
  static const String USERFLAG = "userFlag";

  static Preference? _instance;

  static Future<Preference> get instance async {
    return await getInstance();
  }

  static SharedPreferences? _spf;

  Preference._();

  Future _init() async {
    _spf = await SharedPreferences.getInstance();
  }

  static Future<Preference> getInstance() async {
    _instance ??=  Preference._();
    if (_spf == null) {
      await _instance?._init();
    }
    return _instance!;
  }

  bool hasKey(String key) {
    Set keys = getKeys();
    return keys.contains(key);
  }

  Set<String> getKeys() {
    return _spf!.getKeys();
  }

  get(String key) {
    return _spf!.get(key);
  }

  getString(String key) {

    return _spf!.getString(key);
  }

  Future<bool> putString(String key, String value) {
    return _spf!.setString(key, value);
  }

  bool getBool(String key) {

    return _spf!.getBool(key) ?? false;
  }

  Future<bool> putBool(String key, bool value) {

    return _spf!.setBool(key, value);
  }

  int getInt(String key) {

    return _spf!.getInt(key) ?? 0;
  }

  Future<bool> putInt(String key, int value) {

    return _spf!.setInt(key, value);
  }

  double getDouble(String key) {

    return _spf!.getDouble(key) ?? 0.0;
  }

  Future<bool> putDouble(String key, double value) {

    return _spf!.setDouble(key, value);
  }

  List<String> getStringList(String key) {
    return _spf!.getStringList(key) ?? [];
  }

  Future<bool> putStringList(String key, List<String> value) {

    return _spf!.setStringList(key, value);
  }

  dynamic getDynamic(String key) {

    return _spf!.get(key);
  }

  Future<bool> remove(String key) {
    return _spf!.remove(key);
  }

  Future<bool> clear() {
    return _spf!.clear();
  }

  clearImportantKeys() {
    remove(USER_ID);
    remove(USER_NAME);
    remove(USER_EMAIL);
    remove(USER_MOBILE);
    remove(LANGUAGEKEY);
  }
}

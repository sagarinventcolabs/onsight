import 'package:on_sight_application/repository/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';


class AppInternetManager{

  String mAppInternetTable = 'app_internet_table';

  /// App Internet
  Future<bool> updateAppInternetStatus({required int appInternetStatus}) async {
    Database db = await DatabaseHelper().database;
    var dynamicc = await getSettingsTable() as List;
    Map<String, dynamic> map = {
      "AppInternetStatus":appInternetStatus
    };

    if(dynamicc.length==0){
      await db.insert(mAppInternetTable, map);
      return true;
    }else{
      String query="UPDATE $mAppInternetTable SET AppInternetStatus=$appInternetStatus";
      await db.rawQuery(query);
      return true;
    }

  }

  /// App Battery Toggle
  Future<bool> updateBatterySaverStatus({required int val}) async {
    Database db = await DatabaseHelper().database;
    var dynamicc = await getSettingsTable() as List;
    Map<String, dynamic> map = {
      "BatterySaverStatus":val
    };

    if(dynamicc.length==0){
      await db.insert(mAppInternetTable, map);
      return true;
    }else{
      String query="UPDATE $mAppInternetTable SET BatterySaverStatus=$val";
      await db.rawQuery(query);
      return true;
    }

  }

  /// Set Base Api Url
  Future<bool> setBaseUrl({required String val}) async {
    Database db = await DatabaseHelper().database;
    var dynamicc = await getSettingsTable() as List;
    Map<String, dynamic> map = {
      "BaseUrl":val
    };

    if(dynamicc.length==0){
      await db.insert(mAppInternetTable, map);
      return true;
    }else{
      String query="UPDATE $mAppInternetTable SET BaseUrl=$val";
      await db.rawQuery(query);
      return true;
    }

  }

  /// Set status of Task Progress
  Future<bool> updateTaskProgress({required int val}) async {
    Database db = await DatabaseHelper().database;
    var dynamicc = await getSettingsTable() as List;
    Map<String, dynamic> map = {
      "TaskInProgress":val
    };

    if(dynamicc.length==0){
      await db.insert(mAppInternetTable, map);
      return true;
    }else{
      String query="UPDATE $mAppInternetTable SET TaskInProgress=$val";
      await db.rawQuery(query);
      return true;
    }

  }

  /// Set status of Task Progress
  Future<bool> updateFlavor({required String val}) async {
    Database db = await DatabaseHelper().database;
    var dynamicc = await getSettingsTable() as List;
    Map<String, dynamic> map = {
      "Flavor":val
    };

    if(dynamicc.length==0){
      await db.insert(mAppInternetTable, map);
      return true;
    }else{
      String query="UPDATE $mAppInternetTable SET Flavor='$val'";
      await db.rawQuery(query);
      return true;
    }

  }

  /// App Camera Sound Toggle
  Future<bool> updateCameraShutterStatus({required int val}) async {
    Database db = await DatabaseHelper().database;
    var dynamicc = await getSettingsTable() as List;
    Map<String, dynamic> map = {
      "CameraShutterStatus":val
    };

    if(dynamicc.length==0){
      await db.insert(mAppInternetTable, map);
      return true;
    }else{
      String query="UPDATE $mAppInternetTable SET CameraShutterStatus=$val";
      await db.rawQuery(query);
      return true;
    }

  }

  Future<dynamic> getSettingsTable() async {
    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery('SELECT * FROM $mAppInternetTable');
    return result;
  }



  /// Upload Complete Status
  Future<bool> updateUploadNotifyStatus({required int uploadCompleteNotify}) async {
    Database db = await DatabaseHelper().database;
    var dynamicc = await getSettingsTable() as List;
    Map<String, dynamic> map = {
      "UploadCompleteStatus":uploadCompleteNotify
    };

    if(dynamicc.length==0){
      await db.insert(mAppInternetTable, map);
      return true;
    }else{
      String query="UPDATE $mAppInternetTable SET UploadCompleteStatus=$uploadCompleteNotify";
      await db.rawQuery(query);
      return true;
    }

  }


  /// App Camera Sound Toggle
  Future<bool> updateAuthenticationMode({required int value}) async {
    Database db = await DatabaseHelper().database;
    var dynamicc = await getSettingsTable() as List;
    Map<String, dynamic> map = {
      "AuthenticationMode":value
    };

    if(dynamicc.length==0){
      await db.insert(mAppInternetTable, map);
      return true;
    }else{
      String query="UPDATE $mAppInternetTable SET AuthenticationMode=$value";
      await db.rawQuery(query);
      return true;
    }

  }

  /// Ask Auth Pop up display
  Future<bool> updateAuthAsking({required int value}) async {
    Database db = await DatabaseHelper().database;
    var dynamicc = await getSettingsTable() as List;
    Map<String, dynamic> map = {
      "IsAskedAuth":value
    };

    if(dynamicc.length==0){
      await db.insert(mAppInternetTable, map);
      return true;
    }else{
      String query="UPDATE $mAppInternetTable SET IsAskedAuth=$value";
      await db.rawQuery(query);
      return true;
    }

  }

  Future<dynamic> getAuthPop()async{
    Database db = await DatabaseHelper().database;
    String query = "SELECT IsAskedAuth FROM $mAppInternetTable";
    var result = await db.rawQuery(query);
    return result.first["IsAskedAuth"];
  }
}
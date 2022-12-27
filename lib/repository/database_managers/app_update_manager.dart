import 'package:on_sight_application/repository/database/database_helper.dart';
import 'package:on_sight_application/repository/database_model/version_model.dart';
import 'package:sqflite/sqflite.dart';

class AppUpdateManager{

  String mAppUpdateTable = 'app_update_table';

  /// App Internet
  Future<bool> insertVersion(version, releaseType) async {
    Database db = await DatabaseHelper().database;
    Map<String, dynamic> map = {
      "Version":version,
      "ReleaseType":releaseType,
      "UpdateStatus":0,
      "isAlert":1
    };
    var dynamicc = await existOrNot(version);

    if(dynamicc.toString()=="false"){
     await db.insert(mAppUpdateTable, map);
      return true;
    }

    return true;
  }

  Future<dynamic> updateStatus(String Version,int status) async {
    Database db = await DatabaseHelper().database;
    String query="UPDATE $mAppUpdateTable SET UpdateStatus=$status WHERE Version='$Version'";
    var result = await db.rawQuery(query);
    return result;
  }

  Future<dynamic> existOrNot(String version) async {
    Database db = await DatabaseHelper().database;
    String query="SELECT CASE WHEN count(RowID) > 0 THEN 'true' ELSE 'false' END as result from $mAppUpdateTable where Version = '$version'";
    var result = await db.rawQuery(query);
    if(result.isNotEmpty){
      return result.first['result'];
    }
    return false;
  }


  Future<VersionDetails> getVersionDetails(String Version) async {
    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery(
        "SELECT * FROM $mAppUpdateTable WHERE Version= '$Version'");
    List<VersionDetails> list = result.isNotEmpty ? result.map((c) =>
        VersionDetails.fromJson(c)).toList() : [];
    if (list.isNotEmpty) {
      return list.first;

    } else {
      return VersionDetails();
    }
  }

  Future<List<VersionDetails>> getImageList() async {

    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery('SELECT * FROM $mAppUpdateTable');
    List<VersionDetails> list = result.isNotEmpty ? result.map((c) => VersionDetails.fromJson(c)).toList() : [];
    return list;


  }
}
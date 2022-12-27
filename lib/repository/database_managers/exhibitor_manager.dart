import 'package:on_sight_application/repository/database/database_helper.dart';
import 'package:on_sight_application/repository/web_service_response/lead_sheet_response.dart';
import 'package:sqflite/sqflite.dart';


class ExhibitorManager{

  String mShowTable = 'show_table';
  String mExhibitorTable = 'exhibitor_table';



  Future<int> insertExhibitors(Exhibitors showModel) async {
    Database db = await DatabaseHelper().database;
    var rs = -1;
    var a = await existOrNot(showModel.exhibitorId.toString());
    if(a=="false"){
      rs= await db.insert(mExhibitorTable, showModel.toMap());
    }else{
      String query="UPDATE ${mExhibitorTable} SET ShowNumber = '${showModel.showNumber}', ExhibitorName = '${showModel.exhibitorName}', BoothSize = '${showModel.boothSize.toString()}', BoothNumber = '${showModel.boothNumber}', Shop = '${showModel.shop}', SetupCompany = '${showModel.setupCompany}', Notes = '${showModel.notes}', FolderUrl = '${showModel.folderUrl}', ExhibitorImageCount = '${showModel.exhibitorImageCount}', IsHighPriority = '${showModel.isHighPriority}', ExhibitorGuid = '${showModel.exhibitorGuid}', ExhibitorId = '${showModel.exhibitorId}', YetToSubmit = '${showModel.yetToSubmit}', ShowName = '${showModel.showName}' WHERE ExhibitorId = '${showModel.exhibitorId.toString()}';";
     // rs= await db.update(mExhibitorTable, showModel.toJson(), where: "ExhibitorId", whereArgs: [showModel.exhibitorId]);
      await db.rawQuery(query);
      return 0;
    }
    return rs;
  }

  Future<int> updateYetToSubmit(yetToSubmit, exhibitorId) async {
    Database db = await DatabaseHelper().database;

      String query="UPDATE ${mExhibitorTable} SET YetToSubmit = '${yetToSubmit}' WHERE ExhibitorId = '${exhibitorId}';";
      // rs= await db.update(mExhibitorTable, showModel.toJson(), where: "ExhibitorId", whereArgs: [showModel.exhibitorId]);
      await db.rawQuery(query);
      return 0;

  }

  Future<List<Exhibitors>> getExhibitors(String showNumber) async {

    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery('SELECT * FROM $mExhibitorTable' +" WHERE ShowNumber='"+showNumber+"'");
    List<Exhibitors> list = result.isNotEmpty ? result.map((c) => Exhibitors.fromDb(c)).toList() : [];
    return list;

  }



  Future<int> deleteShow(String showNumber) async {

    Database db = await DatabaseHelper().database;
    await db.rawQuery("DELETE FROM $mExhibitorTable WHERE ShowNumber='"+showNumber+"'");
    return 1;
  }
  Future<int> deleteAllData() async {

    Database db = await DatabaseHelper().database;
    await db.rawQuery("DELETE FROM $mExhibitorTable");
    return 1;
  }

  Future<dynamic> existOrNot(String ExhibitorId) async {
    Database db = await DatabaseHelper().database;
    String query="SELECT CASE WHEN count(RowID) > 0 THEN 'true' ELSE 'false' END as result from $mExhibitorTable where ExhibitorId = '$ExhibitorId'";
    var result = await db.rawQuery(query);
    if(result.isNotEmpty){
      return result.first['result'];
    }
    return false;
  }







  Future<dynamic>getCount() async {

    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery("SELECT COUNT(*) FROM ${mExhibitorTable}");
    return result.first["COUNT(*)"];
  }
}
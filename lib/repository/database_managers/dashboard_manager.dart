import 'package:on_sight_application/repository/database/database_helper.dart';
import 'package:on_sight_application/repository/web_service_response/security_flags_model.dart';
import 'package:sqflite/sqflite.dart';


class DashboardManager{

  /// Variable for dashboard table name
  String mDashboardTable = 'dashboard_table';


  /// Method for insert menu items
  Future<int> insertMenu(SecurityFlagsModel flagsModel) async {
    Database db = await DatabaseHelper().database;
    var rs = -1;
    if(await existOrNot(flagsModel.menuItems.toString())=="false"){
      rs= await db.insert(mDashboardTable, flagsModel.toMap());
    }else{
      rs= await db.update(mDashboardTable, flagsModel.toMap(), where: 'MenuItems=?', whereArgs: [flagsModel.menuItems]);
    }


    return rs;
  }
  /// Method for get menu items by  menu  item name
  Future<int> getMenuVisibility(String menuItem) async {

    Database db = await DatabaseHelper().database;
    var result;
    // if(menuItem==jobUpdates){
    //   print("Condition 1");
    //   var result1 = await db.rawQuery('SELECT * FROM $mDashboardTable' +" WHERE MenuItems='"+jobPhotos+"'");
    //   var result2 = await db.rawQuery('SELECT * FROM $mDashboardTable' +" WHERE MenuItems='"+projectEvaluation+"'");
    //   print("Result1 $result1");
    //   print("Result2 $result2");
    //   var a,b;
    //
    //   if(result1.isNotEmpty) {
    //     a = result1.first["isAllowed"] as int;
    //
    //   }else{
    //     a= 0;
    //   }
    //
    //   if(result2.isNotEmpty) {
    //     b = result2.first["isAllowed"] as int;
    //
    //   }else{
    //     b = 0;
    //   }
    //   print("a $a");
    //   print("b $b");
    //   if(a==1 || b==1){
    //     return 1;
    //   }else{
    //     return 0;
    //   }
    // }else {
      result = await db.rawQuery(
          'SELECT * FROM $mDashboardTable' + " WHERE MenuItems='" + menuItem +
              "'");
      if(result!=null){
        if(result.isNotEmpty) {
          var a = result.first["isAllowed"] as int;
          return a;
        }else{
          return 0;
        }
      }else{
        return 0;
      }
   // }

  }

  /// Method for delete all data from dashboard table
  Future<dynamic> deleteAllData()async{
    Database db = await DatabaseHelper().database;
    String query="DELETE FROM $mDashboardTable";
    var result = await db.rawQuery(query);
    return result;

  }

  /// Method for checking if item exist or not
  Future<dynamic> existOrNot(String menuItem) async {
    Database db = await DatabaseHelper().database;
    String query="SELECT CASE WHEN count(RowID) > 0 THEN 'true' ELSE 'false' END as result from $mDashboardTable where MenuItems = '$menuItem'";
    var result = await db.rawQuery(query);
    if(result.isNotEmpty){
      return result.first['result'];
    }
    return false;
  }

  /// Method for getting all menu items
  Future<dynamic> getAllData()async{
    Database db = await DatabaseHelper().database;
    String query="SELECT * FROM $mDashboardTable";
    var result = await db.rawQuery(query);
    List<SecurityFlagsModel> flagList = result.isNotEmpty?result.map((e) => SecurityFlagsModel.fromDBJson(e)).toList():[];
    return flagList;

  }
}
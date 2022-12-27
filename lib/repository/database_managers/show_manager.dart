import 'package:flutter/material.dart';
import 'package:on_sight_application/repository/database/database_helper.dart';
import 'package:on_sight_application/repository/web_service_response/lead_sheet_response.dart';
import 'package:sqflite/sqflite.dart';


class ShowManager{

  String mShowTable = 'show_table';



  Future<int> insertShow(LeadSheetResponse showModel) async {
    Database db = await DatabaseHelper().database;
    var rs = -1;
    var a = await existOrNot(showModel.showNumber.toString());
    if(a=="false"){
      rs= await db.insert(mShowTable, showModel.showDetails!.toMap());
    }
    return rs;
  }

  Future<ShowDetails> getShow(String showNumber) async {

    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery('SELECT * FROM $mShowTable' +" WHERE ShowNumber='"+showNumber+"'");
    List<ShowDetails> list = result.isNotEmpty ? result.map((c) => ShowDetails.fromDb(c)).toList() : [];
    return list.first;

  }



  Future<int> deleteShow(String showNumber) async {

    Database db = await DatabaseHelper().database;
    await db.rawQuery("DELETE FROM $mShowTable WHERE ShowNumber='"+showNumber+"'");
    return 1;
  }
  Future<int> deleteAllData() async {

    Database db = await DatabaseHelper().database;
    await db.rawQuery("DELETE FROM $mShowTable");
    return 1;
  }

  Future<dynamic> existOrNot(String showNumber) async {
    Database db = await DatabaseHelper().database;
    String query="SELECT CASE WHEN count(RowID) > 0 THEN 'true' ELSE 'false' END as result from $mShowTable where ShowNumber = '$showNumber'";
    var result = await db.rawQuery(query);
    if(result.isNotEmpty){
      return result.first['result'];
    }
    return false;
  }




  Future<dynamic>getCount() async {


    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery("SELECT COUNT(*) FROM ${mShowTable}");
    debugPrint(result.toString());

    return result.first["COUNT(*)"];
  }
}
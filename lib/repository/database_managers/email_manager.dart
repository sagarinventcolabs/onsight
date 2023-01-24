import 'dart:developer';

import 'package:on_sight_application/repository/database/database_helper.dart';
import 'package:on_sight_application/repository/database_model/email.dart';
import 'package:sqflite/sqflite.dart';

class EmailManager{

  String mEmailTable = 'email_table';

  Future<dynamic> updateEmail(String emailId,int status) async {
    Database db = await DatabaseHelper().database;
    String query="UPDATE $mEmailTable SET EmailOnProgress=$status WHERE AdditionalEmail='$emailId'";
    var result = await db.rawQuery(query);
    return result;
  }

  Future<dynamic> updateEmailStatus(String emailId,int status) async {
    Database db = await DatabaseHelper().database;
    String query="UPDATE $mEmailTable SET EmailOnProgress=$status WHERE AdditionalEmail='$emailId'";
    var result = await db.rawQuery(query);
    return result;
  }
  Future<int> insertAdditionalEmail(Email email) async {
    Database db = await DatabaseHelper().database;
    var rs = -1;
    print(await existOrNot(email.additionalEmail.toString(), email.jobNumber.toString()));
    if(await existOrNot(email.additionalEmail.toString(), email.jobNumber.toString())=="false"){

      rs= await db.insert(mEmailTable, email.toMap());
    }else{
      updateEmail(email.additionalEmail.toString(), email.emailOnProgress??1);
    }

    return rs;
  }

  Future<List<Email>> getEmailRecord(String jobNumber) async {

    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery('SELECT * FROM $mEmailTable' +" WHERE lower(JobNumber)='"+jobNumber+"'"+"OR upper(JobNumber)='"+jobNumber+"'");
    List<Email> list = result.isNotEmpty ? result.map((c) => Email.fromJson(c)).toList() : [];

    return list;
  }
  Future<List<Email>> getEmailRecordInitialize(String jobNumber) async {

    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery('SELECT * FROM $mEmailTable' +" WHERE lower(JobNumber)='"+jobNumber+"'"+"OR upper(JobNumber)='"+jobNumber+"'"+"AND EmailOnProgress !='"+'${2}'+"'");
    List<Email> list = result.isNotEmpty ? result.map((c) => Email.fromJson(c)).toList() : [];
    log(list.toString());
    return list;
  }

  Future<List<Email>> getAllRecord() async {

    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery('SELECT * FROM $mEmailTable');
    List<Email> list = result.isNotEmpty ? result.map((c) => Email.fromJson(c)).toList() : [];
    list.forEach((element) {
      print(element.jobNumber.toString()+" - "+element.additionalEmail.toString()+" - "+element.emailOnProgress.toString());
    });
    return list;
  }
  Future<int> updateEmailData(String emailId) async {
    Database db = await DatabaseHelper().database;
    await db.transaction((txn) {
      Map<String, dynamic> row = {
        'AdditionalEmail': emailId,
      };
      return txn.update(mEmailTable, row,
          where: "AdditionalEmail = ?", whereArgs: [emailId]);
    });
    return 1;
  }
  Future<int> deleteEmail(String emailId, String jobNumber) async {

    Database db = await DatabaseHelper().database;
    await db.rawQuery("DELETE FROM $mEmailTable WHERE AdditionalEmail='"+emailId+"' AND JobNumber='"+jobNumber+"'");
    return 1;
  }

  Future<int> deleteEmailFromAPI(String jobNumber) async {

    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery("DELETE FROM $mEmailTable WHERE lower(JobNumber)='"+jobNumber+"' OR upper(JobNumber)='"+jobNumber+"'"+"AND EmailOnProgress !=${1}");
    log("Result delete = "+result.toString());
    return 1;
  }


  Future<dynamic> existOrNot(String email, String jobNumber) async {
    Database db = await DatabaseHelper().database;
    String query="SELECT CASE WHEN count(RowID) > 0 THEN 'true' ELSE 'false' END as result from $mEmailTable where AdditionalEmail = '$email' AND JobNumber LIKE '$jobNumber'" ;
    var result = await db.rawQuery(query);

    if(result.isNotEmpty){
      return result.first['result'];
    }
    return false;
  }

}
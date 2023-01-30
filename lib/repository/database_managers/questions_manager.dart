import 'package:flutter/material.dart';
import 'package:on_sight_application/repository/database/database_helper.dart';
import 'package:on_sight_application/repository/web_service_response/get_project_evaluation_questions_response.dart';
import 'package:sqflite/sqflite.dart';


class QuestionsManager{

  String mEvaluationQuestionTable = 'evaluation_question_table';
  String mEvaluationAdditionalInfoTable = 'evaluation_additional_info_table';


  Future<int> updateCategory(QuestionnaireDataList response) async {
    Database db = await DatabaseHelper().database;
    var result= await db.update(mEvaluationQuestionTable, response.toMap(), where: 'QuestionID=?', whereArgs: [response.questionID]);
    return result;
  }

  Future<int> insertQuestions(QuestionnaireDataList categoryModel) async {
    Database db = await DatabaseHelper().database;
    var rs = -1;
    var a = await existOrNot(categoryModel.questionID.toString());
    if(a=="false"){
      rs= await db.insert(mEvaluationQuestionTable, categoryModel.toMap());
    }/*else{
      rs= await db.update(mEvaluationQuestionTable, categoryModel.toMap());
    }*/
    return rs;
  }
  Future<int> insertAdditionalInfo(GetProjectEvaluationQuestionsResponse categoryModel) async {
    Database db = await DatabaseHelper().database;
    var rs = -1;
    var a = await existOrNotAdditional(categoryModel.categoryName.toString());
    if(a=="false"){
      rs= await db.insert(mEvaluationAdditionalInfoTable, categoryModel.toMap());
    }/*else{
      rs= await db.update(mEvaluationQuestionTable, categoryModel.toMap());
    }*/
    return rs;
  }

  Future<List<QuestionnaireDataList>> getCategory(String categoryName) async {

    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery('SELECT * FROM $mEvaluationQuestionTable' +" WHERE CategoryName='"+categoryName+"'");
    List<QuestionnaireDataList> list = result.isNotEmpty ? result.map((c) => QuestionnaireDataList.fromJson(c)).toList() : [];
    return list;
  }

  Future<int> updateEmailData(String emailId) async {
    Database db = await DatabaseHelper().database;
    await db.transaction((txn) {
      Map<String, dynamic> row = {
        'AdditionalEmail': emailId,
      };
      return txn.update(mEvaluationQuestionTable, row,
          where: "AdditionalEmail = ?", whereArgs: [emailId]);
    });
    return 1;
  }

  Future<int> deleteCategory(String emailId, String jobNumber) async {

    Database db = await DatabaseHelper().database;
    await db.rawQuery("DELETE FROM $mEvaluationQuestionTable WHERE AdditionalEmail='"+emailId+"' AND JobNumber='"+jobNumber+"'");
    return 1;
  }
  Future<int> deleteAllData() async {

    Database db = await DatabaseHelper().database;
    await db.rawQuery("DELETE FROM $mEvaluationQuestionTable");
    return 1;
  }

  Future<dynamic> existOrNot(String questionID) async {
    Database db = await DatabaseHelper().database;
    String query="SELECT CASE WHEN count(RowID) > 0 THEN 'true' ELSE 'false' END as result from $mEvaluationQuestionTable where QuestionID = '$questionID'";
    var result = await db.rawQuery(query);
    if(result.isNotEmpty){
      return result.first['result'];
    }
    return false;
  }
  Future<dynamic> existOrNotAdditional(String categoryName) async {
    Database db = await DatabaseHelper().database;
    String query="SELECT CASE WHEN count(RowID) > 0 THEN 'true' ELSE 'false' END as result from $mEvaluationAdditionalInfoTable where CategoryName = '$categoryName'";
    var result = await db.rawQuery(query);
    if(result.isNotEmpty){
      return result.first['result'];
    }
    return false;
  }


  Future<List<QuestionnaireDataList>> getQuestionsList(categoryName) async {

    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery("SELECT * FROM $mEvaluationQuestionTable WHERE CategoryName = '$categoryName'");
    List<QuestionnaireDataList> list = result.isNotEmpty ? result.map((c) => QuestionnaireDataList.fromDatabase(c)).toList() : [];
    return list;

  }

  Future<GetProjectEvaluationQuestionsResponse> getModel(categoryName) async {

    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery("SELECT * FROM $mEvaluationAdditionalInfoTable WHERE CategoryName = '$categoryName'");
    GetProjectEvaluationQuestionsResponse model = GetProjectEvaluationQuestionsResponse.saveInDB(result.first);
    return model;

  }

  Future<dynamic>getCount() async {


    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery("SELECT COUNT(*) FROM ${mEvaluationQuestionTable}");
    //var result = await db.rawQuery("SELECT SUM(IsSubmitted) FROM ${mImageDataTable} WHERE IsSubmitted= '1' AND CategoryId= '${categoryId}';");

    debugPrint(result.toString());

    return result.first["COUNT(*)"];
  }
}
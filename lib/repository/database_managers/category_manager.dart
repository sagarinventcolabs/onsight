import 'package:on_sight_application/repository/database/database_helper.dart';
import 'package:on_sight_application/repository/web_service_response/job_categories_response.dart';
import 'package:sqflite/sqflite.dart';


class CategoryManager{

  String mCategoryTable = 'category_table';

  Future<bool> updateIsChecked(String categoryId,int status) async {
    Database db = await DatabaseHelper().database;
    String query="UPDATE $mCategoryTable SET isChecked=$status WHERE Id='$categoryId'";
    await db.rawQuery(query);
    return true;
  }

  Future<int> updateCategory(JobCategoriesResponse response) async {
    Database db = await DatabaseHelper().database;
    var result= await db.update(mCategoryTable, response.toMap(), where: 'Id=?', whereArgs: [response.id]);
    return result;
  }

  Future<int> insertCategory(JobCategoriesResponse categoryModel) async {
    Database db = await DatabaseHelper().database;
    var rs = -1;
    if(await existOrNot(categoryModel.id.toString())=="false"){
      rs= await db.insert(mCategoryTable, categoryModel.toMap());
    }


    return rs;
  }

  Future<JobCategoriesResponse> getCategory(String jobNumber, categoryId) async {

    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery('SELECT * FROM $mCategoryTable' +" WHERE JobNumber='"+jobNumber+"'"+" AND Id="+'${categoryId}');
    List<JobCategoriesResponse> list = result.isNotEmpty ? result.map((c) => JobCategoriesResponse.fromJson(c,0)).toList() : [];
    if(list.isEmpty){
      return JobCategoriesResponse();
    }else{
      return list.first;
    }
  }

  Future<int> updateEmailData(String emailId) async {
    Database db = await DatabaseHelper().database;
    await db.transaction((txn) {
      Map<String, dynamic> row = {
        'AdditionalEmail': emailId,
      };
      return txn.update(mCategoryTable, row,
          where: "AdditionalEmail = ?", whereArgs: [emailId]);
    });
    return 1;
  }

  Future<int> deleteCategory(String emailId, String JobNumber) async {

    Database db = await DatabaseHelper().database;
    await db.rawQuery("DELETE FROM $mCategoryTable WHERE AdditionalEmail='"+emailId+"' AND JobNumber='"+JobNumber+"'");
    return 1;
  }


  Future<dynamic> existOrNot(String categoryId) async {
    Database db = await DatabaseHelper().database;
    String query="SELECT CASE WHEN count(RowID) > 0 THEN 'true' ELSE 'false' END as result from $mCategoryTable where Id = '$categoryId'";
    var result = await db.rawQuery(query);
    if(result.isNotEmpty){
      return result.first['result'];
    }
    return false;
  }


  Future<List<JobCategoriesResponse>> getCategoryList() async {

    Database db = await DatabaseHelper().database;
    await db.rawQuery('SELECT * FROM $mCategoryTable');
    List<JobCategoriesResponse> list = [];
   // List<JobCategoriesResponse> list = result.isNotEmpty ? result.map((c) => JobCategoriesResponse.fromJson(c)).toList() : [];
    return list;


  }
}
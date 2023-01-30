import 'package:on_sight_application/repository/database/database_helper.dart';
import 'package:on_sight_application/repository/database_model/field_issue_image_model.dart';
import 'package:on_sight_application/repository/database_model/lead_sheet_image_model.dart';
import 'package:sqflite/sqflite.dart';

class FieldIssueImageManager {

  String mFieldIssueImageTable = 'field_issue_image_table';



  Future<int> insertImage(FieldIssueImageModel imageModel) async {
    Database db = await DatabaseHelper().database;
    var dynamic = await existOrNot(imageModel.imageName!);
    if(dynamic.toString()=="false") {
      var rs = db.insert(mFieldIssueImageTable, imageModel.toMap());
      return rs;
    }
    FieldIssueImageModel model = await getImageByImageName(imageModel.imageName!);
    String query="UPDATE ${mFieldIssueImageTable} SET ImageNote = '${imageModel.imageNote}' WHERE RowID = ${model.rowID.toString()};";
    await db.rawQuery(query);
      return model.rowID!;

    }

  Future<int> updateImageData(FieldIssueImageModel imageModel) async {
    Database db = await DatabaseHelper().database;
    var result= await db.update(mFieldIssueImageTable, imageModel.toMap(), where: 'RowID=?', whereArgs: [imageModel.rowID]);
    return result;
  }


  Future<dynamic> existOrNot(String imageName) async {
    Database db = await DatabaseHelper().database;
    String query="SELECT CASE WHEN count(RowID) > 0 THEN 'true' ELSE 'false' END as result from $mFieldIssueImageTable where ImageName = '$imageName'";
    var result = await db.rawQuery(query);
    if(result.isNotEmpty){
      return result.first['result'];
    }
    return false;
  }


  Future<List<FieldIssueImageModel>> getImageList() async {

    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery('SELECT * FROM $mFieldIssueImageTable');
    List<FieldIssueImageModel> list = result.isNotEmpty ? result.map((c) => FieldIssueImageModel.fromJson(c)).toList() : [];
    return list;


  }

  Future<List<LeadSheetImageModel>> getImageByExhibitorIdandShowNumber(String exhibitorId, String showNumber) async {

    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery("SELECT * FROM $mFieldIssueImageTable WHERE ExhibitorId = '"+exhibitorId+"' AND ShowNumber='"+showNumber+"'"+" AND IsSubmitted= '0'");
    List<LeadSheetImageModel> list = result.isNotEmpty ? result.map((c) => LeadSheetImageModel.fromJson(c)).toList() : [];
    return list;
  }

  Future<int> deleteImage(int id) async {
    Database db = await DatabaseHelper().database;
    await db.rawQuery("DELETE FROM $mFieldIssueImageTable WHERE RowID='"+id.toString()+"'");
    return 1;
  }


  Future<FieldIssueImageModel> getImageByImageName(String imageName) async {

    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery("SELECT * FROM $mFieldIssueImageTable WHERE ImageName = '$imageName'");
    List<FieldIssueImageModel> list = result.isNotEmpty ? result.map((c) => FieldIssueImageModel.fromJson(c)).toList() : [];
    if(list.isNotEmpty){
      return list.first;
    }else{
      return FieldIssueImageModel();
    }

  }

   getAllData() async {
    Database db = await DatabaseHelper().database;
    await db.rawQuery("SELECT * FROM $mFieldIssueImageTable");
  }


  Future<dynamic>getCount(exhibitorId) async {
    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery("SELECT SUM(IsSubmitted) FROM ${mFieldIssueImageTable} WHERE ExhibitorId= '${exhibitorId}';");
    return result;
  }

  Future<dynamic>getYetToSubmitCount(exhibitorId, showNumber) async {


    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery("SELECT COUNT(*) FROM ${mFieldIssueImageTable} WHERE ExhibitorId= '${exhibitorId}' AND IsSubmitted= '0' AND ShowNumber= '${showNumber}';");
    if(result.isNotEmpty){
      return result.first['COUNT(*)'];
    }
    return 0;
  }


  Future<int> updateYetToSubmit(yetToSubmit, exhibitorId) async {
    Database db = await DatabaseHelper().database;
    String query="UPDATE ${mFieldIssueImageTable} SET IsSubmitted = '${yetToSubmit}' WHERE ExhibitorId = '${exhibitorId}';";
    await db.rawQuery(query);
    return 0;

  }

}
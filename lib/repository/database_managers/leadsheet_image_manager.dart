import 'package:on_sight_application/repository/database/database_helper.dart';
import 'package:on_sight_application/repository/database_model/lead_sheet_image_model.dart';
import 'package:sqflite/sqflite.dart';


class LeadSheetImageManager {

  String mExhibitorImageTable = 'exhibitor_image_table';



  Future<int> insertImage(LeadSheetImageModel imageModel) async {
    Database db = await DatabaseHelper().database;
    var dynamic = await existOrNot(imageModel.imageName!);
    if(dynamic.toString()=="false") {
      var rs = db.insert(mExhibitorImageTable, imageModel.toMap());

      return rs;
    }
    LeadSheetImageModel model = await getImageByImageName(imageModel.imageName!);
    String query="UPDATE ${mExhibitorImageTable} SET ImageNote = '${imageModel.imageNote}' WHERE RowID = ${model.rowID.toString()};";
    await db.rawQuery(query);
      return model.rowID!;

    }

  Future<int> updateImageData(LeadSheetImageModel imageModel) async {
    Database db = await DatabaseHelper().database;
    var result= await db.update(mExhibitorImageTable, imageModel.toMap(), where: 'RowID=?', whereArgs: [imageModel.rowID]);
    return result;
  }


  Future<dynamic> existOrNot(String imageName) async {
    Database db = await DatabaseHelper().database;
    String query="SELECT CASE WHEN count(RowID) > 0 THEN 'true' ELSE 'false' END as result from $mExhibitorImageTable where ImageName = '$imageName'";
    var result = await db.rawQuery(query);
    if(result.isNotEmpty){
      return result.first['result'];
    }
    return false;
  }


  Future<List<LeadSheetImageModel>> getImageList() async {

    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery('SELECT * FROM $mExhibitorImageTable');
    List<LeadSheetImageModel> list = result.isNotEmpty ? result.map((c) => LeadSheetImageModel.fromJson(c)).toList() : [];
    return list;


  }

  Future<List<LeadSheetImageModel>> getImageByExhibitorIdandShowNumber(String ExhibitorId, String ShowNumber) async {

    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery("SELECT * FROM $mExhibitorImageTable WHERE ExhibitorId = '"+ExhibitorId+"' AND ShowNumber='"+ShowNumber+"'"+" AND IsSubmitted= '0'");
    List<LeadSheetImageModel> list = result.isNotEmpty ? result.map((c) => LeadSheetImageModel.fromJson(c)).toList() : [];
    return list;
  }

  Future<int> deleteImage(int id) async {
    Database db = await DatabaseHelper().database;
    await db.rawQuery("DELETE FROM $mExhibitorImageTable WHERE RowID='"+id.toString()+"'");
    return 1;
  }


  Future<LeadSheetImageModel> getImageByImageName(String ImageName) async {

    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery("SELECT * FROM $mExhibitorImageTable WHERE ImageName = '$ImageName'");
    List<LeadSheetImageModel> list = result.isNotEmpty ? result.map((c) => LeadSheetImageModel.fromJson(c)).toList() : [];
    if(list.isNotEmpty){
      return list.first;
    }else{
      return LeadSheetImageModel();
    }

  }

   getAllData() async {
    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery("SELECT * FROM $mExhibitorImageTable");
    print(result);
  }


  Future<dynamic>getCount(ExhibitorId) async {
    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery("SELECT SUM(IsSubmitted) FROM ${mExhibitorImageTable} WHERE ExhibitorId= '${ExhibitorId}';");
    return result;
  }

  Future<dynamic>getYetToSubmitCount(exhibitorId, showNumber) async {


    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery("SELECT COUNT(*) FROM ${mExhibitorImageTable} WHERE ExhibitorId= '${exhibitorId}' AND IsSubmitted= '0' AND ShowNumber= '${showNumber}';");
    if(result.isNotEmpty){
      return result.first['COUNT(*)'];
    }
    return 0;
  }


  Future<int> updateYetToSubmit(yetToSubmit, exhibitorId) async {
    Database db = await DatabaseHelper().database;
    String query="UPDATE ${mExhibitorImageTable} SET IsSubmitted = '${yetToSubmit}' WHERE ExhibitorId = '${exhibitorId}';";
    await db.rawQuery(query);
    return 0;

  }


  Future<List<LeadSheetImageModel>> getFailedImage(String ExhibitorId, String ShowNumber) async {

    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery("SELECT * FROM $mExhibitorImageTable WHERE ExhibitorId = '"+ExhibitorId+"' AND ShowNumber='"+ShowNumber+"'"+" AND IsSubmitted= '1'");
    List<LeadSheetImageModel> list = result.isNotEmpty ? result.map((c) => LeadSheetImageModel.fromJson(c)).toList() : [];
    return list;
  }

}
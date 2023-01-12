import 'package:on_sight_application/repository/database/database_helper.dart';
import 'package:on_sight_application/repository/database_model/image_model.dart';
import 'package:sqflite/sqflite.dart';

class ImageManager{

  String mImageDataTable = 'image_data_table';



  Future<int> insertImage(ImageModel imageModel) async {
    Database db = await DatabaseHelper().database;
    var dynamic = await existOrNot(imageModel.imageName!);
    if(dynamic.toString()=="false") {
      var rs = db.insert(mImageDataTable, imageModel.toMap());

      return rs;
    }
    ImageModel model = await getImageByImageName(imageModel.imageName!);
   // String query="UPDATE ${mImageDataTable} SET ImageNote = '${imageModel.imageNote}' WHERE RowID = ${model.rowID.toString()};";
    var result= await db.update(mImageDataTable, imageModel.toMap(), where: 'RowID=?', whereArgs: [imageModel.rowID]);
    await result;
      return model.rowID!;

    }

  Future<int> updateImageData(ImageModel imageModel) async {
    Database db = await DatabaseHelper().database;
    var result= await db.update(mImageDataTable, imageModel.toMap(), where: 'RowID=?', whereArgs: [imageModel.rowID]);
    return result;
  }
  Future<dynamic> updateSendEmail(val, catId) async {
    Database db = await DatabaseHelper().database;
    String query="UPDATE $mImageDataTable SET IsEmailRequired=$val where CategoryId = '$catId'";
    var result = await db.rawQuery(query);
    return result;
  }


  Future<dynamic> existOrNot(String imageName) async {
    Database db = await DatabaseHelper().database;
    String query="SELECT CASE WHEN count(RowID) > 0 THEN 'true' ELSE 'false' END as result from $mImageDataTable where ImageName = '$imageName'";
    var result = await db.rawQuery(query);
    if(result.isNotEmpty){
      return result.first['result'];
    }
    return false;
  }


  Future<List<ImageModel>> getImageList() async {

    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery('SELECT * FROM $mImageDataTable');
    List<ImageModel> list = result.isNotEmpty ? result.map((c) => ImageModel.fromJson(c)).toList() : [];
    return list;


  }

  Future<List<ImageModel>> getFailedImageList() async {

    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery('SELECT * FROM $mImageDataTable WHERE IsSubmitted= 1');
    List<ImageModel> imageList = result.isNotEmpty ? result.map((c) => ImageModel.fromJson(c)).toList() : [];
    return imageList;


  }

  Future<List<ImageModel>> getImageByCategoryIdandJobNumber(String categoryId, String JobNumber) async {

    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery("SELECT * FROM $mImageDataTable WHERE CategoryId LIKE '"+categoryId+"' AND JobNumber LIKE '"+JobNumber+"'"+" AND IsSubmitted= '0'");
    List<ImageModel> list = result.isNotEmpty ? result.map((c) => ImageModel.fromJson(c)).toList() : [];
    return list;
  }

  Future<dynamic> deleteImage(name) async {
    Database db = await DatabaseHelper().database;
    await db.rawQuery("DELETE FROM $mImageDataTable WHERE ImageName='"+name.toString()+"'");
    return ;
  }


  Future<ImageModel> getImageByImageName(String ImageName) async {

    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery("SELECT * FROM $mImageDataTable WHERE ImageName = '$ImageName'");
    List<ImageModel> list = result.isNotEmpty ? result.map((c) => ImageModel.fromJson(c)).toList() : [];
    if(list.isNotEmpty){
      return list.first;
    }else{
      return ImageModel();
    }

  }


  Future<dynamic>getCount(categoryId) async {


    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery("SELECT SUM(IsSubmitted), CategoryName FROM ${mImageDataTable} WHERE CategoryId= '${categoryId}';");
    //var result = await db.rawQuery("SELECT SUM(IsSubmitted) FROM ${mImageDataTable} WHERE IsSubmitted= '1' AND CategoryId= '${categoryId}';");


    return result;
  }

  Future<dynamic>getYetToSubmitCount(categoryId, jobNumber) async {


    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery("SELECT COUNT(*), CategoryName FROM ${mImageDataTable} WHERE CategoryId= '${categoryId}' AND IsSubmitted= '0' AND JobNumber= '${jobNumber}';");
    //var result = await db.rawQuery("SELECT SUM(IsSubmitted) FROM ${mImageDataTable} WHERE IsSubmitted= '1' AND CategoryId= '${categoryId}';");


    return result;
  }
}
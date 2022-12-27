import 'package:on_sight_application/repository/database/database_helper.dart';
import 'package:on_sight_application/repository/database_model/image_count.dart';
import 'package:sqflite/sqflite.dart';

class ImageCountManager{

  String mImageCountTable = 'image_count_table';

  Future<dynamic> insertImageCount(ImageCount imageModel) async {
    Database db = await DatabaseHelper().database;
    var dynamic = await existOrNot(imageModel.categoryId!, imageModel.jobNumber);
    if(dynamic.toString()=="false") {
      var rs = db.insert(mImageCountTable, imageModel.toMap());

      return rs;
    }
    var result= await db.update(mImageCountTable, imageModel.toMap(), where: 'CategoryId=?', whereArgs: [imageModel.categoryId]);

    return result;

  }

  Future<ImageCount> getCountByCategoryName(String CategoryId, jobnumber) async {

    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery("SELECT * FROM $mImageCountTable WHERE CategoryId = '$CategoryId' AND JobNumber = '${jobnumber}'");
    List<ImageCount> list = result.isNotEmpty ? result.map((c) => ImageCount.fromJson(c)).toList() : [];
    if(list.isNotEmpty){
      return list.first;
    }else{
      return ImageCount();
    }

  }

  Future<dynamic> existOrNot(String CategoryId, jobnumber) async {
    Database db = await DatabaseHelper().database;
    String query="SELECT CASE WHEN count(RowID) > 0 THEN 'true' ELSE 'false' END as result from $mImageCountTable where CategoryId = '$CategoryId' AND JobNumber = '$jobnumber'";
    var result = await db.rawQuery(query);
    if(result.isNotEmpty){
      return result.first['result'];
    }
    return false;
  }

  Future<dynamic> getCount(String categoryId, String JobNumber) async {
    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery("SELECT * FROM $mImageCountTable WHERE CategoryId LIKE '"+categoryId+"' AND JobNumber LIKE '"+JobNumber+"'");
   // count = int.parse(result.toString());
    return result;
  }


  Future<dynamic> getAllCounts(jobnumber) async{
    Database db = await DatabaseHelper().database;
  var result = await db.rawQuery("SELECT * FROM $mImageCountTable where JobNumber = '${jobnumber}'");
    print(result);
    return result;
  }

}
import 'package:on_sight_application/repository/database/database_helper.dart';
import 'package:on_sight_application/screens/onboarding/model/onboarding_document_image_model.dart';
import 'package:sqflite/sqflite.dart';

class OnboardingImageManager{

  String mOnboardingImageTable = 'onboarding_image_table';


  Future<int> insertImage(OnBoardingDocumentImageModel imageModel) async {
    Database db = await DatabaseHelper().database;
    var dynamic = await existOrNot(imageModel.imageName!);
    if(dynamic.toString()=="false") {
      var rs = db.insert(mOnboardingImageTable, imageModel.toDb());

      return rs;
    }
    OnBoardingDocumentImageModel model = await getImageByImageName(imageModel.imageName!);
   // String query="UPDATE ${mImageDataTable} SET ImageNote = '${imageModel.imageNote}' WHERE RowID = ${model.rowID.toString()};";
    var result= await db.update(mOnboardingImageTable, imageModel.toMap(), where: 'RowID=?', whereArgs: [imageModel.rowID]);
    await result;
      return model.rowID!;

    }



  Future<dynamic> existOrNot(String imageName) async {
    Database db = await DatabaseHelper().database;
    String query="SELECT CASE WHEN count(RowID) > 0 THEN 'true' ELSE 'false' END as result from $mOnboardingImageTable where ImageName = '$imageName'";
    var result = await db.rawQuery(query);
    if(result.isNotEmpty){
      return result.first['result'];
    }
    return false;
  }


  Future<List<OnBoardingDocumentImageModel>> getImageList() async {

    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery('SELECT * FROM $mOnboardingImageTable');
    List<OnBoardingDocumentImageModel> list = result.isNotEmpty ? result.map((c) => OnBoardingDocumentImageModel.fromDBJson(c)).toList() : [];
    return list;


  }

  Future<List<OnBoardingDocumentImageModel>> getFailedImageList() async {

    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery('SELECT * FROM $mOnboardingImageTable WHERE IsSubmitted= 1');
    List<OnBoardingDocumentImageModel> imageList = result.isNotEmpty ? result.map((c) => OnBoardingDocumentImageModel.fromDBJson(c)).toList() : [];
    return imageList;


  }

  Future<List<OnBoardingDocumentImageModel>> getImageByCategoryIdandJobNumber(String categoryId, String jobNumber) async {

    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery("SELECT * FROM $mOnboardingImageTable WHERE CategoryId LIKE '"+categoryId+"' AND JobNumber LIKE '"+jobNumber+"'"+" AND IsSubmitted= '0'");
    List<OnBoardingDocumentImageModel> list = result.isNotEmpty ? result.map((c) => OnBoardingDocumentImageModel.fromDBJson(c)).toList() : [];
    return list;
  }

  Future<dynamic> deleteImage(name) async {
    Database db = await DatabaseHelper().database;
    await db.rawQuery("DELETE FROM $mOnboardingImageTable WHERE ImageName='"+name.toString()+"'");
    return ;
  }


  Future<OnBoardingDocumentImageModel> getImageByImageName(String imageName) async {

    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery("SELECT * FROM $mOnboardingImageTable WHERE ImageName = '$imageName'");
    List<OnBoardingDocumentImageModel> list = result.isNotEmpty ? result.map((c) => OnBoardingDocumentImageModel.fromDBJson(c)).toList() : [];
    if(list.isNotEmpty){
      return list.first;
    }else{
      return OnBoardingDocumentImageModel();
    }

  }


  Future<dynamic>getCount(categoryId) async {


    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery("SELECT SUM(IsSubmitted), CategoryName FROM ${mOnboardingImageTable} WHERE CategoryId= '${categoryId}';");
    //var result = await db.rawQuery("SELECT SUM(IsSubmitted) FROM ${mImageDataTable} WHERE IsSubmitted= '1' AND CategoryId= '${categoryId}';");


    return result;
  }

  Future<dynamic>getYetToSubmitCount(categoryId) async {


    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery("SELECT COUNT(*), CatName FROM ${mOnboardingImageTable} WHERE CatName= '${categoryId}' AND IsSubmitted= '0';");
    //var result = await db.rawQuery("SELECT SUM(IsSubmitted) FROM ${mImageDataTable} WHERE IsSubmitted= '1' AND CategoryId= '${categoryId}';");


    return result;
  }
}
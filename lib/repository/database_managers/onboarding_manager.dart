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
    var result= await db.update(mOnboardingImageTable, imageModel.toDb(), where: 'RowID=?', whereArgs: [imageModel.rowID]);
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

    print("List Length after delete ${list.length}");
    return list;


  }

  Future<List<OnBoardingDocumentImageModel>> getFailedImageList() async {

    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery('SELECT * FROM $mOnboardingImageTable WHERE IsSubmitted= 1');
    List<OnBoardingDocumentImageModel> imageList = result.isNotEmpty ? result.map((c) => OnBoardingDocumentImageModel.fromDBJson(c)).toList() : [];
    return imageList;


  }

  Future<List<OnBoardingDocumentImageModel>> getImageListNotSubmitted(resourceKey, CatName) async {

    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery('SELECT * FROM $mOnboardingImageTable WHERE IsSubmitted= 0'+" AND ResourceKey= '$resourceKey'"+" AND CatName= '$CatName'");
    List<OnBoardingDocumentImageModel> imageList = result.isNotEmpty ? result.map((c) => OnBoardingDocumentImageModel.fromDBJson(c)).toList() : [];
    return imageList;


  }




  Future<dynamic> deleteImage(name) async {
    print("Method: deleteImage");
    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery("DELETE FROM $mOnboardingImageTable WHERE ImageName='"+name.toString()+"'");
    print("deleteImage  result is $result");

    await getImageList();
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


  Future<dynamic>getCount(itemId) async {


    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery("SELECT SUM(IsSubmitted), CatName FROM ${mOnboardingImageTable} WHERE ResourceKey= '${itemId}';");
    //var result = await db.rawQuery("SELECT SUM(IsSubmitted) FROM ${mImageDataTable} WHERE IsSubmitted= '1' AND CategoryId= '${categoryId}';");


    return result;
  }



  Future<dynamic>getYetToSubmitCount(categoryId, resourceKey) async {
    print(resourceKey);

    Database db = await DatabaseHelper().database;
    var result = await db.rawQuery("SELECT COUNT(*), CatName FROM ${mOnboardingImageTable} WHERE CatName= '${categoryId.toString().trim()}' AND IsSubmitted= '0' AND ResourceKey= '$resourceKey';");
    //var result = await db.rawQuery("SELECT SUM(IsSubmitted) FROM ${mImageDataTable} WHERE IsSubmitted= '1' AND CategoryId= '${categoryId}';");

    print("This is Result "+result.toString());
    return result;

  }
}
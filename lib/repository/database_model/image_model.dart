
import 'package:flutter/material.dart';

class ImageModel{

  int? rowID;
  String? categoryId;
  String? categoryName ;
  String? jobNumber ;
  String? imageName ;
  String? imageNote ;
  String? imagePath ;
  String? requestId ;
  int? isSubmitted ;
  int? PromoFlag = 0;
  int? isEmailRequired ;
  int? jobAction ;
  int? attemptCount ;
  int? submitID ;
  int? isPhotoAdded;
  TextEditingController? controller = TextEditingController(text: "");
  bool isListening = false;

  ImageModel(
      {
        this.rowID,
        this.categoryId,
        this.categoryName,
        this.jobNumber,
        this.imageName,
        this.imageNote,
        this.imagePath,
        this.requestId,
        this.isSubmitted,
        this.PromoFlag,
        this.isEmailRequired,
        this.jobAction,
        this.attemptCount,
        this.submitID,
        this.isPhotoAdded,
      });

  ImageModel.fromJson(dynamic json) {
    rowID = json['RowID'] ?? 0;
    categoryId = json['CategoryId'] ?? "";
    categoryName = json['CategoryName'] ?? "";
    jobNumber = json['JobNumber'] ?? "";
    imageName = json['ImageName'] ?? "";
    imageNote = json['ImageNote'] ?? "";
    imagePath = json['ImagePath'] ?? "";
    requestId = json['RequestId'] ?? "";
    PromoFlag = json['PromoFlag'] ?? 0;
    isSubmitted =json['IsSubmitted'].toString()=='null'?0: int.parse(json['IsSubmitted'].toString());
    isEmailRequired =json['IsEmailRequired'].toString()=='null'?0: int.parse(json['IsEmailRequired'].toString());
    jobAction =json['JobAction'].toString()=='null'?0: int.parse(json['JobAction'].toString());
    attemptCount =json['AttemptCount'].toString()=='null'?0: int.parse(json['AttemptCount'].toString());
    submitID =json['SubmitID'].toString()=='null'?0: int.parse(json['SubmitID'].toString());
    isPhotoAdded =json['isPhotoAdded'].toString()=='null'?0: int.parse(json['isPhotoAdded'].toString());
  }
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
      map['RowID'] = rowID;
      map['CategoryId'] = categoryId;
      map['CategoryName'] = categoryName;
      map['JobNumber'] = jobNumber;
      map['ImageName'] = imageName;
      map['ImageNote'] = imageNote;
      map['ImagePath'] = imagePath;
      map['RequestId'] = requestId;
      map['PromoFlag'] = PromoFlag??0;
      map['IsSubmitted'] = isSubmitted ?? 0;
      map['IsEmailRequired'] = isEmailRequired;
      map['JobAction'] = jobAction;
      map['AttemptCount'] = attemptCount;
      map['SubmitID'] = submitID;
      map['isPhotoAdded'] = isPhotoAdded;

    return map;
  }

  Map<String, dynamic> toDb() {
    final map = <String, dynamic>{};
    map['CategoryId'] = categoryId;
    map['CategoryName'] = categoryName;
    map['JobNumber'] = jobNumber;
    map['ImageName'] = imageName;
    map['ImageNote'] = imageNote;
    map['ImagePath'] = imagePath;
    map['RequestId'] = requestId;
    map['PromoFlag'] = PromoFlag??0;
    map['IsSubmitted'] = isSubmitted ?? 0;
    map['IsEmailRequired'] = isEmailRequired;
    map['JobAction'] = jobAction;
    map['AttemptCount'] = attemptCount;
    map['SubmitID'] = submitID;
    map['isPhotoAdded'] = isPhotoAdded;

    return map;
  }
}

import 'package:flutter/material.dart';

class PromoImageModel{

  String? imageName ;
  String? imageNote ;
  String? imagePath ;
  String? showName ;
  String? year ;
  String? fullDate ;
  String? user ;
  String? description ;
  String? status ;
  TextEditingController? controller = TextEditingController(text: "");
  bool isListening = false;

  PromoImageModel(
      {
        this.imageName,
        this.imageNote,
        this.imagePath,
        this.showName,
        this.year,
        this.fullDate,
        this.user,
        this.description,
        this.status,
      });

  PromoImageModel.fromJson(dynamic json) {
    imageName = json['ImageName'] ?? "";
    imageNote = json['ImageNote'] ?? "";
    imagePath = json['ImagePath'] ?? "";
    showName = json['ShowName'] ?? "";
    year = json['Year'] ?? "";
    fullDate = json['FullDate'] ?? "";
    user = json['User'] ?? "";
    description = json['Description'] ?? "";
    status = json['Status'] ?? "";
  }
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
      map['ImageName'] = imageName;
      map['ImageNote'] = imageNote;
      map['ImagePath'] = imagePath;
      map['ShowName'] = showName;
      map['Year'] = year;
      map['FullDate'] = fullDate;
      map['User'] = user;
      map['Description'] = description;
      map['Status'] = status;
    return map;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ShowName'] = showName;
    map['Year'] = year;
    map['FullDate'] = fullDate;
    map['User'] = user;
    map['Description'] = description;
    map['Status'] = status;
    return map;
  }
}
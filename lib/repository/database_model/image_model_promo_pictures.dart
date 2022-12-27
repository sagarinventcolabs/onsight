
import 'package:flutter/material.dart';

class PromoImageModel{

  String? imageName ;
  String? imageNote ;
  String? imagePath ;
  String? ShowName ;
  String? Year ;
  String? FullDate ;
  String? User ;
  String? Description ;
  String? Status ;
  TextEditingController? controller = TextEditingController(text: "");
  bool isListening = false;

  PromoImageModel(
      {
        this.imageName,
        this.imageNote,
        this.imagePath,
        this.ShowName,
        this.Year,
        this.FullDate,
        this.User,
        this.Description,
        this.Status,
      });

  PromoImageModel.fromJson(dynamic json) {
    imageName = json['ImageName'] ?? "";
    imageNote = json['ImageNote'] ?? "";
    imagePath = json['ImagePath'] ?? "";
    ShowName = json['ShowName'] ?? "";
    Year = json['Year'] ?? "";
    FullDate = json['FullDate'] ?? "";
    User = json['User'] ?? "";
    Description = json['Description'] ?? "";
    Status = json['Status'] ?? "";
  }
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
      map['ImageName'] = imageName;
      map['ImageNote'] = imageNote;
      map['ImagePath'] = imagePath;
      map['ShowName'] = ShowName;
      map['Year'] = Year;
      map['FullDate'] = FullDate;
      map['User'] = User;
      map['Description'] = Description;
      map['Status'] = Status;
    return map;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ShowName'] = ShowName;
    map['Year'] = Year;
    map['FullDate'] = FullDate;
    map['User'] = User;
    map['Description'] = Description;
    map['Status'] = Status;
    return map;
  }
}
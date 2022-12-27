
import 'package:flutter/material.dart';

class LeadSheetImageModel{

  int? rowID;
  String? exhibitorId;
  String? showNumber ;
  String? imageName ;
  String? imageNote ;
  String? imagePath ;
  int? isSubmitted ;
  TextEditingController? controller = TextEditingController(text: "");
  bool isListening = false;

  LeadSheetImageModel(
      {
        this.rowID,
        this.exhibitorId,
        this.showNumber,
        this.imageName,
        this.imageNote,
        this.imagePath,
        this.isSubmitted,

      });

  LeadSheetImageModel.fromJson(dynamic json) {
    rowID = json['RowID'] ?? 0;
    showNumber = json['ShowNumber'] ?? "";
    exhibitorId = json['ExhibitorId'] ?? "";
    imageName = json['ImageName'] ?? "";
    imageNote = json['ImageNote'] ?? "";
    imagePath = json['ImagePath'] ?? "";
    isSubmitted =json['IsSubmitted'].toString()=='null'?0: int.parse(json['IsSubmitted'].toString());

  }
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
      map['RowID'] = rowID;
      map['ShowNumber'] = showNumber;
      map['ExhibitorId'] = exhibitorId;
      map['ImageName'] = imageName;
      map['ImageNote'] = imageNote;
      map['ImagePath'] = imagePath;
      map['IsSubmitted'] = isSubmitted ?? 0;


    return map;
  }

  Map<String, dynamic> toDb() {
    final map = <String, dynamic>{};
    map['ShowNumber'] = showNumber;
    map['ExhibitorId'] = exhibitorId;
    map['ImageName'] = imageName;
    map['ImageNote'] = imageNote;
    map['ImagePath'] = imagePath;
    map['IsSubmitted'] = isSubmitted ?? 0;

    return map;
  }
}
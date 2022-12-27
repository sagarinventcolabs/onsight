import 'package:on_sight_application/screens/onboarding/model/onboarding_document_image_model.dart';

class OnBoardingDocumentModel {
  String? category;
  List<OnBoardingDocumentImageModel>? image = [];

  OnBoardingDocumentModel({this.category, this.image});

  OnBoardingDocumentModel.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    if (json['image'] != null) {
      image = <OnBoardingDocumentImageModel>[];
      json['image'].forEach((v) {
        image!.add(new OnBoardingDocumentImageModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    if (this.image != null) {
      data['image'] = this.image!.map((v) => v.toMap()).toList();
    }
    return data;
  }
}

import 'dart:io';
import 'package:flutter/material.dart';

class JobPhotosModel {
  File? image;
  TextEditingController? controller = TextEditingController(text: "");
  int? dbId;
  JobPhotosModel({required this.image});
}

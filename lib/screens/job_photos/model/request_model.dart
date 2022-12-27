import 'package:on_sight_application/screens/job_photos/model/job_key_model.dart';
import 'package:on_sight_application/screens/job_photos/model/notes_model.dart';

class RequestModel{

  JobKeyModel? jobKeyModel;
  List<NotesKey> list = [];
  RequestModel.one({
    JobKeyModel? jobKeyModell,
    List<NotesKey>? notesModel,}){
    jobKeyModel = jobKeyModell;
    list = notesModel!;
  }

  RequestModel();

  RequestModel.fromJson(dynamic json) {
    jobKeyModel = json['jobkey'];
    if (json['notejson'] != null) {
      list = <NotesKey>[];
      json['notejson'].forEach((v) {
        list.add(NotesKey.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['jobkey'] = jobKeyModel!.toJson();
    map['notejson'] = list.map((e) => e.toJson());
    return map;
  }

}
class NotesKey{

  String? name = "";
  NotesModel? listNotes ;

  NotesKey({
    String? namee,
    NotesModel? notesModel,}){
    name = namee;
    listNotes = notesModel!;
  }
  NotesKey.fromJson(dynamic json) {
    name = json[name];
    listNotes = json['notes']!=null?NotesModel.fromJson(json['notes']):NotesModel();
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map[name!] = listNotes!.toJson();
    return map;
  }
}
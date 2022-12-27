import 'dart:convert';
/// ExhibitorName : "Exhibitor San Test S-104203"
/// BoothSize : "100*100"
/// BoothNumber : "138"
/// Shop : "sop100"
/// SetupCompany : "c10"
/// Notes : "Andy Test Exhibitor_QA"
/// FolderUrl : ""
/// ExhibitorImageCount : 0
/// ExhibitorGuid : ""
/// Id : ""

AddExhibitorRequest addExhibitorRequestFromJson(String str) => AddExhibitorRequest.fromJson(json.decode(str));
String addExhibitorRequestToJson(AddExhibitorRequest data) => json.encode(data.toJson());
class AddExhibitorRequest {
  AddExhibitorRequest({
      String? exhibitorName, 
      String? boothSize, 
      String? boothNumber, 
      String? shop, 
      String? setupCompany, 
      String? notes, 
      String? folderUrl, 
      num? exhibitorImageCount, 
      String? exhibitorGuid, 
      String? id,}){
    _exhibitorName = exhibitorName;
    _boothSize = boothSize;
    _boothNumber = boothNumber;
    _shop = shop;
    _setupCompany = setupCompany;
    _notes = notes;
    _folderUrl = folderUrl;
    _exhibitorImageCount = exhibitorImageCount;
    _exhibitorGuid = exhibitorGuid;
    _id = id;
}

  AddExhibitorRequest.fromJson(dynamic json) {
    _exhibitorName = json['ExhibitorName'];
    _boothSize = json['BoothSize'];
    _boothNumber = json['BoothNumber'];
    _shop = json['Shop'];
    _setupCompany = json['SetupCompany'];
    _notes = json['Notes'];
    _folderUrl = json['FolderUrl'];
    _exhibitorImageCount = json['ExhibitorImageCount'];
    _exhibitorGuid = json['ExhibitorGuid'];
    _id = json['Id'];
  }
  String? _exhibitorName;
  String? _boothSize;
  String? _boothNumber;
  String? _shop;
  String? _setupCompany;
  String? _notes;
  String? _folderUrl;
  num? _exhibitorImageCount;
  String? _exhibitorGuid;
  String? _id;
AddExhibitorRequest copyWith({  String? exhibitorName,
  String? boothSize,
  String? boothNumber,
  String? shop,
  String? setupCompany,
  String? notes,
  String? folderUrl,
  num? exhibitorImageCount,
  String? exhibitorGuid,
  String? id,
}) => AddExhibitorRequest(  exhibitorName: exhibitorName ?? _exhibitorName,
  boothSize: boothSize ?? _boothSize,
  boothNumber: boothNumber ?? _boothNumber,
  shop: shop ?? _shop,
  setupCompany: setupCompany ?? _setupCompany,
  notes: notes ?? _notes,
  folderUrl: folderUrl ?? _folderUrl,
  exhibitorImageCount: exhibitorImageCount ?? _exhibitorImageCount,
  exhibitorGuid: exhibitorGuid ?? _exhibitorGuid,
  id: id ?? _id,
);
  String? get exhibitorName => _exhibitorName;
  String? get boothSize => _boothSize;
  String? get boothNumber => _boothNumber;
  String? get shop => _shop;
  String? get setupCompany => _setupCompany;
  String? get notes => _notes;
  String? get folderUrl => _folderUrl;
  num? get exhibitorImageCount => _exhibitorImageCount;
  String? get exhibitorGuid => _exhibitorGuid;
  String? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ExhibitorName'] = _exhibitorName;
    map['BoothSize'] = _boothSize;
    map['BoothNumber'] = _boothNumber;
    map['Shop'] = _shop;
    map['SetupCompany'] = _setupCompany;
    map['Notes'] = _notes;
    map['FolderUrl'] = _folderUrl;
    map['ExhibitorImageCount'] = _exhibitorImageCount;
    map['ExhibitorGuid'] = _exhibitorGuid;
    map['Id'] = _id;
    return map;
  }

}
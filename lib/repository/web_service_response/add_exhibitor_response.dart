import 'dart:convert';
/// ExhibitorName : "Test"
/// BoothSize : ""
/// BoothNumber : ""
/// Shop : ""
/// SetupCompany : ""
/// Notes : ""
/// FolderUrl : ""
/// ExhibitorImageCount : 0
/// ExhibitorGuid : "7a5e5de4-6bc0-4422-94c4-38cdc3f9fb4a"
/// ExhibitorId : "8092"
/// IsHighPriority : false
/// ShowName : null

AddExhibitorResponse addExhibitorResponseFromJson(String str) => AddExhibitorResponse.fromJson(json.decode(str));
String addExhibitorResponseToJson(AddExhibitorResponse data) => json.encode(data.toJson());
class AddExhibitorResponse {
  AddExhibitorResponse({
      String? exhibitorName, 
      String? boothSize, 
      String? boothNumber, 
      String? shop, 
      String? setupCompany, 
      String? notes, 
      String? folderUrl, 
      var exhibitorImageCount,
      String? exhibitorGuid, 
      String? exhibitorId, 
      bool? isHighPriority, 
      String? showName,}){
    _exhibitorName = exhibitorName;
    _boothSize = boothSize;
    _boothNumber = boothNumber;
    _shop = shop;
    _setupCompany = setupCompany;
    _notes = notes;
    _folderUrl = folderUrl;
    _exhibitorImageCount = exhibitorImageCount;
    _exhibitorGuid = exhibitorGuid;
    _exhibitorId = exhibitorId;
    _isHighPriority = isHighPriority;
    _showName = showName;
}

  AddExhibitorResponse.fromJson(dynamic json) {
    _exhibitorName = json['ExhibitorName'];
    _boothSize = json['BoothSize'];
    _boothNumber = json['BoothNumber'];
    _shop = json['Shop'];
    _setupCompany = json['SetupCompany'];
    _notes = json['Notes'];
    _folderUrl = json['FolderUrl'];
    _exhibitorImageCount = json['ExhibitorImageCount'];
    _exhibitorGuid = json['ExhibitorGuid'];
    _exhibitorId = json['ExhibitorId'];
    _isHighPriority = json['IsHighPriority'];
    _showName = json['ShowName'];
  }
  var _exhibitorName;
  String? _boothSize;
  String? _boothNumber;
  String? _shop;
  String? _setupCompany;
  String? _notes;
  String? _folderUrl;
  var _exhibitorImageCount;
  String? _exhibitorGuid;
  String? _exhibitorId;
  bool? _isHighPriority;
  String? _showName;
AddExhibitorResponse copyWith({  String? exhibitorName,
  String? boothSize,
  String? boothNumber,
  String? shop,
  String? setupCompany,
  String? notes,
  String? folderUrl,
  var exhibitorImageCount,
  String? exhibitorGuid,
  String? exhibitorId,
  bool? isHighPriority,
  dynamic showName,
}) => AddExhibitorResponse(  exhibitorName: exhibitorName ?? _exhibitorName,
  boothSize: boothSize ?? _boothSize,
  boothNumber: boothNumber ?? _boothNumber,
  shop: shop ?? _shop,
  setupCompany: setupCompany ?? _setupCompany,
  notes: notes ?? _notes,
  folderUrl: folderUrl ?? _folderUrl,
  exhibitorImageCount: exhibitorImageCount ?? _exhibitorImageCount,
  exhibitorGuid: exhibitorGuid ?? _exhibitorGuid,
  exhibitorId: exhibitorId ?? _exhibitorId,
  isHighPriority: isHighPriority ?? _isHighPriority,
  showName: showName ?? _showName,
);
  get exhibitorName => _exhibitorName;
  String? get boothSize => _boothSize;
  String? get boothNumber => _boothNumber;
  String? get shop => _shop;
  String? get setupCompany => _setupCompany;
  String? get notes => _notes;
  String? get folderUrl => _folderUrl;
  get exhibitorImageCount => _exhibitorImageCount;
  String? get exhibitorGuid => _exhibitorGuid;
  String? get exhibitorId => _exhibitorId;
  bool? get isHighPriority => _isHighPriority;
  dynamic get showName => _showName;

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
    map['ExhibitorId'] = _exhibitorId;
    map['IsHighPriority'] = _isHighPriority;
    map['ShowName'] = _showName;
    return map;
  }

}
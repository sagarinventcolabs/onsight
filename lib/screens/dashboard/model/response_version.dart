/// OperatingSystem : "Android"
/// CreatedDate : "2022-10-13T00:00:00"
/// VersionNumber : "6.0.2"
/// ReleaseType : "Critical"

class ResponseVersion {
  ResponseVersion({
      String? operatingSystem, 
      String? createdDate, 
      String? versionNumber, 
      String? releaseType,}){
    _operatingSystem = operatingSystem;
    _createdDate = createdDate;
    _versionNumber = versionNumber;
    _releaseType = releaseType;
}

  ResponseVersion.fromJson(dynamic json, i) {
    _operatingSystem = json[i]['OperatingSystem'];
    _createdDate = json[i]['CreatedDate'];
    _versionNumber = json[i]['VersionNumber'];
    _releaseType = json[i]['ReleaseType'];
  }
  String? _operatingSystem;
  String? _createdDate;
  String? _versionNumber;
  String? _releaseType;
ResponseVersion copyWith({  String? operatingSystem,
  String? createdDate,
  String? versionNumber,
  String? releaseType,
}) => ResponseVersion(  operatingSystem: operatingSystem ?? _operatingSystem,
  createdDate: createdDate ?? _createdDate,
  versionNumber: versionNumber ?? _versionNumber,
  releaseType: releaseType ?? _releaseType,
);
  String? get operatingSystem => _operatingSystem;
  String? get createdDate => _createdDate;
  String? get versionNumber => _versionNumber;
  String? get releaseType => _releaseType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['OperatingSystem'] = _operatingSystem;
    map['CreatedDate'] = _createdDate;
    map['VersionNumber'] = _versionNumber;
    map['ReleaseType'] = _releaseType;
    return map;
  }

}
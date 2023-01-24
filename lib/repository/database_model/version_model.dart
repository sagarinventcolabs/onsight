

class VersionDetails{

  String? version;
  String? releaseType;
  int updateStatus = 0;
  int isAlert = 0;


  VersionDetails();

  VersionDetails.fromJson(dynamic json) {
    version = json['Version'] ?? "";
    releaseType = json['ReleaseType'] ?? "";
    updateStatus = json['UpdateStatus'] ?? 0;
    isAlert = json['isAlert'] ?? 0;

  }
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['Version'] = version;
    map['ReleaseType'] = releaseType;
    map['UpdateStatus'] = updateStatus;
    map['isAlert'] = isAlert;

    return map;
  }
}
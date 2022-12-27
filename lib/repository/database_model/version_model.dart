

class VersionDetails{

  String? Version;
  String? ReleaseType;
  int UpdateStatus = 0;
  int isAlert = 0;


  VersionDetails();

  VersionDetails.fromJson(dynamic json) {
    Version = json['Version'] ?? "";
    ReleaseType = json['ReleaseType'] ?? "";
    UpdateStatus = json['UpdateStatus'] ?? 0;
    isAlert = json['isAlert'] ?? 0;

  }
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['Version'] = Version;
    map['ReleaseType'] = ReleaseType;
    map['UpdateStatus'] = UpdateStatus;
    map['isAlert'] = isAlert;

    return map;
  }
}
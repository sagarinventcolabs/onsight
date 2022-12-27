
class Email{

  String? jobNumber;
  String? categoryName ;
  String? url ;
  String? additionalEmail ;
  int? emailOnProgress ;

  Email(
      {this.jobNumber,
        this.categoryName,
        this.url,
        this.additionalEmail,
        this.emailOnProgress,
      });

  Email.fromJson(dynamic json) {
    jobNumber = json['JobNumber'] ?? "";
    categoryName = json['CategoryName'] ?? "";
    url = json['Url'] ?? "";
    additionalEmail = json['AdditionalEmail'] ?? "";
    emailOnProgress =json['EmailOnProgress'].toString()=='null'?0: int.parse(json['EmailOnProgress'].toString());
  }
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
      map['JobNumber'] = jobNumber;
      map['CategoryName'] = categoryName;
      map['Url'] = url;
      map['AdditionalEmail'] = additionalEmail;
      map['EmailOnProgress'] = emailOnProgress;

    return map;
  }
}
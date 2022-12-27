/// JobNumber : "W-105682"
/// TakenDateTime : "2018-05-25 17:40:28.947"
/// AdditionalEmail : "sandeep.singh@dreamorbit.com, nazia.sultana@dreamorbit.com, satyarth.shukla@dreamorbit.com, tushar.sakhare@dreamorbit.com"

class JobKeyModel {
  JobKeyModel({
      String? jobNumber, 
      String? takenDateTime, 
      String? additionalEmail,}){
    _jobNumber = jobNumber;
    _takenDateTime = takenDateTime;
    _additionalEmail = additionalEmail;
}

  JobKeyModel.fromJson(dynamic json) {
    _jobNumber = json['JobNumber'];
    _takenDateTime = json['TakenDateTime'];
    _additionalEmail = json['AdditionalEmail'];
  }
  String? _jobNumber;
  String? _takenDateTime;
  String? _additionalEmail;
JobKeyModel copyWith({  String? jobNumber,
  String? takenDateTime,
  String? additionalEmail,
}) => JobKeyModel(  jobNumber: jobNumber ?? _jobNumber,
  takenDateTime: takenDateTime ?? _takenDateTime,
  additionalEmail: additionalEmail ?? _additionalEmail,
);
  String? get jobNumber => _jobNumber;
  String? get takenDateTime => _takenDateTime;
  String? get additionalEmail => _additionalEmail;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['JobNumber'] = _jobNumber;
    map['TakenDateTime'] = _takenDateTime;
    map['AdditionalEmail'] = _additionalEmail;
    return map;
  }

}
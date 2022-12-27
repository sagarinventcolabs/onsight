/// IsExist : false

class IsEvaluationExistResponse {
  IsEvaluationExistResponse({
      bool? isExist,}){
    _isExist = isExist;
}

  IsEvaluationExistResponse.fromJson(dynamic json) {
    _isExist = json['IsExist'];
  }
  bool? _isExist;
IsEvaluationExistResponse copyWith({  bool? isExist,
}) => IsEvaluationExistResponse(  isExist: isExist ?? _isExist,
);
  bool? get isExist => _isExist;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['IsExist'] = _isExist;
    return map;
  }

}
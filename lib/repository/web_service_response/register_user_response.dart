/// .expires : "Tue, 01 Aug 2023 12:01:57 GMT"
/// .issued : "Mon, 01 Aug 2022 12:01:57 GMT"
/// access_token : "YoJOhEcRcAXWdO2IC_BE6pGb-wr0GEAMyIoDzNP-uSBhv-7NZcnE9Xhht3-OAacy6Go8mByanCjCq1fiJ19f7oxaVQiHirx022r3wyYhTZgQajpXJ2pJNh8C7oat4QyYvQmwqoANFRva9ACYZyZqRVTC4M3CJkD7vkxYq9fNt3RJYLsSZh_IEpb_dsSolzEE9TRdxKVw3FlgVOkv488ZiHHigrvG-P5ZqdxiBb4rAibfdaabgwJOMUshJAcyD-7jjKaRwnbVZk_tcf-eku2GKCj51GiiXKfuDShPEL_m6pCmCMvWqqXsCQqfy99BT4-oyaNipHdqZ-gHKnTFzuwI8n6WnnDpVlHskt05HTexmo5EC-KDcwqZyDmUE7nBJpn4GrR-NdwMjFBJXrNOZBokzZEH7gXmTFc6rf1LtahuP8iIdbzRH0Uu8GhG6KGVT0qa0x_kaDWzG5zDuiGHwjhUJgRUsE3HD5eqeBRgBMRTSII6caoWVdBt6X_RcxjseGTb2zWPw6f9lJ9lPcInj2d1B61W8WnpcbaZa3GSYgaXIEe7JydK-PepX0sTmeQu-eES4M8qOinWi_jGIT1TMaMeI-DyNnYPcLpbe0psU8L1jxG9GbKRfm4M41pRPzOgnoH2t0kpMnORR1KZ9gWqjqt5yEjq74dAvjfLvW-S5P9_mKUK7ESlXkmtWGHY-9OuC8s73L-vnPMhwstRi7GkoplJ4g"
/// as:client_id : "Mobile"
/// expires_in : 31535999
/// refresh_token : "43235022885745588e920fc9a427bd1e"
/// token_type : "bearer"
/// userName : "918431839044"
/// signInStatus : "Success"
/// as:authenticationType : "Bearer"
/// as:authenticationCookieName : ".AuthCookie"
/// IsAdmin : null

class RegisterUserResponse {
  RegisterUserResponse({
      String? expires, 
      String? issued, 
      String? accessToken, 
      String? asclientId, 
      num? expiresIn, 
      String? refreshToken, 
      String? tokenType, 
      String? userName, 
      String? signInStatus, 
      String? asauthenticationType, 
      String? asauthenticationCookieName}){
    _expires = expires;
    _issued = issued;
    _accessToken = accessToken;
    _asclientId = asclientId;
    _expiresIn = expiresIn;
    _refreshToken = refreshToken;
    _tokenType = tokenType;
    _userName = userName;
    _signInStatus = signInStatus;
    _asauthenticationType = asauthenticationType;
    _asauthenticationCookieName = asauthenticationCookieName;
}

  RegisterUserResponse.fromJson(dynamic json) {
    _expires = json['.expires'];
    _issued = json['.issued'];
    _accessToken = json['access_token'];
    _asclientId = json['as:client_id'];
    _expiresIn = json['expires_in'];
    _refreshToken = json['refresh_token'];
    _tokenType = json['token_type'];
    _userName = json['userName'];
    _signInStatus = json['signInStatus'];
    _asauthenticationType = json['as:authenticationType'];
    _asauthenticationCookieName = json['as:authenticationCookieName'];
  }
  String? _expires;
  String? _issued;
  String? _accessToken;
  String? _asclientId;
  num? _expiresIn;
  String? _refreshToken;
  String? _tokenType;
  String? _userName;
  String? _signInStatus;
  String? _asauthenticationType;
  String? _asauthenticationCookieName;
RegisterUserResponse copyWith({  String? expires,
  String? issued,
  String? accessToken,
  String? asclientId,
  num? expiresIn,
  String? refreshToken,
  String? tokenType,
  String? userName,
  String? signInStatus,
  String? asauthenticationType,
  String? asauthenticationCookieName
}) => RegisterUserResponse(  expires: expires ?? _expires,
  issued: issued ?? _issued,
  accessToken: accessToken ?? _accessToken,
  asclientId: asclientId ?? _asclientId,
  expiresIn: expiresIn ?? _expiresIn,
  refreshToken: refreshToken ?? _refreshToken,
  tokenType: tokenType ?? _tokenType,
  userName: userName ?? _userName,
  signInStatus: signInStatus ?? _signInStatus,
  asauthenticationType: asauthenticationType ?? _asauthenticationType,
  asauthenticationCookieName: asauthenticationCookieName ?? _asauthenticationCookieName,
);
  String? get expires => _expires;
  String? get issued => _issued;
  String? get accessToken => _accessToken;
  String? get asclientId => _asclientId;
  num? get expiresIn => _expiresIn;
  String? get refreshToken => _refreshToken;
  String? get tokenType => _tokenType;
  String? get userName => _userName;
  String? get signInStatus => _signInStatus;
  String? get asauthenticationType => _asauthenticationType;
  String? get asauthenticationCookieName => _asauthenticationCookieName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['.expires'] = _expires;
    map['.issued'] = _issued;
    map['access_token'] = _accessToken;
    map['as:client_id'] = _asclientId;
    map['expires_in'] = _expiresIn;
    map['refresh_token'] = _refreshToken;
    map['token_type'] = _tokenType;
    map['userName'] = _userName;
    map['signInStatus'] = _signInStatus;
    map['as:authenticationType'] = _asauthenticationType;
    map['as:authenticationCookieName'] = _asauthenticationCookieName;
    return map;
  }

}
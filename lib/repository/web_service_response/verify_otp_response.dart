/// .expires : "Tue, 01 Aug 2023 12:01:15 GMT"
/// .issued : "Mon, 01 Aug 2022 12:01:15 GMT"
/// access_token : "A7e08tlT_X0p9DmRpaeNM2pI17qYmrLCpQjE1BN81ctdRKssX1bbx9PS7XS5e5uyYCoBBJxIbyRQDZgrhbwD4WuiMxorHrZp-NjxnvwTTzKBiZr01BX4PEJ4q15--nSEYAx_E5nZV7i7iGVgGMj02sNEn3Oa4_5OvAiugsGOU8fs4myMZC7NypWxD852oVH8RTDaCgZXewpwlPmim4OfBkk96ElhrK3RlBNhuZG0dlc_aYSbKiZ_FqQjNRgzMa8G1LoY5K13mxStixNMT3vVKtkkJrwa0EgX4v0vrBZrfxRe52rIJGd-NWhwKnTkinvik8N81XVAGJqviPmwPPUUVUukQidUQ0olsW0xQtN2Spxx9t1vqWRtOKktuqUjgc72QyCmq8_LruqEYuZ-M1UwRmqUiSIIIty1Pn73jovxSIukesxQfq2ik11YLPLx8tfTqgR4YkTFltINivckJjJlLg"
/// as:client_id : "Mobile"
/// expires_in : 31535999
/// refresh_token : null
/// token_type : "bearer"
/// userName : "918431839044"
/// signInStatus : "RequiredRegistration"
/// as:authenticationType : ".AuthCookie"
/// as:authenticationCookieName : ".OrbitOtpCookie"
/// IsAdmin : null

class VerifyOtpResponse {
  VerifyOtpResponse({
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

  VerifyOtpResponse.fromJson(dynamic json) {
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
VerifyOtpResponse copyWith({  String? expires,
  String? issued,
  String? accessToken,
  String? asclientId,
  num? expiresIn,
  String? refreshToken,
  String? tokenType,
  String? userName,
  String? signInStatus,
  String? asauthenticationType,
  String? asauthenticationCookieName,
}) => VerifyOtpResponse(  expires: expires ?? _expires,
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
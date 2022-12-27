class GetOtpResponse {
  GetOtpResponse({
      this.expires, 
      this.issued, 
      this.accessToken, 
      this.asclientId, 
      this.expiresIn, 
      this.refreshToken, 
      this.tokenType, 
      this.userName, 
      this.signInStatus, 
      this.asauthenticationType, 
      this.asauthenticationCookieName});

  GetOtpResponse.fromJson(dynamic json) {
    expires = json['.expires'];
    issued = json['.issued'];
    accessToken = json['access_token'];
    asclientId = json['as:client_id'];
    expiresIn = json['expires_in'];
    refreshToken = json['refresh_token'];
    tokenType = json['token_type'];
    userName = json['userName'];
    signInStatus = json['signInStatus'];
    asauthenticationType = json['as:authenticationType'];
    asauthenticationCookieName = json['as:authenticationCookieName'];
  }
  String? expires;
  String? issued;
  String? accessToken;
  String? asclientId;
  int? expiresIn;
  String? refreshToken;
  String? tokenType;
  String? userName;
  String? signInStatus;
  String? asauthenticationType;
  String? asauthenticationCookieName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['.expires'] = expires;
    map['.issued'] = issued;
    map['access_token'] = accessToken;
    map['as:client_id'] = asclientId;
    map['expires_in'] = expiresIn;
    map['refresh_token'] = refreshToken;
    map['token_type'] = tokenType;
    map['userName'] = userName;
    map['signInStatus'] = signInStatus;
    map['as:authenticationType'] = asauthenticationType;
    map['as:authenticationCookieName'] = asauthenticationCookieName;
    return map;
  }

}
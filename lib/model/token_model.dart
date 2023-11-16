class TokenModel {
  String? token;

  TokenModel({this.token});

  TokenModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
  }
}

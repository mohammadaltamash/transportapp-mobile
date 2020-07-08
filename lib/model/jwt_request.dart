import 'package:json_annotation/json_annotation.dart';

part 'jwt_request.g.dart';

@JsonSerializable()
class JwtRequest {
  String email;
  String password;
  JwtRequest({this.email, this.password});

  /*getEmail() {
    return email;
  }

  void setEmail(email) {
    this.email = email;
  }

  getPassword() {
    return password;
  }

  setPassword(password) {
    this.password = password;
  }*/

  factory JwtRequest.fromJson(Map<String, dynamic> json) =>_$JwtRequestFromJson(json);
  Map<String, dynamic> toJson() =>_$JwtRequestToJson(this);
}
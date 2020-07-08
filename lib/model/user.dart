import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {

  String email;
  String password;
  User({this.email, this.password});
}

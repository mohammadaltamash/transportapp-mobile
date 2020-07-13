import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  int id;
  String userName;
  String password;
  String resetToken;
  String jwtToken;
  String fullName;
  String companyName;
  String address;
  String zip;
  double latitude;
  double longitude;
  Map<String, String> phones;
  String email;
  String type;
  List<int> createdOrders;

  User(
      {this.userName,
      this.password,
      this.resetToken,
      this.jwtToken,
      this.fullName,
      this.companyName,
      this.address,
      this.zip,
      this.latitude,
      this.longitude,
      this.phones,
      this.email,
      this.type,
      this.createdOrders});

  factory User.fromJson(Map<String, dynamic> json) =>_$UserFromJson(json);
  Map<String, dynamic> toJson() =>_$UserToJson(this);
}

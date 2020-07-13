// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User()
    ..id = json['id'] as int
    ..userName = json['userName'] as String
    ..password = json['password'] as String
    ..resetToken = json['resetToken'] as String
    ..jwtToken = json['jwtToken'] as String
    ..fullName = json['fullName'] as String
    ..companyName = json['companyName'] as String
    ..address = json['address'] as String
    ..zip = json['zip'] as String
    ..latitude = (json['latitude'] as num)?.toDouble()
    ..longitude = (json['longitude'] as num)?.toDouble()
    ..phones = (json['phones'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    )
    ..email = json['email'] as String
    ..type = json['type'] as String
    ..createdOrders =
        (json['createdOrders'] as List)?.map((e) => e as int)?.toList();
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'userName': instance.userName,
      'password': instance.password,
      'resetToken': instance.resetToken,
      'jwtToken': instance.jwtToken,
      'fullName': instance.fullName,
      'companyName': instance.companyName,
      'address': instance.address,
      'zip': instance.zip,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'phones': instance.phones,
      'email': instance.email,
      'type': instance.type,
      'createdOrders': instance.createdOrders,
    };

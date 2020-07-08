// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jwt_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JwtRequest _$JwtRequestFromJson(Map<String, dynamic> json) {
  return JwtRequest()
    ..email = json['email'] as String
    ..password = json['password'] as String;
}

Map<String, dynamic> _$JwtRequestToJson(JwtRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
    };

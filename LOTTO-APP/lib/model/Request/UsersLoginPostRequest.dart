// To parse this JSON data, do
//
//     final usersLoginPostRequestDart = usersLoginPostRequestDartFromJson(jsonString);

import 'dart:convert';

UsersLoginPostRequest usersLoginPostRequestDartFromJson(String str) =>
    UsersLoginPostRequest.fromJson(json.decode(str));

String usersLoginPostRequestDartToJson(UsersLoginPostRequest data) =>
    json.encode(data.toJson());

class UsersLoginPostRequest {
  String usernameOrEmail;
  String password;

  UsersLoginPostRequest({
    required this.usernameOrEmail,
    required this.password,
  });

  factory UsersLoginPostRequest.fromJson(Map<String, dynamic> json) =>
      UsersLoginPostRequest(
        usernameOrEmail: json["usernameOrEmail"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "usernameOrEmail": usernameOrEmail,
        "password": password,
      };
}

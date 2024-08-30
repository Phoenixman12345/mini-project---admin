// To parse this JSON data, do
//
//     final usersLoginPostResponse = usersLoginPostResponseFromJson(jsonString);

import 'dart:convert';

UsersLoginPostResponse usersLoginPostResponseFromJson(String str) =>
    UsersLoginPostResponse.fromJson(json.decode(str));

String usersLoginPostResponseToJson(UsersLoginPostResponse data) =>
    json.encode(data.toJson());

class UsersLoginPostResponse {
  int uid;
  String fullname;
  String username;
  String email;
  String phone;
  int type;
  int wallet;
  String? image;

  UsersLoginPostResponse({
    required this.uid,
    required this.fullname,
    required this.username,
    required this.email,
    required this.phone,
    required this.type,
    required this.wallet,
    required this.image,
  });

  factory UsersLoginPostResponse.fromJson(Map<String, dynamic> json) =>
      UsersLoginPostResponse(
        uid: json["uid"],
        fullname: json["fullname"],
        username: json["username"],
        email: json["email"],
        phone: json["phone"],
        type: json["type"],
        wallet: json["wallet"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "fullname": fullname,
        "username": username,
        "email": email,
        "phone": phone,
        "type": type,
        "wallet": wallet,
        "image": image,
      };
}

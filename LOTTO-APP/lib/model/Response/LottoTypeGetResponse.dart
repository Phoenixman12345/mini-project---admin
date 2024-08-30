// To parse this JSON data, do
//
//     final lottoTypeGetResponse = lottoTypeGetResponseFromJson(jsonString);

import 'dart:convert';

List<LottoTypeGetResponse> lottoTypeGetResponseFromJson(String str) =>
    List<LottoTypeGetResponse>.from(
        json.decode(str).map((x) => LottoTypeGetResponse.fromJson(x)));

String lottoTypeGetResponseToJson(List<LottoTypeGetResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LottoTypeGetResponse {
  int lid;
  int number;
  String type;
  int price;
  int lottoQuantity;
  String date;

  LottoTypeGetResponse({
    required this.lid,
    required this.number,
    required this.type,
    required this.price,
    required this.lottoQuantity,
    required this.date,
  });

  factory LottoTypeGetResponse.fromJson(Map<String, dynamic> json) =>
      LottoTypeGetResponse(
        lid: json["lid"],
        number: json["number"],
        type: json["type"],
        price: json["price"],
        lottoQuantity: json["lotto_quantity"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "lid": lid,
        "number": number,
        "type": type,
        "price": price,
        "lotto_quantity": lottoQuantity,
        "date": date,
      };
}

import 'dart:convert';
import 'package:intl/intl.dart';

LottoGetResponse lottoGetResponseFromJson(String str) =>
    LottoGetResponse.fromJson(json.decode(str));

String lottoGetResponseToJson(LottoGetResponse data) =>
    json.encode(data.toJson());

class LottoGetResponse {
  int prize; // Added this field
  int number;
  String type;
  int price;
  String date;
  int lottoQuantity;
  late String formattedDate;

  LottoGetResponse({
    required this.prize, // Added this field
    required this.number,
    required this.type,
    required this.price,
    required this.date,
    required this.lottoQuantity,
  }) {
    formattedDate =
        DateFormat('วันที่ d MMMM yyyy', 'th').format(DateTime.parse(date));
  }

  factory LottoGetResponse.fromJson(Map<String, dynamic> json) {
    return LottoGetResponse(
      prize: json["prize"] ?? 0, // Default value if null
      number: json["number"] ?? 0, // Default value if null
      type: json["type"] ?? '', // Default empty string if null
      price: json["price"] ?? 0, // Default value if null
      date: json["date"] ??
          DateTime.now().toString(), // Default to current date if null
      lottoQuantity: json["lotto_quantity"] ?? 0, // Default value if null
    );
  }

  Map<String, dynamic> toJson() => {
        "prize": prize,
        "number": number,
        "type": type,
        "price": price,
        "date": date,
        "lotto_quantity": lottoQuantity,
      };
}

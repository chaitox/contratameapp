// To parse this JSON data, do
//
//  final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

import 'package:contratame/src/models/order.dart';

OrderResponse orderResponseFromJson(String str) =>
    OrderResponse.fromJson(json.decode(str));

String orderResponseToJson(OrderResponse data) => json.encode(data.toJson());

class OrderResponse {
  OrderResponse({
    this.ok,
    this.order,
  });

  bool ok;
  Order order;

  factory OrderResponse.fromJson(Map<String, dynamic> json) => OrderResponse(
        ok: json["ok"],
        order: Order.fromJson(json["order"]),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "order": order.toJson(),
      };
}

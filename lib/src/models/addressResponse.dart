// To parse this JSON data, do
//
//  final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

import 'package:contratame/src/models/usuario.dart';

AddressResponse addressResponseFromJson(String str) =>
    AddressResponse.fromJson(json.decode(str));

String addressResponseToJson(AddressResponse data) =>
    json.encode(data.toJson());

class AddressResponse {
  AddressResponse({
    this.ok,
    this.usuario,
  });

  bool ok;
  Usuario usuario;

  factory AddressResponse.fromJson(Map<String, dynamic> json) =>
      AddressResponse(
        ok: json["ok"],
        usuario: Usuario.fromJson(json["usuario"]),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "usuario": usuario.toJson(),
      };
}

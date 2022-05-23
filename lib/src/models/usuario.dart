// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
  Usuario({
    this.google,
    this.facebook,
    this.enable,
    this.online,
    this.orders,
    this.displayName,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.email,
    this.streetAddress,
    this.profilePicUrl,
    this.uid,
  });

  bool google;
  bool facebook;
  bool enable;
  bool online;
  List<String> orders;
  String displayName;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  List<StreetAddress> streetAddress;
  String profilePicUrl;
  String uid;

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        google: json["google"],
        facebook: json["facebook"],
        enable: json["enable"],
        online: json["online"],
        orders: List<String>.from(json["orders"].map((x) => x)),
        displayName: json["displayName"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        phoneNumber: json["phoneNumber"],
        email: json["email"],
        streetAddress: List<StreetAddress>.from(
            json["streetAddress"].map((x) => StreetAddress.fromJson(x))),
        profilePicUrl: json["profilePicUrl"],
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "google": google,
        "facebook": facebook,
        "enable": enable,
        "online": online,
        "orders": List<dynamic>.from(orders.map((x) => x)),
        "displayName": displayName,
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
        "email": email,
        "streetAddress":
            List<dynamic>.from(streetAddress.map((x) => x.toJson())),
        "profilePicUrl": profilePicUrl,
        "uid": uid,
      };
}

class StreetAddress {
  StreetAddress({
    this.id,
    this.name,
    this.address,
    this.country,
    this.state,
    this.city,
    this.latitude,
    this.longitude,
  });

  String id;
  String name;
  String address;
  String country;
  String state;
  String city;
  double latitude;
  double longitude;

  factory StreetAddress.fromJson(Map<String, dynamic> json) => StreetAddress(
        id: json["_id"],
        name: json["name"],
        address: json["address"],
        country: json["country"],
        state: json["state"],
        city: json["city"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "address": address,
        "country": country,
        "state": state,
        "city": city,
        "latitude": latitude,
        "longitude": longitude,
      };
}

// To parse this JSON data, do
//
//     final categories = categoriesFromJson(jsonString);

import 'dart:convert';

List<Categories> categoriesFromJson(String str) =>
    List<Categories>.from(json.decode(str).map((x) => Categories.fromJson(x)));

String categoriesToJson(List<Categories> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Categories {
  Categories({
    this.description,
    this.id,
    this.name,
    this.imgPath,
  });

  String description;

  String id;
  String name;
  String imgPath;

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
        description: json["description"],
        id: json["_id"],
        name: json["name"],
        imgPath: json["imgPath"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "_id": id,
        "name": name,
        "imgPath": imgPath,
      };
}

// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

import 'package:contratame/src/models/professional.dart';

List<Order> orderFromJson(String str) =>
    List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

String orderToJson(List<Order> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class Order {
  String jobdescription;
  String jobLocation;
  String status;
  double grade;
  String jobComments;
  String id;
  Customer customer;
  Professional professional;
  DateTime jobStartDate;
  DateTime jobEndDate;
  String jobPicUrl;
  String jobPicUrlId;
  DateTime createdAt;
  DateTime updatedAt;

  Order({
    this.jobdescription,
    this.jobLocation,
    this.status,
    this.grade,
    this.jobComments,
    this.id,
    this.customer,
    this.professional,
    this.jobStartDate,
    this.jobEndDate,
    this.jobPicUrl,
    this.jobPicUrlId,
    this.createdAt,
    this.updatedAt,
  });

  Order.fromJson(Map<String, dynamic> json) {
    jobdescription = json['jobdescription'];
    jobLocation = json['jobLocation'];
    status = json['status'];
    grade = json['grade'].toDouble();
    jobComments = json['jobComments'];
    id = json['_id'];
    customer =
        json['customer'] != null && json['customer'].runtimeType != String
            ? new Customer.fromJson(json['customer'])
            : null;
    professional = json['professional'] != null &&
            json['professional'].runtimeType != String
        ? new Professional.fromJson(json['professional'])
        : null;
    jobStartDate = DateTime.parse(json["jobStartDate"]);
    jobEndDate = DateTime.parse(json["jobEndDate"]);
    jobPicUrl = json['jobPicUrl'];
    jobPicUrlId = json['jobPicUrlId'];
    createdAt = DateTime.parse(json["createdAt"]);
    updatedAt = DateTime.parse(json["updatedAt"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['jobdescription'] = this.jobdescription;
    data['jobLocation'] = this.jobLocation;
    data['status'] = this.status;
    data['grade'] = this.grade;
    data['jobComments'] = this.jobComments;
    data['_id'] = this.id;
    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }
    if (this.professional != null) {
      data['professional'] = this.professional.toJson();
    }
    data['jobStartDate'] = this.jobStartDate;
    data['jobEndDate'] = this.jobEndDate;
    data['jobPicUrl'] = this.jobPicUrl;
    data['jobPicUrlId'] = this.jobPicUrlId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Customer {
  String displayName;
  String profilePicUrl;
  String uid;

  Customer({this.displayName, this.profilePicUrl, this.uid});

  Customer.fromJson(Map<String, dynamic> json) {
    displayName = json['displayName'];
    profilePicUrl = json['profilePicUrl'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['displayName'] = this.displayName;
    data['profilePicUrl'] = this.profilePicUrl;
    data['uid'] = this.uid;
    return data;
  }
}

// class Professional {
//   List<Categories> categories;
//   String displayName;
//   String profilePicUrl;
//   String uid;

//   Professional(
//       {this.categories, this.displayName, this.profilePicUrl, this.uid});

//   Professional.fromJson(Map<String, dynamic> json) {
//     if (json['categories'] != null) {
//       categories = new List<Categories>();
//       json['categories'].forEach((v) {
//         categories.add(new Categories.fromJson(v));
//       });
//     }
//     displayName = json['displayName'];
//     profilePicUrl = json['profilePicUrl'];
//     uid = json['uid'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.categories != null) {
//       data['categories'] = this.categories.map((v) => v.toJson()).toList();
//     }
//     data['displayName'] = this.displayName;
//     data['profilePicUrl'] = this.profilePicUrl;
//     data['uid'] = this.uid;
//     return data;
//   }
// }

// class Categories {
//   String id;
//   String name;

//   Categories({this.id, this.name});

//   Categories.fromJson(Map<String, dynamic> json) {
//     id = json['_id'];
//     name = json['name'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.id;
//     data['name'] = this.name;
//     return data;
//   }
// }

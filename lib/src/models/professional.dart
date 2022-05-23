// To parse this JSON data, do
//
//     final professional = professionalFromJson(jsonString);

import 'dart:convert';

import 'package:contratame/src/models/category_model.dart';
import 'package:contratame/src/models/order.dart';

List<Professional> professionalFromJson(String str) => List<Professional>.from(
    json.decode(str).map((x) => Professional.fromJson(x)));

String professionalToJson(List<Professional> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Professional {
  double distance;
  String id;
  String displayName;
  double qualityScore;
  List<Categories> categories;
  String about;
  String phoneNumber;
  List<StreetAddress> streetAddress;
  String profilePicUrl;
  List<Order> orders;

  Professional(
      {this.distance,
      this.id,
      this.displayName,
      this.qualityScore,
      this.categories,
      this.about,
      this.phoneNumber,
      this.streetAddress,
      this.profilePicUrl,
      this.orders});

  Professional.fromJson(Map<String, dynamic> json) {
    distance = json['distance'] != null ? json['distance'].toDouble() : 0.0;
    id = json['id'];
    displayName = json['displayName'];
    qualityScore =
        json["qualityScore"] != null ? json['qualityScore'].toDouble() : 0.0;
    if (json['categories'] != null) {
      categories = [];
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
    about = json['about'];
    phoneNumber = json['phoneNumber'];
    if (json['streetAddress'] != null) {
      streetAddress = [];
      json['streetAddress'].forEach((v) {
        streetAddress.add(new StreetAddress.fromJson(v));
      });
    }
    profilePicUrl = json['profilePicUrl'];
    if (json['orders'] != null) {
      orders = [];
      json['orders'].forEach((v) {
        orders.add(new Order.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['distance'] = this.distance;
    data['id'] = this.id;
    data['displayName'] = this.displayName;
    data['qualityScore'] = this.qualityScore;
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    data['about'] = this.about;
    data['phoneNumber'] = this.phoneNumber;
    if (this.streetAddress != null) {
      data['streetAddress'] =
          this.streetAddress.map((v) => v.toJson()).toList();
    }
    data['profilePicUrl'] = this.profilePicUrl;
    if (this.orders != null) {
      data['orders'] = this.orders.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

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

class StreetAddress {
  String id;
  String name;
  String address;
  String country;
  String state;
  String city;
  double latitude;
  double longitude;

  StreetAddress(
      {this.id,
      this.name,
      this.address,
      this.country,
      this.state,
      this.city,
      this.latitude,
      this.longitude});

  StreetAddress.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    address = json['address'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

// class Orders {
//   String jobdescription;
//   String jobLocation;
//   String status;
//   int grade;
//   String jobComments;
//   String id;
//   Customer customer;
//   String professional;
//   String jobStartDate;
//   String jobEndDate;

//   Orders(
//       {this.jobdescription,
//       this.jobLocation,
//       this.status,
//       this.grade,
//       this.jobComments,
//       this.id,
//       this.customer,
//       this.professional,
//       this.jobStartDate,
//       this.jobEndDate});

//   Orders.fromJson(Map<String, dynamic> json) {
//     jobdescription = json['jobdescription'];
//     jobLocation = json['jobLocation'];
//     status = json['status'];
//     grade = json['grade'];
//     jobComments = json['jobComments'];
//     id = json['_id'];
//     customer = json['customer'] != null
//         ? new Customer.fromJson(json['customer'])
//         : null;
//     professional = json['professional'];
//     jobStartDate = json['jobStartDate'];
//     jobEndDate = json['jobEndDate'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['jobdescription'] = this.jobdescription;
//     data['jobLocation'] = this.jobLocation;
//     data['status'] = this.status;
//     data['grade'] = this.grade;
//     data['jobComments'] = this.jobComments;
//     data['_id'] = this.id;
//     if (this.customer != null) {
//       data['customer'] = this.customer.toJson();
//     }
//     data['professional'] = this.professional;
//     data['jobStartDate'] = this.jobStartDate;
//     data['jobEndDate'] = this.jobEndDate;
//     return data;
//   }
// }

// class Customer {
//   String displayName;
//   String profilePicUrl;
//   String uid;

//   Customer({this.displayName, this.profilePicUrl, this.uid});

//   Customer.fromJson(Map<String, dynamic> json) {
//     displayName = json['displayName'];
//     profilePicUrl = json['profilePicUrl'];
//     uid = json['uid'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['displayName'] = this.displayName;
//     data['profilePicUrl'] = this.profilePicUrl;
//     data['uid'] = this.uid;
//     return data;
//   }
// }

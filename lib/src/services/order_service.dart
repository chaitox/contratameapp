import 'dart:convert';

import 'package:contratame/src/models/order.dart';
import 'package:contratame/src/models/order_response.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;

import 'package:contratame/src/services/auth_service.dart';

import 'package:contratame/src/global/environment.dart';

class OrderService with ChangeNotifier {
  List<Order> orders;
  Order order;
  Future<List<Order>> getAllOrders() async {
    try {
      final url = Uri.parse('${Environment.apiUrl}/order');
      final resp = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      });

      this.orders = orderFromJson(resp.body);

      return orders;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<Order>> getOrder(String orderid) async {
    try {
      final url = Uri.parse('${Environment.apiUrl}/order/$orderid');
      final resp = await http.get(url, headers: {
        'Content-Type': 'application/json',
        // 'x-token': await AuthService.getToken()
      });

      this.orders = orderFromJson(resp.body);

      return orders;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<Order>> getOrderByCustomerId(
      String customerId, String status) async {
    try {
      final data = {'status': status};
      final url = Uri.parse('${Environment.apiUrl}/order/customer/$customerId');
      final resp = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            // 'x-token': await AuthService.getToken()
          },
          body: jsonEncode(data));

      this.orders = orderFromJson(resp.body);

      return orders;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future addOrder(String customer, String professional, String jobdescription,
      String jobLocation, String jobStartDate, String imagePath) async {
    /*final data = {
      'customer': customer,
      'professional': professional,
      'jobdescription': jobdescription,
      'jobLocation': jobLocation,
      'jobStartDate': jobStartDate,
    };*/
    final url = Uri.parse('${Environment.apiUrl}/order/');
    var request = http.MultipartRequest('POST', url);
    // request.headers['customer'] ='bearer $authorizationToken';
    request.fields['customer'] = customer;
    request.fields['professional'] = professional;
    request.fields['jobdescription'] = jobdescription;
    request.fields['jobLocation'] = jobLocation;
    request.fields['jobStartDate'] = jobStartDate;
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    var response = await request.send();
    print(response.stream);
    print(response.statusCode);
    final resp = await http.Response.fromStream(response);
    print(resp.body);
    // final resp = await http.post(url,
    //     body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    // print(resp.body);

    if (resp.statusCode == 200) {
      final orderResponse = orderResponseFromJson(resp.body);
      // notifyListeners();
      //this.order = orderResponse;
      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future updateOrder(
      String orderid,
      String jobdescription,
      String jobEndDate,
      String jobStartDate,
      String jobLocation,
      String status,
      double grade,
      String jobComments) async {
    final data = {
      'jobStartDate': jobStartDate,
      'jobdescription': jobdescription,
      'jobEndDate': jobEndDate,
      'jobLocation': jobLocation,
      'status': status,
      'grade': grade,
      'jobComments': jobComments,
    };
    final url = Uri.parse('${Environment.apiUrl}/order/$orderid');
    final resp = await http.put(url,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    // print(resp.body);

    if (resp.statusCode == 200) {
      final orderResponse = orderResponseFromJson(resp.body);

      this.order = orderResponse.order;
      notifyListeners();
      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future deleteOrder(String orderid) async {
    final url = Uri.parse('${Environment.apiUrl}/order/$orderid');
    final resp = await http.delete(url, headers: {
      'Content-Type': 'application/json',
      // 'x-token': await AuthService.getToken()
    });

    if (resp.statusCode == 200) {
      final orderResponse = orderResponseFromJson(resp.body);

      // this.order = orderResponse;

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }
}

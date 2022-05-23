import 'package:contratame/src/global/environment.dart';
import 'package:contratame/src/models/professional.dart';
import 'package:contratame/src/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfesionalService with ChangeNotifier {
  Future<List<Professional>> getTopProfesional(
      double latitude, longitude) async {
    try {
      final url = Uri.parse(
          '${Environment.apiUrl}/professional/top/$latitude/$longitude');
      final resp = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      });

      // print(resp.body);
      var professsionaResponse = professionalFromJson(resp.body);
      return professsionaResponse.toList();
      // final resp = await http.get(url, headers: {
      //   'Content-Type': 'application/json',
      //   'x-token': await AuthService.getToken()
      // });

      // var data = professionalModelFromJson(resp.body);

      // return data.professional.toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<Professional>> getProfessionalByCategory(
      String idCategory) async {
    try {
      final data = {'idCategory': idCategory};
      final url = Uri.parse('${Environment.apiUrl}/professional');
      final resp = await http.post(url, body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      });

      // print(resp.body);
      var professsionaResponse = professionalFromJson(resp.body);
      return professsionaResponse.toList();
      // final resp = await http.get(url, headers: {
      //   'Content-Type': 'application/json',
      //   'x-token': await AuthService.getToken()
      // });

      // var data = professionalModelFromJson(resp.body);

      // return data.professional.toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<Professional>> addProfessionaltoCategory(
      String professionalId, categoryId) async {
    try {
      // final data = {'idCategory': categoryId};
      final url = Uri.parse(
          '${Environment.apiUrl}/$professionalId/categories/$categoryId');
      final resp = await http.post(url, headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      });

      // print(resp.body);
      var professsionaResponse = professionalFromJson(resp.body);
      return professsionaResponse.toList();
      // final resp = await http.get(url, headers: {
      //   'Content-Type': 'application/json',
      //   'x-token': await AuthService.getToken()
      // });

      // var data = professionalModelFromJson(resp.body);

      // return data.professional.toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<Professional>> getProfessionalByCategoryLocation(
      String idCategory, latitude, longitude, range) async {
    try {
      final url = Uri.parse(
          '${Environment.apiUrl}/professional/prof/$idCategory/$latitude/$longitude/$range');
      final resp = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      });

      // print(resp.body);
      var professsionaResponse = professionalFromJson(resp.body);
      return professsionaResponse.toList();
      // final resp = await http.get(url, headers: {
      //   'Content-Type': 'application/json',
      //   'x-token': await AuthService.getToken()
      // });

      // var data = professionalModelFromJson(resp.body);

      // return data.professional.toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}

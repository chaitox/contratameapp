import 'package:contratame/src/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:contratame/src/services/auth_service.dart';

import 'package:contratame/src/global/environment.dart';

class CategoryService with ChangeNotifier {
  Future<List<Categories>> getAllCategory() async {
    try {
      final url = Uri.parse('${Environment.apiUrl}/category');
      final resp = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      });

      final category = categoriesFromJson(resp.body);

      return category;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<Categories>> getCategory(String idCategory) async {
    try {
      final url = Uri.parse('${Environment.apiUrl}/$idCategory');
      final resp = await http.get(url, headers: {
        'Content-Type': 'application/json',
        // 'x-token': await AuthService.getToken()
      });

      final category = categoriesFromJson(resp.body);

      return category;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}

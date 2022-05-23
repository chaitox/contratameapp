import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class ServiceMenuProvider {
  List<dynamic> opciones = [];

  ServiceMenuProvider() {
    loadData();
  }
  Future<List<dynamic>> loadData() async{

  final resp = await rootBundle.loadString('data/menu.json');
    Map dataMap = json.decode(resp);   
    opciones = dataMap['rutas'];

    return opciones;
  }
}

final serviceMenuProvider = new ServiceMenuProvider();

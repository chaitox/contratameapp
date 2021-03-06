import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:contratame/src/services/auth_service.dart';
import 'package:contratame/src/global/environment.dart';

import 'package:contratame/src/models/mensajes_response.dart';
import 'package:contratame/src/models/usuario.dart';

class ChatService with ChangeNotifier {
  Usuario usuarioPara;

  Future<List<Mensaje>> getChat(String usuarioID) async {
    final url = Uri.parse('${Environment.apiUrl}/mensajes/$usuarioID');
    final resp = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'x-token': await AuthService.getToken()
    });

    final mensajesResp = mensajesResponseFromJson(resp.body);

    return mensajesResp.mensajes;
  }
}

import 'package:http/http.dart' as http;

import 'package:contratame/src/models/usuario.dart';
import 'package:contratame/src/models/usuarios_response.dart';

import 'package:contratame/src/services/auth_service.dart';

import 'package:contratame/src/global/environment.dart';

class UsuariosService {
  Future<List<Usuario>> getUsuarios() async {
    try {
      final url = Uri.parse('${Environment.apiUrl}/usuarios');
      final resp = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      });

      final usuariosResponse = usuariosResponseFromJson(resp.body);

      return usuariosResponse.usuarios;
    } catch (e) {
      return [];
    }
  }
}

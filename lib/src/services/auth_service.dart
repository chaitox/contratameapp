import 'package:contratame/src/models/addressResponse.dart';
import 'package:contratame/src/models/usuarios_response.dart';
import 'package:contratame/src/utils/rol.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:contratame/src/global/environment.dart';

import 'package:contratame/src/models/login_response.dart';
import 'package:contratame/src/models/usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService with ChangeNotifier {
  SharedPreferences _sharedPreferencesInstance;
  Usuario usuario;
  bool _autenticando = false;

  final _storage = new FlutterSecureStorage();

  bool get autenticando => this._autenticando;
  set autenticando(bool valor) {
    this._autenticando = valor;
    notifyListeners();
  }

  // Getters del token de forma estática
  static Future<String> getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString("token");
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password, bool isCustomer) async {
    _sharedPreferencesInstance = await SharedPreferences.getInstance();
    final fcmToken = _sharedPreferencesInstance.getString('fcmToken');
    this.autenticando = true;
    String rol = Rol().retornaRol(isCustomer);

    final data = {
      'email': email,
      'password': password,
      'role': rol,
      'fcmToken': fcmToken
    };
    String url;

    /*if (isCustomer) {
      url = '${Environment.apiUrl}/customer/login';
    } else {
      url = '${Environment.apiUrl}/professional/login';
    }*/

    url = '${Environment.apiUrl}/customer/login';

    final resp = await http.post(Uri.parse(url),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    this.autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;
      await _sharedPreferencesInstance.setString("token", loginResponse.token);
      await _sharedPreferencesInstance.setString("email", email);
      // await this._guardarToken(loginResponse.token);

      return true;
    } else {
      return false;
    }
  }

  Future register(
      String firstName,
      String lastName,
      String phoneNumber,
      String email,
      String password,
      String name,
      String address,
      String country,
      String state,
      String city,
      double latitude,
      double longitude,
      String about,
      String categories,
      bool isCustomer) async {
    // TODO AQUI REGISTRAMOS UN CLIENTE NUEVO, PODEMOS REGISTRAR UN PROVEEDOR TAMBIEN?
    this.autenticando = true;
    _sharedPreferencesInstance = await SharedPreferences.getInstance();
    final data = {
      'displayName': firstName + " " + lastName,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'email': email,
      'password': password,
      'fcmToken': _sharedPreferencesInstance.getString('fcmToken'),
      "streetAddress": [
        {
          "name": name,
          "address": address,
          "country": country,
          "state": state,
          "city": city,
          "latitude": latitude,
          "longitude": longitude
        }
      ],
      'about': about,
      'categories': categories,
      'role': Rol().retornaRol(isCustomer)
    };

    String url;
    /*
    if (isCustomer) {
      url = '${Environment.apiUrl}/customer/new';
    } else {
      url = '${Environment.apiUrl}/professional/new';
    }*/
    url = '${Environment.apiUrl}/customer/new';

    final resp = await http.post(Uri.parse(url),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    // print(resp.body);
    this.autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;
      await _sharedPreferencesInstance.setString("token", loginResponse.token);
      await _sharedPreferencesInstance.setString("email", email);

      // await this._guardarToken(loginResponse.token);

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future<bool> isLoggedIn(bool isCustomer) async {
    // final token = await this._storage.read(key: 'token');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString("token");
    String url;
    if (isCustomer) {
      url = '${Environment.apiUrl}/customer/renew';
    } else {
      url = '${Environment.apiUrl}/professional/renew';
    }

    final resp = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'x-token': token,
      'fcmToken': sharedPreferences.getString('fcmToken')
    });

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;
      await sharedPreferences.setString("token", loginResponse.token);
      // await this._guardarToken(loginResponse.token);
      return true;
    } else {
      this.logout();
      return false;
    }
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future<void> logout() async {
    // await _storage.delete(key: 'token');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    await _googleSignIn.signOut();
    print('Se cerro la sesion');
  }

  static GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  Future signInWithGoogle(bool isCustomer) async {
    final GoogleSignInAccount account = await _googleSignIn.signIn();
    final googleKey = await account.authentication;

    // print(account);
    // print('===============ID TOKEN ================');
    // print(googleKey.idToken);

    this.autenticando = true;

    final data = {
      'google': true,
      'password': 'noPassword',
      'token': googleKey.idToken
    };
    String url;
    if (isCustomer) {
      url = '${Environment.apiUrl}/customer/google';
    } else {
      url = '${Environment.apiUrl}/professional/google';
    }

    final resp = await http.post(Uri.parse(url),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    print(resp.body);

    this.autenticando = false;
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;
      print(loginResponse.token);
      await this._guardarToken(loginResponse.token);

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future addAddress(String name, String address, String country, String state,
      String city, double latitude, double longitude, String usuarioid) async {
    final data = {
      "name": name,
      "address": address,
      "country": country,
      "state": state,
      "city": city,
      "latitude": latitude,
      "longitude": longitude
    };
    final url = Uri.parse('${Environment.apiUrl}/customer/address/$usuarioid');
    final resp = await http.post(url,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    // print(resp.body);

    if (resp.statusCode == 200) {
      final usuarioResponse = addressResponseFromJson(resp.body);
      this.usuario = usuarioResponse.usuario;
      notifyListeners();
      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future deleteAddress(String addressid, String usuarioid) async {
    final data = {"_id": usuarioid};
    final url =
        Uri.parse('${Environment.apiUrl}/customer/address/del/$addressid');
    final resp = await http.post(url,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    if (resp.statusCode == 200) {
      final usuarioResponse = addressResponseFromJson(resp.body);
      this.usuario = usuarioResponse.usuario;
      notifyListeners();
      // this.order = orderResponse;

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }
}

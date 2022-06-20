import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyBrk9Rwz7FSkHWIrhQ8bI575i_MiQc0jYI';
  final storage = const FlutterSecureStorage();

//si retornamos algo es error, sino tutti benne
  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {'email': email, 'password': password, 'returnSecureToken': true};
    final url = Uri.https(_baseUrl, '/v1/accounts:signUp', {'key': _firebaseToken});
    final response = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(response.body);

    if (decodedResp.containsKey('idToken')) {
      //grabar token en el storage
      await storage.write(key: 'idToken', value: decodedResp['idToken']);
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {'email': email, 'password': password};
    final url =
        Uri.https(_baseUrl, '/v1/accounts:signInWithPassword', {'key': _firebaseToken, 'returnSecureToken': true});
    final response = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(response.body);

    if (decodedResp.containsKey('idToken')) {
      await storage.write(key: 'idToken', value: decodedResp['idToken']);
      //grabar token en el storage
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  Future<void> logout() async {
    await storage.delete(key: 'idToken');
  }

  Future<String> readToken() async {
    return await storage.read(key: 'idToken') ?? '';
  }
}

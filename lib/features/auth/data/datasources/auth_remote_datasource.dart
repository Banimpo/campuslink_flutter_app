import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

abstract class AuthRemoteDataSource {
  Future<String> register({
    required String name,
    required int age,
    required String email,
    required String password,
  });

  Future<String> login({required String email, required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  static String get baseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:8000';
    }

    return 'http://192.168.100.220:8000';
  }

  @override
  Future<String> register({
    required String name,
    required int age,
    required String email,
    required String password,
  }) async {
    final response = await client.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'age': age, 'email': email, 'password': password}),
    );

    return _extractToken(response);
  }

  @override
  Future<String> login({required String email, required String password}) async {
    final response = await client.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    return _extractToken(response);
  }

  String _extractToken(http.Response response) {
    final body = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return body['access_token'] as String;
    }

    if (response.statusCode == 401) {
      throw Exception('Email ou mot de passe incorrect');
    }

    if (response.statusCode == 409) {
      throw Exception('Cette adresse e-mail est déjà utilisée');
    }

    if (response.statusCode == 422) {
      throw Exception('Les informations saisies sont invalides');
    }

    throw Exception(
      body is Map && body['detail'] != null
          ? body['detail'].toString()
          : 'Erreur du serveur (${response.statusCode})',
    );
  }
}

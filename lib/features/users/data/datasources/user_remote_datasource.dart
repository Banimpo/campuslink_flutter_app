import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user_model.dart';
import 'package:flutter/foundation.dart';

abstract class UserRemoteDataSource {
  Future<List<UserModel>> getUsers();

  Future<UserModel> createUser({required String name, required int age, required String email});
  Future<void> deleteUser(int userId);
  Future<UserModel> getUserById(int userId);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;

  UserRemoteDataSourceImpl({required this.client});

  static String get baseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:8000';
    }

    return 'http://192.168.100.220:8000';
  }

  @override
  Future<List<UserModel>> getUsers() async {
    final response = await client.get(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);

      return jsonList.map((json) => UserModel.fromJson(json as Map<String, dynamic>)).toList();
    }

    throw Exception('Impossible de récupérer les utilisateurs : ${response.statusCode}');
  }

  @override
  Future<UserModel> createUser({
    required String name,
    required int age,
    required String email,
  }) async {
    final response = await client.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'age': age, 'email': email}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> json = jsonDecode(response.body) as Map<String, dynamic>;

      return UserModel.fromJson(json);
    }

    throw Exception('Création impossible (${response.statusCode}) : ${response.body}');
  }

  @override
  Future<void> deleteUser(int userId) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/users/$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return;
    }

    if (response.statusCode == 404) {
      throw Exception('Utilisateur introuvable');
    }

    if (response.statusCode >= 500) {
      throw Exception('Erreur interne du serveur');
    }

    throw Exception('Suppression impossible (${response.statusCode})');
  }

  @override
  Future<UserModel> getUserById(int userId) async {
    final response = await client.get(
      Uri.parse('$baseUrl/users/$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return UserModel.fromJson(json);
    }

    if (response.statusCode == 404) {
      throw Exception('Utilisateur introuvable');
    }

    throw Exception('Impossible de récupérer l’utilisateur (${response.statusCode})');
  }
}

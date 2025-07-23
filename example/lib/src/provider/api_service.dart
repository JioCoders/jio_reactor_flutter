// API Service
import 'dart:convert';

import 'package:example/src/provider/todo_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<User>> fetchUsers() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay

    final response = await http.get(Uri.parse('$baseUrl/users'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<User> fetchUser(int id) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    
    final response = await http.get(Uri.parse('$baseUrl/users/$id'));
    
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }
}

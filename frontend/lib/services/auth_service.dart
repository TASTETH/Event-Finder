// lib/services/auth_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // В эмуляторе Android локальный хост (ваш ПК) доступен по 10.0.2.2
  // Если запускаете на iOS Simulator, можно оставить 'http://localhost:8000'.
  static const String _baseUrl = 'http://10.0.2.2:8000';

  /// Метод регистрации пользователя (POST /register)
  /// Формат JSON полей должен точно совпадать с тем, что ждёт ваш FastAPI
  static Future<bool> register({
    required String username,
    required String email,
    required String password,
    String? fullName,
    int? age,
    String? city,
  }) async {
    final uri = Uri.parse('$_baseUrl/register');

    final Map<String, dynamic> body = {
      'username': username,
      'email': email,
      'password': password,
      if (fullName != null && fullName.isNotEmpty) 'full_name': fullName,
      if (age != null) 'age': age,
      if (city != null && city.isNotEmpty) 'city': city,
    };

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      // Выводим логи, если что-то пошло не так
      print('=== AuthService.register FAILED ===');
      print('URL: $uri');
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  }

  /// Метод логина пользователя (POST /token)
  /// FastAPI с OAuth2PasswordRequestForm ждёт данные в формате form data
  static Future<String?> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('http://10.0.2.2:8000/token');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: 'username=$email&password=$password',
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData['access_token'];
    } else {
      print('=== AuthService.login FAILED ===');
      print('URL: $uri');
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null;
    }
  }
}

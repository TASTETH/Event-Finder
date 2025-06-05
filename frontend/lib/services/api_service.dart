import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/event.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.43.206:8000';

  static Future<String?> login(String username, String password) async {
    var response = await http.post(
      Uri.parse('$baseUrl/token'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'username': username,
        'password': password,
      },
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['access_token'];
    }
    return null;
  }

  static Future<bool> register(String email, String username, String password,
      String fullName, int age, String city) async {
    var response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'username': username,
        'password': password,
        'full_name': fullName,
        'age': age,
        'city': city,
      }),
    );
    return response.statusCode == 200;
  }

  static Future<User?> getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) return null;
    var response = await http.get(
      Uri.parse('$baseUrl/users/me'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return User.fromJson(data);
    }
    return null;
  }

  static Future<List<Event>?> getEvents() async {
    var response = await http.get(Uri.parse('$baseUrl/events/'));
    if (response.statusCode == 200) {
      var list = json.decode(response.body) as List;
      return list.map((e) => Event.fromJson(e)).toList();
    }
    return null;
  }

  static Future<bool> createEvent(
      String title,
      String address,
      String briefDesc,
      String detailedDesc,
      String contact,
      double lat,
      double lon,
      String date,
      bool ageRestriction) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) return false;
    var response = await http.post(
      Uri.parse('$baseUrl/events/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode({
        'title': title,
        'address': address,
        'brief_description': briefDesc,
        'detailed_description': detailedDesc,
        'contact_info': contact,
        'latitude': lat,
        'longitude': lon,
        'date': date,
        'age_restriction': ageRestriction,
      }),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }
}

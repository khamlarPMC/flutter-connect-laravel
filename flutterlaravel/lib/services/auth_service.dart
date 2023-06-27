import 'dart:convert';
import 'package:flutterlaravel/services/globals.dart';
import 'package:http/http.dart' as http;

class AuthServices {
  static Future<http.Response> register(
      String name, String email, String password) async {
    try {
      final url = Uri.parse('${baseUrl}auth/register');
      final headers = {'Content-Type': 'application/json'};
      final body = json.encode({
        "name": name,
        "email": email,
        "password": password,
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print(response.body);
        return response;
      } else {
        print('Registration failed with status code: ${response.statusCode}');
        return response;
      }
    } catch (e) {
      print('Registration failed with error: $e');
      throw e;
    }
  }

  static Future<http.Response> login(String email, String password) async {
    try {
      final url = Uri.parse('${baseUrl}auth/login');
      final headers = {'Content-Type': 'application/json'};
      final body = json.encode({
        "email": email,
        "password": password,
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print(response.body);
        return response;
      } else {
        print('Login failed with status code: ${response.statusCode}');
        return response;
      }
    } catch (e) {
      print('Login failed with error: $e');
      throw e;
    }
  }
}

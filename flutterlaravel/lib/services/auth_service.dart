import 'dart:convert';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterlaravel/services/dio.dart';
import 'package:flutterlaravel/services/globals.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class AuthServices with ChangeNotifier {
  bool _isLoggedIn = false;
  User? _user;
  static String? _token;

  bool get authenticated => _isLoggedIn;
  User get user => _user ?? User(name: '', email: '', avatar: '');

  final storage = const FlutterSecureStorage();

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

  static Future<http.Response> logout(String token) async {
    try {
      final url = Uri.parse('${baseUrl}auth/logout');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        print('Logout successful');
        return response;
      } else {
        print('Logout failed with status code: ${response.statusCode}');
        return response;
      }
    } catch (e) {
      print('Logout failed with error: $e');
      throw e;
    }
  }

  void setLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  Future<void> tryToken({required String token, String? accessToken}) async {
    if (token == null) {
      return;
    } else {
      try {
        Dio.Response response = await dio().get('/user',
            options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
        _isLoggedIn = true;
        _user = User.fromJson(response.data);
        _token = token;
        storeToken(token: token);

        await fetchUserDetails(); // Fetch additional user details

        notifyListeners();
      } catch (e) {
        print(e);
      }
    }
  }

  void storeToken({required String token}) async {
    storage.write(key: 'token', value: token);
  }

  Future<void> fetchUserDetails() async {
    try {
      Dio.Response response = await dio().get('/user',
          options: Dio.Options(headers: {'Authorization': 'Bearer $_token'}));
      _user = User.fromJson(response.data);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchUser() async {
    try {
      Dio.Response response = await dio().get('/user',
          options: Dio.Options(headers: {'Authorization': 'Bearer $_token'}));
      _isLoggedIn = true;
      _user = User.fromJson(response.data);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
  static void setToken(String token) {
    _token = token;
  }
}

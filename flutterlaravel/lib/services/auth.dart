import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterlaravel/models/user.dart';
import 'package:flutterlaravel/services/dio.dart';

class Auth extends ChangeNotifier {
  bool _isLoggedIn = false;
  User? _user;
  String? _token;

  bool get authenticated => _isLoggedIn;
  User get user => _user!;

  final storage = FlutterSecureStorage();

  Future<void> login({required Map creds}) async {
    print(creds);

    try {
      Dio.Response response = await dio().post('/sanctum/token', data: creds);
      print(response.data.toString());

      String token = response.data.toString();
      tryToken(token: token);
    } catch (e) {
      print(e);
    }
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

        notifyListeners();
        print(_user);
      } catch (e) {
        print(e);
      }
    }
  }

  void storeToken({required String token}) async {
    storage.write(key: 'token', value: token);
  }

  Future<void> logout() async {
    try {
      final response = await dio().get(
        '/user/revoke',
        options: Dio.Options(headers: {'Authorization': 'Bearer $_token'}),
      );

      if (response.statusCode == 200) {
        cleanUp();
        notifyListeners();
      } else {
        throw Exception('Failed to revoke token: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Dio.DioError) {
        if (e.response?.statusCode == 401) {
          print(
              'Unauthorized access: Invalid or expired token. Please log in again.');
        } else {
          print('Request Error: ${e.message}');
        }
      } else {
        print('Error: $e');
      }
    }
  }

  void cleanUp() async {
    _user = null;
    _isLoggedIn = false;
    _token = null;
    await storage.delete(key: 'token');
  }
}

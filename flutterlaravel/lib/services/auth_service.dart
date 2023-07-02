import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';

class AuthServices with ChangeNotifier {
  bool _isLoggedIn = false;
  User? _user;

  bool get authenticated => _isLoggedIn;
  User get user => _user ?? User(name: '', email: '', avatar: '');

  final storage = const FlutterSecureStorage();

}

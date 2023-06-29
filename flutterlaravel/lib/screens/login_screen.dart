import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutterlaravel/home.dart';
import 'package:flutterlaravel/models/rounded_button.dart';
import 'package:flutterlaravel/screens/register_form.dart';
import 'package:flutterlaravel/services/auth_service.dart';
import 'package:flutterlaravel/services/globals.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  String get title => 'Login and Register';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool rememberMe = false;

  String _email = '';
  String _password = '';

  late SharedPreferences _prefs;
  final String _emailKey = 'email';
  final String _passwordKey = 'password';

  loginPressed() async {
    if (_email.isNotEmpty && _password.isNotEmpty) {
      http.Response response = await AuthServices.login(_email, _password);
      Map responseMap = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Store the email and password if the "Remember Me" checkbox is checked
        if (rememberMe) {
          _prefs.setString(_emailKey, _email);
          _prefs.setString(_passwordKey, _password);
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) =>
                MyHomePage(title: "show in space"),
          ),
        );
      } else {
        errorSnackBar(context, responseMap.values.first);
      }
    } else {
      errorSnackBar(context, 'enter all required fields');
    }
  }

  // Device info
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  // Show and hide password
  bool _isPasswordHidden = true;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
      setState(() {
        // Retrieve the stored email and password
        _email = _prefs.getString(_emailKey) ?? '';
        _password = _prefs.getString(_passwordKey) ?? '';
        // Set the initial values for the controllers
        _emailController.text = _email;
        _passwordController.text = _password;
      });

      // Perform automatic login if both email and password are not empty
      if (_email.isNotEmpty && _password.isNotEmpty) {
        loginPressed();
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
  create: (context) => AuthServices(),
  child:Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/Google-flutter-logo.png',
                    height: 100,
                    width: 300,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Login This app',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 77, 70, 70),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _email = value;
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordHidden
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordHidden = !_isPasswordHidden;
                          });
                        },
                      ),
                    ),
                    obscureText: _isPasswordHidden,
                    onChanged: (value) {
                      setState(() {
                        _password = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  RoundedButton(
                    btnText: 'Create Account',
                    onBtnPressed: loginPressed,
                  ),
                  CheckboxListTile(
                    title: const Text('Remember Me'),
                    value: rememberMe,
                    onChanged: (bool? value) {
                      setState(() {
                        rememberMe = value ?? false;
                      });
                    },
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 24),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 2,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'Forgot password?',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blueAccent,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(flex: 1),
                              Flexible(
                                flex: 2,
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const RegisterScreen(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Register',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blueAccent,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}

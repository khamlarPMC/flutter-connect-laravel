import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutterlaravel/home.dart';
import 'package:flutterlaravel/models/login_button.dart';
import 'package:flutterlaravel/screens/register_form.dart';
import 'package:flutterlaravel/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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

  //variable rememberme=ture when i login
  bool rememberMe = false;
  SharedPreferences? prefs;


  // Show and hide password
  bool _isPasswordHidden = true;

  @override
  void initState() {
    super.initState();
    loadRememberMe();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

    String _email = '';
  String _password = '';


Future<void> loginAccountPressed() async {
  // Perform email validation

  // Make the login request
  final response = await http.post(
    Uri.parse('http://10.0.2.2:8000/api/auth/login'),
    body: {
      'email': _email,
      'password': _password,
    },
  );

  if (response.statusCode == 200) {
    // Login successful, navigate to the desired page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const MyHomePage(title: 'Show my space'),
      ),
    );
  } else {
    // Login failed, handle the error
    final responseMap = jsonDecode(response.body);
    String errorMessage;
    if (responseMap['error'] != null) {
      // Handle specific login errors
      errorMessage = responseMap['error'];
    } else {
      // Handle general error
      errorMessage = responseMap['message'];
    }
    errorSnackBar(context, errorMessage);
  }
}

void errorSnackBar(BuildContext context, String errorMessage) {
    final snackBar = SnackBar(
      content: Text(errorMessage),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  

  Future<void> loadRememberMe() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      rememberMe = prefs!.getBool('rememberMe') ?? false;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AuthServices(),
        child: Scaffold(
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
                _email = value;
              },
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordHidden ? Icons.visibility : Icons.visibility_off,
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
                _password = value;
              },
            ),
                    const SizedBox(height: 10),
                    LoginButton(
                      btnText: 'Login Account',
                      onBtnPressed: loginAccountPressed,
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
        ));
  }
}

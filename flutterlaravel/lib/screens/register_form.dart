import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutterlaravel/home.dart';
import 'package:flutterlaravel/models/register_button.dart';
import 'package:flutterlaravel/screens/login_screen.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  String get title => 'Register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordHidden = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _name = '';
  String _email = '';
  String _password = '';

  Future<void> createAccountPressed() async {
    // Perform email validation

    // Make the registration request
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/auth/register'),
      body: {
        'name': _name,
        'email': _email,
        'password': _password,
      },
    );

    if (response.statusCode == 200) {
      // Registration successful, navigate to the desired page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              const MyHomePage(title: 'Show my space'),
        ),
      );
    } else {
      // Registration failed, handle the error
      final responseMap = jsonDecode(response.body);
      String errorMessage;
      if (responseMap['errors'] != null) {
        // Handle validation errors
        errorMessage = responseMap['errors'].values.first[0];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Name',
              ),
              onChanged: (value) {
                _name = value;
              },
            ),
            const SizedBox(height: 30),
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
            const SizedBox(height: 40),
            RegisterButton(
              onBtnPressed: createAccountPressed,
              btnText: 'Create Account',
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const LoginScreen(),
                  ),
                );
              },
              child: const Text(
                'Already have an account?',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.blueAccent,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

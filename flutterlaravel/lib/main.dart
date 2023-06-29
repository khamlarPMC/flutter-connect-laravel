import 'package:flutter/material.dart';
import 'package:flutterlaravel/screens/login_screen.dart';
import 'package:flutterlaravel/services/auth_service.dart';
import 'screens/update_student_form.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthServices()),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connect Flutter with Laravel',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
      ),
      home: const LoginScreen(),
      routes: {
        UpdateStudentForm.routeName: (context) => UpdateStudentForm(),
      },
    );
  }
}

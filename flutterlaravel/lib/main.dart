import 'package:flutter/material.dart';
import 'package:flutterlaravel/screens/fisrt_page.dart';
import 'services/auth.dart';
import 'screens/update_student_form.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
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
      home: const FisrtPage(),
      routes: {
        UpdateStudentForm.routeName: (context) => UpdateStudentForm(),
      },
    );
  }
}



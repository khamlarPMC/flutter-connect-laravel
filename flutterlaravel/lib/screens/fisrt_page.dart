import 'package:flutter/material.dart';
import 'package:flutterlaravel/screens/login_screen.dart';

class FisrtPage extends StatefulWidget {
  const FisrtPage({super.key});

  @override
  State<FisrtPage> createState() => _FisrtPageState();
}

class _FisrtPageState extends State<FisrtPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connect Flutter with Laravel',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Connect Flutter with Laravel'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const LoginScreen(),
                ),
              );
            },
            child: const Text('Please login'),
          ),
        ),
      ),
    );
  }
}
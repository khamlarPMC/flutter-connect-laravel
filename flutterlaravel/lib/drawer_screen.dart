import 'package:flutter/material.dart';
import 'package:flutterlaravel/screens/login_screen.dart';
import 'package:flutterlaravel/services/auth_service.dart';
import 'package:provider/provider.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<AuthServices>(
        builder: (context, auth, child) {
          if (!auth.authenticated) {
            return ListView(
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(auth.user.avatar),
                        radius: 30,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        auth.user.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        auth.user.email,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: const Text("Logout"),
                  leading: const Icon(Icons.logout),
                  onTap: () async {
                    try {
                      AuthServices.logout;
                      Navigator.pop(context);
                    } catch (e) {
                      print('Logout error: $e');
                    }
                  },
                ),
              ],
            );
          } else {
            return ListView(
              children: [
                ListTile(
                  title: const Text("Login"),
                  leading: const Icon(Icons.login),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutterlaravel/screens/login_screen.dart';
import 'package:flutterlaravel/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                    await logout(context);
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

  Future<void> logout(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear(); // Clear any user-related data stored in SharedPreferences
  Navigator.pushNamedAndRemoveUntil(
    context, '/login', (Route<dynamic> route) => false);
}


}

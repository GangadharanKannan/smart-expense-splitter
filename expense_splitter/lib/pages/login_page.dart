import 'package:flutter/material.dart';
import '../widgets/glass_background.dart';
import 'register_page.dart';
import 'groups_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassBackground(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          const Text(
            "Login",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 25),

          const TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: "Username",
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          const TextField(
            obscureText: true,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: "Password",
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GroupsPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              child: const Text("Login"),
            ),
          ),

          const SizedBox(height: 10),

          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegisterPage(),
                ),
              );
            },
            child: const Text(
              "Don't have an account? Register",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

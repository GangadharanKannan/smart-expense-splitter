import 'package:flutter/material.dart';
import '../widgets/glass_background.dart';
import 'register_page.dart';
import 'groups_page.dart';
import '../services/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final ApiService apiService = ApiService();
  @override
  Widget build(BuildContext context) {
    return GlassBackground(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // App title
            const Text(
              "SplitEasy",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 30),

            // Username field
            TextField(
              controller: emailController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Email",
                hintStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withOpacity(0.15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.person, color: Colors.white),
              ),
            ),

            const SizedBox(height: 16),

            // Password field
            TextField(
              controller: passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Password",
                hintStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withOpacity(0.15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.lock, color: Colors.white),
              ),
            ),

            const SizedBox(height: 24),

            // Login button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
              onPressed: () async {
                if(emailController.text.isEmpty || passwordController.text.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Enter email & password")),
                  );
                  return;
                }

                var response = await ApiService.login(
                  emailController.text,
                  passwordController.text,
                );
                if (response["status"] == true) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => GroupsPage(user: response["user"]),),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response["message"])));
                }
              },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Register link
            TextButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage(),),);
              },
              child: const Text(
                "Don't have an account? Register",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

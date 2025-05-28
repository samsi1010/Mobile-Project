import 'package:flutter/material.dart';
import '../../../services/auth/auth_service.dart';
import '../components/my_textfld.dart';
import '../components/my_button.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _emlController = TextEditingController();
  final TextEditingController _confController = TextEditingController();

  RegisterPage({super.key, required this.onTap});

  final void Function()? onTap;

  void register(BuildContext context) {
    final _auth = AuthService();
    if (_pwController.text == _confController.text) {
      try {
        _auth.signUpWithEmailPassword(
          _emlController.text,
          _pwController.text,
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Passwords do not match"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.message,
                  size: 60,
                  color: Colors.white,
                ),
                const SizedBox(height: 30),
                Text(
                  "Let's Create Your Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),

                // Email
                MyTextfld(
                  hintText: "Email",
                  obscureText: false,
                  controller: _emlController,

                ),
                const SizedBox(height: 20),

                // Password
                MyTextfld(
                  hintText: "Password",
                  obscureText: true,
                  controller: _pwController,

                ),
                const SizedBox(height: 20),

                // Confirm Password
                MyTextfld(
                  hintText: "Confirm Password",
                  obscureText: true,
                  controller: _confController,

                ),
                const SizedBox(height: 20),

                MyButton(
                  button: "Register",
                  onTap: () => register(context),

                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: onTap,
                      child: Text(
                        "LOGIN",
                        style: TextStyle(
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

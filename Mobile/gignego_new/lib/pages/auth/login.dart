import 'package:flutter/material.dart';
import 'register_page.dart';
import 'package:flutter_application/pages/home/home_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isFormValid = false;
  bool _isLoading = false;

  void _checkFormValidity() {
    final isValid = _formKey.currentState?.validate() ?? false;
    setState(() => _isFormValid = isValid);
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _submitForm() async {
    if (!_isFormValid) return;

    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final response = await _loginUser(email, password);

    setState(() => _isLoading = false);

    if (response != null && response['status'] == 'success') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    } else {
      _showMessage("Email atau password salah.");
    }
  }

  Future<Map<String, dynamic>?> _loginUser(String email, String password) async {
    final url = Uri.parse('http://192.168.130.184:8080/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            onChanged: _checkFormValidity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                SvgPicture.asset('assets/gignego.svg', height: 200, width: 400.0),
                const SizedBox(height: 10),
                const Text(
                  "Masuk",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Belum punya akun? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => RegisterPage()),
                        );
                      },
                      child: const Text(
                        "Daftar",
                        style: TextStyle(
                            color: Colors.purple, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const DividerWithText(text: "atau masuk dengan email"),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _emailController,
                  label: "Email*",
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Email tidak boleh kosong";
                    if (!value.contains('@')) return "Email tidak valid";
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _passwordController,
                  label: "Password*",
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Password tidak boleh kosong";
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isFormValid && !_isLoading ? _submitForm : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFormValid
                        ? const Color(0xFF781CAA)
                        : Colors.grey.shade300,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Masuk",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(12),
                  color: const Color(0xFFF8E9FF),
                  width: double.infinity,
                  child: const Center(
                    child: Text.rich(
                      TextSpan(
                        text: "Butuh bantuan? Hubungi ",
                        children: [
                          TextSpan(
                            text: "Gignego Care",
                            style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }
}

class DividerWithText extends StatelessWidget {
  final String text;
  const DividerWithText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(text, style: const TextStyle(color: Colors.black54)),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
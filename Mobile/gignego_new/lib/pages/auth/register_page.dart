import 'package:flutter/material.dart';
import 'package:flutter_application/pages/auth/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _showValidationErrors = false;
  bool _isLoading = false;

  // Fungsi untuk menyimpan nama, email, dan nomor telepon ke SharedPreferences
  Future<void> saveUserDetails(String name, String email, String phone) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user_name', name);  // Menyimpan nama
    prefs.setString('user_email', email);  // Menyimpan email
    prefs.setString('user_phone', phone);  // Menyimpan nomor telepon
  }

  // Fungsi registrasi
  Future<void> _register() async {
    setState(() {
      _showValidationErrors = true;
    });

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

<<<<<<< Updated upstream
      final url = Uri.parse('http://192.168.130.184:8080/register');
=======
      final url = Uri.parse('http://192.168.34.59:8081/register');
>>>>>>> Stashed changes

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _namaController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Menyimpan nama, email, dan nomor telepon setelah registrasi berhasil
        await saveUserDetails(_namaController.text, _emailController.text, _phoneController.text);

        // Delay sebelum tampilkan snackbar
        await Future.delayed(Duration(milliseconds: 1500));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registrasi berhasil")),
        );

        // Delay biar user bisa baca snackbar
        await Future.delayed(Duration(milliseconds: 1500));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registrasi gagal: ${response.body}")),
        );
        print("Error: ${response.body}");
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Register', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black87,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context); // Menambahkan tombol kembali
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 24.0),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(blurRadius: 8, color: Color(0xFF781CAA))],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Form(
              key: _formKey,
              autovalidateMode: _showValidationErrors
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Image.asset('assets/logo.png', height: 40)),
                  SizedBox(height: 16),
                  Text("Buat Akun",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text("Punya akun?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                        child: Text("Sign in",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.purple)),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _namaController,
                    decoration: _inputDecoration("Nama Lengkap*"),
                    validator: (value) =>
                        value!.isEmpty ? "Nama wajib diisi" : null,
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController,
                    decoration: _inputDecoration("Email*"),
                    validator: (value) =>
                        value!.isEmpty ? "Email wajib diisi" : null,
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: _phoneController,
                    decoration: _inputDecoration("Nomor Ponsel*"),
                    keyboardType: TextInputType.phone,
                    validator: (value) =>
                        value!.isEmpty ? "Nomor Ponsel wajib diisi" : null,
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    decoration: _inputDecoration("Password*"),
                    obscureText: true,
                    validator: (value) =>
                        value!.isEmpty ? "Password wajib diisi" : null,
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF781CAA),
                        padding: EdgeInsets.symmetric(vertical: 16), // Menambah padding
                        textStyle: TextStyle(fontSize: 18), // Memperjelas teks tombol
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text("Lanjutkan",
                              style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  SizedBox(height: 12),
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: Text.rich(
                        TextSpan(
                          text: "Butuh bantuan? Hubungi ",
                          children: [
                            TextSpan(
                              text: "Gignego Care",
                              style: TextStyle(color: Colors.purple),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CreatePasswordPage extends StatefulWidget {
  const CreatePasswordPage({Key? key}) : super(key: key);

  @override
  State<CreatePasswordPage> createState() => _CreatePasswordPageState();
}

enum PasswordStrength { weak, average, strong }

class _CreatePasswordPageState extends State<CreatePasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureConfirm = true;

  PasswordStrength? _passwordStrength;

  bool get _isPasswordValid {
    final password = _passwordController.text;
    return password.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password);
  }


  Widget _buildPasswordStrengthBar() {
    if (_passwordStrength == null) return const SizedBox();

    String label;
    double progress;
    Color color;

    switch (_passwordStrength!) {
      case PasswordStrength.weak:
        label = "Lemah";
        progress = 0.33;
        color = Colors.red;
        break;
      case PasswordStrength.average:
        label = "Sedang";
        progress = 0.66;
        color = Colors.orange;
        break;
      case PasswordStrength.strong:
        label = "Kuat";
        progress = 1.0;
        color = Colors.green;
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        Row(
          children: [
            Text(label, style: TextStyle(color: color)),
            const SizedBox(width: 8),
            Expanded(
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 5,
                backgroundColor: Colors.grey[300],
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPasswordConfirmed =
        _passwordController.text == _confirmPasswordController.text;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.asset("assets/images/Gignego.png", height: 40)),
            const SizedBox(height: 12),
            const Text("Buat Akun", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Row(
              children: const [
                Text("Punya akun? "),
                Text(
                  "Sign in",
                  style: TextStyle(color: Colors.purple, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirm,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
            labelText: "Konfirmasi Password",
            errorText: _confirmPasswordController.text.isNotEmpty && !isPasswordConfirmed
            ? "Password baru tidak sama"
            : null,
            suffixIcon: IconButton(
            icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
          ),
            border: const OutlineInputBorder(),
        ),
      ),


            _buildPasswordStrengthBar(),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirm,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: "Konfirmasi Password",
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            RichText(
              text: const TextSpan(
                text: "Dengan mendaftar Anda menyetujui ",
                style: TextStyle(color: Colors.black87),
                children: [
                  TextSpan(
                    text: "Syarat dan Ketentuan",
                    style: TextStyle(color: Colors.purple),
                  ),
                  TextSpan(text: " & "),
                  TextSpan(
                    text: "Kebijakan Privasi",
                    style: TextStyle(color: Colors.purple),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isPasswordValid && isPasswordConfirmed
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Password valid!")),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isPasswordValid && isPasswordConfirmed
                    ? const Color(0xFF781CAA)
                    : Colors.grey,
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text("Lanjutkan", style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            const SizedBox(height: 16),
            Center(
              child: RichText(
                text: const TextSpan(
                  text: "Butuh bantuan? Hubungi ",
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: "Gignego Care",
                      style: TextStyle(color: Colors.purple),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

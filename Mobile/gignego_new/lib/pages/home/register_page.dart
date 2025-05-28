import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _nomorController = TextEditingController();
  bool isFormValid = false;

  void checkFormValidity() {
    final isValid = _formKey.currentState?.validate() ?? false;
    setState(() => isFormValid = isValid);
  }

void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Form(
          key: _formKey,
          onChanged: checkFormValidity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Image.asset('assets/images/Gignego.png', height: 50),
              const SizedBox(height: 10),
              const Text("Buat Akun", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Punya akun? "),
                  Text("Sign in", style: TextStyle(color: Colors.purple, fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 24),
              const DividerWithText(text: "atau daftar dengan email"),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _namaController,
                label: "Nama Lengkap*",
                validator: (value) {
                  if (value == null || value.isEmpty) return "Nama tidak boleh kosong";
                  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) return "Nama hanya boleh huruf";
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _emailController,
                label: "Email*",
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Email tidak boleh kosong";
                  if (!value.contains('@')) return "Email harus mengandung @";
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _nomorController,
                label: "Nomor Ponsel*",
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) return "Nomor tidak boleh kosong";
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) return "Hanya boleh angka";
                  return null;
                },
              ),
              const SizedBox(height: 4),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Nomor terhubung dengan WhatsApp.", style: TextStyle(fontSize: 12, color: Colors.black54)),
              ),
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Lanjutkan untuk menyelesaikan pendaftaran.",
                    style: TextStyle(fontWeight: FontWeight.w500)),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: isFormValid ? () => _showMessage("Form berhasil divalidasi") : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFormValid ? const Color(0xFF781CAA) : Colors.grey.shade300,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Lanjutkan", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: const Color(0xFFF8E9FF),
                child: const Center(
                  child: Text.rich(
                    TextSpan(
                      text: "Butuh bantuan? Hubungi ",
                      children: [
                        TextSpan(
                          text: "Gignego Care",
                          style: TextStyle(color: Colors.purple, fontWeight: FontWeight.w500),
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
    );
  }

  Widget _buildSocialButton({
    required Widget icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(color: Colors.purple),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 10),
            Text(text, style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }
}

class DividerWithText extends StatelessWidget {
  final String text;
  const DividerWithText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text(text)),
        const Expanded(child: Divider()),
      ],
    );
  }
}

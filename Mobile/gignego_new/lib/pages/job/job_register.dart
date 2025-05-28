import 'package:flutter/material.dart';
import 'package:flutter_application/pages/job/form_validasi.dart';

class JobRegisterPage extends StatefulWidget {
  const JobRegisterPage({super.key});

  @override
  State<JobRegisterPage> createState() => _JobRegisterPageState();
}

class _JobRegisterPageState extends State<JobRegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final List<String> _kecamatanList = [
    'Ajibata',
    'Balige',
    'Bonatua Lunasi',
    'Borbor',
    'Habinsaran',
    'Laguboti',
    'Lumban Julu',
    'Nassau',
    'Parmaksian',
    'Pintu Pohan Meranti',
    'Porsea',
    'Siantar Narumonda',
    'Sigumpar',
    'Silaen',
    'Tampahan',
    'Uluan',
  ];

  String? _selectedKecamatan;
  TimeOfDay selectedTime = const TimeOfDay(hour: 9, minute: 0);
  bool isAgreed = false;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _handleSubmit() {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _selectedKecamatan == null ||
        _experienceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Harap lengkapi semua data wajib terlebih dahulu."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (!isAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Anda harus menyetujui syarat dan ketentuan."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Form disubmit!..."),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FormValidasiPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pekerjaan apa hari ini?'),
        centerTitle: true,
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField(_nameController, "Nama"),
            _buildTextField(_phoneController, "No HP/WhatsApp", keyboardType: TextInputType.phone),
            
            // Dropdown lokasi
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Pilih Lokasi (Kecamatan)',
                  labelStyle: const TextStyle(color: Colors.deepPurple),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                value: _selectedKecamatan,
                items: _kecamatanList.map((String kecamatan) {
                  return DropdownMenuItem<String>(
                    value: kecamatan,
                    child: Text(kecamatan),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedKecamatan = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Waktu pengerjaan",
                      hintText: "${selectedTime.format(context)} WIB",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () => _selectTime(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              _experienceController,
              "Pengalaman\n*Pernah melakukan pengalaman yang serupa sebelumnya?",
              maxLines: 2,
            ),
            _buildTextField(_noteController, "Catatan Tambahan\n(optional)", maxLines: 2),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: isAgreed,
                  onChanged: (value) {
                    setState(() {
                      isAgreed = value ?? false;
                    });
                  },
                ),
                const Expanded(
                  child: Text(
                    "Saya bersedia mengikuti syarat dan ketentuan pekerjaan ini",
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  disabledBackgroundColor: Colors.purple.shade200,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "SUBMIT",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.deepPurple),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import untuk format tanggal
import 'package:http/http.dart' as http; // Import untuk request HTTP
import 'dart:convert'; // Import untuk encoding JSON

class TambahPengalamanPage extends StatefulWidget {
  @override
  _TambahPengalamanPageState createState() => _TambahPengalamanPageState();
}

class _TambahPengalamanPageState extends State<TambahPengalamanPage> {
  final _formKey = GlobalKey<FormState>();
  bool _masihBekerja = false;
  DateTime? _tanggalMulai;
  DateTime? _tanggalBerakhir;

  // Field controllers
  final TextEditingController posisiController = TextEditingController();
  final TextEditingController perusahaanController = TextEditingController();
  final TextEditingController negaraController = TextEditingController();
  final TextEditingController kotaController = TextEditingController();
  final TextEditingController fungsiController = TextEditingController();
  final TextEditingController industriController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _tanggalMulai = picked;
        } else {
          _tanggalBerakhir = picked;
        }
      });
    }
  }

  // Fungsi untuk mengirim data pengalaman kerja ke API
  Future<void> _submitExperience() async {
    if (_formKey.currentState!.validate()) {
      // Mengambil data yang dimasukkan
      final posisi = posisiController.text;
      final perusahaan = perusahaanController.text;
      final negara = negaraController.text;
      final kota = kotaController.text;
      final fungsi = fungsiController.text;
      final industri = industriController.text;
      final deskripsi = deskripsiController.text;

      // Memastikan semua field diisi
      if (posisi.isEmpty || perusahaan.isEmpty || negara.isEmpty || kota.isEmpty || fungsi.isEmpty || industri.isEmpty || deskripsi.isEmpty || _tanggalMulai == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Semua field wajib diisi')),
        );
        return;
      }

      // Mengirim data ke API
      try {
        final response = await http.post(
          Uri.parse('http://192.168.34.59:8081/work-experiences'), // Ganti dengan URL API Anda
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'position': posisi,
            'company_name': perusahaan,
            'country': negara,
            'city': kota,
            'start_date': DateFormat('yyyy-MM-dd').format(_tanggalMulai!),
            'end_date': _masihBekerja ? null : DateFormat('yyyy-MM-dd').format(_tanggalBerakhir ?? DateTime.now()),
            'is_current': _masihBekerja,
            'job_function': fungsi,
            'industry': industri,
            'description': deskripsi,
          }),
        );

        if (response.statusCode == 201) {
          // Data berhasil disimpan
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Pengalaman Kerja berhasil disimpan')),
          );
          Navigator.pop(context); // Kembali ke halaman sebelumnya
        } else {
          // Jika gagal
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menyimpan data pengalaman kerja')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Tambah Pengalaman Kerja', style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField('Posisi Pekerjaan*', controller: posisiController),
                _buildTextField('Nama Perusahaan*', controller: perusahaanController),
                Row(
                  children: [
                    Expanded(child: _buildTextField('Negara*', controller: negaraController)),
                    SizedBox(width: 10),
                    Expanded(child: _buildTextField('Kota*', controller: kotaController)),
                  ],
                ),
                _buildDateField('Tanggal Mulai*', _tanggalMulai, () => _selectDate(context, true)),
                _buildDateField('Tanggal Berakhir (atau ekspetasi)', _tanggalBerakhir, _masihBekerja ? null : () => _selectDate(context, false)),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Saya masih bekerja di sini'),
                  value: _masihBekerja,
                  onChanged: (val) {
                    setState(() {
                      _masihBekerja = val!;
                      if (_masihBekerja) _tanggalBerakhir = null;
                    });
                  },
                ),
                _buildTextField('Fungsi Pekerjaan*', controller: fungsiController),
                _buildTextField('Industri Perusahaan*', controller: industriController),
                _buildTextField('Deskripsi Pekerjaan*', controller: deskripsiController, maxLines: 5),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.purple)),
                        child: Text('Batal', style: TextStyle(color: Colors.purple)),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submitExperience, // Simpan pengalaman kerja
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300]),
                        child: Text('Simpan', style: TextStyle(color: Colors.black45)),
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

  Widget _buildTextField(String label, {TextEditingController? controller, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDateField(String label, DateTime? date, VoidCallback? onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: AbsorbPointer(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
            ),
            controller: TextEditingController(
              text: date != null ? DateFormat('dd/MM/yyyy').format(date) : '',
            ),
          ),
        ),
      ),
    );
  }
}

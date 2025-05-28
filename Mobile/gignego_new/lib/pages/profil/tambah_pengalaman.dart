import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TambahPengalamanPage extends StatefulWidget {
  @override
  _TambahPengalamanPageState createState() => _TambahPengalamanPageState();
}

class _TambahPengalamanPageState extends State<TambahPengalamanPage> {
  final _formKey = GlobalKey<FormState>();
  bool _masihBekerja = false;
  DateTime? _tanggalMulai;
  DateTime? _tanggalBerakhir;

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
        title: Text(
          'Tambah Pengalaman Kerja',
          style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField('Posisi Pekerjaan*'),
                _buildTextField('Nama Perusahaan*'),
                Row(
                  children: [
                    Expanded(child: _buildDropdown('Negara*')),
                    SizedBox(width: 10),
                    Expanded(child: _buildDropdown('Kota*')),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildDateField(
                        'Tanggal Mulai*',
                        _tanggalMulai,
                        () => _selectDate(context, true),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildDateField(
                        'Tanggal Berakhir (atau ekspetasi)',
                        _tanggalBerakhir,
                        _masihBekerja ? null : () => _selectDate(context, false),
                      ),
                    ),
                  ],
                ),
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
                _buildDropdown('Fungsi Pekerjaan*'),
                _buildDropdown('Industri Perusahaan*'),
                Row(
                  children: [
                    Expanded(child: _buildDropdown('Level Pekerjaan*')),
                    SizedBox(width: 10),
                    Expanded(child: _buildDropdown('Tipe Pekerjaan*')),
                  ],
                ),
                _buildTextField('Deskripsi Pekerjaan*', maxLines: 5),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Tulis tugas dan tanggung jawab atau pencapaianmu selama bekerja di sini',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.purple),
                        ),
                        child: Text('Batal', style: TextStyle(color: Colors.purple)),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                        ),
                        child: Text('Simpan', style: TextStyle(color: Colors.black45)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        items: ['Item 1', 'Item 2'].map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: (val) {},
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

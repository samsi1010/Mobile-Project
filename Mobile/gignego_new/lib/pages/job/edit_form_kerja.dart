import 'package:flutter/material.dart';

class EditFormKerja extends StatefulWidget {
  @override
  _EditFormKerja createState() => _EditFormKerja();
}

class _EditFormKerja extends State<EditFormKerja> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();
  final locationController = TextEditingController();
  final timeController = TextEditingController();
  final dateController = TextEditingController();
  final priceController = TextEditingController();
  final durationController = TextEditingController();

  TimeOfDay? _selectedTime;
  DateTime? _selectedDate;
  DateTime? _adDurationDate;

  final List<String> _locationList = [
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

  Future<void> _pickTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        _selectedTime = time;
        timeController.text = "${time.format(context)} WIB";
      });
    }
  }

  Future<void> _pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
        dateController.text = _formatDate(date);
      });
    }
  }

  Future<void> _pickAdDurationDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        _adDurationDate = date;
        durationController.text = _formatDate(date);
      });
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')} "
        "${_monthToText(date.month)} ${date.year}";
  }

  String _monthToText(int month) {
    const monthNames = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return monthNames[month - 1];
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    locationController.dispose();
    timeController.dispose();
    dateController.dispose();
    priceController.dispose();
    durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100, // Latar belakang abu-abu muda
      appBar: AppBar(
        title: Text("Butuh bantuan apa hari ini?", style: TextStyle(fontSize: 16)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 160, 9, 186),
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField("Judul Iklan", titleController),
              _buildTextField("Deskripsi", descriptionController, maxLines: 3),
              _buildDropdownCategory(),
              _buildDropdownLocation(),
              _buildTimePicker(),
              _buildDatePicker(),
              _buildTextField("Harga", priceController),
              _buildAdDurationPicker(),
              _buildImagePicker(),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple, 
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 5, 
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print("Form valid, data dikirim!");
                  }
                },
                child: Text("SUBMIT", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.deepPurple), // Warna label
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), 
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.deepPurple, width: 2),
          ), // Border saat fokus
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'Field tidak boleh kosong' : null,
      ),
    );
  }

  Widget _buildDropdownCategory() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        width: 250, // Lebar dropdown sedikit lebih lebar
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: "Pilih kategori",
            labelStyle: TextStyle(color: Colors.deepPurple), // Warna label
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          isExpanded: true,
          items: ['Kebersihan', 'Pertukangan', 'Pendidikan', 'Lainnya']
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: (value) {
            categoryController.text = value!;
          },
          validator: (value) =>
              value == null || value.isEmpty ? 'Pilih kategori' : null,
        ),
      ),
    );
  }

  Widget _buildDropdownLocation() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        width: 250, // Lebar dropdown sedikit lebih lebar
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: "Pilih Kecamatan",
            labelStyle: TextStyle(color: Colors.deepPurple), // Warna label
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          isExpanded: true,
          value: locationController.text.isEmpty ? null : locationController.text,
          items: _locationList
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item, overflow: TextOverflow.ellipsis),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              locationController.text = value!;
            });
          },
          validator: (value) =>
              value == null || value.isEmpty ? 'Pilih lokasi' : null,
          dropdownColor: Colors.white,
          menuMaxHeight: 300,
        ),
      ),
    );
  }

  Widget _buildTimePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: _pickTime,
        child: AbsorbPointer(
          child: TextFormField(
            controller: timeController,
            decoration: InputDecoration(
              labelText: "Waktu pengerjaan",
              labelStyle: TextStyle(color: Colors.deepPurple), // Warna label
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              suffixIcon: Icon(Icons.access_time),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'Pilih waktu' : null,
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: _pickDate,
        child: AbsorbPointer(
          child: TextFormField(
            controller: dateController,
            decoration: InputDecoration(
              labelText: "Tanggal pengerjaan",
              labelStyle: TextStyle(color: Colors.deepPurple), // Warna label
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              suffixIcon: Icon(Icons.calendar_today),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'Pilih tanggal' : null,
          ),
        ),
      ),
    );
  }

  Widget _buildAdDurationPicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: _pickAdDurationDate,
        child: AbsorbPointer(
          child: TextFormField(
            controller: durationController,
            decoration: InputDecoration(
              labelText: "Masa Iklan",
              labelStyle: TextStyle(color: Colors.deepPurple), // Warna label
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              suffixIcon: Icon(Icons.calendar_month),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'Pilih masa iklan' : null,
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            icon: Icon(Icons.image, color: Colors.deepPurple),
            onPressed: () {
              // Fungsi untuk memilih gambar
            },
          ),
          Text("Pilih Gambar Iklan", style: TextStyle(color: Colors.deepPurple))
        ],
      ),
    );
  }
}

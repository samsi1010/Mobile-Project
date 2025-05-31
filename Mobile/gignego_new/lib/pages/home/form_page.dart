import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application/pages/models/job.dart';
import 'validasi.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application/pages/models/applicant.dart';

class ApiService {
  static const String apiUrl = 'http://192.168.100.4:8080/job-postings';

  // Fungsi untuk mengirim data pekerjaan baru ke API
  static Future<bool> createJob(Job job) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Pastikan field teks ditambahkan ke dalam form fields
      request.fields['nama_pekerjaan'] = job.namaPekerjaan;
      request.fields['deskripsi'] = job.deskripsi;
      request.fields['lokasi'] = job.lokasi;
      request.fields['harga_pekerjaan'] = job.hargaPekerjaan.toString();
      request.fields['syarat_ketentuan'] = job.syaratKetentuan;
      request.fields['jenis_pekerjaan'] = job.jenisPekerjaan;
      request.fields['status_pekerjaan'] = job.status;
      request.fields['time'] = job.time.toString();
      request.fields['email'] = job.email;

      // File gambar
      if (job.gambar1.isNotEmpty) {
        request.files
            .add(await http.MultipartFile.fromPath('image1', job.gambar1));
      }
      if (job.gambar2.isNotEmpty) {
        request.files
            .add(await http.MultipartFile.fromPath('image2', job.gambar2));
      }
      if (job.gambar3.isNotEmpty) {
        request.files
            .add(await http.MultipartFile.fromPath('image3', job.gambar3));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Failed to send data: ${response.statusCode}");
        var responseBody = await http.Response.fromStream(response);
        print('Error response body: ${responseBody.body}');
        return false;
      }
    } catch (e) {
      print('Error sending data to API: $e');
      return false;
    }
  }

 static Future<List<Job>?> fetchJobsByEmail(String email) async {
  try {
    final url = Uri.parse('$apiUrl?email=$email');
    final response = await http.get(url);
    print('DEBUG: fetchJobsByEmail statusCode = ${response.statusCode}');
    print('DEBUG: fetchJobsByEmail response body = ${response.body}');

    if (response.statusCode == 200) {
      // Nah, di bagian inilah kamu ubah kode lama yang decode langsung ke List
      // jadi decode ke Map dulu, lalu ambil value 'data' yang List itu
      final Map<String, dynamic> jsonMap = jsonDecode(response.body);
      final List<dynamic> jsonData = jsonMap['data'];  // <-- INI BAGIAN PENTING
      print('DEBUG: jsonData length = ${jsonData.length}');
      return jsonData.map((item) => Job.fromMap(item)).toList();
    } else {
      print('Failed to fetch jobs, status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error fetching jobs: $e');
    return null;
  }
}



static Future<bool> deleteJobFromApi(int id) async {
    final response = await http.delete(
      Uri.parse('http://192.168.100.4:8080/job-postings/id'),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Failed to delete job: ${response.statusCode}');
      return false;
    }
  }

  static Future<bool> updateJob(Job job) async {
  final url = Uri.parse('http://192.168.100.4:8080/job-postings/${job.id}');
  try {
    var request = http.MultipartRequest('PUT', url);

    request.fields['nama_pekerjaan'] = job.namaPekerjaan;
    request.fields['deskripsi'] = job.deskripsi;
    request.fields['lokasi'] = job.lokasi;
    request.fields['harga_pekerjaan'] = job.hargaPekerjaan.toString();
    request.fields['syarat_ketentuan'] = job.syaratKetentuan;
    request.fields['jenis_pekerjaan'] = job.jenisPekerjaan;
    request.fields['status_pekerjaan'] = job.status;
    request.fields['time'] = job.time.toString();
    request.fields['email'] = job.email;
    request.fields['waktu'] = job.waktu;
    request.fields['tanggal'] = job.tanggal;

    if (job.gambar1.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('image1', job.gambar1));
    }
    if (job.gambar2.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('image2', job.gambar2));
    }
    if (job.gambar3.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('image3', job.gambar3));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      return true;
    } else {
      print("Failed to update job: ${response.statusCode}");
      var resBody = await http.Response.fromStream(response);
      print('Response body: ${resBody.body}');
      return false;
    }
  } catch (e) {
    print('Error updating job: $e');
    return false;
  }
}
static Future<List<Applicant>> fetchApplicantsByJobId(int jobId) async {
  final url = Uri.parse('http://192.168.100.4:8080/applications?job_id=$jobId');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((item) => Applicant.fromMap(item)).toList();
  } else {
    print('Failed to fetch applicants: ${response.statusCode}');
    return [];
  }
}

}

class FormPage extends StatefulWidget {
  final Function(Job) onJobAdded;
  final Job? job; // job bisa null jika membuat pekerjaan baru

  const FormPage({Key? key, required this.onJobAdded, this.job}) : super(key: key);

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();
  final TextEditingController _waktuController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _syaratController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _emailController =
      TextEditingController(); // Tambahkan email controller
  bool isLoading = false;
  File? _selectedImage1;
  File? _selectedImage2;
  File? _selectedImage3;
  String? _selectedKategori;

  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>(); // Tambahkan untuk validasi

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      // Jika mode edit, isi form dengan data dari job
      _judulController.text = widget.job!.namaPekerjaan;
      _deskripsiController.text = widget.job!.deskripsi;
      _lokasiController.text = widget.job!.lokasi;
      _waktuController.text = widget.job!.waktu;
      _tanggalController.text = widget.job!.tanggal;
      _hargaController.text = widget.job!.hargaPekerjaan.toString();
      _syaratController.text = widget.job!.syaratKetentuan;
      _selectedKategori = widget.job!.jenisPekerjaan;
      _timeController.text = widget.job!.time.toString();
      _emailController.text = widget.job!.email;
    }
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final DateTime today = DateTime.now();
    final DateTime threeDaysFromNow = today.add(Duration(days: 3));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today, // Allow selection from today
      lastDate: threeDaysFromNow, // Allow selection only up to three days ahead
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _pickTime(TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      controller.text = picked.format(context);
    }
  }

  Future<void> _pickImage(int imageNumber) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (imageNumber == 1) {
          _selectedImage1 = File(pickedFile.path);
        } else if (imageNumber == 2) {
          _selectedImage2 = File(pickedFile.path);
        } else if (imageNumber == 3) {
          _selectedImage3 = File(pickedFile.path);
        }
      });
    }
  }

  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email');
    print(
        "Email yang diambil: $email"); // Debugging untuk memastikan email diambil dengan benar
    return email;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() &&
        _selectedImage1 != null &&
        _selectedKategori != null) {
      setState(() {
        isLoading = true; // Show loading indicator
      });

      final email = await getEmail(); // Ambil email dari SharedPreferences

      if (email == null || email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Email pengguna tidak ditemukan. Mohon login terlebih dahulu.')));
        setState(() {
          isLoading = false; // Hide loading indicator
        });
        return;
      }

// Lanjutkan proses pengiriman pekerjaan dengan email
      final jobBaru = Job(
         id: widget.job?.id,
        namaPekerjaan: _judulController.text,
        deskripsi: _deskripsiController.text,
        lokasi: _lokasiController.text,
        waktu: _waktuController.text,
        tanggal: _tanggalController.text,
        hargaPekerjaan: double.tryParse(_hargaController.text) ?? 0.0,
        syaratKetentuan: _syaratController.text,
        jenisPekerjaan: _selectedKategori!, // Pastikan kategori dipilih
        gambar1: _selectedImage1?.path ?? '',
        gambar2: _selectedImage2?.path ?? '',
        gambar3: _selectedImage3?.path ?? '',
        status: 'Tersedia', // Status pekerjaan
        time: int.tryParse(_timeController.text) ?? 0,
        email: email,
      );

      
      // Log data pekerjaan yang akan dikirim
      print("Data pekerjaan yang akan dikirim:");
      print("Nama Pekerjaan: ${jobBaru.namaPekerjaan}");
      print("Deskripsi: ${jobBaru.deskripsi}");
      print("Lokasi: ${jobBaru.lokasi}");
      print("Harga Pekerjaan: ${jobBaru.hargaPekerjaan}");
      print("Syarat Ketentuan: ${jobBaru.syaratKetentuan}");
      print("Jenis Pekerjaan: ${jobBaru.jenisPekerjaan}");
      print("Email: ${jobBaru.email}"); // Log email yang akan dikirim


      bool isSuccess;
      if (widget.job == null) {
        // Jika job null, buat job baru
        isSuccess = await ApiService.createJob(jobBaru);
      } else {
        // Jika job sudah ada, update job yang ada
        isSuccess = await ApiService.updateJob(jobBaru);
      }

      setState(() {
        isLoading = false;
      });

      if (isSuccess) {
        widget.onJobAdded(jobBaru);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(widget.job == null ? 'Pekerjaan berhasil ditambahkan!' : 'Pekerjaan berhasil diperbarui!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Terjadi kesalahan saat menyimpan pekerjaan!')));
      }
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Pastikan semua field wajib diisi dan gambar 1 dipilih!")));
    }
  }
  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    _lokasiController.dispose();
    _waktuController.dispose();
    _tanggalController.dispose();
    _hargaController.dispose();
    _syaratController.dispose();
    _timeController.dispose(); // Dispose untuk controller time
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Form Job Posting"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField("Nama Pekerjaan", _judulController),
                _buildTextField("Deskripsi Pekerjaan", _deskripsiController),
                _buildTextField("Lokasi Pekerjaan", _lokasiController),
                _buildTextField("Harga Pekerjaan", _hargaController,
                    isNumber: true),
                _buildTextField("Syarat dan Ketentuan", _syaratController),
                _buildDateTimeField("Tanggal Pekerjaan", _tanggalController,
                    Icons.calendar_today),
                _buildDateTimeField(
                    "Waktu Pekerjaan", _waktuController, Icons.access_time,
                    isTime: true),
                _buildTextField("Lama Pekerjaan (dalam jam)", _timeController,
                    isNumber: true), // Input field untuk time
                _buildDropdownField("Jenis Pekerjaan"),
                _buildImageUploadSection(1),
                _buildImageUploadSection(2),
                _buildImageUploadSection(3),
                SizedBox(height: 20),

                // Show loading indicator while submitting
                if (isLoading)
                  Center(child: CircularProgressIndicator())
                else
                  _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isNumber = false, int? min, int? max, bool isDuration = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(border: OutlineInputBorder()),
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            inputFormatters: isNumber
                ? [
                    FilteringTextInputFormatter
                        .digitsOnly, // Hanya menerima angka
                  ]
                : [],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '$label wajib diisi';
              }
              if (isNumber) {
                final int? intValue = int.tryParse(value);
                if (intValue == null) {
                  return '$label harus berupa angka';
                }
                // Validasi hanya diterapkan jika ini adalah field "Lama Pekerjaan"
                if (isDuration &&
                    (intValue < (min ?? 1) || intValue > (max ?? 7))) {
                  return '$label harus antara $min dan $max jam';
                }
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          DropdownButtonFormField<String>(
            value: _selectedKategori,
            hint: Text("Pilih Kategori"),
            items: [
              "Kebersihan",
              "Perbaikan Rumah",
              "Perbaikan Kendaraan",
              "Perbaikan Elektronik",
              "Tutor",
              "Rumah Tangga",
              "Fotografi dan Videografi",
              "Lainnya"
            ]
                .map((String category) =>
                    DropdownMenuItem(value: category, child: Text(category)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedKategori = value;
              });
            },
            validator: (value) =>
                value == null ? 'Kategori wajib dipilih' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeField(
      String label, TextEditingController controller, IconData icon,
      {bool isTime = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          TextFormField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              suffixIcon: Icon(icon),
            ),
            onTap: () {
              if (isTime) {
                _pickTime(controller); // Untuk memilih waktu
              } else {
                _pickDate(controller); // Untuk memilih tanggal
              }
            },
            validator: (value) =>
                value == null || value.isEmpty ? '$label wajib diisi' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildImageUploadSection(int imageNumber) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Gambar $imageNumber",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          GestureDetector(
            onTap: () => _pickImage(imageNumber),
            child: Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: (imageNumber == 1 && _selectedImage1 != null) ||
                      (imageNumber == 2 && _selectedImage2 != null) ||
                      (imageNumber == 3 && _selectedImage3 != null)
                  ? Image.file(
                      imageNumber == 1
                          ? _selectedImage1!
                          : imageNumber == 2
                              ? _selectedImage2!
                              : _selectedImage3!,
                      fit: BoxFit.cover)
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_upload, size: 40, color: Colors.grey),
                        Text("Tap untuk memilih gambar",
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed:
              isLoading ? null : _submitForm, // Disable jika sedang loading
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                Colors.purple), // Warna latar belakang ungu
            foregroundColor: MaterialStateProperty.all<Color>(
                Colors.white), // Warna teks putih
          ),
          child: isLoading
              ? CircularProgressIndicator(
                  color: Colors
                      .white) // Tampilkan indikator loading jika sedang loading
              : Text("Submit"),
        ),
      ),
    );
  }
}

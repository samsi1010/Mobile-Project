import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilPage extends StatefulWidget {
  @override
  _EditProfilPageState createState() => _EditProfilPageState();
}

class _EditProfilPageState extends State<EditProfilPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController namaController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController noTelpController = TextEditingController();
  TextEditingController alamatLengkapController = TextEditingController();
  TextEditingController tanggalController = TextEditingController();

  String? selectedKecamatan;
  String? selectedDesa;

  final Map<String, List<String>> dataWilayah = {
    'Balige': ['Lumban Pea', 'Parparean', 'Tangga Batu', 'Lumban Bulbul'],
    'Porsea': ['Porsea','Lumban Gurning', 'Lumban Huala', 'Siraituruk','Lumban Sitorus', 'Tanjung Pasir'],
    'Laguboti': ['Tampubolon', 'Sibarani', 'Lumban Gaol'],
    'Tampahan': ['Tampahan', 'Lumban Binanga'],
    'Habinsaran': ['Aek Natolu', 'Sitorang'],
    'Borbor': ['Borbor Tonga', 'Parsaoran'],
    'Silaen': ['Lumban Sitorus', 'Lumban Holbung'],
    'Ajibata': ['Ajibata', 'Parparean', 'Tanjung Unta'],
  };

  @override
  void initState() {
    super.initState();
    _loadProfileData(); // Memuat data pengguna dari SharedPreferences
  }

  // Fungsi untuk memuat data profil pengguna dari SharedPreferences
  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    // Mengambil data profil dari SharedPreferences dan mengisi controller dengan data yang ada
    namaController.text = prefs.getString('user_name') ?? '';
    emailController.text = prefs.getString('user_email') ?? '';
    noTelpController.text = prefs.getString('user_phone') ?? '';
    alamatLengkapController.text = prefs.getString('user_address') ?? '';
    tanggalController.text = prefs.getString('user_birthdate') ?? '';

    // Jika perlu, bisa menambahkan logika untuk mengambil Kecamatan dan Desa
    setState(() {
      selectedKecamatan = prefs.getString('user_kecamatan');
      selectedDesa = prefs.getString('user_desa');
    });
  }

  // Fungsi untuk menyimpan data yang sudah diedit
  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    // Menyimpan data yang sudah diedit ke SharedPreferences
    prefs.setString('user_name', namaController.text);
    prefs.setString('user_email', emailController.text);
    prefs.setString('user_phone', noTelpController.text);
    prefs.setString('user_address', alamatLengkapController.text);
    prefs.setString('user_birthdate', tanggalController.text);
    prefs.setString('user_kecamatan', selectedKecamatan ?? '');
    prefs.setString('user_desa', selectedDesa ?? '');

    // Tampilkan snackbar atau konfirmasi untuk memberitahukan pengguna
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Profil berhasil disimpan!'),
    ));

    // Kembali ke halaman ProfilPage setelah menyimpan data
    Navigator.pop(context); // Kembali ke halaman sebelumnya (ProfilPage)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Edit Profil',
          style: TextStyle(
            color: Colors.purple,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nama Field
              buildTextField("Nama", controller: namaController),

              // Email Field
              buildTextField("Email", controller: emailController),

              // Kecamatan Dropdown
              DropdownButtonFormField<String>(
                value: selectedKecamatan,
                decoration: InputDecoration(
                  labelText: 'Kecamatan',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF7C4CB8)),
                  ),
                ),
                items: dataWilayah.keys
                    .map((kec) => DropdownMenuItem(value: kec, child: Text(kec)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedKecamatan = value;
                    selectedDesa = null; // Reset desa when kecamatan is changed
                  });
                },
              ),

              // Desa Dropdown
              DropdownButtonFormField<String>(
                value: selectedDesa,
                decoration: InputDecoration(
                  labelText: 'Desa',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF7C4CB8)),
                  ),
                ),
                items: (selectedKecamatan != null)
                    ? dataWilayah[selectedKecamatan]!
                        .map((desa) => DropdownMenuItem(value: desa, child: Text(desa)))
                        .toList()
                    : [],
                onChanged: (value) {
                  setState(() {
                    selectedDesa = value;
                  });
                },
              ),

              // Alamat Lengkap Field
              buildTextField("Alamat Lengkap", controller: alamatLengkapController),

              // Nomor Telepon Field
              buildTextField("Nomor Telepon", controller: noTelpController),

              // Tanggal Lahir Field
              buildDatePicker(),

              SizedBox(height: 30),
              // Save Button
              ElevatedButton(
                onPressed: _saveProfileData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFCD50F3),
                  minimumSize: Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                ),
                 child: Text(
    "Simpan", 
    style: TextStyle(
      fontWeight: FontWeight.bold, 
      color: Colors.white, 
              ),
                 ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Reusable TextFormField
  Widget buildTextField(String label, {TextEditingController? controller}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF7C4CB8)),
          ),
        ),
      ),
    );
  }

  // Date Picker Field for Date of Birth
  Widget buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: tanggalController,
        readOnly: true,
        decoration: InputDecoration(
          labelText: "Tanggal Lahir",
          suffixIcon: Icon(Icons.calendar_today),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF7C4CB8)),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            tanggalController.text =
                "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
          }
        },
      ),
    );
  }
}

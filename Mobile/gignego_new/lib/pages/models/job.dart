class Job {
  final int? id; // Nullable karena saat buat baru, id belum ada (dari DB nanti)
  final String namaPekerjaan;
  final String deskripsi;
  final String lokasi;
  final String waktu;
  final String tanggal;
  final double hargaPekerjaan;
  final String syaratKetentuan;
  final String jenisPekerjaan;
  final String gambar1;
  final String gambar2;
  final String gambar3;
  final String status;
  final int time;
  final String email;

  Job({
    this.id,
    required this.namaPekerjaan,
    required this.deskripsi,
    required this.lokasi,
    required this.waktu,
    required this.tanggal,
    required this.hargaPekerjaan,
    required this.syaratKetentuan,
    required this.jenisPekerjaan,
    required this.gambar1,
    required this.gambar2,
    required this.gambar3,
    required this.status,
    required this.time,
    required this.email,
  });

  // Factory constructor untuk membuat objek dari Map (hasil query DB)
  factory Job.fromMap(Map<String, dynamic> map) {
    return Job(
      id: map['id'] as int?, // pastikan cast ke int? karena nullable
      namaPekerjaan: map['nama_pekerjaan'] ?? '',
      deskripsi: map['deskripsi'] ?? '',
      lokasi: map['lokasi'] ?? '',
      waktu: map['waktu'] ?? '',
      tanggal: map['tanggal'] ?? '',
      hargaPekerjaan: map['harga_pekerjaan'] is int
          ? (map['harga_pekerjaan'] as int).toDouble()
          : (map['harga_pekerjaan'] ?? 0.0),
      syaratKetentuan: map['syarat_ketentuan'] ?? '',
      jenisPekerjaan: map['jenis_pekerjaan'] ?? '',
      gambar1: map['gambar1'] ?? '',
      gambar2: map['gambar2'] ?? '',
      gambar3: map['gambar3'] ?? '',
      status: map['status'] ?? 'Tersedia',
      time: map['time'] ?? 0,
      email: map['email'] ?? '',
    );
  }

  // Convert objek Job ke Map untuk insert/update ke DB
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'nama_pekerjaan': namaPekerjaan,
      'deskripsi': deskripsi,
      'lokasi': lokasi,
      'waktu': waktu,
      'tanggal': tanggal,
      'harga_pekerjaan': hargaPekerjaan,
      'syarat_ketentuan': syaratKetentuan,
      'jenis_pekerjaan': jenisPekerjaan,
      'gambar1': gambar1,
      'gambar2': gambar2,
      'gambar3': gambar3,
      'status': status,
      'time': time,
      'email': email,
    };
    if (id != null) {
      map['id'] = id; // tambahkan id jika tidak null (untuk update/delete)
    }
    return map;
  }

  @override
  String toString() {
    return 'Job{id: $id, namaPekerjaan: $namaPekerjaan, deskripsi: $deskripsi, lokasi: $lokasi, waktu: $waktu, tanggal: $tanggal, hargaPekerjaan: $hargaPekerjaan, syaratKetentuan: $syaratKetentuan, jenisPekerjaan: $jenisPekerjaan, gambar1: $gambar1, gambar2: $gambar2, gambar3: $gambar3, status: $status, time: $time, email: $email}';
  }
}

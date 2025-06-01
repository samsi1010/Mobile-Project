import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/job.dart';  // sesuaikan path import dengan struktur projectmu

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('jobs.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // Buka DB dan buat tabel kalau belum ada
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE pekerjaan (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nama_pekerjaan TEXT NOT NULL,
      deskripsi TEXT NOT NULL,
      lokasi TEXT NOT NULL,
      waktu TEXT NOT NULL,
      tanggal TEXT NOT NULL,
      harga_pekerjaan REAL NOT NULL,
      syarat_ketentuan TEXT NOT NULL,
      jenis_pekerjaan TEXT NOT NULL,
      gambar1 TEXT NOT NULL,
      gambar2 TEXT NOT NULL,
      gambar3 TEXT NOT NULL,
      status TEXT NOT NULL,
      time INTEGER NOT NULL,
      email TEXT NOT NULL
    )
    ''');
  }

  // CREATE / Insert job baru
  Future<int> insertJob(Job job) async {
    final db = await instance.database;
    return await db.insert('pekerjaan', job.toMap());
  }

  // READ / Get semua job
  Future<List<Job>> getJobs() async {
    final db = await instance.database;
    final result = await db.query('pekerjaan');
    return result.map((json) => Job.fromMap(json)).toList();
  }

  // UPDATE job berdasarkan id
  Future<int> updateJob(Job job) async {
    final db = await instance.database;
    return await db.update(
      'pekerjaan',
      job.toMap(),
      where: 'id = ?',
      whereArgs: [job.id],
    );
  }
  Future<bool> checkIfJobExists(String namaPekerjaan) async {
  final db = await instance.database;
  final result = await db.query(
    'pekerjaan',
    where: 'nama_pekerjaan = ?', // Cek berdasarkan nama pekerjaan
    whereArgs: [namaPekerjaan],
  );
  return result.isNotEmpty;  // Jika pekerjaan sudah ada, return true
}


  // DELETE job berdasarkan id
  Future<int> deleteJob(int id) async {
    final db = await instance.database;
    return await db.delete(
      'pekerjaan',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
// Hapus semua data pekerjaan di tabel 'pekerjaan'
  Future<void> clearJobs() async {
    final db = await instance.database;
    await db.delete('pekerjaan');
  }

  Future<List<Job>> getJobsByEmail(String email) async {
    final db = await instance.database;
    final result = await db.query('pekerjaan', where: 'email = ?', whereArgs: [email]);
    return result.map((json) => Job.fromMap(json)).toList();
  }


}

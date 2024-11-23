import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  // Tạo và mở cơ sở dữ liệu
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDatabase();
      return _database!;
    }
  }

  // Khởi tạo cơ sở dữ liệu
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'auth_data.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE auth(id INTEGER PRIMARY KEY, token TEXT, clientId TEXT, clientName TEXT)',
        );
      },
    );
  }

  // Lưu thông tin xác thực
  Future<void> saveAuthData(String token, String clientId, String clientName) async {
    final db = await database;
    await db.insert(
      'auth',
      {'token': token, 'employeeId': clientId, 'employeeName': clientName},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Lấy thông tin xác thực
  Future<Map<String, dynamic>?> getAuthData() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query('auth');
    if (result.isEmpty) return null;
    return result.first;
  }

  // Xóa thông tin xác thực
  Future<void> deleteAuthData() async {
    final db = await database;
    await db.delete('auth');
  }
}

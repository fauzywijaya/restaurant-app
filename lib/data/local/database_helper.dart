import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:submission_restaurant/data/remote/model/restaurant.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  DatabaseHelper._createObject() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._createObject();

  static const String _tableName = "favorite";

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/.db',
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tableName (
             id TEXT PRIMARY KEY,
             name TEXT,
             description TEXT,
             city TEXT,
             address TEXT,
             pictureId TEXT,
             rating DOUBLE
           )     
        ''');
      },
      version: 1,
    );
    return db;
  }



  Future<Database?> get database async {
    _database ??= await _initializeDb();

    return _database;
  }

  Future<void> insertRestaurant(Restaurants restaurant) async {
    final db = await database;
    await db!.insert(_tableName, restaurant.toJson());
    
  }

  Future<List<Restaurants>> getRestaurants() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(_tableName);

    return results.map((e) => Restaurants.fromJson(e)).toList();
  }

  Future<Map> getRestauranyById(String id) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db!.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  Future<void> deleteRestaurantById(String id) async {
    final db = await database;

    await db!.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

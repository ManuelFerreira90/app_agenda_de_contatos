import 'package:app_agenda/model/contact.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const String contactTable = "contact";
const String idColumn = "id";
const String nameColumn = "name";
const String emailColumn = "email";
const String phoneColumn = "phone";
const String imgColumn = "img";

class DB {
  static final _instance = DB.internal();

  factory DB() => _instance;

  DB.internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB('schedule1');
    return _database!;
  }

  Future<Database> _initDB(filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreateDB,
    );
  }

  Future<void> _onCreateDB (Database db, int version) async {
    await db.execute(
      """
        CREATE TABLE $contactTable(
          $idColumn INTEGER PRIMARY KEY AUTOINCREMENT,
          $nameColumn TEXT,
          $emailColumn TEXT,
          $phoneColumn TEXT,
          $imgColumn TEXT
        )
      """
    );
  }

  Future<Contact> insertContact(Contact contact) async {
    final db = await database;
    contact.id = await db.insert(contactTable, contact.toMap());
    return contact;
  }

  Future<Contact?> queryIdContact(int id) async {
    final db = await database;
    List<Map> maps = await db.query(contactTable ,where: "$idColumn = ?", whereArgs: [id]);
    if(maps.isNotEmpty){
      return Contact.fromMap(maps.first);
    }
    return null;
  }

  Future<int> deleteContact(int id) async {
    final db = await database;
    return await db.delete(contactTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateContact (Contact contact) async {
    final db = await database;
    return await db.update(contactTable, contact.toMap(), where: "$idColumn = ?", whereArgs: [contact.id]);
  }

  Future<List<Contact>> queryAllContacts() async {
    final db = await database;
    List<Map> maps = await db.query(contactTable, columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn]);
    return maps.map((e) => Contact.fromMap(e)).toList();
  }

  Future<int?> getLengthDB () async {
    final db = await database;
    return Sqflite.firstIntValue(await db.rawQuery("SELECT * FROM $contactTable"));
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}

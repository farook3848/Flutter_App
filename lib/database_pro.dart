import 'package:notesqflite/modelclass.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  static final DatabaseProvider db = DatabaseProvider._init();
  static Database? _database;
  DatabaseProvider._init();

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    return await openDatabase(join(await getDatabasesPath(), "noteapp.db"),
        onCreate: (db, version) async {
      await db.execute(''' 
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        body TEXT,
        creation_date DATE

      )
 ''');
    }, version: 1);
  }

  addNewNote(NoteModel note) async {
    final db = await database;
    db!.insert("notes", note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<dynamic> getNotes() async {
    final db = await database;
    var res = await db!.query("notes");
    if (res.length == 0) {
      return Null;
    } else {
      var resultMap = res.toList();
      return resultMap.isNotEmpty ? resultMap : Null;
    }
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    int count = await db!.rawDelete("DELETE FROM notes WHERE id = ?", [id]);
    return count;
  }

  Future<int> updateNote(
      int id, String title, String body, DateTime date) async {
    final db = await database;
    int count = await db!.rawUpdate('''
    UPDATE notes 
    SET title = ?, body = ?, creation_date = ? 
    WHERE id = ?
    ''', [title, body, date.toString().substring(0, 10), id]);
    return count;
  }
}

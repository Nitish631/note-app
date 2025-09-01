import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path/path.dart';
class NoteDatabase {
  static final NoteDatabase instance=NoteDatabase._init();
  NoteDatabase._init();//PRIVATE CONSTRUCTOR
  static sqflite.Database? _database;
  Future<sqflite.Database> get database async{//GETTER FOR "_database"
    if(_database!=null) return _database!;
    _database= await _initDB('notes.db');
    return _database!;
  }
  Future<sqflite.Database> _initDB(String filePath) async{//"_initDB" IS A FUNCTION TO OPEN/CREATE DATABASE
    final dbPath= await sqflite.getDatabasesPath();
    final path = join (dbPath,filePath);
    return await sqflite.openDatabase(
      path,
      version:1,
      onCreate:_createDB,
    );
  }
  Future _createDB(sqflite.Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        desc TEXT NOT NULL,
        date TEXT NOT NULL,
        color INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Initialize AUTOINCREMENT to 1111
    await db.rawInsert(
        "INSERT INTO sqlite_sequence (name, seq) VALUES ('notes', 1110)"
    );
  }
  Future<int> addNote(String title, String desc,int color,String date)async{
    final db = await instance.database;
    return await db.insert("notes",
        {
          "title":title,
          "desc":desc,
          "date":date,
          "color":color
        }
    );
  }
  Future<List<Map<String, dynamic>>> getNotes() async{
    final db = await instance.database;
    return await db.query("notes",orderBy: "date DESC");
  }
  Future<int> updateNote(String title, String desc,String date,int color,int id)async{
    final db = await instance.database;
    return await db.update("notes",
      {
        "title":title,
        "desc":desc,
        "date":date,
        "color":color
      },
      where: "id = ?",
      whereArgs: [id],
    );
  }
  Future<int> deleteNote(int id)async{
    final db=await instance.database;
    return await db.delete("notes",
      where: "id=?",
      whereArgs: [id],
    );
  }
}
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list_app/models/todo_model.dart';

class DBHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  /// Creates the database file and initializes the schema. If the database file
  /// already exists, this function simply opens the existing file.
  ///
  /// The database has one table named 'todos' with the following columns:
  ///
  /// - id: INTEGER PRIMARY KEY AUTOINCREMENT
  /// - title: TEXT
  /// - description: TEXT
  /// - isCompleted: INTEGER
  /// - category: TEXT
  /// - deadline: TEXT
  /// - priority: INTEGER
  ///
  /// This function is private and should not be called directly. Instead, use the
  /// [database] getter to get the database instance.
  static Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'todo.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE todos(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            isCompleted INTEGER,
            category TEXT,
            deadline TEXT,
            priority INTEGER
          )
        ''');
      },
    );
  }

  /// Inserts a todo into the database, returning the row id of the newly
  /// inserted todo.
  static Future<int> insertTodo(Todo todo) async {
    final db = await database;
    return await db.insert('todos', todo.toMap());
  }

  /// Gets all todos from the database.
  ///
  /// Returns a list of [Todo] objects. The list is sorted in ascending order
  /// by the 'id' column.
  static Future<List<Todo>> getTodos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('todos');
    return maps.map((e) => Todo.fromMap(e)).toList();
  }

  /// Updates a todo in the database. Returns the number of rows modified.
  ///
  /// The [Todo] object passed in must have a valid 'id' field, which is used to
  /// identify the todo to be updated. All fields of the [Todo] object are updated.
  ///
  /// If no row is modified, the function returns 0. Otherwise, it returns the
  /// number of rows modified, which should always be 1 unless the database is
  /// misconfigured or corrupted.
  static Future<int> updateTodo(Todo todo) async {
    final db = await database;
    return await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  /// Deletes a todo from the database by its [id].
  ///
  /// The [id] parameter specifies the unique identifier of the todo to be deleted.
  ///
  /// Returns the number of rows affected, which should be 1 if the delete operation
  /// was successful, or 0 if no todo with the specified [id] was found.
  static Future<int> deleteTodo(int id) async {
    final db = await database;
    return await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }
}

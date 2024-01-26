import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../Models/item.dart';

class DatabaseHelper {
  static const String _databaseName = 'projManage.db';
  static Logger logger = Logger();

  static Future<Database> _init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, _databaseName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE items(
            id INTEGER PRIMARY KEY,
            name TEXT,
            team TEXT,
            details TEXT,
            status TEXT,
            members INTEGER,
            type TEXT
          )
        ''');
      },
    );
  }

  static Future<List<Item>> getItems() async {
    final db = await _init();
    final result = await db.query('items');
    logger.log(Level.info, 'getItems: $result');
    return result.map((e) => Item.fromJson(e)).toList();
  }

  static Future<int> addItem(Item item) async {
    final db = await _init();
    final id = await db.insert(
      'items',
      item.toJsonWithoutId(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    logger.log(Level.info, 'addItem: $id');
    return id;
  }

  static Future<int> updateItem(Item item) async {
    final db = await _init();
    final result = await db.update(
      'items',
      item.toJson(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
    logger.log(Level.info, 'updateItem: $result');
    return result;
  }

  static Future<int> deleteItem(int id) async {
    final db = await _init();
    final result = await db.delete('items', where: 'id = ?', whereArgs: [id]);
    logger.log(Level.info, 'deleteItem: $result');
    return result;
  }

  static Future<void> close() async {
    final db = await _init();
    await db.close();
  }
}

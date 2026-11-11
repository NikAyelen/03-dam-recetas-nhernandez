import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:recetas_app/models/opinion.dart';

class OpinionesDb {
  OpinionesDb._();
  static final OpinionesDb instancia = OpinionesDb._(); // Singleton
  static const _nombreArchivo = 'misopiniones_v2.db';
  static const _tabla = 'opiniones';

  Database? _db;

  // devuelve la bd abierta (la abre solo la primera vez)
  Future<Database> get _database async {
    _db ??= await _abrir();
    return _db!;
  }

  Future<Database> _abrir() async {
    final ruta = join(await getDatabasesPath(), _nombreArchivo);
    return openDatabase(
      ruta,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
CREATE TABLE $_tabla (
id INTEGER PRIMARY KEY AUTOINCREMENT,
receta_id INTEGER NOT NULL,
opinion TEXT NOT NULL
)
''');
      },
    );
  }

  // guarda y devuelve el id
  Future<int> insert(Opinion opinion) async {
    final db = await _database;
    return db.insert(_tabla, opinion.toMap());
  }

  // lee las opiniones de UNA receta, las más nuevas primero
  Future<List<Opinion>> obtenerPorReceta(int recetaId) async {
    final db = await _database;
    final filas = await db.query(
      _tabla,
      where: 'receta_id = ?',
      whereArgs: [recetaId],
      orderBy: 'id DESC',
    );
    return filas.map(Opinion.fromMap).toList();
  }

  // elimina la opinión con el id
  Future<int> eliminar(int id) async {
    final db = await _database;
    return db.delete(_tabla, where: 'id = ?', whereArgs: [id]);
  }
}
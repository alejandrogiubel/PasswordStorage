
import 'package:myapp/models/Credential.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {

  static final Future<Database> dataBase = openDatabase(
    // Establece la ruta a la base de datos. 
    join(getDatabasesPath().toString(), 'password_storage.db'),
    // Cuando la base de datos se crea por primera vez, crea una tabla para almacenar dogs
    onCreate: (db, version) {
    // Ejecuta la sentencia CREATE TABLE en la base de datos
      return db.execute(
        "CREATE TABLE credentials(id INTEGER PRIMARY KEY, name TEXT, user_name TEXT, password TEXT)",
      );
    },
  // Establece la versión. Esto ejecuta la función onCreate y proporciona una
  // ruta para realizar actualizacones y defradaciones en la base de datos.
  version: 1,
  );


// A continuación, define la función para insertar datos en la base de datos
  static Future<void> insertCredential(Credential credential) async {
    // Obtiene una referencia de la base de datos
    final Database db = await dataBase;
    // Inserta el dato en la tabla correcta. También puede especificar el
    // `conflictAlgorithm` para usar en caso de que el mismo Dog se inserte dos veces.
    // En este caso, reemplaza cualquier dato anterior.
    await db.insert(
      'credentials',
      credential.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Credential>> getCredentials() async {
    // Obtiene una referencia de la base de datos
    final Database db = await dataBase;
    // Consulta la tabla por todos los datos.
    final List<Map<String, dynamic>> maps = await db.query('credentials');
    // Convierte List<Map<String, dynamic> en List<Datos>.
    return List.generate(maps.length, (i) {
      return Credential (
        id: maps[i]['id'],
        name: maps[i]['name'],
        userName: maps[i]['user_name'],
        password: maps[i]['password'],
      );
    });
  }


  static Future<void> updateCredential(Credential credential) async {
    // Obtiene una referencia de la base de datos
    final db = await dataBase;

    // Actualiza el Dog dado
    await db.update(
      'credentials',
      credential.toMap(),
      // Asegúrate de que solo actualizarás el dato con el id coincidente
      where: "id = ?",
      // Pasa el id dato a través de whereArg para prevenir SQL injection
      whereArgs: [credential.id],
    );
  }

  static Future<void> deleteCredential(int id) async {
    // Obtiene una referencia de la base de datos
    final db = await dataBase;

    // Elimina el Dog de la base de datos
    await db.delete(
      'credentials',
      // Utiliza la cláusula `where` para eliminar un dog específico
      where: "id = ?",
      // Pasa el id Dog a través de whereArg para prevenir SQL injection
      whereArgs: [id],
    );
  }
}
import 'package:sqflite/sqflite.dart' as sql;
import 'initDB.dart' as INITDB;

class SQLHelper{
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS data(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    nome TEXT,
    sexo TEXT,
    nascimento TEXT,
    cpf TEXT,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )""");
  }
  
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      "database_usuario.db",
      version: 1,
      onCreate: (sql.Database database, int version) async {
        //INITDB.initBD();
       // await createTables(database);
        await database.execute("""CREATE TABLE IF NOT EXISTS professor(
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            nome TEXT NOT NULL,
            sexo TEXT NOT NULL,
            nascimento TEXT NOT NULL,
            cpf TEXT NOT NULL,
            createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
            )""");

        await database.execute("""CREATE TABLE IF NOT EXISTS disciplina(
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            nome TEXT NOT NULL,
            cod CHAR[3] NOT NULL,
            matricula_professor TEXT,
            createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (matricula_professor) REFERENCES professor (id)
            )""");

        await database.execute("""CREATE TABLE IF NOT EXISTS data(
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            nome TEXT NOT NULL,
            sexo TEXT NOT NULL,
            nascimento TEXT NOT NULL,
            cpf TEXT NOT NULL,
            createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
            )""");

        await database.execute("""CREATE TABLE IF NOT EXISTS matriculadosDisciplinas(
            matricula_aluno INTEGER,
            matricula_disciplina INTEGER,
            FOREIGN KEY (matricula_aluno) REFERENCES data(id),
            FOREIGN KEY (matricula_disciplina) REFERENCES disciplina(id),
            PRIMARY KEY (matricula_aluno, matricula_disciplina)
            )""");
      }
    );
  }


  static Future<int> createData(String nome, String sexo, String nascimento, String cpf) async {
    final db = await SQLHelper.db();

    final data = {'nome': nome, 'sexo': sexo, 'nascimento': nascimento, 'cpf': cpf};
    final id = await db.insert('data', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllData() async{
    final db = await SQLHelper.db();
    return db.query('data', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getSingleData(int id) async {
    final db = await SQLHelper.db();
    return db.query('data', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateData(int id, String nome, String sexo, String nascimento, String cpf) async{
    final db = await SQLHelper.db();
    final data = {
      'nome': nome,
      'sexo': sexo,
      'nascimento': nascimento,
      'cpf': cpf,
      'createdAt': DateTime.now().toString()
    };

    final result = await db.update('data', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteData (int id) async{
    final db = await SQLHelper.db();
    try {
      await db.delete('data', where: "id = ?", whereArgs: [id]);
    } catch(e) {}
  }
}
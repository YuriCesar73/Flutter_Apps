import 'package:sqflite/sqflite.dart' as sql;


class DisciplinaDB{
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS disciplina(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    nome TEXT,
    cod CHAR[3],
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
        "database_usuario.db",
        version: 1,
        onCreate: (sql.Database database, int version) async {
         // INITDB.initBD();
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
            nome_aluno TEXT,
            FOREIGN KEY (matricula_aluno) REFERENCES data(id),
            FOREIGN KEY (matricula_disciplina) REFERENCES disciplina(id),
            PRIMARY KEY (matricula_aluno, matricula_disciplina)
            )""");
        }
    );
  }

  static Future<int> createData(String nome, String cod, String matriculaProfessor) async {
    final db = await DisciplinaDB.db();

    final data = {'nome': nome, 'cod': cod, 'matricula_professor': matriculaProfessor};
    final id = await db.insert('disciplina', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllData() async{
    final db = await DisciplinaDB.db();
    return db.query('disciplina', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getSingleData(int id) async {
    final db = await DisciplinaDB.db();
    return db.query('disciplina', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> getAllProfessorData(String matricula_professor) async {
    final db = await DisciplinaDB.db();
    return db.query('disciplina', where: "matricula_professor = ?", whereArgs: [matricula_professor]);
  }

  static Future<int> updateData(int id, String nome, String cod, String matriculaProfessor) async{
    final db = await DisciplinaDB.db();
    final data = {
      'nome': nome,
      'cod': cod,
      'matricula_professor': matriculaProfessor,
      'createdAt': DateTime.now().toString()
    };

    final result = await db.update('disciplina', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<int> updateProfessorData(String id) async{
    final db = await DisciplinaDB.db();
    final result = await db.update('disciplina', {'matricula_professor': ''}, where: "matricula_professor = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteData (int id) async{
    final db = await DisciplinaDB.db();
    try {
      await db.delete('disciplina', where: "id = ?", whereArgs: [id]);
    } catch(e) {}
  }


}
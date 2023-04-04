import 'package:sqflite/sqflite.dart' as sql;


class MatriculadosDB{
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS matriculadosDisciplinas(
            matricula_aluno INTEGER,
            matricula_disciplina INTEGER,
            FOREIGN KEY (matricula_aluno) REFERENCES data(id),
            FOREIGN KEY (matricula_disciplina) REFERENCES disciplina(id),
            PRIMARY KEY (matricula_aluno, matricula_disciplina),
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
            FOREIGN KEY (matricula_aluno) REFERENCES data(id),
            FOREIGN KEY (matricula_disciplina) REFERENCES disciplina(id),
            PRIMARY KEY (matricula_aluno, matricula_disciplina)
            )""");
        }
    );
  }

  static Future<int> createData(String matricula_aluno, String matricula_disciplina) async {
    final db = await MatriculadosDB.db();

    final data = {'matricula_aluno': matricula_aluno, 'matricula_disciplina': matricula_disciplina};
    final id = await db.insert('matriculadosDisciplinas', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllData() async{
    final db = await MatriculadosDB.db();
    return db.query('matriculadosDisciplinas', orderBy: 'matricula_aluno');
  }

  static Future<List<Map<String, dynamic>>> getSingleData(String matricula_aluno, String matricula_disciplina) async {
    final db = await MatriculadosDB.db();
    return db.query('matriculadosDisciplinas', where: "matricula_aluno = ? and matricula_disciplina = ?", whereArgs: [matricula_aluno, matricula_disciplina], limit: 1);
  }

 /* static Future<int> updateData(int id, String nome, String cod, String matriculaProfessor) async{
    final db = await MatriculadosDB.db();
    final data = {
      'nome': nome,
      'cod': cod,
      'matricula_professor': matriculaProfessor,
      'createdAt': DateTime.now().toString()
    };

    final result = await db.update('matriculadosDisciplinas', data, where: "id = ?", whereArgs: [id]);
    return result;
  }*/

  static Future<void> deleteData (String matricula_aluno, String matricula_disciplina) async{
    final db = await MatriculadosDB.db();
    try {
      await db.delete('matriculadosDisciplinas', where: "matricula_aluno = ? and matricula_disciplina = ?", whereArgs: [matricula_aluno, matricula_disciplina]);
    } catch(e) {}
  }
}
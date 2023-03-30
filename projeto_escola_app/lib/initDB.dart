import 'package:sqflite/sqflite.dart' as sql;

initBD (){

   Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS professor(
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            nome TEXT,
            sexo TEXT,
            nascimento TEXT,
            cpf TEXT,
            createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
            )""");

    await database.execute("""CREATE TABLE IF NOT EXISTS disciplina(
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            nome TEXT,
            cod CHAR[3],
            createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
            )""");

    await database.execute("""CREATE TABLE IF NOT EXISTS data(
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            nome TEXT,
            sexo TEXT,
            nascimento TEXT,
            cpf TEXT,
            createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
            )""");

  };

}
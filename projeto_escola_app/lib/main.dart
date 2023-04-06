import 'package:flutter/material.dart';
import 'package:projeto_escola_android/professor_screen.dart';
import 'dados_disciplina_screen.dart';
import 'disciplina_screen.dart';
import 'firstHome.dart';
import 'home_screen.dart';


void main() => runApp(MyApp(
));

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo
      ),
      routes: {
        '/': (context) => FirstHome(),
        '/home_screen': (context) => HomeScreen(),
        '/professor_screen': (context) => ProfessorScreen(),
        '/disciplina_screen': (context) => DisciplinaScreen(),
        '/dados_disciplina_screen': (context) => DadosDisciplina(),
      },
      //home: HomeScreen(),
    );
  }
}


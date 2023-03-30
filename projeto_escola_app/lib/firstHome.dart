import 'package:flutter/material.dart';

class FirstHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Projeto Escola"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 150.0, 0.0, 0.0),
        child: Center(
          child: Column(
            children: [
              TextButton.icon(onPressed: () {
                Navigator.pushNamed(context, '/professor_screen');
              },
                  icon: Icon(Icons.school_rounded),
                  label: Text("Docentes")
              ),
              SizedBox(height: 20,),
              TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/disciplina_screen');
                  },
                  icon: Icon(Icons.book),
                  label: Text("Disciplinas")
              ),
              SizedBox(height: 20,),
              TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/home_screen');
                  },
                  icon: Icon(Icons.person_pin),
                  label: Text("Discentes")
              )
            ],
        ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class FirstHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Projeto Escola",
        style: TextStyle(
            fontSize: 25
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 150.0, 0.0, 0.0),
        child: Center(
          child: Column(
            children: [
              ElevatedButton.icon(
                  onPressed: () {
                Navigator.pushNamed(context, '/professor_screen');
              },
                  icon: Icon(Icons.school_rounded),
                  label: Text("Docentes")
              ),
              SizedBox(height: 30,),
              ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/disciplina_screen');
                  },
                  icon: Icon(Icons.book),
                  label: Text("Disciplinas")
              ),
              SizedBox(height: 30,),
              ElevatedButton.icon(
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

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/user_file.dart';
import 'package:flutter_application_1/provider/professor.dart';
import 'package:flutter_application_1/routes/app_routes.dart';
import 'package:provider/provider.dart';

import '../components/professor_file.dart';
import '../models/user.dart';
import '../provider/users.dart';


class ProfessorList extends StatelessWidget {

  const ProfessorList({Key? key}) :super(key: key);


  @override
  Widget build(BuildContext context) {

    final Docentes users = Provider.of<Docentes>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de docentes'),
        actions: [
          IconButton(
             icon: Icon(Icons.add),
            onPressed: () {
             Navigator.of(context).pushNamed(
              AppRoutes.PROFESSOR_FORM,
              arguments: const User(
                id: '',
                name: '',
                email: '',
                avatarUrl: '',
              )
             );
            }, 
            )
        ],
      ),
      body: ListView.builder(
        itemCount: users.count,
        itemBuilder: ((context, index) => ProfessorTile(users.byIndex(index)))
        ),
       drawer: Drawer(
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: Text("Dicentes"),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                     Navigator.pushReplacementNamed(context, AppRoutes.HOME, arguments: const User(
                id: '',
                name: '',
                email: '',
                avatarUrl: '',
              ));
                  },
                ),
                ListTile(
                  title: Text("Disciplina"),
                  trailing: Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ),
      
      );
  }
}
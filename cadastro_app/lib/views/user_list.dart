import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/user_file.dart';
import 'package:flutter_application_1/provider/users.dart';
import 'package:flutter_application_1/routes/app_routes.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';


class UserList extends StatelessWidget {

  const UserList({Key? key}) :super(key: key);

  @override
  Widget build(BuildContext context) {

    final Users users = Provider.of<Users>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Discentes'),
        actions: [
          IconButton(
             icon: Icon(Icons.add),
            onPressed: () {
             Navigator.of(context).pushNamed(
              AppRoutes.USER_FORM,
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
        itemBuilder: ((context, index) => UserTile(users.byIndex(index)))
        ),
       drawer: Drawer(
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: Text("Docentes"),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                     Navigator.pushReplacementNamed(context, AppRoutes.PROFESSOR_LIST, arguments: const User(
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
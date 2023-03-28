import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/professor.dart';
import 'package:flutter_application_1/provider/users.dart';
import 'package:flutter_application_1/routes/app_routes.dart';
import 'package:flutter_application_1/views/professor_form.dart';
import 'package:flutter_application_1/views/professor_list.dart';
import 'package:flutter_application_1/views/user_form.dart';
import 'package:provider/provider.dart';
import 'views/user_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
   return MultiProvider(
    providers: [
      ChangeNotifierProvider<Users>(
        create: (context) => Users(),
      ),
      ChangeNotifierProvider<Docentes>(
        create: (context) => Docentes(),
      ),
    ],
    child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(   
          primarySwatch: Colors.blue,
        ),
        routes: {
          AppRoutes.HOME: (_) => UserList(),
          AppRoutes.USER_FORM: (_) => UserForm(),
          AppRoutes.PROFESSOR_LIST: (_) => ProfessorList(),
          AppRoutes.PROFESSOR_FORM: (_) => ProfessorForm(),
        },
      ),
    );
  }
}
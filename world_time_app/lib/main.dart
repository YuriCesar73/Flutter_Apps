import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/choose_location.dart';
import 'pages/loading.dart';

void main() => runApp(MaterialApp(

  initialRoute: '/',
  /* Propriedade routes: Map
      As chaves são as rotas de acesso.
      Os valores são funções, que recebem um parametro context, que chamam cada arquivo do dart (nesse caso as classes)
   */
  routes: {
    '/': (context) => Loading(),
    '/home': (context) => Home(),
    '/location': (context) => ChooseLocation(),
  },
));



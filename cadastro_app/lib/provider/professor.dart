import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/dummy_users.dart';

import '../data/professor_user.dart';
import '../models/user.dart';

class Docentes with ChangeNotifier {
  final Map<String, User> _items = {...DOCENTES_MODELS};
  
  List<User> get all {
    return [..._items.values];
  }

  int get count {
    return _items.length;
  }

  User byIndex(int i){
    return _items.values.elementAt(i);
  }

  void put(User user){
    if(user == null){
      return;
    }

    if(user.id != null && user.id!.trim().isNotEmpty && _items.containsKey(user.id)) {
      _items.update(user.id!
      , (_) => User(
        id: user.id,
        name: user.name, 
        email: user.email, 
        avatarUrl: user.avatarUrl
        ));
    }
    else {
      //adicionar
      final id = Random().nextDouble().toString();
      _items.putIfAbsent(id, () => User(
        id: id,
        name: user.name,
        email: user.email,
        avatarUrl: user.avatarUrl,
      ));
    }

    notifyListeners();
  }

  void remove(User user) {
    if(user.id != null && user != null){
      _items.remove(user.id);
     notifyListeners();
    }
     
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../provider/users.dart';

class UserForm extends StatelessWidget {

  final _form = GlobalKey <FormState>(); 
  final Map<String, String> _formData = {};

  void _loadFormData(User user){

    // ignore: unnecessary_null_comparison
    if(user != null){
    _formData['id'] = user.id!;
    _formData['name'] = user.name;
    _formData['email'] = user.email;
    _formData['avatarUrl'] = user.avatarUrl;
    }
  }
  
  UserForm({Key? key}) :super(key: key);

  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context)?.settings.arguments as User;
  
  _loadFormData(user);

    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de usuário'),
        actions: [
          IconButton(
            onPressed: () {
             final isValid = _form.currentState!.validate();
             

             if(isValid) {
              _form.currentState!.save();

              Provider.of<Users>(context, listen: false).put(
                User(
                id: _formData['id'],
                name: _formData['name']!,
                email: _formData['email']!,
                avatarUrl: _formData['avatarUrl']!,
              ),
              );
              Navigator.of(context).pop();
             }
              
            }, 
            icon: Icon(Icons.save),
            )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(13),
        child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(
                initialValue: _formData['name'],
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if(value == null || value.trim().isEmpty){
                   return 'Ocorreu um erro';
                   }
                   if(value.trim().length < 3) {
                    return 'Nome muito pequeno. No mínimo 3 letras';
                   }
                   },
                onSaved: (value) => _formData['name'] = value!,
              ),
              TextFormField(
                 initialValue: _formData['email'],
                decoration: InputDecoration(labelText: 'Email'),
                onSaved: (value) => _formData['email'] = value!,
              ),
              TextFormField(
                 initialValue: _formData['avatarUrl'],
                decoration: InputDecoration(labelText: 'URL do Avatar'),
                 onSaved: (value) => _formData['avatarUrl'] = value!,
              ),
            ],
            ),
        ),
        ),
    );
  }
}
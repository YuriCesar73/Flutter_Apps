import 'dart:ffi';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:projeto_escola_android/db_helper.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _allData = [];

  bool _isLoading = true;

  //Get all data
  void _refreshData() async {
    final data = await SQLHelper.getAllData();
    setState(() {
      _allData = data;
      _isLoading = false;
      print(_allData);
    });
  }

  @override
  void initState(){
    super.initState();
    _refreshData();
    //databaseFactory.deleteDatabase("database_usuario.db");
  }

  //Add
  Future<void> _addData() async {
    await SQLHelper.createData(_nomeController.text, _sexoController.text, _nascimentoController.text, _cpfController.text);
    _refreshData();
  }

  //Update
  Future<void> _updateData(int id) async {
    await SQLHelper.updateData(id, _nomeController.text, _sexoController.text, _nascimentoController.text, _cpfController.text);
    _refreshData();
  }

  //Delete
  void _deleteData(int id) async {
    await SQLHelper.deleteData(id);
    ScaffoldMessenger.of(context).
    showSnackBar(const SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text('Dados apagados!'),
    ));
    _refreshData();
  }

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _sexoController = TextEditingController();
  final TextEditingController _nascimentoController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();


  final formKey = GlobalKey<FormState>();

  void showBottomSheet(int? id) async {
    if(id!=null){
      final existingData = _allData.firstWhere((element) => element['id'] == id);
      _nomeController.text = existingData['nome'];
      _sexoController.text = existingData['sexo'];
      _nascimentoController.text = existingData['nascimento'];
      _cpfController.text = existingData['cpf'];
    }
    
    showModalBottomSheet(
      elevation: 5,
      isScrollControlled: true,
      context: context,
      builder: (_) => Container(
        padding: EdgeInsets.only(
            left: 15.0,
            top: 30.0,
            right: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom + 40),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormField(
                controller: _nomeController,
                validator: (String? value){
                  if(value!.isEmpty || value == null){
                    return 'Nome obrigatório';
                  }
                  if(value.length < 3){
                    return 'Nome precisa ter no mínimo 3 letras';
                  }
                },
                  decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Nome",
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _sexoController,
                validator: (String? value){
                  if(value!.isEmpty || value == null){
                    return 'Sexo obrigatório';
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Sexo",
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _nascimentoController,
                validator: (String? value){
                  if(value!.isEmpty || value == null){
                    return 'Data de nascimento obrigatória';
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Data de Nascimento",
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _cpfController,
                validator: (String? value){
                  if(value!.isEmpty || value == null){
                    return 'CPF obrigatório';
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "CPF",
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {

                    bool? formulario = formKey.currentState?.validate();
                    print(formulario);
                    if(formulario != null && formulario == true) {
                      if (id == null) {
                        await _addData();
                      }
                      if (id != null) {
                        await _updateData(id);
                      }
                      _nomeController.text = "";
                      _sexoController.text = "";
                      _cpfController.text = "";
                      _nascimentoController.text = "";

                      Navigator.of(context).pop();
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(18),
                    child: Text(id == null ? "Add Data" : "Update",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent[50],
      appBar: AppBar(
        title: Text("Projeto Escola - Discentes"),
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator(),):
      ListView.builder(
        itemCount: _allData.length,
        itemBuilder: (context, index) => Card(
          margin: EdgeInsets.all(15),
          child: ListTile(
            title: Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text(
                _allData[index]['nome'],
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            subtitle: Text('Matricula: ' +_allData[index]['id'].toString() +'\nSexo: ' + _allData[index]['sexo'] + ', \nNascimento: ' + _allData[index]['nascimento'] + ', \nCPF: ' + _allData[index]['cpf']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () {
                      showBottomSheet(_allData[index]['id']);
                    },
                    icon: Icon(Icons.edit),
                  color: Colors.indigo,
                ),
                IconButton(
                  onPressed: () {
                    _deleteData(_allData[index]['id']);
                  },
                  icon: Icon(Icons.delete),
                  color: Colors.red,
                )
              ],
            ),
          ),
        ),
      ) ,
      floatingActionButton: FloatingActionButton(
        onPressed: () => showBottomSheet(null),
        child: Icon(Icons.add),
        ),
      );
  }
}

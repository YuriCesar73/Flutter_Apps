import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:projeto_escola_android/disciplina_db.dart';
import 'package:sqflite/sqflite.dart';

class DisciplinaScreen extends StatefulWidget {
  @override
  State<DisciplinaScreen> createState() => _DisciplinaScreen();
}

class _DisciplinaScreen extends State<DisciplinaScreen> {

  List<Map<String, dynamic>> _allData = [];

  bool _isLoading = true;

  //Get all data
  void _refreshData() async {
    final data = await DisciplinaDB.getAllData();
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
    await DisciplinaDB.createData(_nomeController.text, _codController.text);
    _refreshData();
  }

  //Update
  Future<void> _updateData(int id) async {
    await DisciplinaDB.updateData(id, _nomeController.text, _codController.text);
    _refreshData();
  }

  //Delete
  void _deleteData(int id) async {
    await DisciplinaDB.deleteData(id);
    ScaffoldMessenger.of(context).
    showSnackBar(const SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text('Dados da disciplina deletados!'),
    ));
    _refreshData();
  }

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _codController = TextEditingController();


  void showBottomSheet(int? id) async {
    if(id!=null){
      final existingData = _allData.firstWhere((element) => element['id'] == id);
      _nomeController.text = existingData['nome'];
      _codController.text = existingData['cod'];
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Nome",
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: _codController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "cod (apenas 3 letras)",
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if(id == null) {
                    await _addData();
                  }
                  if(id != null){
                    await _updateData(id);
                  }
                  _nomeController.text = "";
                  _codController.text = "";


                  Navigator.of(context).pop();
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent[50],
      appBar: AppBar(
        title: Text("Projeto Escola - Disciplinas"),
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
            subtitle: Text('Matricula: ' +_allData[index]['id'].toString() + '\nCOD: ' + _allData[index]['cod']),
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

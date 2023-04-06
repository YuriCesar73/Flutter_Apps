import 'package:flutter/material.dart';
import 'package:projeto_escola_android/professor_db.dart';


class ProfessorScreen extends StatefulWidget {
  @override
  State<ProfessorScreen> createState() => _ProfessorScreen();
}

class _ProfessorScreen extends State<ProfessorScreen> {

  List<Map<String, dynamic>> _allData = [];

  bool _isLoading = true;

  //Get all data
  void _refreshData() async {
    final data = await ProfessorDB.getAllData();
    setState(() {
      _allData = data;
      _isLoading = false;
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
    await ProfessorDB.createData(_nomeController.text, _sexoController.text, _nascimentoController.text, _cpfController.text);
    ScaffoldMessenger.of(context).
    showSnackBar(const SnackBar(
      backgroundColor: Colors.greenAccent,
      content: Text('Docente cadastrado!'),
    ));
    _refreshData();
  }

  //Update
  Future<void> _updateData(int id) async {
    await ProfessorDB.updateData(id, _nomeController.text, _sexoController.text, _nascimentoController.text, _cpfController.text);
    ScaffoldMessenger.of(context).
    showSnackBar(const SnackBar(
      backgroundColor: Colors.blueAccent,
      content: Text('Dados atualizados!'),
    ));
    _refreshData();
  }

  //Delete
  void _deleteData(int id) async {
    await ProfessorDB.deleteData(id);
    ScaffoldMessenger.of(context).
    showSnackBar(const SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text('Dados deletados!'),
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
                  if(value.length < 3) return "Insira, no mínimo, 3 caracteres";
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
                  if(value.length != 1){
                    return "Digite apenas 1 caractere";
                  }
                  if(value.toUpperCase() != 'M' && value.toUpperCase() != 'F' && value.toUpperCase() != 'O'){
                    return 'Insira um caractere válido (M, F, O)';
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
                  if(value.length != 10 && value.length != 8){
                    return 'Formato de data inválido (DD/MM/AAAA) ou (DD/MM/AA)';
                  }
                  if(value.contains(RegExp(r'[A-Z]')) || value.contains(RegExp(r'[a-z]')) || !value.contains(RegExp('/'),2) || !value.contains(RegExp('/'),5)){
                    return "Insira caracteres válidos";
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
                  String result = value.replaceAll(RegExp('[^A-Za-z0-9]'), ''); //Retira os caracteres diferentes de números

                  if(result.length != 11) {
                    return 'CPF inválido';
                  }

                  var cpfNumeros = [];

                  for(int i = 0; i < result.length; i++){
                    cpfNumeros.add(int.parse(result[i]));
                  }

                  int j=1;
                  num soma=0;
                  for (int i=0; i<9; i++){
                    soma = (soma + (cpfNumeros[i]*j));
                    j++;
                  }

                  num digitoVerificador1 = soma % 11;

                  if (digitoVerificador1 == 10){
                    digitoVerificador1=0;
                  }

                  soma = 0;

                  for (int i = 0; i < 10; i++){
                    soma = soma + (cpfNumeros[i]*i);
                  }

                  num digitoVerificador2 = soma%11;

                  if (digitoVerificador2 == 10){
                    digitoVerificador2 = 0;
                  }

                  if(!(digitoVerificador1 == cpfNumeros[9]) || !(digitoVerificador2 == cpfNumeros[10])){
                    return "CPF inválido";
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
                    child: Text(id == null ? "Adicionar" : "Atualizar",
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
        title: Text("Projeto Escola - Docentes"),
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
            subtitle: Text('Matricula: ' +_allData[index]['id'].toString() + '\nSexo: ' + _allData[index]['sexo'] + ' \nNascimento: ' + _allData[index]['nascimento'] + ' \nCPF: ' + _allData[index]['cpf']),
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

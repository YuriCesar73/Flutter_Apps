import 'package:flutter/material.dart';
import 'package:projeto_escola_android/disciplina_db.dart';
import 'package:projeto_escola_android/professor_db.dart';


class DisciplinaScreen extends StatefulWidget {
  @override
  State<DisciplinaScreen> createState() => _DisciplinaScreen();
}

class _DisciplinaScreen extends State<DisciplinaScreen> {

  List<Map<String, dynamic>> _allData = [];
  List<Map<String, dynamic>> singleProfessor = [];

  bool _isLoading = true;

  //Get all data
  void _refreshData() async {
    final data = await DisciplinaDB.getAllData();
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
    await DisciplinaDB.createData(_nomeController.text, _codController.text, _matriculaProfessorController.text);
    ScaffoldMessenger.of(context).
    showSnackBar(const SnackBar(
      backgroundColor: Colors.greenAccent,
      content: Text('Disciplina adicionada!'),
    ));

    _refreshData();
  }

  //Update
  Future<void> _updateData(int id) async {
    await DisciplinaDB.updateData(id, _nomeController.text, _codController.text, _matriculaProfessorController.text);
    ScaffoldMessenger.of(context).
    showSnackBar(const SnackBar(
      backgroundColor: Colors.blueAccent,
      content: Text('Dados atualizados!'),
    ));

    _refreshData();
  }


  //Delete
  void _deleteData(int id) async {
    await DisciplinaDB.deleteData(id);
    ScaffoldMessenger.of(context).
    showSnackBar(const SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text('Dados deletados!'),
    ));
    _refreshData();
  }

  Future<List?> buscaProfessor(matricula) async {

    List<Map<String, dynamic>> professor;

      if(matricula == null) return null;

    int? id = int.tryParse(matricula);

    if(id == null) return null;

    professor = await ProfessorDB.getSingleData(id!);

    if(professor.isEmpty) {

    };
    var matriculaProfessor = professor;

    //getDadosProfessor(professor);

    return matriculaProfessor.toList();
  }

  void getDadosProfessor(professor){
    singleProfessor = professor;
  }

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _codController = TextEditingController();
  final  TextEditingController _matriculaProfessorController = TextEditingController();
  String? matriculaProfesssor;


  final formKey = GlobalKey<FormState>();

  void showBottomSheet(int? id) async {
    if(id!=null){
      final existingData = _allData.firstWhere((element) => element['id'] == id);
      _nomeController.text = existingData['nome'];
      _codController.text = existingData['cod'];
      _matriculaProfessorController.text = existingData['matricula_professor'];
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
                    return 'Nome Obrigatório';
                  }
                  if(value.length < 3) return 'Insira, no mínimo, três caracteres';
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Nome",
                ),
              ),
              const SizedBox(height: 10,),
              TextFormField(
                controller: _codController,
                validator: (String? value){
                  if(value!.isEmpty || value == null){
                    return 'Código Obrigatório';
                  }
                  if(value.length != 6){
                    return "Código precisa de 6 caracteres";
                  }
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "cod (6 caracteres)",
                ),
              ),
              const SizedBox(height: 10,),
              TextFormField(
                onChanged: (text){
                  matriculaProfesssor = text;
                },
                controller: _matriculaProfessorController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Adicionar professor (inserir matricula)",
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    var objectProfessor;

                    bool? formulario = formKey.currentState?.validate();
                    if(formulario != null && formulario == true)
                    {

                      if (formulario != null && formulario == true)
                         objectProfessor =
                            await buscaProfessor(matriculaProfesssor);



                      if (objectProfessor == null) {
                        _matriculaProfessorController.text = "";
                      } else if (objectProfessor!.isEmpty) {

                        _matriculaProfessorController.text = "";
                      } else {
                        _matriculaProfessorController.text =
                            matriculaProfesssor!;
                      }

                      if (id == null) {
                        await _addData();
                      }
                      if (id != null) {
                        await _updateData(id);
                      }
                      _nomeController.text = "";
                      _codController.text = "";
                      _matriculaProfessorController.text = "";

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
            subtitle: Text('ID:  ${_allData[index]['id'].toString()}  \nCOD: ${_allData[index]['cod']} \nMatricula docente: ${_allData[index]['matricula_professor']}'),
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
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/dados_disciplina_screen', arguments: _allData[index]);
                    },
                  icon: Icon(Icons.more),
                  color: Colors.lime,
                ),
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_escola_android/professor_db.dart';

import 'db_helper.dart';
import 'matriculados_db.dart';

class DadosDisciplina extends StatefulWidget {

  @override
  State<DadosDisciplina> createState() => _DadosDisciplinaState();
}

class _DadosDisciplinaState extends State<DadosDisciplina> {

  String? tooltipVariavel = "Adicionar discente";

  final TextEditingController _nomeControllerProfessor = TextEditingController();
  final TextEditingController _sexoControllerProfessor = TextEditingController();
  final TextEditingController _nascimentoControllerProfessor = TextEditingController();
  final TextEditingController _cpfControllerProfessor = TextEditingController();

  final TextEditingController _matriculaDisciplina = TextEditingController();
  final TextEditingController _matriculaDiscente = TextEditingController();

  List<Map<String, dynamic>> _allProfessorData = [];
  List<Map<String, dynamic>> _allDiscentesData = [];
  List<Map<String, dynamic>> _allDiscentesMatriculados = [];


  void _refreshData() async {
    final data = await ProfessorDB.getAllData();
    setState(() {
      _allProfessorData = data;
    });

    final alunoData = await SQLHelper.getAllData();
    setState(() {
      _allDiscentesData = alunoData;
    });

    final alunosMatriculados = await MatriculadosDB.getAllData();
    setState(() {
      _allDiscentesMatriculados = alunosMatriculados;
    });
  }

  @override
  void initState(){
    super.initState();
    _refreshData();
    //databaseFactory.deleteDatabase("database_usuario.db");
  }

  Future<void> _addData() async {
    await MatriculadosDB.createData(_matriculaDiscente.text, _matriculaDisciplina.text);
    print("Cheguei aqui");
    _refreshData();
  }


  @override
  Widget build(BuildContext context) {

    final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    String? existeMatricula = arguments['matricula_professor'];



    _nomeControllerProfessor.text = "";
    _sexoControllerProfessor.text = "";
    _nascimentoControllerProfessor.text = "";
    _cpfControllerProfessor.text = "";

    if(existeMatricula != null && existeMatricula.isNotEmpty){
      var existingData;
      print("A MATRICULA É $existeMatricula");
      var mat = int.parse(existeMatricula);
      if(_allProfessorData.isNotEmpty) {
         existingData = _allProfessorData
            .firstWhere((element) => element['id'] == mat, orElse: () => {});
      }
      if(existingData != null && existingData.isNotEmpty) {
        _nomeControllerProfessor.text = existingData['nome'];
        _sexoControllerProfessor.text = existingData['sexo'];
        _nascimentoControllerProfessor.text = existingData['nascimento'];
        _cpfControllerProfessor.text = existingData['cpf'];
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Dados da disciplina: ${arguments['nome']}"),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                children: [
                  Card(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(child: Text(
                            "Dados do Docente",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                          ),
                          Center(child: Text("Nome: ${_nomeControllerProfessor.text}")),
                          Center(child: Text("Sexo: ${_sexoControllerProfessor.text}")),
                          Center(child: Text("Nascimento: ${_nascimentoControllerProfessor.text}")),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ),
          ),
        ],

      ),
      floatingActionButton: FloatingActionButton(
        tooltip: tooltipVariavel,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Escolha um discente"),
                content: SizedBox(
                  width: double.maxFinite,
                    child: CupertinoScrollbar(
                      child: ListView.builder(
                          shrinkWrap: true,
                        itemCount: _allDiscentesData.length,
                        itemBuilder: (context, index){
                            return ListTile(
                              title: Text(
                                _allDiscentesData[index]['nome'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              onTap: () {
                                _matriculaDiscente.text = _allDiscentesData[index]['id'].toString();
                                _matriculaDisciplina.text = arguments['id'].toString();
                                _addData();
                              },
                            );
                        },
                      ),
                  ),
                ),
              )
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

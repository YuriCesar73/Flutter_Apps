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
  String? tooltipVariavelApagar = "Retirar discente da disciplina";

  final TextEditingController _nomeControllerProfessor = TextEditingController();
  final TextEditingController _sexoControllerProfessor = TextEditingController();
  final TextEditingController _nascimentoControllerProfessor = TextEditingController();
  final TextEditingController _cpfControllerProfessor = TextEditingController();



  final TextEditingController _matriculaDisciplina = TextEditingController();
  final TextEditingController _matriculaDiscente = TextEditingController();
  var _idDisciplina;
  var _idDiscente;

  List<Map<String, dynamic>> _allProfessorData = [];
  List<Map<String, dynamic>> _allDiscentesData = [];
  List<Map<String, dynamic>> _allDiscentesMatriculados = [];
  List<Map<String, dynamic>> _allDiscentesMatriculadosDisciplina = [];
  final TextEditingController nome_aluno = TextEditingController();


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
    //IniciaLista();
    //databaseFactory.deleteDatabase("database_usuario.db");
  }

  Future<void> _addData(int id) async {
    await MatriculadosDB.createData(_idDiscente, _idDisciplina, nome_aluno.text);
    print("Cheguei aqui");
    ScaffoldMessenger.of(context).
    showSnackBar(const SnackBar(
      backgroundColor: Colors.greenAccent,
      content: Text('Docente cadastrado na disciplina!'),
    ));
    _refreshData();
    _dadosDisciplinaById(id);
  }

  void _deleteData(int matricula_aluno, int matricula_disciplina, int index) async {
    await MatriculadosDB.deleteData(matricula_aluno, matricula_disciplina);
    ScaffoldMessenger.of(context).
    showSnackBar(const SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text('Discente retirado!'),
    ));
    _refreshData();
  }

  void _dadosDisciplinaById(int id) async{
    final data = await MatriculadosDB.getDataByDisciplina(id);
    setState(() {
      _allDiscentesMatriculadosDisciplina = data;
    });
  }



  @override
  Widget build(BuildContext context) {


    final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    String? existeMatricula = arguments['matricula_professor'];

    _dadosDisciplinaById(arguments['id']);
    _nomeControllerProfessor.text = "";
    _sexoControllerProfessor.text = "";
    _nascimentoControllerProfessor.text = "";
    _cpfControllerProfessor.text = "";

    if(existeMatricula != null && existeMatricula.isNotEmpty){
      var existingData;
      //print("A MATRICULA É $existeMatricula");
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
      body: Center(
        child: Column(

          children: [
            ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  title: Text('Docente: ${_nomeControllerProfessor.text}'),
                  subtitle: Text('Data de nascimento: ${_nascimentoControllerProfessor.text}\nSexo: ${_sexoControllerProfessor.text}'),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _allDiscentesMatriculadosDisciplina.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text("Nome: ${_allDiscentesMatriculadosDisciplina[index]['nome_aluno']}"),
                  subtitle: Text('Matricula: ${_allDiscentesMatriculadosDisciplina[index]['matricula_aluno'].toString()}'),
                    trailing: IconButton(
                      tooltip: tooltipVariavelApagar,
                      onPressed: () {
                        _deleteData(_allDiscentesMatriculadosDisciplina[index]['matricula_aluno'], _allDiscentesMatriculadosDisciplina[index]['matricula_disciplina'], index);
                      },
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                    )
                ),
              ),
            )
          ],
        ),
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
                                _idDiscente = _allDiscentesData[index]['id'];
                                _idDisciplina = arguments['id'];
                                nome_aluno.text = _allDiscentesData[index]['nome'];

                                //_listagemDiscentes.add(_allDiscentesData[index]['nome']);
                                _addData(arguments['id']);
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

import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {

  String location; // nome do lugar para a UI
  late String time; // o horário de um local
  String flag; //url para um icon de uma bandeira
  String url; //url do local para o endpoint da API
  late bool isDayTime; //true or false if daytime or not

  WorldTime( {required this.location, required this.flag, required this.url});


  Future<void> getTime() async {

    try {
      var httpURi;

      //Fazendo uma requisição
      httpURi = Uri.http('worldtimeapi.org', 'api/timezone/$url');
      Response response = await get(httpURi);
      Map data = jsonDecode(response.body);
      //print(data);

      print('DATA É: $data');
      //Pegando informações da variável data (ou seja, da requisição feita)
      String datetime = data['datetime'];
      print(data['utc_offset'][0]);
      String offset = data['utc_offset'].substring(1,3);
      int numero = int.parse(offset);
      if(data['utc_offset'][0] == '-'){

      }
      print('offset: $numero');
      //print(datetime);
      //print(offset);

      //Criando um objeto DateTime
      DateTime now = DateTime.parse(datetime);
      String signal = data['utc_offset'].substring(0,1);
      if(signal == '+') {
        now = now.add(Duration(hours: int.parse(offset)));
      }
      else {
        now = now.subtract(Duration(hours: int.parse(offset)));
      }
      //set the time properly
      isDayTime = now.hour > 6 && now.hour < 20 ? true : false;
      time = DateFormat.jm().format(now);


    }
    catch (e) {
      print('caught error: $e');
      time = 'could not get data';
    }

  }

}


import 'package:flutter/material.dart';
import 'package:world_time_app/services/world_time.dart';

class ChooseLocation extends StatefulWidget {
  @override
  State<ChooseLocation> createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {


  List<WorldTime> locations = [
    WorldTime(location:'London', flag:'uk.png', url: 'Europe/London'),
    WorldTime(location:'Lisbon', flag: 'portugal.png', url: 'Europe/Lisbon'),
    WorldTime(location:'Madrid', flag: 'spain.png', url: 'Europe/Madrid'),
    WorldTime(location:'Bahia', flag: 'brazil.png', url: 'America/Bahia'),
    WorldTime(location:'Havana', flag: 'cuba.png', url: 'America/Havana'),
    WorldTime(location:'Toronto', flag: 'canada.png', url: 'America/Toronto'),
    WorldTime(location:'Vostok', flag: 'russia.png', url: 'Antarctica/Vostok'),
    WorldTime(location:'Vancouver', flag: 'canada.png', url: 'America/Vancouver'),
  ];

  void updateTime(index) async {

    WorldTime instance = locations[index];
    await instance.getTime();
    print(instance.isDayTime);

    //navigate to home screen
    Navigator.pop(context, {
      'location': instance.location,
      'flag': instance.flag,
      'time': instance.time,
      'isDayTime': instance.isDayTime,
    });

  }

  @override
  Widget build(BuildContext context) {
    print('Build function ran');
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Choose a Location'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
          itemCount: locations.length,
        itemBuilder: (context, index){
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
              child: Card(
                child: ListTile(
                onTap: () {
                  updateTime(index);
                },
                title: Text(locations[index].location),
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/${locations[index].flag}'),
                  ),
                ),
              ),
            );
        },
      )
    );
  }
}

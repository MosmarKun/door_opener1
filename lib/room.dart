import 'package:door_opener/Utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'app.dart';
import 'databasehelper.dart';
import 'dart:async';

class Room extends StatefulWidget {
  final doorId;
  const Room({Key? key, required this.doorId}) : super(key: key);

  @override
  State<Room> createState() => _RoomState();
}
class _RoomState extends State<Room> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  int _doorID = 0;
  String _doorBluetooth_mac = "ffffffffffff";

  Future<String> getToken()async{
    return await Util.getToken(await Util.readString("username") , await Util.readString("password"));
  }

  @override
  void initState() {
      Util.readInt("doorId0").then((value) {
        _doorID = value;
      });
      Util.readString("doorBluetooth_mac0").then((value) {
        _doorBluetooth_mac = value;
        setState(() {

        });
      });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title:   Text(_doorBluetooth_mac),
      ),
      body: FutureBuilder<List>(
        future: databaseHelper.getData(),
        builder: (context,snapshot){
          return Column(
            children: const <Widget>[
              Text(""),
            ],
          );
        },
      ),
    );
  }
}

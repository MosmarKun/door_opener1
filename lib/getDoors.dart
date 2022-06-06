import 'dart:convert';
import 'package:door_opener/Utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'app.dart';
import 'databasehelper.dart';
import 'doors.dart';
import 'dart:async';

class GetDoors extends StatefulWidget {

  const GetDoors({Key? key}) : super(key: key);

  @override
  State<GetDoors> createState() => _GetDoorsState();
}
class _GetDoorsState extends State<GetDoors> {
  List <dynamic> _door = [];
  DatabaseHelper databaseHelper = DatabaseHelper();
  var token;

  Future<String> getToken()async{
    return await Util.getToken(await Util.readString("username") , await Util.readString("password"));
  }
  @override
  void initState() {
    Util.readString("token").then((value) {
      token = value;
      Util.fetchDoors(token,_door).then((door){
        setState(() {
          _door= door;
        });
      });
    });
    // TODO: implement initState

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title:  const Text('Doors'),
      ),
      body: FutureBuilder<List>(
        future: databaseHelper.getData(),
        builder: (context,snapshot){
          return ItemList(doors: _door,);
        },
      ),
    );
  }
}
class ItemList extends StatefulWidget{
  final doors;
  ItemList({Key? key, required this.doors}) : super(key: key);

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  List <dynamic> _door = [];
  var token;
  Future<String> getToken()async{
    return await Util.getToken(await Util.readString("username") , await Util.readString("password"));
  }
  @override
  void initState() {
    // TODO: implement initState
    getToken().then((value) {
      token = value;
      Util.fetchAllDoors(token).then((door){
        setState(() {
          if (door[0] == "aaa"){
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => App(token: token)));
          }
          _door = door;
        });
      });
    } );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return ListView.builder(
        itemCount: widget.doors.length,
        itemBuilder: (context,i){
          return  Container(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              child: Card(
                child: ListTile(
                  title: Text('ID: ${widget.doors[i].id}   (${widget.doors[i].description})',style: const TextStyle(fontSize: 20),),
                  leading: const Icon(Icons.sensor_door),
                ),
              ),
            ),
          );
        }
    );
  }
}

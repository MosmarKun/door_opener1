import 'dart:convert';
import 'package:door_opener/databasehelper.dart';
import 'package:door_opener/doors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'User.dart';
import 'dart:async';

import 'Utils.dart';
import 'app.dart';


class GetUsers extends StatefulWidget {

  const GetUsers({Key? key}) : super(key: key);

  @override
  State<GetUsers> createState() => _GetUsersState();
}
class _GetUsersState extends State<GetUsers> {
  List <dynamic> _user = [];
  List <dynamic> doors = [Door("", "", 0, false)];
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<List<dynamic>> fetchUsers()async{
    var userByTokenUrl = 'https://ibs.cronos.typedef.cf:4040/admin/users/?skip=0&limit=100';
    List<dynamic> users = [];
    try {
      var response = await get(Uri.parse(userByTokenUrl),headers: {'accept': 'application/json',});
      if (response.statusCode == 200) {
        users = json.decode(response.body)
            .map((data) => User.fromJson(data))
            .toList();
        return users;
      }
      else {
        var token = Util.getToken(Util.readString("username") as String, Util.readString("password") as String);
        print(token);
      }
    }
    on Exception{
     print("fetch all users exception");
    }
    return users;
  }
  @override
  void initState() {
    // TODO: implement initState
    fetchUsers().then((user){
      setState(() {
        _user= user;
      });
    });
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title:  const Text('Users'),
      ),
      body: FutureBuilder<List>(
        future: databaseHelper.getData(),
        builder: (context,snapshot){
          return ItemList(user: _user);
        },
      ),
    );
  }
}
class ItemList extends StatefulWidget{
   List<dynamic> user = [User("","",0,false,[{'description': '---', 'bluetooth_mac': 'ff:ff:ff:ff','id':'0'}])];
  ItemList({Key? key, required this.user}) : super(key: key);

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  List <dynamic> _door = [];
  DatabaseHelper databaseHelper = DatabaseHelper();
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
        itemCount: widget.user.length,
        itemBuilder: (context,i){
          var  userDoorsList = [];
          var list = [];
          if(widget.user[i].authorized_devices.isNotEmpty){userDoorsList = widget.user[i].authorized_devices;}
          else{ userDoorsList = [{"description": "No devises"}];}
          int x =0;
          while(x<userDoorsList.length){
            list.add(userDoorsList[x]['description']);
            x++;
          }
          return  Container(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              child: Card(
                child: ListTile(
                  title: Text('ID: ${widget.user[i].id}\n${widget.user[i].username}\n${widget.user[i].email} \nAuthorized to:\n${list}'),
                  leading: const Icon(Icons.sensor_door),
                ),
              ),
            ),
          );
        }
    );
  }
}
import 'dart:io';
import 'package:door_opener/databasehelper.dart';
import 'package:door_opener/getDoors.dart';
import 'package:door_opener/login.dart';
import 'package:door_opener/pair_iot_user.dart';
import 'package:door_opener/removeAuthrizatuin.dart';
import 'package:flutter/material.dart';
import 'package:door_opener/User.dart';
import 'package:door_opener/getUsers.dart';
import 'package:door_opener/welcome.dart';
import 'package:door_opener/profile.dart';
import 'dart:async';
import 'Utils.dart';
import 'app.dart';
import 'bluetoothMain.dart';
import 'doors.dart';
import 'led.dart';
import 'room.dart';


class AdminApp extends StatefulWidget {

  final list;
  final  index;
  final token;
  const AdminApp({Key? key,required this.token,this.list,this.index}) : super(key: key);

  @override
  State<AdminApp> createState() => _AdminAppState();
}
class _AdminAppState extends State<AdminApp> {
  bool tokenIsValid = false;
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<dynamic> doors = [];
  User user = User("username", "email", 0, false, []);
  String token = "";

  readNoInternet()async{
    int length = await Util.readInt('doorsLength');
    print("we are here");
    doors = List.filled(length, null);
    for(int i = 0; i !=length;i++){
      doors[i] = Door(
          await Util.readString('doorBluetooth_mac$i'),
          await Util.readString('doorDescription$i'),
          await Util.readInt('doorId$i'),
          await Util.readBool('doorOpen_request$i'));
    }

  }

  void initState() {
    String username;
    Util.readString("token").then((value){
      String newToken = value;
      Util.validToken(value).then((value){
        tokenIsValid = value;
        print("token is $tokenIsValid");
        Util.readString("username").then((value) {
          username = value;
          Util.fetchUser(newToken).then((value) {
            user = value;
            Util.saveString("email", user.email);
            Util.saveInt("id", user.id);
          });
          if (tokenIsValid == true) {
            Util.fetchDoors(newToken,doors).then((value) {
              Util.saveInt("doorsLength", doors.length);
              doors = value;
              print("door's length${doors.length}");
              if(doors.length == 0){
                print(doors);
                doors = [];
                print(doors);
              }
              else{
                for(int i = 0;i!=doors.length;i++){
                  print("doorBluetooth_mac$i");
                  Util.saveInt("doorsLength", doors.length);
                  Util.saveString("doorDescription$i",doors[i].description);
                  Util.saveString("doorBluetooth_mac$i",doors[i].bluetooth_mac);
                  Util.saveInt("doorId$i",doors[i].id);
                  Util.saveBool("doorOpen_request$i",doors[i].open_request);
                }
              }
            });
          }
          else {
            String username;
            String password;
            Util.readString("username").then((value) {
              username = value;
              Util.readString("password").then((value) {
                print("username adminApp$username");
                password = value;
                Util.getToken(username, password).then((value) {
                  print("password adminApp$password");
                  newToken = value;
                  Util.saveString("token", value);
                  Util.validToken(newToken).then((value) {
                    try {
                      Util.fetchDoors(newToken,doors).then((value) {
                        doors = value;
                        if (value.isNotEmpty) {
                          for (int i = 0; i != doors.length; i++) {
                            print("doorBluetooth_mac$i");
                            Util.saveInt("doorsLength", doors.length);
                            Util.saveString(
                                "doorDescription$i", doors[i].description);
                            Util.saveString("doorBluetooth_mac$i",
                                doors[i].bluetooth_mac);
                            Util.saveInt("doorId$i", doors[i].id);
                            Util.saveBool("doorOpen_request$i",
                                doors[i].open_request);
                          }
                        }
                        else {
                          for (int i = 0; i != doors.length; i++) {
                            print("doorBluetooth_mac$i");
                            Util.saveInt("doorsLength", 0);
                            Util.saveString("doorDescription$i", "");
                            Util.saveString("doorBluetooth_mac$i", "");
                            Util.saveInt("doorId$i", 0);
                            Util.saveBool("doorOpen_request$i", false);
                          }
                        }
                      });
                    }
                    on Error{
                      readNoInternet();
                    }
                  });
                });
              });
            });
          }
        });
      });
    } );

    readNoInternet();
    super.initState();
  }

  Future<void> onRefresh() async{
    await Future.delayed(const Duration(seconds: 1));
    Util.getToken(await Util.readString("username"), await Util.readString("password").then((value) {

      Util.fetchAllDoors(value).then((door){
        setState(() {
          if (door[0] == "aaa"){
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => App(token: value)));
          }
          else{
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AdminApp(token: value)));
          }
          }
        );
      });
      return token = value;
    }
    ));

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title:  Text('Door Opener'),
      ),
      drawer: Drawer1(token: widget.token,doors: doors,user: user,),

      body: RefreshIndicator(
      child:FutureBuilder<List>(
        future: databaseHelper.getData(),
        builder: (context,snapshot){
          return ItemList();
        },
      ),
    onRefresh: onRefresh,
    ),
    );
  }
}
class ItemList extends StatefulWidget{
  ItemList({Key? key}) : super(key: key);
  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
   List<dynamic> doors = [];
  String token = "";
  bool isOpened = false;
  bool tokenIsValid = false;
  var user;


  readNoInternet()async{
    int length = await Util.readInt('doorsLength');
    print("we are here");
    doors = List.filled(length, null);
    for(int i = 0; i !=length;i++){
      doors[i] = Door(
          await Util.readString('doorBluetooth_mac$i'),
          await Util.readString('doorDescription$i'),
          await Util.readInt('doorId$i'),
          await Util.readBool('doorOpen_request$i'));
    }

  }
  @override
  void initState() {
    readNoInternet();
    super.initState();
  }

  openDoor(int i)async{
    int x = 0;
    await Util.getToken("username", "password");
    Util.openDoor(
        await Util.readString("token"),
        await Util.readString('username'),
        await Util.readString("doorBluetooth_mac$i")).then((value) {
      x = value;
      if(x == 200) {
        isOpened = true;
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  Room(doorId: i)));
      }
      else{
        print("Should be in BluetoothApp");
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  BluetoothApp()));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
          body: ListView.builder(
              itemCount: doors.length,
              itemBuilder: (context,i){
                return  Container(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    child: Card(
                      child: ListTile(
                        tileColor: isOpened ? Color(0x10000000) : Colors.white,
                        title: isOpened ? Text('${doors[i].description}   Door is opened') : Text('${doors[i].description}  Click to open'),
                        leading: const Icon(Icons.sensor_door),
                        onTap: (){
                            openDoor(i);
                        },
                      ),
                    ),
                  ),
                );
              }
          ),

        );

  }
}

class Drawer1 extends StatefulWidget {
  final String token;
  final List<dynamic> doors;
  final User user;
  const Drawer1({Key? key, required this.token, required this.doors, required this.user}) : super(key: key);

  @override
  _Drawer1State createState() => _Drawer1State();
}
class _Drawer1State extends State<Drawer1> {
  User user = User("username", "email", 0, true, []);

  @override
  void initState() {

    // TODO: implement initState
    super.initState();
  }
  void deleteInfo() {
    Util.clearInfo();
  }
  @override
  Widget build(BuildContext context) {

    return Drawer(
      backgroundColor: Colors.grey[200],
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/PIC3.png'))),
          ),
          ListTile(
            leading: const Icon(Icons.verified_user),
            iconColor: Colors.blue,
            title: const Text('Profile'),
            onTap: () async {
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile(user: widget.user,token: widget.token,doors: widget.doors,)));
            });},
          ),
          ListTile(
            leading: const Icon(Icons.star),
            iconColor: Colors.black,
            title: const Text('About'),
            onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context)=>const Welcome()))},
          ),
          ListTile(
            leading: const Icon(Icons.remove_red_eye),
            iconColor: const Color(0xFF8D6E63),
            title: const Text('Show Users'),
            onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context)=>const GetUsers()))},
          ),
          ListTile(
            leading: const Icon(Icons.remove_red_eye),
            iconColor: const Color(0xFF8D6E63),
            title: const Text('Show Doors'),
            onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context)=>const GetDoors()))},
          ),
          ListTile(
            leading: const Icon(Icons.add),
            iconColor: Colors.green,
            title: const Text('Enable Door For User'),
            onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context)=>const PaitIotUser()))},
          ),
          ListTile(
            leading: const Icon(Icons.remove),
            iconColor: Colors.red,
            title: const Text('Disable Door From User'),
            onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context)=>const RemoveAuthrization()))},
          ),
          ListTile(
              leading: const Icon(Icons.exit_to_app),
              iconColor: Colors.red,
              title: const Text('Logout'),
              onTap: ()  {
                deleteInfo();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Login()));
              }
          ),
        ],
      ),
    );
  }
}
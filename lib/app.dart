import 'package:door_opener/databasehelper.dart';
import 'package:door_opener/login.dart';
import 'package:flutter/material.dart';
import 'package:door_opener/User.dart';
import 'package:door_opener/welcome.dart';
import 'package:door_opener/profile.dart';
import 'dart:async';
import 'Utils.dart';
import 'adminapp.dart';
import 'doors.dart';


class App extends StatefulWidget {

  final list;
  final  index;
  final token;
  const App({Key? key,required this.token,this.list,this.index}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}
class _AppState extends State<App> {
  bool tokenIsValid = false;
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<dynamic> doors = [];
  @override
  void initState() {
    // TODO: implement initState
    setState(() {

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title:  Text('Door Opener'),
      ),
      drawer: Drawer1(token: widget.token,doors: doors,),

      body: FutureBuilder<List>(
        future: databaseHelper.getData(),
        builder: (context,snapshot){
          return ItemList();
        },
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
                    catch(Error){
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
    isOpened = false;
    print(isOpened);
    Util.getToken(await Util.readString("username"), await Util.readString("password").then((value) async {
      return token = value;
    }));
    Util.fetchAllDoors(token).then((door){
      setState(() {
        if (door[0] == "aaa"){
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => App(token: token)));
        }
        else {
           Util.readString("username").then((value) {

            if(value == "Admin"){
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => AdminApp(token: token)));
            }
            else{
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => App(token: token)));
            }
          });
        }
      });
    });
    }

  openDoor(int i)async{
    Util.openDoor(
        await Util.readString("token"),
        await Util.readString('username'),
        await Util.readString("doorBluetooth_mac$i")).then((value) {
      if(value == 200) {
        isOpened = true;
      }
      else{
        isOpened = false;
      }
      final snackBar = SnackBar(content: Text("x"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RefreshIndicator(
        child: Scaffold(
          body: ListView.builder(
              itemCount: doors.length,
              itemBuilder: (context,i){
                print(doors);
                print(doors.length);
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

        ),
        onRefresh: onRefresh);
  }
}

class Drawer1 extends StatefulWidget {
  final String token;
  final List<dynamic> doors;
  const Drawer1({Key? key, required this.token, required this.doors}) : super(key: key);

  @override
  _Drawer1State createState() => _Drawer1State();
}
class _Drawer1State extends State<Drawer1> {
  User user = User("username", "email", 0, true, []);

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
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile(user: user,token: widget.token,doors: widget.doors,)));
              });},
          ),
          ListTile(
            leading: const Icon(Icons.star),
            iconColor: Colors.black,
            title: const Text('About'),
            onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context)=>const Welcome()))},
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
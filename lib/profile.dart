import 'dart:io';

import 'package:flutter/material.dart';
import 'package:door_opener/User.dart';

import 'Utils.dart';
import 'doors.dart';



class Profile extends StatefulWidget {
  const Profile({Key? key, required this.user,required this.doors,required this.token}) : super(key: key);
  final List doors;
  final User user;
   final String token;

  @override
  State<Profile> createState() => _ProfileState();
}
class _ProfileState extends State<Profile> {
  List<dynamic> doors = ["*******"];
  String username = "******";
  String email = "*******************";
  bool show = true;

  readNoInternet()async{
    int length = await Util.readInt('doorsLength');
    email = await Util.readString("email");
    username =  await Util.readString("username");
    print(username);
    print(email);
    doors = List.filled(length, null);
    for(int i = 0; i !=length;i++){
      doors[i] = await Util.readString('doorDescription$i');
    }

  }
  @override
  void initState() {
    setState(() {
      readNoInternet();
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var  userDoorsList = [];
    if(doors.isNotEmpty){userDoorsList = doors;}
    else{ userDoorsList = ["No Devices"];}

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed:() {setState(() {
          if(show){
            show = false;
            username = "******";
            email = "*******************";
            doors = ["*******"];
          }
          else{
            show = true;
            readNoInternet();
          }
        });},
        tooltip: 'Show data',
        child: const Icon(Icons.remove_red_eye),
        backgroundColor: Colors.grey,
      ),
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title:  const Text("Profile"),
        centerTitle: true,
        backgroundColor: Colors.grey[800],
        elevation: 0,
      ),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
          child: SingleChildScrollView(
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget> [
                const Center(
                  child: CircleAvatar(
                    backgroundImage: NetworkImage("https://img.favpng.com/6/14/19/computer-icons-user-profile-icon-design-png-favpng-vcvaCZNwnpxfkKNYzX3fYz7h2.jpg"),
                    backgroundColor: Colors.grey,
                    radius: 100,
                  ),
                ),
                const Divider(
                  height: 50,
                  color: Colors.black,
                  thickness: 2,
                ),
                 const Text(
                  'NAME: ',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize:18,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 10,),
                Text(
                  username,
                  style: TextStyle(
                      color: Colors.amberAccent[200],
                      letterSpacing: 2,
                      fontSize:28,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 30,),
                const Text(
                  'Available Doors Information: ',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize:18,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 10,),
                Text(
                  '$userDoorsList',
                  style: TextStyle(
                      color: Colors.amberAccent[200],
                      letterSpacing: 2,
                      fontSize:15,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 30,),
                const Text(
                  'Email',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize:18,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 10,),
                Row(
                  children: <Widget> [
                    Icon(
                      Icons.email_rounded,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(width: 10,),
                    Text(
                      email,
                      style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 18,
                          letterSpacing: 0.2
                      ),
                    ),
                    Text(
                      '',
                      style: TextStyle(
                          color: Colors.amberAccent[200],
                          letterSpacing: 2,
                          fontSize:24,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30,),

              ],
            ),)
      ),
    );
  }
}

import 'package:door_opener/databasehelper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'Utils.dart';
import 'adminapp.dart';
import 'doors.dart';
import 'forgetPassword.dart';
import 'register.dart';
import 'dart:convert';
import 'app.dart';
//https://www.google.com/url?sa=i&url=https%3A%2F%2Fsaudigazette.com.sa%2Farticle%2F595285%2FSAUDI-ARABIA%2FKAU-adopts-coronavirus-prevention-training-program-in-university-curricula&psig=AOvVaw3m7Q6J5gqIgOxjaU8ljbfj&ust=1646191820046000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCIDis8z8o_YCFQAAAAAdAAAAABAL
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Login(),
    );
  }
}
class Login extends StatefulWidget {
  const Login({Key? key,}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}
class _LoginState extends State<Login> {
  final password = TextEditingController();
  final username = TextEditingController();
  final userByTokenUrl = 'https://ibs.cronos.typedef.cf:4040/admin/users/?skip=0&limit=100';
  final tokenUrl = 'https://ibs.cronos.typedef.cf:4040/tkn';
  bool isVisable = true;
  final storage = const FlutterSecureStorage();
  String token = "";
  DatabaseHelper databaseHelper = DatabaseHelper();

  _save(String token,String username, String password ) async {
    Util.saveString('token', token);
    Util.saveString('username', username);
    Util.saveString('password', password);
  }
  doIt()async{

    setState(() {
      getToken().then((response)  {
        if (response.statusCode == 200) {
          _save(json.decode(response.body)["access_token"],username.text,password.text);
          List<dynamic> Rdoors = [Door("","",0,false)];

          if(username.text == 'Admin') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>  AdminApp(token: json.decode(response.body)["access_token"])),
            );
          } else {
            Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  App(token: json.decode(response.body)["access_token"])),
          );

          }
        }
        else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  content: Text(
                      "error(${response.statusCode}): ${jsonDecode(response.body)["detail"]}")
              );
            },
          );
        }
      }
      );
    }
    );
  }
  Future<Response> getToken() async {
    Response response = await post(
        Uri.parse(tokenUrl),
        headers: {'accept': 'application/json','Content-Type': 'application/x-www-form-urlencoded'},
        body: 'grant_type=&username=${username.text}&password=${password.text}&scope=&client_id=&client_secret='
    );
    return response;
  }

  @override
  void initState() {

    // TODO: implement initState
    String usernameSaved = "";
    String passwordSaved = "";
    super.initState();
        Util.readString("password").then((value){
          passwordSaved = value;
          Util.readString("username").then((value) {
            usernameSaved = value;
                if(usernameSaved == "Admin"){
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) =>  AdminApp(token: token)));
                }
                else{
                  if(usernameSaved.isEmpty){
                    print("hi");
                  }
                  else{
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => App(token: token)));
                  }
                }
            });
          });
  }
   @override
   Widget build(BuildContext context) {
     double width=MediaQuery.of(context).size.width;
      double height=MediaQuery.of(context).size.height;
      return Scaffold(
        body: SizedBox(
          height: height,
          width: width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: width,
                  height: height*0.45,
                  child: Image.asset('assets/PIC1.jpg',fit: BoxFit.fill,),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 30, 8, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:  const [
                      Text('  Login',style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
                const SizedBox(height: 30.0,),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 0,horizontal:15 ),
                  child: TextField(
                    controller: username,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]"))],
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0,),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 0,horizontal:15 ),
                  child:TextField(
                    controller: password,
                    obscureText: isVisable,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          isVisable ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            isVisable = !isVisable;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,20,0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const Forgetpassword()));
                        },
                        child: const Text.rich(
                          TextSpan(
                            text: '      Forget password? ',
                            style: TextStyle(
                                color: Color(0xffEE7B23)
                            ),
                          ),
                        ),
                      ),
                      // ignore: deprecated_member_use
                      RaisedButton(
                        child: const Text('Login'),
                        color: const Color(0xffEE7B23),
                        onPressed: () {
                          doIt();
                      }
                      ),
                    ],
                  ),
                ),
                const SizedBox(height:20.0),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const Register()));
                  },
                  child: const Text.rich(
                    TextSpan(
                        text: 'Don\'t have an account? ',
                        children: [
                          TextSpan(
                            text: 'Signup',
                            style: TextStyle(
                                color: Color(0xffEE7B23)
                            ),
                          ),]
                    ),
                  ),
                ),],
            ),
          ),
        ),
      );
}}

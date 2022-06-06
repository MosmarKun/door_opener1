import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);


  @override
  _RegisterState createState() => _RegisterState();
}
class _RegisterState extends State<Register> {
  var password = TextEditingController();
  var username = TextEditingController();
  var email = TextEditingController();
  bool _isObscure = true;
  final tryUser0Url = 'https://ibs.cronos.typedef.cf:4040/users/0';
  final regUrl = 'https://ibs.cronos.typedef.cf:4040/users/reg';
  Future<Response> registerUser() async {
    Response response = await post(
      Uri.parse(regUrl),
      headers: {'accept': 'application/json','Content-Type': 'application/json'},
      body: jsonEncode({'email': email.text,'username': username.text,'password': password.text})
    );
    var data = jsonDecode(response.body);
    print(data);
    print(response.statusCode);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: width,
                height: height * 0.30,
                child: Image.asset('assets/1597507.jpg', fit: BoxFit.fill,),
              ),
              const SizedBox(height: 10.0,),

              Padding(
                padding: const EdgeInsets.all(8.0),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(' Register', style: TextStyle(
                        fontSize: 25.0, fontWeight: FontWeight.bold),),
                  ],
                ),
              ),

              const SizedBox(height: 30.0,),
              Container(
                margin: const EdgeInsets.symmetric(
                    vertical: 0, horizontal: 15),
                child: TextField(
                  controller: username,
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

                margin: const EdgeInsets.symmetric(
                    vertical: 0, horizontal: 15),
                child: TextField(
                  controller: email,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    suffixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0,),
              Container(
                margin: const EdgeInsets.symmetric(
                    vertical: 0, horizontal: 15),
                child: TextField(
                  controller: password,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
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
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    // ignore: deprecated_member_use
                    RaisedButton(

                      child: const Text('Register'),
                      color: const Color(0xffEE7B23),
                      onPressed: () async{
                        setState(() {
                          //Username input validations
                          if (usernameValidateStructure(username.text)) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  content: Text(
                                      "Username most be more than 5 letter and numbers and less than 30"),
                                );
                              },
                            );
                          }
                          //password input validations
                          else
                          if (!passwordValidateStructure(password.text)) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  content: Text(
                                      "Password most contain at least 1 number, 1 lower case letter and 1 upper case letter,"),
                                );
                              },
                            );
                          }
                          //Email input validation
                          else if (!emailValidateStructure(email.text)) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  content: Text("email is not valid"),
                                );
                              },
                            );
                          }
                          else {
                            registerUser().then((response) {
                              if (response.statusCode == 200) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Text("your Username: " + username.text +
                                              "\nyour Email: " + email.text + "\nyour Password: " + password.text),);},);}
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
                            });
                          }
                        }
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Text.rich(
                  TextSpan(
                      text: 'Already have an account? ',
                      children: [
                        TextSpan(
                          text: 'Sign in',
                          style: TextStyle(
                              color: Color(0xffEE7B23)
                          ),
                        ),
                      ]
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

bool passwordValidateStructure(String value) {
  String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,25}$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(value);
}
bool emailValidateStructure(String value) {
  String pattern =
      r"^\S+@\S+\.\S+$";
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(value);
}
bool usernameValidateStructure(String value) {
  if (value.isEmpty || value.length > 30 || value.length < 5) {
    return true;
  }
  else {
    return false;
  }
}

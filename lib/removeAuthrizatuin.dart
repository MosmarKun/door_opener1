import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'Utils.dart';

class RemoveAuthrization extends StatefulWidget {
  const RemoveAuthrization({Key? key}) : super(key: key);
  @override
  _RemoveAuthrizationState createState() => _RemoveAuthrizationState();
}
class _RemoveAuthrizationState extends State<RemoveAuthrization> {
  var iotDevise = TextEditingController();
  var id = TextEditingController();
  final tryUser0Url = 'https://cronos.typedef.cf:4040/users/0';

  Future<Response> registerUser() async {
    const regUrl = 'https://ibs.cronos.typedef.cf:4040/admin/users/disallowdevice/id';
    Response response = await post(
        Uri.parse(regUrl),
        headers: {'accept': 'application/json','Content-Type': 'application/json'},
        body: jsonEncode({'user_id': id.text,'iot_entity_id': iotDevise.text,})
    );
    await Util.clearValue('doorDescription${iotDevise.text}');
    await Util.clearValue('doorBluetooth_mac${iotDevise.text}');
    await Util.clearValue('doorId${iotDevise.text}');
    await Util.clearValue('doorOpen_request${iotDevise.text}');


    return response;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
      ),
      body: SizedBox(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                child: Image.asset('assets/1597507.jpg', fit: BoxFit.fill,),
              ),
              const SizedBox(height: 10.0,),

              Padding(
                padding: const EdgeInsets.all(8.0),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(' Remove Authrization', style: TextStyle(
                        fontSize: 25.0, fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
              const SizedBox(height: 30.0,),
              Container(
                margin: const EdgeInsets.symmetric(
                    vertical: 0, horizontal: 15),
                child: TextField(
                  controller: id,
                  decoration: InputDecoration(
                    labelText: 'User ID',
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
                  controller: iotDevise,
                  decoration: InputDecoration(
                    labelText: 'iot Device',
                    suffixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0,),
              const SizedBox(height: 10.0,),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    // ignore: deprecated_member_use
                    RaisedButton(

                      child: const Text('Remove Authrization'),
                      color: const Color(0xffEE7B23),
                      onPressed: () async{
                        setState(() {
                          registerUser().then((response) {
                            if (response.statusCode == 200) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text(
                                        "The user with ID: " + id.text +
                                            "\nhas been unauthorized to\ndevice number: " + iotDevise.text),
                                  );
                                },
                              );
                            }
                            else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return  AlertDialog(
                                    content: Text(
                                        "Error (${response.statusCode}): ${jsonDecode(response.body)['detail']}"),
                                  );
                                },
                              );
                            }
                          });
                        }
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
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



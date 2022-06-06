import 'package:flutter/material.dart';



class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
            'About'
        ),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(10, 25, 10, 0),
        child: const Text(
          'This program is created to make doors open by users who are authorized. To open a door go back to the previous page'
          ,style: TextStyle(
            fontSize: 25,
            fontFamily:'Railway'
        ),
        ),
      ),
    );
  }
}
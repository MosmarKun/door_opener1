import 'package:door_opener/login.dart';
import 'package:door_opener/register.dart';
import 'package:door_opener/app.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'dart:io';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
 main(){
  HttpOverrides.global =MyHttpOverrides();
  runApp( MaterialApp(
    title: 'Door Opener',

    initialRoute: '/login',
    routes: <String, WidgetBuilder>{
      '/login': (BuildContext context) => Login(),


    },
  ));
}

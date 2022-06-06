import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'User.dart';
import 'app.dart';
import 'doors.dart';

class Util{
  static readNoInternet(List<dynamic> doors)async{
    int length = await Util.readInt('doorsLength');
    doors = List.filled(length, null);
    for(int i = 0; i !=length;i++){
      doors[i] = Door(
          await Util.readString('doorBluetooth_mac$i'),
          await Util.readString('doorDescription$i'),
          await Util.readInt('doorId$i'),
          await Util.readBool('doorOpen_request$i'));
    }

  }
  static Future<int> openDoor(String token, String username, String bluetooth_mac) async{
    var url = 'https://ibs.cronos.typedef.cf:4040/users/open';
    print("$bluetooth_mac, $token, $username");

    try {
      var response = await post(
          Uri.parse(url),
          headers: {'accept': 'application/json', 'Authorization': 'Bearer $token','Content-Type': 'application/json'},
          body: jsonEncode({'username': username,'bluetooth_mac': bluetooth_mac,'time_seconds' : 10 })

      );
      var userElements = jsonDecode(response.body);
      Door door = Door.fromJson(userElements);
      print(response.body);
      if (response.statusCode == 200) {
        return response.statusCode;
      }
      else {
        return response.statusCode;
      }
    }
    on Exception{
      print("openDoorException");
      return 500;
    }

  }
  static Future<User> fetchUser(String token)async{

      var userByTokenUrl = 'https://ibs.cronos.typedef.cf:4040/users/me';
      User user = User("", "", 0, false, [{}, {}]);
      try {
      var response = await get(Uri.parse(userByTokenUrl), headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token'
      });
      if (response.statusCode == 200) {
        var userElements = jsonDecode(response.body);
        user = User.fromJson(userElements);
      }
    }
    on Exception {
      print("fetchDoors Exception");
    }
      return user;
  }
  static Future<List<dynamic>> fetchAllDoors(String token)async{
    var doorByTokenUrl = 'https://ibs.cronos.typedef.cf:4040/admin/iotentities/?skip=0&limit=100';
    List<dynamic> doors = [];
    try {
      var response = await get(
          Uri.parse(doorByTokenUrl), headers: {'accept': 'application/json',});
      if (response.statusCode == 200) {
        doors = json.decode(response.body)
            .map((data) => Door.fromJson(data))
            .toList();
      }
      return  doors;
    }
      on Exception{
        print("fetchAllDoors Exception");
        doors=["aaa"];
        return doors;
      }
  }
  static Future<List<dynamic>> fetchDoors(String token,List<dynamic> doors)async{
    var acessList = 'https://ibs.cronos.typedef.cf:4040/users/acesslist/';
    List<dynamic> doors = [];
    try {
    var response = await get(Uri.parse(acessList),headers: {'accept': 'application/json', 'Authorization': 'Bearer $token'});
    if (response.statusCode ==200){
      doors = json.decode(response.body)
          .map((data) => Door.fromJson(data))
          .toList();
    }
    }
    on Exception{
      print("fetchDoors Exception");
      readNoInternet(doors);//read
    }
    return  doors;
  }
  static Future<bool> validToken(String token)async{
    var userByTokenUrl = 'https://ibs.cronos.typedef.cf:4040/users/me';
    try{
    var response = await get(Uri.parse(userByTokenUrl),headers: {'accept': 'application/json', 'Authorization': 'Bearer $token'});
    print("${response.statusCode} token true false");
    print("$token token token ");
    if (response.statusCode == 200){
      return true;
    }
    return false;
    }
    on Exception{
      print("validToken Exception");//read
      return false;
    }
  }
  static Future<String> getToken(String username, String password) async {
    String token = "";
    try {
      Response response = await post(
          Uri.parse('https://ibs.cronos.typedef.cf:4040/tkn'),
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/x-www-form-urlencoded'
          },
          body: 'grant_type=&username=$username&password=$password&scope=&client_id=&client_secret='
      );
      if (response.statusCode == 200) {
        token = json.decode(response.body)["access_token"];
      }
    }
    on Exception{
      print("fetchDoors Exception");//read
    }
    return token;
  }

  static Future<String> readString(String read) async {
     final prefs = await SharedPreferences.getInstance();
     var thing = prefs.getString(read);
     thing ??= "";
     if (read == 'token'){

     }
     return thing;
  }
  static Future<int> readInt(String read) async {
    final prefs = await SharedPreferences.getInstance();
    var thing = prefs.getInt(read);
    thing ??= 0;
    print(thing);
    return thing;
  }
  static Future<bool> readBool(String read) async {
    final prefs = await SharedPreferences.getInstance();
    var thing = prefs.getBool(read);
    thing ??= false;
    return thing;
  }

  static saveString(String key,String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
    print("The key: $key, $value saved");
  }

  static saveBool(String key,bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
    print("The key: $key, $value saved");
  }
  static saveInt(String key,int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
    print("The key: $key, $value saved");
  }
  static clearInfo()async{
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
  static clearValue(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
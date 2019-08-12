import 'package:flutter/material.dart';
import 'package:nativemoon/screens/Home/index.dart';
import 'package:nativemoon/screens/Login/index.dart';

class Routes {

  var routes = <String, WidgetBuilder>{
    "/Home": (BuildContext context) => new HomePage()
  };

  Routes() {
    runApp(new MaterialApp(
      title: "Flutter Flat App",
      home:  LoginPage(title: 'Login',),
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      routes: routes
    ));
  }
}
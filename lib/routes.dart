import 'package:flutter/material.dart';
import 'package:nativemoon/screens/login.dart';

class Routes {

  var routes = <String, WidgetBuilder>{
    
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
import 'package:flutter/material.dart';
import 'package:NativeMoon/screens/Home/index.dart';
import 'package:NativeMoon/screens/Login/index.dart';
import 'package:NativeMoon/screens/AppLoad/index.dart';


class Routes {

  var routes = <String, WidgetBuilder>{
    "/Login": (BuildContext context) => new LoginPage(),
    "/Home": (BuildContext context) => new HomePage()
  };

  Routes() {
    runApp(new MaterialApp(
      title: "NativeMoon",
      home:  AppLoad(),
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      routes: routes
    ));
  }
}
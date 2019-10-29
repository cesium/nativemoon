import 'package:flutter/material.dart';
import 'package:nativemoon/screens/Badge/index.dart';
import 'package:nativemoon/screens/Home/index.dart';
import 'package:nativemoon/screens/Login/index.dart';
import 'package:nativemoon/screens/AppLoad/index.dart';

class Routes {
  var routes = <String, WidgetBuilder>{
    "/Login": (BuildContext context) => new LoginPage(),
    "/Home": (BuildContext context) => new HomePage(),
    "/Badge": (BuildContext context) => new BadgePage(),
  };

  Routes() {
    runApp(new MaterialApp(
        title: "NativeMoon",
        home: AppLoad(),
        theme: ThemeData(primarySwatch: Colors.blue),
        routes: routes));
  }
}

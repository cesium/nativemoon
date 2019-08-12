import "package:flutter/material.dart";

class HomePage extends StatefulWidget {
const HomePage({ Key key }) : super(key: key);

@override
HomePageState createState() => new HomePageState();

}

class HomePageState extends State<HomePage>{
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(body:new Center(child: new Text("Home"),));
  }
}
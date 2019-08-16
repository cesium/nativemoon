import "package:flutter/material.dart";
import 'package:nativemoon/services/badges.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
const HomePage({ Key key }) : super(key: key);

@override
HomePageState createState() => new HomePageState();

}

class HomePageState extends State<HomePage>{

  Future<Badges> badges;

  Future<Badges> getBadges() async {
    SharedPreferences prefs =  await SharedPreferences.getInstance();
    return fetchBadges(prefs.getString('token'));
  }

  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    badges = getBadges();
    print(badges);
  }
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(body:new Center(child: new Text("Home"),));
  }
}
import "package:flutter/material.dart";
import 'package:nativemoon/components/cardGrid.dart';
import 'package:nativemoon/services/badge.dart';
import 'package:nativemoon/services/badges.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Badge> badges;
  List<Image> images;

  Future<List<Badge>> getBadges() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return fetchBadges(prefs.getString('token'));
  }

  @override
  void initState() {
    getBadges().then((fbadges) {
      this.badges = fbadges;
      this.images = new List(this.badges.length);
      for(int i = 0; i < this.badges.length; i++){
       this.images[i] = Image.network(this.badges[i].avatar, );
      }
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    final BadgeGrid badgeGrid = new BadgeGrid(this.badges, this.images);
    
    return MaterialApp(
        title: 'Badges',
        home: Scaffold(
          appBar: AppBar(
            title: Text('Badges'),
            backgroundColor: Colors.cyan[900],
          ),
          body: GridView.count(
            crossAxisCount: 2,
            padding: EdgeInsets.all(16.0),
            childAspectRatio: 8.0 / 9.0,
            children: badgeGrid.buildGrid(),
          ),
        )
        );
  }
}

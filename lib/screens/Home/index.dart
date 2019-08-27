import "package:flutter/material.dart";
import 'package:nativemoon/services/badge.dart';
import 'package:nativemoon/services/badges.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
const HomePage({ Key key }) : super(key: key);

@override
HomePageState createState() => new HomePageState();

}

class HomePageState extends State<HomePage>{

  List<Badge> badges;

  Future<List<Badge>> getBadges() async {
    SharedPreferences prefs =  await SharedPreferences.getInstance();
    return fetchBadges(prefs.getString('token'));
  }

  List<Card> _buildGridCards(int count) {
  List<Card> cards = List.generate(
    count,
    (int index) => Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 18.0 / 11.0,
            child: Image.network(this.badges[index].avatar ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(this.badges[index].name),
                SizedBox(height: 8.0),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  return cards;
}

  @override
  Widget build(BuildContext context) {

    getBadges().then((fbadges){
      this.badges = fbadges;
    });

    return MaterialApp(
      title: 'Badges',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Badges'),
        ),
        body: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(16.0),
          childAspectRatio: 8.0 / 9.0,
          children: _buildGridCards(this.badges.length),
        ),
      )
    );
  }
 
} 
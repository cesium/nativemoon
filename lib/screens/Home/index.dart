import "package:flutter/material.dart";
import 'package:nativemoon/components/badgeGrid.dart';
import 'package:nativemoon/services/badge.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/line_scale_party_indicator.dart';

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
    super.initState();

    getBadges().then((fbadges) {
      setState(() {
        this.badges = fbadges;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    List<Badge> rbadges = new List();

    if (this.badges == null){
      return MaterialApp(
          title: 'Badges',
          home: Scaffold(
            appBar: AppBar(
              title: new Text("Badges"),
              backgroundColor: Colors.cyan[900],
            ),
            body: Container(
              color: Colors.cyan[900],
              child: Center(
              child: Loading(indicator: LineScalePartyIndicator(), size: 100.0),
              ),
            ),
          ),
      );
      }

      else {
        for (int i = 0; i < this.badges.length; i++) {
          
          DateTime startDate = DateTime.parse(this.badges[i].begin.substring(0, 10) +
            ' ' +
            this.badges[i].begin.substring(11, 19));
          DateTime endDate = DateTime.parse(this.badges[i].end.substring(0, 10) +
            ' ' +
            this.badges[i].end.substring(11, 19)); 

          if (!(startDate.isAfter(DateTime.now()) ||  endDate.isBefore(DateTime.now()))) {
            rbadges.add(this.badges[i]);
          }
        }
 
        final BadgeGrid badgeGrid = new BadgeGrid(rbadges);

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
}

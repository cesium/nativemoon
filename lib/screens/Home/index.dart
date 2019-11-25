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
        this.images = new List(this.badges.length);
        for(int i = 0; i < this.badges.length; i++){
          this.images[i] = Image.network(this.badges[i].avatar, );
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {

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
              drawer: Drawer(
                  child: ListView(
                    children: <Widget>[
                      UserAccountsDrawerHeader(
                        accountName: Text("ENEI"),
                        accountEmail: Text("tecnologia@enei.pt"),
                        currentAccountPicture: CircleAvatar(
                          backgroundColor: Colors.cyan[900],
                          child: Text(
                            "ENEI",
                            style: TextStyle(fontSize: 25.0),
                          ),
                        ),
                      ),
                      new Container (
                        decoration: new BoxDecoration (
                            color: Colors.cyan[900]
                        ),
                        child: new ListTile(
                          title: Text("Badges", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      ListTile(
                        title: Text("Attendee"),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          Navigator.of(context).pop();
                        }
                      ),
                    ],
                  ),
                ),
              )
        );
      }
    }
}
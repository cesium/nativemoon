import "package:flutter/material.dart";
import 'package:nativemoon/services/badge.dart';
import 'package:nativemoon/services/badges.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qrcode_reader/qrcode_reader.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Badge> badges;

  Future<List<Badge>> getBadges() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return fetchBadges(prefs.getString('token'));
  }

  List<Card> _buildGridCards(int count) {
    List<Card> cards = List.generate(
      count,
      (int index) => Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: (){
            print(this.badges[index].description);
            Future<String> futureString = new QRCodeReader()
               .setAutoFocusIntervalInMs(200) // default 5000
               .setForceAutoFocus(true) // default false
               .setTorchEnabled(true) // default false
               .setHandlePermissions(true) // default true
               .setExecuteAfterPermissionGranted(true) // default true
               .scan();
          },
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 17.3 / 11.0,
              child: Image.network(badges[index].avatar, ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(this.badges[index].name),
                  SizedBox(height: 9.0),
              
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );

    return cards;
  }
  @override
  void initState() {
    getBadges().then((fbadges) {
      this.badges = fbadges;
    });
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
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
            children: _buildGridCards(this.badges.length),
          ),
        )
        );
  }
}

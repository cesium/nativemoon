import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/line_scale_party_indicator.dart';
import 'package:loading/loading.dart';
import '../../components/badgeGrid.dart';
import '../../services/badge.dart';

class AttendeeBadgesState extends StatelessWidget {
  final List<Badge> badges;

  const AttendeeBadgesState({Key key, this.badges}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (this.badges == null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Badges',
        home: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Text('Attendee Badges'),
            backgroundColor: Colors.cyan[900],
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            ),
          ),
          body: Container(
            color: Colors.cyan[900],
            child: Center(
              child: Loading(indicator: LineScalePartyIndicator(), size: 100.0),
            ),
          ),
        ),
      );
    } else {
      List<Badge> filteredBadges = new List();

      for (int i = 0; i < this.badges.length; i++) {
        if (this.badges[i].type == 0) {
        filteredBadges.add(this.badges[i]);
        }
      }

      return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Badges',
          home: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              title: Text('Attendee Badges'),
              backgroundColor: Colors.cyan[900],
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context, false),
              )
            ),
            body: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(16.0),
              childAspectRatio: 8.0 / 9.0,
              children: (new BadgeGrid(filteredBadges)).buildGrid(context, 0),
            ),
          ));
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/line_scale_party_indicator.dart';
import 'package:loading/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/badgeGrid.dart';
import '../../services/badge.dart';

class AttendeeBadgesState extends StatelessWidget {
  final List<Badge> badges;

  const AttendeeBadgesState({Key key, this.badges}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (this.badges == null) {
      return MaterialApp(
        title: 'Badges',
        home: Scaffold(
          appBar: AppBar(
            title: Text('Attendee Badges'),
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
    } else {
      List<Badge> filteredBadges = new List();

      for (int i = 0; i < this.badges.length; i++) {
        //if (this.badges[i].type) {
        filteredBadges.add(this.badges[i]);
        //}
      }

      return MaterialApp(
          title: 'Badges',
          home: Scaffold(
            appBar: AppBar(
              title: Text('Attendee Badges'),
              backgroundColor: Colors.cyan[900],
            ),
            body: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(16.0),
              childAspectRatio: 8.0 / 9.0,
              children: (new BadgeGrid(filteredBadges)).buildGrid(context),
            ),
          ));
    }
  }
}

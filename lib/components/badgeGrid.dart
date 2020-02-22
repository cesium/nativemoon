import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nativemoon/services/badge.dart';

class BadgeGrid {
  final List<Badge> badges;

  BadgeGrid(this.badges);

  List<Card> buildGrid(BuildContext context, int view) { // if 0 is read only to not allow redeem
    return List.generate(
      this.badges.length,
      (int index) => Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {view != 0 ?
            Navigator.pushNamed(context, "/Badge",
                arguments: this.badges[index]) : view = 0;
          },
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 17.3 / 11.0,
              child: Image.network(this.badges[index].avatar),
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
  }
}

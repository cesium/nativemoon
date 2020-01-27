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
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  List<Badge> filteredBadges = new List();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Badges');

  Future<List<Badge>> getBadges() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return fetchBadges(prefs.getString('token'));
  }

  HomePageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredBadges = badges;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    getBadges().then((fbadges) {
      setState(() {
        this.badges = fbadges;
        this.filteredBadges = this.badges;
      });
    });
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search), hintText: 'badge...'),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Badges');
        filteredBadges = badges;
        _filter.clear();
      }
    });
  }

  List<Card> _buildGrid() {
  if (_searchText.length != 0) {
    List<Badge> tempList = new List();
    for (int i = 0; i < filteredBadges.length; i++) {
      if (filteredBadges[i].name.toLowerCase().contains(_searchText.toLowerCase())) {
        tempList.add(filteredBadges[i]);
      }
    }
    filteredBadges = tempList;
  }
  return (new BadgeGrid(filteredBadges)).buildGrid();
}

  @override
  Widget build(BuildContext context) {
    
    if (this.badges == null) {
      return MaterialApp(
        title: 'Badges',
        home: Scaffold(
          appBar: AppBar(
            title: _appBarTitle,
            leading: new IconButton(
              icon: _searchIcon,
              onPressed: _searchPressed,
            ),
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
      filteredBadges= new List();

      for (int i = 0; i < this.badges.length; i++) {
        DateTime startDate = DateTime.parse(
            this.badges[i].begin.substring(0, 10) +
                ' ' +
                this.badges[i].begin.substring(11, 19));
        DateTime endDate = DateTime.parse(this.badges[i].end.substring(0, 10) +
            ' ' +
            this.badges[i].end.substring(11, 19));

        //if (!(startDate.isAfter(DateTime.now()) ||
           // endDate.isBefore(DateTime.now()))) {
        filteredBadges.add(this.badges[i]);
      }

      return MaterialApp(
          title: 'Badges',
          home: Scaffold(
            appBar: AppBar(
            title: _appBarTitle,
            leading: new IconButton(
              icon: _searchIcon,
              onPressed: _searchPressed,
            ),
            backgroundColor: Colors.cyan[900],
          ),
            body: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(16.0),
              childAspectRatio: 8.0 / 9.0,
              children: _buildGrid(),
            ),
          ));
    }
  }
}

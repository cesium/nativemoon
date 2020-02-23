import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:nativemoon/components/popUpAlert.dart';
import 'package:nativemoon/screens/Attendee/badges.dart';
import 'package:nativemoon/services/attendee.dart';
import 'package:nativemoon/services/badge.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendeePage extends StatefulWidget {
  @override
  _AttendeePageState createState() => _AttendeePageState();
}

class _AttendeePageState extends State<AttendeePage> {
  bool isLoading;
  bool isScanned;
  Attendee attendee;

  Future<Attendee> getAttendee(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return fetchAttendee(prefs.getString('token'), id);
  }

  Future<List<Badge>> getAttendeeBadges(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return fetchAttendeeBadges(prefs.getString('token'), id);
  }

  @override
  void initState() {
    super.initState();
    isLoading = false;
    isScanned = false;
  }

  Widget drawBody() {
    if (!isScanned) {
      if (!isLoading) {
        return Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.person_pin,
                  size: 350,
                  color: Colors.cyan[900],
                ),
                RaisedButton(
                  key: null,
                  onPressed: () => scanQRCode(),
                  color: Colors.orange[800],
                  child: Text("Scan QR Code",
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto")),
                ),
                RaisedButton(
                  key: null,
                  onPressed: () => scanQRCodeforBadges(),
                  color: Colors.orange[800],
                  child: Text("Scan to check Badges",
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto")
                          ),
                ),
              ]),
        );
      } else {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan[900]),
                ),
                height: 200.0,
                width: 200.0,
              ),
              Padding(
                padding: EdgeInsets.only(top: 120),
                child: Text("Loading attendee...",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w100,
                        fontFamily: "Roboto")),
              ),
            ],
          ),
        );
      }
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: new Image.network(
                // attendee.avatar
                attendee.avatar,
                width: 200.0,
                height: 200.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 25, right: 25),
              child: Text(
                // attendee.name
                attendee.name,
                style: TextStyle(
                    fontSize: 40.0,
                    color: const Color(0xFF000000),
                    fontWeight: FontWeight.w800,
                    fontFamily: "Roboto"),
                maxLines: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 0, bottom: 30),
              child: Text(
                attendee.email,
                style: TextStyle(
                    fontSize: 20.0,
                    color: const Color(0xFF000000),
                    fontWeight: FontWeight.w300,
                    fontFamily: "Roboto"),
              ),
            ),
            RaisedButton(
              key: null,
              onPressed: () => scanQRCode(),
              color: Colors.orange[800],
              child: Text("Scan QR Code Again",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Roboto")),
            ),
          ],
        ),
      );
    }
  }

  Widget build(BuildContext build) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text("Attendee"),
          backgroundColor: Colors.cyan[900],
        ),
        body: drawBody(),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text("ENEI"),
                accountEmail: Text("tecnologia@enei.pt"),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    "ENEI",
                    style: TextStyle(fontSize: 25.0, color: Colors.cyan[900]),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.cyan[900],
                ),
              ),
              ListTile(
                  title: Row(
                    children: <Widget>[
                      Icon(Icons.lock_open, color: Colors.cyan[900]),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text("Badges",
                            style: TextStyle(color: Colors.cyan[900])),
                      )
                    ],
                  ),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, "/Home");
                  }),
              Container(
                decoration: BoxDecoration(color: Colors.orange[800]),
                child: ListTile(
                  title: Row(
                    children: <Widget>[
                      Icon(Icons.person_outline, color: Colors.white),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Attendee",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void scanQRCode() async {
    String link = await FlutterBarcodeScanner.scanBarcode("#006064", "Cancel", true, ScanMode.QR);

    RegExp regExp = new RegExp(
      ".*https:\/\/enei.pt\/user\/(([A-Za-z0-9]+-*)+)",
      caseSensitive: false,
      multiLine: false,
    );

    if (regExp.hasMatch(link)) {
      List<String> vars = link.split("/");
      String userId = vars[vars.length - 1];

      // set the loading indicator
      setState(() {
        isScanned = false;
        isLoading = true;
      });

      // get attendee
      getAttendee(userId).then((attendee) {
        setState(() {
          this.attendee = attendee;
          this.isScanned = true;
          this.isLoading = false;
        });
      });
    } else {
      setState(() {
        isScanned = false;
        isLoading = false;
      });
      PopUpAlert.showAlert(context, "Error", "Invalid QR Code", "Try again");
    }
  }

  void scanQRCodeforBadges() async {
    String link = await FlutterBarcodeScanner.scanBarcode("#006064", "Cancel", true, ScanMode.QR);

    RegExp regExp = new RegExp(
      ".*https:\/\/enei.pt\/user\/(([A-Za-z0-9]+-*)+)",
      caseSensitive: false,
      multiLine: false,
    );

    if (regExp.hasMatch(link)) {
      List<String> vars = link.split("/");
      String userId = vars[vars.length - 1];

      // set the loading indicator
      setState(() {
        isScanned = false;
        isLoading = true;
      });

      // get attendee
      getAttendeeBadges(userId).then((badges) {
        setState(() {
          this.isScanned = false;
          this.isLoading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AttendeeBadgesState(badges: badges),
          ),
        );
      });
    } else {
      setState(() {
        isScanned = false;
        isLoading = false;
      });
      PopUpAlert.showAlert(context, "Error", "Invalid QR Code", "Try again");
    }
  }
}

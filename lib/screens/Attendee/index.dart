import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class AttendeePage extends StatefulWidget {
  @override
  _AttendeePageState createState() => _AttendeePageState();
}

class _AttendeePageState extends State<AttendeePage> {
  bool isLoading;
  bool isScanned;

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
                'https://dazedimg-dazedgroup.netdna-ssl.com/786/azure/dazed-prod/1120/0/1120288.jpg',
                width: 200.0,
                height: 200.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 25, right: 25),
              child: Text(
                // attendee.nick
                'Mr. Poopy',
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
                // attendee.email
                'waazuuuuuup@email.poop',
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
    return Scaffold(
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
    );
  }

  void scanQRCode() async {
    // for testing purposes

    setState(() {
      isScanned = false;
      isLoading = true;
    });

    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        isScanned = true;
        isLoading = false;
      });
    });
  }
}

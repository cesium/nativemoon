import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:nativemoon/services/badge.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class BadgePage extends StatefulWidget {
  @override
  _BadgePageState createState() => _BadgePageState();
}

class _BadgePageState extends State<BadgePage> {
  bool isLoading;
  String statusText;
  Color statusColor;

  @override
  void initState() {
    super.initState();
    isLoading = false;
    statusText = "";
    statusColor = Colors.black;
  }

  Widget build(BuildContext build) {
    final Badge badge = ModalRoute.of(build).settings.arguments;

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(badge.name),
          backgroundColor: Colors.cyan[900],
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(build, false),
          )),
      body: new Container(
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: new Image.network(
                  // for testing purposes while image not available: 'http://clipart-library.com/data_images/298652.png',
                  badge.avatar,
                  width: 200.0,
                  height: 200.0,
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(top: 15),
                child: new Text(badge.name,
                    style: new TextStyle(
                        fontSize: 25.0,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w800,
                        fontFamily: "Roboto")),
              ),
              new Padding(
                padding: EdgeInsets.only(top: 10, bottom: 20),
                child: new Text(badge.description,
                    style: new TextStyle(
                        fontSize: 16.0,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w100,
                        fontFamily: "Roboto")),
              ),
              new Padding(
                padding: EdgeInsets.only(top: 75),
                child: !isLoading
                    ? new Center(
                        child: new Column(children: <Widget>[
                          new RaisedButton(
                            key: null,
                            onPressed: () => scanQRCode(badge.name),
                            color: Colors.orange[200],
                            child: new Text("Scan QR Code",
                                style: new TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Roboto")),
                          ),
                          new Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: new Text(statusText,
                                style: new TextStyle(
                                    fontSize: 16.0,
                                    color: statusColor,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: "Roboto")),
                          ),
                        ]),
                      )
                    : new Center(
                        child: new Column(
                          children: <Widget>[
                            new CircularProgressIndicator(),
                            new Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: new Text("Redeeming badge...",
                                  style: new TextStyle(
                                      fontSize: 16.0,
                                      color: const Color(0xFF000000),
                                      fontWeight: FontWeight.w100,
                                      fontFamily: "Roboto")),
                            ),
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

  void scanQRCode(String badgeId) async {
    // Assuming the QR Code will return the User ID:
    String userId = await scanner.scan();

    // set the loading indicator
    setState(() {
      isLoading = true;
    });

    final response = await http.post(DotEnv().env['API_URL'] +
        '/api/v1/redeems?attendee_id=' +
        userId +
        '&badge_id=' +
        badgeId);

    String stText;
    Color stColor;

    if (response.statusCode == 200) {
      stText = "Badge redeemed with success!";
      stColor = Colors.green;
    } else {
      stText = "An error ocurred. Please try again.";
      stColor = Colors.red;
    }

    setState(() {
      isLoading = false;
      statusText = stText;
      statusColor = stColor;
    });
  }
}

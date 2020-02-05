import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:nativemoon/screens/Badge/errors.dart';
import 'package:nativemoon/services/badge.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
          title: Text("Redeem badge"),
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
                  badge.avatar,
                  width: 200.0,
                  height: 200.0,
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(top: 15, left: 25, right: 25),
                child: new AutoSizeText(
                  badge.name,
                  style: new TextStyle(
                      fontSize: 25.0,
                      color: const Color(0xFF000000),
                      fontWeight: FontWeight.w800,
                      fontFamily: "Roboto"),
                  maxLines: 1,
                ),
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
                            onPressed: () => scanQRCode(badge.id),
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

  dynamic sendRequest(String userId, int badgeId) async {
    // get auth token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token');

      // set request params
      var body = {
        "redeem": {"attendee_id": userId, "badge_id": badgeId.toString()}
      };
      String jsonBody = json.encode(body);
      print(jsonBody);
      final encoding = Encoding.getByName('utf-8');

      // send request
      return await http.post(
          DotEnv().env['API_URL'] + 'api/v1/redeems',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + token
          },
          body: jsonBody,
          encoding: encoding);
  }

  void scanQRCode(int badgeId) async {
    String link = await scanner.scan();

    RegExp regExp = new RegExp(
      ".*https:\/\/moonstone.seium.org\/user\/(([A-Za-z0-9]+-*)+)",
      caseSensitive: false,
      multiLine: false,
    );

    String stText;
    Color stColor;

    // check if link is valid
    if (regExp.hasMatch(link)) {
      List<String> vars = link.split("/");
      String userId = vars[vars.length - 1];
      // set the loading indicator
      setState(() {
        isLoading = true;
      });

      final response = await sendRequest(userId, badgeId);

      // change screen state regarding request result
      if (response.statusCode == 201) {
        stText = "Badge redeemed successfully.";
        stColor = Colors.green;
      } else {
        Errors errors = new Errors.fromJson(json.decode(response.body));
        Results res = errors.results;
        stText = res.detail != null ? res.detail : res.msgs[0];
        stColor = Colors.red;
      }
    } else {
      stText = "Invalid link.";
      stColor = Colors.red;
    }

    setState(() {
      isLoading = false;
      statusText = stText;
      statusColor = stColor;
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/line_scale_party_indicator.dart';

class AppLoad extends StatefulWidget {
  @override
  _AppLoadPageState createState() => _AppLoadPageState();
}

class _AppLoadPageState extends State<AppLoad> {
  Future<String> token;

  Future<String> _startPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
      return prefs.getString('token');
    });
  }

  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _startPage().then((token) {
        if (token != null) {
          Navigator.pushNamed(context, "/Home");
        } else
          Navigator.pushNamed(context, "/Login");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.cyan[900],
      body: Center(
          child: Loading(indicator: LineScalePartyIndicator(), size: 100.0)),
    );
  }
}

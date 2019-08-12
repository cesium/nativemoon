import 'package:flutter/material.dart';
import 'package:nativemoon/components/myTextField.dart';
import 'package:nativemoon/components/roundedButton.dart';
import 'package:nativemoon/services/authentication.dart';

class LoginPage extends StatefulWidget {

  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
    
      @override
      Widget build(BuildContext context) {

        final emailField = new MyTextField("Email", true, Colors.white, Colors.white, 32.0, false);

        final passwordField = new MyTextField( "Password", true, Colors.white, Colors.white, 32.0, true);

        _auth() async {
            Authentication auth = await fetchAuthToken(emailField.value.toString(), passwordField.value.toString());
       }

        final loginButon = new RoundedButton("Login", Colors.orange[200], 5.0, 0, 0, 30.0, _auth); 

        return Scaffold(
          body: Center(
            child: Container(
              color: Colors.cyan[900],
              child: 
              Padding(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 55.0,
                      child: Image.asset(
                        "assets/logo_enei.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    emailField,
                    SizedBox(height: 20.0),
                    passwordField,
                    SizedBox(
                      height: 15.0,
                    ),
                    loginButon,
                    SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    }
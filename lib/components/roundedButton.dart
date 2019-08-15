import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  
  final String buttonName;
  final Color buttonColor;
  final double elevation;
  final double width;
  final double heigth;
  final double border;
  final VoidCallback onPressed;

  RoundedButton(
    this.buttonName,
    this.buttonColor,
    this.elevation,
    this.width,
    this.heigth,
    this.border,
    this.onPressed
  );

  @override
  Widget build(BuildContext context){
    return Material(
          elevation: elevation,
          borderRadius: BorderRadius.circular(border),
          color: buttonColor,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: onPressed,
            child: Text(buttonName,
                textAlign: TextAlign.center,
          ),
        )
        );
  }

}
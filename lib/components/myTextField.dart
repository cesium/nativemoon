import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget{
  
  final String hintText;
  final bool filled;
  final Color filledColor;
  final Color textColor;
  final double border;
  final bool hideText;
  String value;

  MyTextField(
    this.hintText,
    this.filled,
    this.filledColor,
    this.textColor,
    this.border,
    this.hideText
  );

@override
  Widget build(BuildContext context){
    if(hideText){
        return TextField(
              onChanged: (text) {
                this.value = text;
              },
              obscureText: hideText,
              decoration: InputDecoration(
                  filled: filled,
                  fillColor: filledColor,
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintText: hintText,
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(border))),
            );
    } else {
        return TextField(
                onChanged: (text) {
                  this.value = text;
              },
                obscureText: hideText,
                decoration: InputDecoration(
                    filled: filled,
                    fillColor: filledColor,
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    hintText: hintText,
                    labelStyle: new TextStyle(color: textColor),
                    border:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(border))),
              );
    }
  }

}
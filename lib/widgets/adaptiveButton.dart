import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';



class AdaptiveFlatButton extends StatelessWidget {
  final String text;
  final Function handler;

  AdaptiveFlatButton(this.handler , this.text);

  @override
  Widget build(BuildContext context) {
    return 
    FlatButton(
             textColor: Theme.of(context).primaryColor,
             onPressed: handler, 
             child: Text(text, 
             style: TextStyle(
             fontWeight: FontWeight.bold ,
               ),
              ),
            );
  }
}
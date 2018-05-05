import 'package:flutter/material.dart';

final mainDrawer = new Drawer(
    child: new ListView(
  children: [
    new DrawerEntry("Players", "/players"),
    new DrawerEntry("Clubs", "/clubs"),
    new DrawerEntry("Turnaments", "/turnaments"),
    new DrawerEntry("Matches", "/matches"),
  ],
));

class DrawerEntry extends StatelessWidget {
  String text;
  String route;
  TextStyle style;

  DrawerEntry(String text, String route) {
    this.text = text;
    this.style = new TextStyle(fontSize: 18.0);
    this.route = route;
  }

  @override
  build(BuildContext context) {
    return new Container(
      padding: new EdgeInsets.all(10.0),
      child: new Text(
        this.text,
        style: this.style,
      ),
    );
  }
}

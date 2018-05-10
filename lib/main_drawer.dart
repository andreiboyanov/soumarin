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
  final String text;
  final String route;
  final TextStyle style = new TextStyle(fontSize: 18.0);

  DrawerEntry(this.text, this.route);

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

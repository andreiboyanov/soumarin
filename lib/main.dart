import 'package:flutter/material.dart';

import 'players_home.dart';
import 'wait_init.dart';
import 'db.dart';

void main() => runApp(new SousMarin());

class SousMarin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SousMarinState();
  }
}

class SousMarinState extends State<SousMarin> {
  SousMarinDb db = SousMarinDb.instance;
  String _title = "sousmarin";
  Widget _home = new WaitInit();

  @override
  void initState() {
    super.initState();
    db.ensureOpened().then((db) {
      setState(() {
        _home = new PlayersHome();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: _title,
      home: _home,
    );
  }
}

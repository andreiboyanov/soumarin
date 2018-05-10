import 'package:flutter/material.dart';

import 'main_drawer.dart';
import 'players_list.dart';
import 'endless_list.dart';

class PlayersHome extends StatefulWidget {

  @override
  createState() => new _PlayersHomeState();
}


class _PlayersHomeState extends State<PlayersHome>
    with SingleTickerProviderStateMixin {
  String filter = "";

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        drawer: mainDrawer,
        appBar: new AppBar(title: new TextField(
            autofocus: false,
            onSubmitted: _filterPlayers,
            decoration: new InputDecoration(
                icon: new Icon(Icons.search),
                hintText: "AFT Players",
            ))),
        body: new FilteredEndlessList(
            filter: filter, child: new PlayersList())
    );
  }


  @override dispose() {
    super.dispose();
  }

  _filterPlayers(newFilter) {
    setState(() {
      filter = newFilter;
    });
  }
}


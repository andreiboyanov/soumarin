import 'package:flutter/material.dart';

import 'main_drawer.dart';
import 'players_list.dart';

class PlayersHome extends StatefulWidget {

  @override
  createState() => new _PlayersHomeState();
}


class _PlayersHomeState extends State<PlayersHome>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  String filter = "";

  @override
  initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
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
        body: new FilteredPlayersList(
            filter: filter, child: new PlayersList())
    );
  }


  @override dispose() {
    super.dispose();
    _tabController.dispose();
  }

  _filterPlayers(newFilter) {
    setState(() {
      filter = newFilter;
    });
  }
}


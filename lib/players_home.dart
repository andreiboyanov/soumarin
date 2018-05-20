import 'package:flutter/material.dart';

import 'main_drawer.dart';
import 'player_filters.dart';

class PlayersHome extends StatefulWidget {
  final filterByFamilyName = new PlayerFilterByFamilyName();

  @override
  createState() => new _PlayersHomeState();
}

class _PlayersHomeState extends State<PlayersHome>
    with SingleTickerProviderStateMixin {
  String filter = "";
  PlayerFilter currentFilterBuilder;

  @override
  initState() {
    super.initState();
    currentFilterBuilder = widget.filterByFamilyName;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: mainDrawer,
      appBar: new AppBar(
        title: currentFilterBuilder.filterWidgetBuilder(
          context,
          onFilterChanged: _filterPlayers,
        ),
        actions: <Widget>[
          new PopupMenuButton(
            itemBuilder: (BuildContext context) =>
                <PopupMenuItem<PlayerFilter>>[
                  new PopupMenuItem(
                    child: new Text("By Family Name"),
                    value: widget.filterByFamilyName,
                  ),
                ],
            onSelected: (selected) =>
                setState(() => currentFilterBuilder = selected),
          )
        ],
      ),
      body:
          currentFilterBuilder.playersListBuilder(context, filter: filter),
    );
  }

  @override
  dispose() {
    super.dispose();
  }

  void _filterPlayers(Map<String, Object> newFilter) {
    setState(() {
      filter = newFilter["name"];
    });
  }
}

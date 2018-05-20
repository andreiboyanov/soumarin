import 'package:flutter/material.dart';

import 'main_drawer.dart';
import 'player_filters.dart';

import "types/player_filter.dart";

class PlayersHome extends StatefulWidget {
  final filterByFamilyName = new PlayerFilterByFamilyName();
  final filterFavorited = new PlayerFilterFavorite();

  @override
  createState() => new _PlayersHomeState();
}

class _PlayersHomeState extends State<PlayersHome>
    with SingleTickerProviderStateMixin {
  var filter = new PlayerFilter();
  PlayerFilterWidget currentFilterBuilder;

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
                <PopupMenuItem<PlayerFilterWidget>>[
                  new PopupMenuItem(
                    child: new Padding(
                      padding: new EdgeInsets.all(12.0),
                      child: new Text("By last name"),
                    ),
                    value: widget.filterByFamilyName,
                  ),
                  new PopupMenuItem(
                    child: new Padding(
                      padding: new EdgeInsets.all(12.0),
                      child: new Text("Favorite players"),
                    ),
                    value: widget.filterFavorited,
                  ),
                ],
            onSelected: (selected) =>
                setState(() => currentFilterBuilder = selected),
          )
        ],
      ),
      body: currentFilterBuilder.playersListBuilder(context, filter: filter),
    );
  }

  @override
  dispose() {
    super.dispose();
  }

  void _filterPlayers(PlayerFilter newFilter) {
    setState(() {
      filter = newFilter;
    });
  }
}

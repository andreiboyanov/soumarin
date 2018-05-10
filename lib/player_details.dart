import 'package:flutter/material.dart';

import 'main_drawer.dart';
import 'types/player.dart';


class PlayerDetails extends StatefulWidget {
  final Player player;

  PlayerDetails(this.player);

  @override
  createState() => new _PlayerDetailsState();
}


class _PlayerDetailsState extends State<PlayerDetails> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        drawer: mainDrawer,
        appBar: new AppBar(
            title: new Text(
                "${widget.player.firstName} ${widget.player.lastName}")),
        body: new Center(
          child: new Text("That's our player's details"),
        )
    );
  }
}


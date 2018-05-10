import 'package:flutter/material.dart';

import 'types/player.dart';
import 'services/players.dart';
import 'endless_list.dart';
import 'player_details.dart';
import 'image_tools.dart';

class PlayersList extends StatefulWidget {

  PlayersList();

  @override
  createState() => new _PlayersListState();

  static _PlayersListState of(BuildContext context) =>
      context.ancestorStateOfType(const TypeMatcher<_PlayersListState>());
}

class _PlayersListState extends State<PlayersList> {
  final playerService = new PlayersRegister();

  void onPlayerChanged(Player player) async {
    if (player.isFavorited) {
      await playerService.savePlayer(player);
      setState(() {});
    } else {
      await playerService.deletePlayer(player);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return new EndlessList(_buildPlayerItem, _findPlayers);
  }

  _findPlayers({filter, start, count}) =>
      playerService.findPlayers(
          filter: {"name": filter},
          start: start,
          max: count == null ? 20 : count);

  _buildPlayerItem(BuildContext context, Player player) =>
      new PlayerItemWidget(player);
}

class PlayerItemWidget extends StatefulWidget {
  final Player player;

  PlayerItemWidget(this.player);

  @override
  createState() {
    return new _PlayerItemWidgetState();
  }
}

class _PlayerItemWidgetState extends State<PlayerItemWidget> {
  @override
  build(BuildContext context) {
    return new Container(
        margin: const EdgeInsets.only(top: 8.0),
        child: ListTile(
            leading: new CircleAvatar(
                backgroundImage: getImageProvider(widget.player.photoUrl)),
            title: new Container(
                child: new Text(""
                    "${widget.player.firstName} "
                    "${widget.player.lastName} ",
                    style: new TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                    )),
                padding: const EdgeInsets.only(bottom: 8.0)),
            subtitle: new Container(
                child: new Text(""
                    "${widget.player.id} "
                    "${widget.player.singleRanking} "
                    "${widget.player.clubName} (${widget.player.clubId})")),
            trailing: new IconButton(
              onPressed: () =>
                  setState(() {
                    widget.player.toggleFavorited();
                    PlayersList.of(context).onPlayerChanged(widget.player);
                  }),
              icon: new Icon(widget.player.isFavorited
                  ? Icons.favorite
                  : Icons.favorite_border,
                  size: 16.0),
            ),
            onTap: () =>
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) => new PlayerDetails(widget.player))),
        ),
        decoration: new BoxDecoration(
            border: new Border(
                bottom: new BorderSide(
                    color: Colors.black12,
                    width: 0.5)))
    );
  }
}


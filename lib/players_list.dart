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

  @override
  Widget build(BuildContext context) {
    return new EndlessList(_buildPlayerItem, _findPlayers);
  }

  _findPlayers({filter, start, count}) {
    if (filter.isFavorited) {
      final players = playerService.getPlayers(
          start: start, max: count == null ? 20 : count);
      return players;
    } else {
      return playerService.findPlayers(
          filter: filter, start: start, max: count == null ? 20 : count);
    }
  }

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
  bool selected = false;

  @override
  build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: new GestureDetector(
        onTap: () => Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new PlayerDetails(widget.player),
              ),
            ),
        behavior: HitTestBehavior.opaque,
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new IconButton(
              icon: new CircleAvatar(
                backgroundImage: getImageProvider(widget.player.photoUrl),
              ),
              onPressed: () => setState(() => selected = !selected),
              alignment: Alignment.topLeft,
              iconSize: 48.0,
              padding: EdgeInsets.all(12.0),
            ),
            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: new Text(
                      ""
                          "${widget.player.firstName} "
                          "${widget.player.lastName} ",
                      style: new TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  new Text(
                    "${widget.player.id} "
                        "${widget.player.singleRanking} "
                        "${widget.player.clubName} (${widget.player.clubId})",
                  ),
                ],
              ),
            ),
            new IconButton(
              onPressed: () {
                PlayersList
                    .of(context)
                    .playerService
                    .toggleFavorited(widget.player)
                    .then((result) => setState(() {}));
              },
              icon: widget.player.isFavorited
                  ? new Icon(
                      Icons.favorite,
                      size: 16.0,
                      color: Colors.red,
                    )
                  : new Icon(
                      Icons.favorite_border,
                      size: 16.0,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

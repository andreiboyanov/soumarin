import 'dart:convert' show Base64Decoder;

import 'package:flutter/material.dart';
import 'package:validator/validator.dart';

import 'types/player.dart';
import 'services/players.dart';
import './endless_list.dart';

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
          filter: {"name": filter}, start: start, max: count);

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
    return (new ListTile(
      leading: _getImage(widget.player.photoUrl),
      title: new Text(""
          "${widget.player.firstName} "
          "${widget.player.lastName}"),
      subtitle: new Text(""
          "${widget.player.id} / "
          "${widget.player.singleRanking} / "
          "${widget.player.clubName} (${widget.player.clubId})"),
      trailing: new IconButton(
        onPressed: () =>
            setState(() {
              widget.player.toggleFavorited();
              PlayersList.of(context).onPlayerChanged(widget.player);
            }),
        icon: new Icon(
            widget.player.isFavorited ? Icons.favorite : Icons.favorite_border),
      ),
    ));
  }

  Image _getImage(String url) {
    Image image;
    if (isURL(url)) {
      image = new Image.network(url);
    } else if (url.startsWith("data:")) {
      const encodingMark = ";base64,";
      final encodingStart = url.indexOf(encodingMark);
      if (encodingStart > 0) {
        final data = url.substring(encodingStart + encodingMark.length);
        final decoder = new Base64Decoder();
        final imageData = decoder.convert(data);
        image = new Image.memory(imageData);
      }
    }
    return image;
  }
}


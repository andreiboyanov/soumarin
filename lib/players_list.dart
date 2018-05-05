import 'dart:async';
import 'dart:convert' show Base64Decoder;

import 'package:flutter/material.dart';
import 'package:validator/validator.dart';

import 'types/player.dart';
import 'services/players.dart';

class PlayersList extends StatefulWidget {
  static _PlayersListState of(BuildContext context) =>
      context.ancestorStateOfType(const TypeMatcher<_PlayersListState>());

  PlayersList();

  @override
  createState() => new _PlayersListState();
}

class _PlayersListState extends State<PlayersList> {
  final playerService = new PlayersRegister();
  List<Player> _players = new List<Player>();
  int _playersCount = 1;
  String currentFilter = "";

  void _onPlayerChanged(PlayerItemWidget playerTile) {
    if (playerTile.player.isFavorited) {
      setState(() => playerService.savePlayer(playerTile.player));
    } else {
      setState(() => playerService.deletePlayer(playerTile.player));
    }
  }

  @override
  Widget build(BuildContext context) {
    final filterWidget = FilteredPlayersList.of(context);
    if (currentFilter != filterWidget.filter) {
      clear();
    }
    currentFilter = filterWidget.filter;
    return new RefreshIndicator(
        child:
        new ListView.builder(
          key: new Key("aft players list"),
          primary: true,
          itemCount: _playersCount,
          itemBuilder: (BuildContext context, int index) =>
              _buildPlayerItem(index, currentFilter),
        ),
        onRefresh: _onRefresh);
  }

  clear() {
    _players.clear();
    _playersCount = 1;
  }

  Future<Null> _onRefresh() {
    setState(() {
      clear();
    });
    final completer = new Completer<Null>();
    completer.complete();
    return completer.future;
  }

  _buildPlayerItem(int index, filter) {
    if (index >= _players.length) {
      playerService.findPlayers(
          filter: {"name": filter}, start: _players.length)
          .then((newPlayers) {
        if (newPlayers.length > 0) {
          setState(() {
            _players.addAll(newPlayers);
            _playersCount = _players.length + 1;
          });
        } else {
          setState(() {
            _playersCount = _players.length;
          });
        }
      });
      return const Padding(
        padding: const EdgeInsets.all(20.0),
        child: const Center(
          child: const CircularProgressIndicator(),
        ),
      );
    } else {
      return new PlayerItemWidget(_players[index], _onPlayerChanged);
    }
  }
}

class PlayerItemWidget extends StatefulWidget {
  final Player player;
  final ValueChanged<PlayerItemWidget> onChangeCallback;

  PlayerItemWidget(this.player, this.onChangeCallback);

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
              widget.onChangeCallback(widget);
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

class FilteredPlayersList extends InheritedWidget {
  final String filter;

  const FilteredPlayersList({Key key, this.filter, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(FilteredPlayersList old) {
    return filter != old.filter;
  }

  static FilteredPlayersList of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(FilteredPlayersList);
  }
}

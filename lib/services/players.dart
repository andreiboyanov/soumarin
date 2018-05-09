import "dart:async";

import "../types/player.dart";
import "../db.dart";
import "./aft.dart";

class PlayersRegister {
  final _db = SousMarinDb.instance;
  var _currentFilter = new Map<String, Object>();

  Future findPlayers({Map<String, Object> filter, start = 0, max = 20}) async {
    if (filter != null) {
      _currentFilter = filter;
    }
    final players = new List<Player>();
    await for (Player player in aftSearchPlayers(
        start: start, count: max,
        name: _currentFilter.containsKey("name") ? filter["name"] : "")) {
      final dbPlayer = await _db.getPlayer(player.id);
      if (dbPlayer != null) {
        player.isFavorited = dbPlayer['isFavorited'];
      }
      players.add(player);
    }
    return players;
  }

  Future getPlayers({start = 0, max = 20}) async {
    return new List<Player>();
  }

  Future deletePlayer(Player player) async {
    _db.deletePlayer(player);
  }

  Future savePlayer(Player player) {
    return _db.savePlayer(player);
  }

}

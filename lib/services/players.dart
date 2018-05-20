import "dart:async";

import "../types/player.dart";
import "../types/player_filter.dart";
import "../types/match.dart";
import "../db.dart";
import "aft.dart";

class PlayersRegister {
  final _db = SousMarinDb.instance;
  var _currentFilter = new PlayerFilter();

  Future findPlayers({PlayerFilter filter, start = 0, max = 20}) async {
    if (filter != null) {
      _currentFilter = filter;
    }
    final players = new List<Player>();
    await for (Player player in aftSearchPlayers(
        start: start,
        count: max,
        name: _currentFilter.lastName)) {
      final dbPlayer = await _db.getPlayer(player.id);
      if (dbPlayer != null) {
        player.isFavorited = dbPlayer['isFavorited'];
      }
      players.add(player);
    }
    return players;
  }

  Future getPlayers({start = 0, max = 20}) async {
    final players = new List<Player>();
    await for (final dbPlayer in _db.getPlayers(start: start, limit: max)) {
      final player = new Player.fromMap(dbPlayer);
      players.add(player);
    }
    return players;
  }

  Future<Player> getPlayer(String playerId) async {
    return new Player(id: playerId, firstName: "Unknown", lastName: "Petrov");
  }

  Future getPlayerDetails(Player player, [forceUpdate = false]) async {
    final currentYear = new DateTime.now().year;
    final playerData = await aftGetPlayerDetails(player.id);
    player.affiliateFrom = playerData["first affiliation"];
    player.singleMatches[currentYear] = new List<TennisMatch>();
    for (final matchData in playerData["single matches"]) {
      final nameComponents = Player.parseName(matchData["opponent name"]);
      final opponent = new Player(
        id: matchData["opponent id"],
        firstName: nameComponents[0],
        lastName: nameComponents[1],
        singleRanking: matchData["opponent ranking"],
      );
      final match = new TennisMatch(
        matchData["date"],
        player,
        opponent,
        score: matchData["score"],
        result: matchData["result"],
        tournamentId: matchData["trounament id"],
        tournamentName: matchData["tournament name"],
        type: TennisMatchType.single,
        winner: matchData["won"] == true
            ? TennisMatchWinner.first
            : TennisMatchWinner.second,
      );
      player.singleMatches[currentYear].add(match);
    }
    return player;
  }

  Future deletePlayer(Player player) async {
    _db.deletePlayer(player);
  }

  Future savePlayer(Player player) {
    return _db.savePlayer(player);
  }

  Future toggleFavorited(Player player) {
    player.toggleFavorited();
    if (player.isFavorited)
      return savePlayer(player);
    else
      return deletePlayer(player);
  }
}

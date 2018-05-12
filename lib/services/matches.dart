import "dart:async";

import "../types/match.dart";
import "../db.dart";
import "aft.dart";

class MatchesRegister {
  final _db = SousMarinDb.instance;

  Future<List<TennisMatch>> findMatches(
    String playerId,
    int year, {
    TennisMatchType type = TennisMatchType.single,
    String partnerId,
    String opponentId,
    String clubId,
    String tournamentId,
  }) async {
    final matches = new List<TennisMatch>();
    final matchFinder = type == TennisMatchType.single
        ? aftGetSingleMatches
        : aftGetDoubleMatches;
    await for (TennisMatch match in matchFinder(playerId)) {
      matches.add(match);
    }
    return matches;
  }
}

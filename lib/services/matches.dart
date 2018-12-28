import "dart:async";

import "../types/match.dart";
//import "../db.dart";
//import "aft.dart";

class MatchesRegister {
//  final _db = SousMarinDb.instance;

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
    return matches;
  }
}

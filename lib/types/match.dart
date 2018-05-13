import "player.dart";

enum TennisMatchType { single, double }
enum TennisMatchWinner { first, second }

class TennisMatch {
  final Player player1;
  final Player player11;
  final Player player2;
  final Player player21;

  final DateTime date;
  final String tournamentId;
  final String tournamentName;

  final List<List<int>> score;
  final String result;
  final TennisMatchWinner winner;
  final TennisMatchType type;

  TennisMatch(
    this.date,
    this.player1,
    this.player2, {
    this.player11,
    this.player21,
    this.tournamentId = "",
    this.tournamentName = "",
    this.score,
    this.result,
    this.winner,
    this.type = TennisMatchType.single,
  });
}

enum TennisMatchType { single, double }
enum TennisMatchWinner { first, second }

class TennisMatch {
  final DateTime date;
  final String clubId;
  final List<List<int>> score;
  final TennisMatchWinner winner;

  TennisMatch(this.date, {this.clubId = "", this.score, this.winner});
}

class SingleMatch extends TennisMatch {
  final String player1Id;
  final String player2Id;

  SingleMatch(this.player1Id, this.player2Id, date,
      {clubId = "", List<List<int>> score, TennisMatchWinner winner})
      : super(date, clubId: clubId, score: score, winner: winner);
}

class DoubleMatch extends TennisMatch {
  final String team1Player1Id;
  final String team1Player2Id;
  final String team2Player1Id;
  final String team2Player2Id;

  DoubleMatch(this.team1Player1Id, this.team1Player2Id, this.team2Player1Id,
      this.team2Player2Id, date,
      {clubId = "", List<List<int>> score, TennisMatchWinner winner})
      : super(date, clubId: clubId, score: score);
}

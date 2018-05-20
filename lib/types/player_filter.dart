import 'player.dart';

class PlayerFilter extends Player {
  final singleRankingFrom;
  final singleRankingTo;
  final doublePointsFrom;
  final doublePointsTo;

  PlayerFilter({
    id = "",
    firstName = "",
    lastName = "",
    this.singleRankingFrom = "",
    this.singleRankingTo = "",
    this.doublePointsFrom = "",
    this.doublePointsTo = "",
    clubId = "",
    clubName = "",
  }) : super(
          id: id,
          firstName: firstName,
          lastName: lastName,
          clubId: clubId,
          clubName: clubName,
        );

  @override
  bool operator ==(other) {
    return (
        id == other.id &&
        firstName ==  other.firstName &&
        lastName == other.lastName &&
        clubId == other.clubId &&
        clubName == other.clubName &&
        singleRankingFrom == other.singleRankingFrom &&
        singleRankingTo == other.singleRankingTo &&
        doublePointsFrom == other.doublePointsFrom &&
        doublePointsTo == other.doublePointsTo
    );

  }
}

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
    isFavorited = false,
  }) : super(
          id: id,
          firstName: firstName,
          lastName: lastName,
          clubId: clubId,
          clubName: clubName,
        ) {
    this.isFavorited = isFavorited;
  }

  factory PlayerFilter.byId(String id) {
    return new PlayerFilter(id: id);
  }

  factory PlayerFilter.byLastName(String lastName) {
    return new PlayerFilter(lastName: lastName);
  }

  @override
  int get hashCode {
    return (
        id.hashCode +
        firstName.hashCode +
        lastName.hashCode +
        clubId.hashCode +
        clubName.hashCode +
        singleRankingFrom.hashCode +
        singleRankingTo.hashCode +
        doublePointsFrom.hashCode +
        doublePointsTo.hashCode +
        isFavorited.hashCode
    );
  }

  @override
  bool operator ==(other) {
    return (id == other.id &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        clubId == other.clubId &&
        clubName == other.clubName &&
        singleRankingFrom == other.singleRankingFrom &&
        singleRankingTo == other.singleRankingTo &&
        doublePointsFrom == other.doublePointsFrom &&
        doublePointsTo == other.doublePointsTo &&
        isFavorited == other.isFavorited);
  }
}

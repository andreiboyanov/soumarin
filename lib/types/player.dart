import 'match.dart';

class Player {
  String id = "";
  String firstName = "";
  String lastName = "";
  String singleRanking = "";
  String doublePoints = "";
  String clubId = "";
  String clubName = "";
  String photoUrl = "";
  String affiliateFrom = "";
  bool isFavorited = false;
  final singleMatches = Map<int, List<SingleMatch>>();
  final doubleMatches = Map<int, List<DoubleMatch>>();

  Player({
    this.id = "", this.firstName = "", this.lastName = "",
    this.singleRanking = "", this.doublePoints = "",
    this.clubId = "", this.clubName = "",
    this.photoUrl = "", this.affiliateFrom = ""
  });

  factory Player.fromMap(Map<String, Object> values) =>
      values != null ? new Player(
          id: values["id"],
          firstName: values["firstName"],
          lastName: values["lastName"],
          singleRanking: values["singleRanking"],
          doublePoints: values["doublePoints"],
          clubId: values["clubId"],
          clubName: values["clubName"]
      ) : null;

  void toggleFavorited() {
    isFavorited = !isFavorited;
  }

  Map<String, Object> toMap() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "singleRanking": singleRanking,
      "doublePoints": doublePoints,
      "clubId": clubId,
      "clubName": clubName,
      "photoUrl": photoUrl,
      "affiliateFrom": affiliateFrom,
      "isFavorited": isFavorited,
    };
  }
}

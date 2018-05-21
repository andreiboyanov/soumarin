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
  final singleMatches = Map<int, List<TennisMatch>>();
  final doubleMatches = Map<int, List<TennisMatch>>();
  final singleInterclubMatches = Map<int, List<TennisMatch>>();
  final doubleInterclubMatches = Map<int, List<TennisMatch>>();

  Player({
    this.id = "",
    this.firstName = "",
    this.lastName = "",
    this.singleRanking = "",
    this.doublePoints = "",
    this.clubId = "",
    this.clubName = "",
    this.photoUrl = "",
    this.affiliateFrom = "",
    this.isFavorited = false,
  });

  factory Player.fromMap(final values) => values != null
      ? new Player(
          id: values["id"],
          firstName: values["firstName"],
          lastName: values["lastName"],
          singleRanking: values["singleRanking"],
          doublePoints: values["doublePoints"],
          clubId: values["clubId"],
          clubName: values["clubName"],
          photoUrl: values["photoUrl"],
          affiliateFrom: values["affiliateFrom"],
          isFavorited:
              values["isFavorited"] == null ? false : values["isFavorited"],
        )
      : null;

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

  // Parse a single string name in the form "Boyanov de Radomir Andrei"
  // and return a list with [firstName, lastName] like this example:
  // ["Andrei", "Boyanov de Radomir"]
  static List<String> parseName(String name) {
    final nameComponents = name.split(" ");
    return [
      nameComponents.removeLast(),
      nameComponents.join(" "),
    ];
  }
}

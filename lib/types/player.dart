
class Player {
  String id;
  String firstName;
  String lastName;
  String singleRanking;
  String doublePoints;
  String clubId;
  String clubName;
  String photoUrl;
  bool isFavorited = false;

  Player({
    this.id, this.firstName, this.lastName,
    this.singleRanking, this.doublePoints,
    this.clubId, this.clubName,
    this.photoUrl
  });

  Player.fromMap(Map<String, Object> values) {
    this.id = values["id"];
    this.firstName = values["firstName"];
    this.lastName = values["lastName"];
    this.singleRanking = values["singleRanking"];
    this.doublePoints = values["doublePoints"];
    this.clubId = values["clubId"];
    this.clubName = values["clubName"];
  }

  void toggleFavorited(){
    isFavorited = !isFavorited;
  }

  Map<String, Object> toMap(){
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "singleRanking": singleRanking,
      "doublePoints": doublePoints,
      "clubId": clubId,
      "clubName": clubName,
      "isFavorited": isFavorited,
    };
  }
}

import "dart:async";
import 'package:http/http.dart' as http;

import "../types/player.dart";
import "../soup/soup.dart";

const PLAYER_INFO_LABELS = {
     "Né le:": "birth date",
     "Nationalité:": "nationality",
//     "Sexe:": "sex",
     "Classement simple:": "single ranking",
     "Valeur double:": "double points",
     "Première affiliation:": "first affiliation",
     "Actif depuis le:": "active from",
     "Club:": "club",
};


Future<Player> aftGetPlayerDetails(Player player) async {
  final url = "http://www.aftnet.be/MyAFT/Players/Detail/${player.id}";
  final response = await http.get(url);
  final soup = new Soup(response.body).body;
  final detailBody =
      soup.findAll("div", attributeClass: "detail-body player", limit: 1)[0];
  final info = detailBody.find(id: 'colInfo').findFirst('dl');
  String currentLabel;
  final playerData = new Map<String, String>();
  for (var infoElement in info.findAll(null)) {
    if (infoElement.tag == "dt") {
      currentLabel = infoElement.text;
    } else if (infoElement.tag == "dd") {
      if (PLAYER_INFO_LABELS.containsKey(currentLabel)) {
        playerData[PLAYER_INFO_LABELS[currentLabel]] = infoElement.text;
      }
    }
  }
  if (playerData.containsKey("first affiliation")) {
    player.affiliateFrom = playerData["first affiliation"];
  }
  return player;
}

Stream<Player> aftSearchPlayers(
    {start: 0,
    count: 10,
    name: "",
    region: 1,
    male: true,
    female: true,
    clubId: ""}) async* {
  final url = start == 0
      ? "http://www.aftnet.be/MyAFT/Players/SearchPlayers"
      : "http://www.aftnet.be/MyAFT/Players/LoadMoreResults";
  final response = await http.post(url, body: {
    "Regions": "1",
    "currentTotalRecords": start.toString(),
    "sortExpression": "",
    "AffiliationNumberFrom": "",
    "AffiliationNumberTo": "",
    "NameFrom": name,
    "NameTo": "",
    "BirthDateFrom": "",
    "BirthDateTo": "",
    "SingleRankingIdFrom": "1",
    "SingleRankingIdTo": "24",
    "Male": male.toString(),
    "Female": female.toString(),
    "ClubId": clubId
  });
  final soup = new Soup(response.body).body;
  final players = soup.findAll("dl");
  for (var player in players) {
    final fields = player.findAll("dd");
    if (fields.length > 3) {
      final idAndName = _parseIdAndName(fields[0].text);
      final firstAndLastName = idAndName[1].split(" ");
      var photo = player.findFirst("img").getAttribute("src");
      if (!photo.startsWith("data:")) {
        photo = "http://www.aftnet.be/$photo";
      }
      final newPlayer = new Player(
        id: idAndName[0],
        firstName: firstAndLastName.removeLast(),
        lastName: firstAndLastName.join(" "),
        singleRanking: fields[1].text,
        doublePoints: fields[2].text.substring("Valeur double: ".length),
        clubId:
            _getClubIdFromHref(fields[3].findFirst("a").getAttribute("href")),
        clubName: fields[3].text,
        photoUrl: photo,
      );
      yield newPlayer;
    }
  }
}

String _getClubIdFromHref(href) {
  const clubDetailsUrl = "/MyAft/Clubs/Detail/";
  final urlLength = clubDetailsUrl.length;
  return href.substring(urlLength, urlLength + 4);
}

List<String> _parseIdAndName(idAndName) {
  idAndName = idAndName.trimLeft().trimRight();
  final firstBracketIndex = idAndName.indexOf("(");
  final name = idAndName.substring(0, firstBracketIndex - 1);
  final id = idAndName.substring(firstBracketIndex + 1, idAndName.length - 1);
  return [id, name];
}

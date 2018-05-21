import "dart:async";
import 'package:http/http.dart' as http;

import "../types/player.dart";
import "../soup/soup.dart";
import "../soup/element.dart";

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

Future<Map<String, Object>> aftGetPlayerDetails(String playerId) async {
  final url = "http://www.aftnet.be/MyAFT/Players/Detail/$playerId";
  final response = await http.get(url);
  final soup = new Soup(response.body).body;
  final detailBody =
      soup.findAll("div", attributeClass: "detail-body player", limit: 1)[0];
  final info = detailBody.find(id: 'colInfo').findFirst('dl');
  String currentLabel;
  final playerData = new Map<String, dynamic>();
  for (var infoElement in info.findAll(null)) {
    if (infoElement.tag == "dt") {
      currentLabel = infoElement.text;
    } else if (infoElement.tag == "dd") {
      if (PLAYER_INFO_LABELS.containsKey(currentLabel)) {
        playerData[PLAYER_INFO_LABELS[currentLabel]] = infoElement.text;
      }
    }
  }
  // FIXME: remove the following commented lines
//  if (playerData.containsKey("first affiliation")) {
//    player.affiliateFrom = playerData["first affiliation"];
//  }
  final singleMatches =
      soup.find(id: "divPlayerDetailTournamentSingleResultData").findAll("dl");
  playerData["single matches"] = [];
  for (final matchElement in singleMatches) {
    final infoElements = matchElement.findAll("dd");
    playerData["single matches"].add(_parseSingleMatch(infoElements));
  }
  return playerData;
}

Map<String, Object> _parseSingleMatch(List<SoupElement> infoElements) {
  final matchData = new Map<String, Object>();

  // Get the tournament name and date form a string in the
  // form "FORÊT DE SOIGNES 28/12/2017"
  // In some cases the string may contain only the tournament name:
  // "FORÊT DE SOIGNES" (e.g. if the match was not played)
  final tournamentAndDate = infoElements[0].text.trim();
  final delimiter = tournamentAndDate.indexOf("/") - 2;
  if (delimiter > 0) {
    // TODO: parse also tournament id
    matchData["tournament name"] = tournamentAndDate.substring(0, delimiter);
    final dateComponents = tournamentAndDate.substring(delimiter).split('/');
    matchData["date"] = new DateTime(int.parse(dateComponents[2]),
        int.parse(dateComponents[1]), int.parse(dateComponents[0]));
  } else {
    matchData["tournament name"] = tournamentAndDate;
    matchData["date"] = null;
  }

  // The name of the category, like "Simples Jeunes Gens - 13 II (2005-2006)"
  matchData["category"] = infoElements[1].text.trim();

  // The following element contains information about the opponent:
  // name, ranking and a link to his details page. I take the ID of
  // the opponent from that link
  //  The format of the element text is like this:
  // "Contre\nMOERENHOUDT Nathan (NC)"
  final opponentNameAndRanking = infoElements[2].text.trim();
  final nameStartIndex = opponentNameAndRanking.indexOf("\n") + 1;
  final nameEndIndex = opponentNameAndRanking.lastIndexOf(" ");
  matchData["opponent name"] =
      opponentNameAndRanking.substring(nameStartIndex, nameEndIndex);
  matchData["opponent ranking"] = opponentNameAndRanking.substring(
      nameEndIndex + 2, opponentNameAndRanking.length - 1);
  final opponentDetailsUrl =
      infoElements[2].findFirst("a").getAttribute("data-url");
  matchData["opponent id"] =
      opponentDetailsUrl.substring(opponentDetailsUrl.lastIndexOf("/") + 1);

  // Score can be like "6/2-6/0" but also "WO Exc." for example if the match
  // was not played. In the latter case I just set 'score' to null.
  // In any case the string version is stored in the field 'result'
  final scoreText = infoElements[3].text.trim();
  final scoreBySets = scoreText.split("-");
  try {
    matchData["score"] = scoreBySets.map((String setScore) {
      final scoreByGames = setScore.split("/");
      final gamesAsIntegers =
          scoreByGames.map((String games) => int.parse(games)).toList();
      return gamesAsIntegers;
    }).toList();
  } on FormatException {
    matchData["score"] = null;
  }
  matchData["result"] = scoreText;

  // I get won/lost information from the image url. The icon shows the
  // situation from the point of view of the main player of course.
  matchData["won"] = infoElements[3]
      .findFirst("img")
      .getAttribute("src")
      .endsWith("victory.png");
  return matchData;
}

Stream<Player> aftSearchPlayers(
    {start: 0,
    count: 10,
    name: "",
    id: "",
    region: "1",
    male: true,
    female: true,
    clubId: ""}) async* {
  final url = start == 0
      ? "http://www.aftnet.be/MyAFT/Players/SearchPlayers"
      : "http://www.aftnet.be/MyAFT/Players/LoadMoreResults";
  final response = await http.post(url, body: {
    "Regions": region,
    "currentTotalRecords": start.toString(),
    "sortExpression": "",
    "AffiliationNumberFrom": id,
    "AffiliationNumberTo": id == "" ? "" : id + "9" * (7 - id.length),
    "NameFrom": name,
    "NameTo": name == "" ? "" : "${name}Z",
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
      final firstAndLastName = Player.parseName(idAndName[1]);
      var photo = player.findFirst("img").getAttribute("src");
      if (!photo.startsWith("data:")) {
        photo = "http://www.aftnet.be/$photo";
      }
      final newPlayer = new Player(
        id: idAndName[0],
        firstName: firstAndLastName[0],
        lastName: firstAndLastName[1],
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

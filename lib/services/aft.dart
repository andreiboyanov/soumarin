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
  final detailBody = soup.findAll("div",
      attributes: {"class": "detail-body player"}, limit: 1)[0];
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

  playerData["single matches"] = [];
  final singleMatches =
      soup.find(id: "divPlayerDetailTournamentSingleResultData").findAll("dl");
  for (final matchElement in singleMatches) {
    final infoElements = matchElement.findAll("dd");
    playerData["single matches"].add(_parseSingleMatch(infoElements));
  }

  playerData["single interclub matches"] = [];
  final interclubsDataUrl = soup
      .findAll("a", attributes: {'data-target': '#tabPlayerInterclubs'})[0]
      .getAttribute("data-url");
  final interclubResponse =
      await http.get("http://www.aftnet.be/$interclubsDataUrl");
  final interclubSoup = new Soup(interclubResponse.body).body;
  final singleMatchesInterclubs = interclubSoup
      .find(id: "collapse_player_interclubs_single_result")
      .findFirst("div")
      .findAll("dl");
  for (final matchElement in singleMatchesInterclubs) {
    final infoElements = matchElement.findAll("dd");
    playerData["single interclub matches"].add(_parseSingleMatch(infoElements));
  }

  playerData["double matches"] = [];
  final doubleMatchesDataUrl = soup
      .findAll("a",
          attributes: {'data-target': '#tabPlayerTournamentDouble'})[0]
      .getAttribute("data-url");
  final doubleMatchesResponse =
      await http.get("http://www.aftnet.be/$doubleMatchesDataUrl");
  final doubleMatchesSoup = new Soup(doubleMatchesResponse.body).body;
  final doubleMatches = doubleMatchesSoup
      .find(id: "divPlayerDetailTournamentDoubleResultData")
      .findAll("dl");
  for (final matchElement in doubleMatches) {
    final infoElements = matchElement.findAll("dd");
    playerData["double matches"].add(_parseDoubleMatch(infoElements));
  }

  playerData["double interclub matches"] = [];
  final doubleInterclubMatchesDataUrl = interclubSoup
      .findAll("a",
          attributes: {'data-target': '#tabPlayerInterclubsDouble'})[0]
      .getAttribute("data-url");
  final doubleInterclubMatchesResponse =
      await http.get("http://www.aftnet.be/$doubleInterclubMatchesDataUrl");
  final doubleInterclubMatchesSoup =
      new Soup(doubleInterclubMatchesResponse.body).body;
  final doubleInterclubMatches = doubleInterclubMatchesSoup
      .find(id: "collapse_player_interclubs_double_result")
      .findFirst("div")
      .findAll("dl");
  for (final matchElement in doubleInterclubMatches) {
    final infoElements = matchElement.findAll("dd");
    playerData["double interclub matches"].add(_parseDoubleMatch(infoElements));
  }

  return playerData;
}

List<dynamic> _parseTournamentAndDate(SoupElement infoElement) {
  // Get the tournament name and date form a string in the
  // form "FORÊT DE SOIGNES 28/12/2017"
  // In some cases the string may contain only the tournament name:
  // "FORÊT DE SOIGNES" (e.g. if the match was not played)
  // The name of the category, like "Simples Jeunes Gens - 13 II (2005-2006)"
  final tournamentAndDate = infoElement.text.trim();
  final delimiter = tournamentAndDate.indexOf("/") - 2;
  String tournament;
  DateTime date;
  if (delimiter > 0) {
    // TODO: parse also tournament id
    tournament = tournamentAndDate.substring(0, delimiter);
    final dateComponents = tournamentAndDate.substring(delimiter).split('/');
    date = new DateTime(int.parse(dateComponents[2]),
        int.parse(dateComponents[1]), int.parse(dateComponents[0]));
  } else {
    tournament = tournamentAndDate;
    date = null;
  }

  return [tournament, date];
}

List<String> _parsePlayerNameAndRanking(SoupElement infoElement) {
  // The following element contains information about the opponent:
  // name, ranking and a link to his details page. I take the ID of
  // the opponent from that link
  //  The format of the element text is like this:
  // "Contre\nMOERENHOUDT Nathan (NC)"
  final playerNameAndRanking = infoElement.text.trim();
  final nameEndIndex = playerNameAndRanking.indexOf(" (");
  final playerName = playerNameAndRanking.substring(0, nameEndIndex);
  final playerRanking = playerNameAndRanking.substring(
      nameEndIndex + 2, playerNameAndRanking.length - 1);
  final playerDetailsUrl = infoElement.getAttribute("data-url");
  final playerId =
      playerDetailsUrl.substring(playerDetailsUrl.lastIndexOf("/") + 1);

  return [playerName, playerRanking, playerId];
}

List<dynamic> _parseScore(SoupElement infoElement) {
  List<List<int>> score;
  String result;
  final scoreText = infoElement.text.trim();
  final scoreBySets = scoreText.split("-");
  try {
    score = scoreBySets.map((String setScore) {
      final scoreByGames = setScore.split("/");
      final gamesAsIntegers =
          scoreByGames.map((String games) => int.parse(games)).toList();
      return gamesAsIntegers;
    }).toList();
  } on FormatException {
    score = null;
  }
  result = scoreText;

  // I get won/lost information from the image url. The icon shows the
  // situation from the point of view of the main player of course.
  final won =
      infoElement.findFirst("img").getAttribute("src").endsWith("victory.png");

  return [score, result, won];
}

Map<String, Object> _parseDoubleMatch(List<SoupElement> infoElements) {
  final matchData = new Map<String, Object>();

  final tournamentAndDate = _parseTournamentAndDate(infoElements[0]);
  matchData["tournament name"] = tournamentAndDate[0];
  matchData["date"] = tournamentAndDate[1];

  matchData["category"] = infoElements[1].text.trim();

  final partnerInfo =
      _parsePlayerNameAndRanking(infoElements[2].findFirst("a"));
  matchData["partner name"] = partnerInfo[0];
  matchData["partner ranking"] = partnerInfo[1];
  matchData["partner id"] = partnerInfo[2];

  final opponentsInfoElements = infoElements[3].findAll("a");
  List<String> opponentInfo =
      _parsePlayerNameAndRanking(opponentsInfoElements[0]);
  matchData["opponent 1 name"] = opponentInfo[0];
  matchData["opponent 1 ranking"] = opponentInfo[1];
  matchData["opponent 1 id"] = opponentInfo[2];
  opponentInfo = _parsePlayerNameAndRanking(opponentsInfoElements[1]);
  matchData["opponent 2 name"] = opponentInfo[0];
  matchData["opponent 2 ranking"] = opponentInfo[1];
  matchData["opponent 2 id"] = opponentInfo[2];

  final scoreAndResult = _parseScore(infoElements[4]);
  matchData["score"] = scoreAndResult[0];
  matchData["result"] = scoreAndResult[1];

  matchData["won"] = scoreAndResult[2];
  return matchData;
}

Map<String, Object> _parseSingleMatch(List<SoupElement> infoElements) {
  final matchData = new Map<String, Object>();

  final tournamentAndDate = _parseTournamentAndDate(infoElements[0]);
  matchData["tournament name"] = tournamentAndDate[0];
  matchData["date"] = tournamentAndDate[1];

  // The name of the category, like "Simples Jeunes Gens - 13 II (2005-2006)"
  matchData["category"] = infoElements[1].text.trim();

  final opponentInfo =
      _parsePlayerNameAndRanking(infoElements[2].findFirst("a"));
  matchData["opponent name"] = opponentInfo[0];
  matchData["opponent ranking"] = opponentInfo[1];
  matchData["opponent id"] = opponentInfo[2];

  final scoreAndResult = _parseScore(infoElements[3]);
  matchData["score"] = scoreAndResult[0];
  matchData["result"] = scoreAndResult[1];
  matchData["won"] = scoreAndResult[2];

  return matchData;
}

Stream<Player> aftSearchPlayers(
    {start: 0,
    count: 10,
    name: "",
    id: "",
    region: "1,3,4,6",
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

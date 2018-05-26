import 'package:flutter/material.dart';

import "../types/match.dart";

class ExpansionPanelMatchList {
  final String title;
  final Icon headerIcon;
  List<TennisMatch> matches;
  bool isExpanded = false;

  ExpansionPanelMatchList(this.title, {this.matches, this.headerIcon});

  ExpansionPanel build(List<TennisMatch> matchList) {
    this.matches = matchList;
    return new ExpansionPanel(
      body: body,
      headerBuilder: headerBuilder,
      isExpanded: isExpanded,
    );
  }

  ExpansionPanelHeaderBuilder get headerBuilder {
    int matchesWon = 0;
    int matchesWonByWO = 0;
    int matchesLost = 0;
    int matchesLostByWO = 0;
    if (matches != null) {
      for (final match in matches) {
        if (match.winner == TennisMatchWinner.first) {
          matchesWon++;
          if (match.result.contains("WO")) {
            matchesWonByWO++;
          }
        } else {
          matchesLost++;
        }
      }
    }
    String woWonMessage = matchesWonByWO > 0 ? " ($matchesWonByWO by WO)" : "";
    String woLostMessage =
        matchesLostByWO > 0 ? " ($matchesLostByWO by WO)" : "";
    return (BuildContext context, bool isExpanded) => new Container(
          child: new Row(children: <Widget>[
            new Image.asset("images/single-player.png"),
            new Container(
              padding: EdgeInsets.only(left: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    title,
                    style: new TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 16.0,
                    ),
                  ),
//                  new Text(""
//                      "Played "
//                      "${matches == null ? '-' : matches.length} "
//                      "matches"),
                  new Text("Won $matchesWon$woWonMessage, "
                      "Lost ${matchesLost}${woLostMessage}"),
                ],
              ),
            ),
          ]),
        );
  }

  Widget get body => matches == null
      ? new Center(child: new CircularProgressIndicator())
      : new Row(
          children: <Widget>[
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: matches.map((TennisMatch match) {
                Widget result;
                if (match.type == TennisMatchType.single) {
                  result = new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        child: new Image.asset(
                          match.winner == TennisMatchWinner.first
                              ? "images/victory.png"
                              : "images/defeat.png",
                          width: 20.0,
                        ),
                        padding: new EdgeInsets.all(12.0),
                      ),
                      new Container(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                              "${match.tournamentName} "
                                  "${_formatDate(match.date)} ",
                              style: new TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                            new Text(
                              "${match.category}",
                              style: new TextStyle(),
                            ),
                            new Text(
                              "vs ${match.player2.firstName} "
                                  "${match.player2.lastName}"
                                  " (${match.player2.singleRanking})",
                              style: new TextStyle(),
                            ),
                            new Text("${match.result}"),
                          ],
                        ),
                        padding: new EdgeInsets.all(12.0),
                      ),
                    ],
                  );
                } else {
                  result = new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        child: new Image.asset(
                          match.winner == TennisMatchWinner.first
                              ? "images/victory.png"
                              : "images/defeat.png",
                          width: 20.0,
                        ),
                        padding: new EdgeInsets.all(12.0),
                      ),
                      new Container(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                              "${match.tournamentName} "
                                  "${_formatDate(match.date)} ",
                              style: new TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                            new Text(
                              "${match.category}",
                              style: new TextStyle(),
                            ),
                            new Text(
                              "with ${match.player11.firstName} "
                                  "${match.player11.lastName}"
                                  " (${match.player11.doublePoints})",
                              style: new TextStyle(),
                            ),
                            new Text(
                              "vs ${match.player2.firstName} "
                                  "${match.player2.lastName}"
                                  " (${match.player2.doublePoints})",
                              style: new TextStyle(),
                            ),
                            new Text(
                              "and ${match.player21.firstName} "
                                  "${match.player21.lastName}"
                                  " (${match.player21.doublePoints})",
                              style: new TextStyle(),
                            ),
                            new Text("${match.result}"),
                          ],
                        ),
                        padding: new EdgeInsets.all(12.0),
                      ),
                    ],
                  );
                }
                return result;
              }).toList(),
            ),
          ],
        );

  String _formatDate(DateTime date) {
    if (date == null) {
      return "";
    }
    return "${date.day}-${date.month}-${date.year}";
  }
}

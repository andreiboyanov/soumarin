import 'package:flutter/material.dart';

import "../types/match.dart";

class ExpansionPanelMatchList {
  List<TennisMatch> matches;
  bool isExpanded = false;

  ExpansionPanelMatchList([this.matches]);

  ExpansionPanel build() => new ExpansionPanel(
        body: body,
        headerBuilder: headerBuilder,
        isExpanded: isExpanded,
      );

  ExpansionPanelHeaderBuilder get headerBuilder {
    int matchesWon = 0;
    int matchesLost = 0;
    if (matches != null) {
      for (final match in matches) {
        if (match.winner == TennisMatchWinner.first)
          matchesWon++;
        else
          matchesLost++;
      }
    }
    return (BuildContext context, bool isExpanded) => new Container(
          child: new Row(children: <Widget>[
            new Image.asset("images/single-player.png"),
            new Container(
              padding: EdgeInsets.only(left: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(""
                      "Played "
                      "${matches == null ? '-' : matches.length} "
                      "matches"),
                  new Text("Won ${matchesWon}, lost ${matchesLost}"),
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
                  result = new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text("Double matches not supported yet."),
                      new Text("Sorry for the discrimination"),
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

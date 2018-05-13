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

  ExpansionPanelHeaderBuilder get headerBuilder =>
      (BuildContext context, bool isExpanded) => new Container(
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
                    new Text("Won 0, lost 10"),
                  ],
                ),
              ),
            ]),
          );

  Widget get body => matches == null
      ? new Center(child: new CircularProgressIndicator())
      : new Container(
          height: 100.0,
          child: new ListView(
            children: matches.map((TennisMatch match) {
              Widget result;
              if (match is SingleMatch) {
                final singleMatch = match as SingleMatch;
                result = new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(""
                        "vs ${singleMatch.player2Id}",
                      style: new TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    new Text("${singleMatch.result}"),
                  ],
                );
              } else {
                final doubleMatch = match as DoubleMatch;
                result = new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(""
                        "${doubleMatch.team1Player1Id} "
                        "vs ${doubleMatch.team2Player1Id}"),
                    new Text("${doubleMatch.result}"),
                  ],
                );
              }
              return result;
            }).toList(),
          ),
        );
}

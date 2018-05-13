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
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: matches.map((TennisMatch match) {
              Widget result;
              if (match.type == TennisMatchType.single) {
                result = new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      "vs ${match.player2.firstName} ${match.player2.lastName}",
                      style: new TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    new Text("${match.result}"),
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
        );
}

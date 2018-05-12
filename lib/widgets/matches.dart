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
            padding: EdgeInsets.all(24.0),
            child: new Text(""
                "List of "
                "${matches == null ? '-' : matches.length} "
                "matches"),
          );

  Widget get body => matches == null
      ? new Center(child: new CircularProgressIndicator())
      : new Container(
          height: 100.0,
          child: new ListView(
            children: matches
                .map((TennisMatch match) => new Text(""
                    "${(match as SingleMatch).player1Id} "
                    "vs ${(match as SingleMatch).player2Id}"))
                .toList(),
          ),
        );
}

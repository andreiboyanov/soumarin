import 'package:flutter/material.dart';

import 'main_drawer.dart';
import 'types/player.dart';
import 'types/match.dart';

import 'image_tools.dart';

import 'services/players.dart';
import 'services/matches.dart';
import 'widgets/matches.dart';

class PlayerDetails extends StatefulWidget {
  final Player player;
  final playersRegister = new PlayersRegister();
  final matchesRegister = new MatchesRegister();
  final singleMatches = new ExpansionPanelMatchList();
  final singleInterclubMatches = new ExpansionPanelMatchList();

  PlayerDetails(this.player);

  @override
  createState() => new _PlayerDetailsState();
}

class _PlayerDetailsState extends State<PlayerDetails> {
  @override
  initState() {
    super.initState();
    widget.playersRegister.getPlayerDetails(widget.player).then((updatePlayer) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final thisYear = new DateTime.now().year;
    final mainInfoPanel = new Container(
      padding: EdgeInsets.all(32.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          new Expanded(
            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new Text(
                    "${widget.player.id}",
                    style: _idStyle,
                  ),
                  new Container(
                    padding: const EdgeInsets.only(bottom: 2.0),
                    child: new Row(
                      children: <Widget>[
                        new Text(
                          'Since:',
                          style: _labelStyle,
                        ),
                        new Text(
                          widget.player.affiliateFrom,
                          style: _labelStyle,
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
          new Container(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Container(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      new Text(
                        'Single ranking:',
                        style: _labelStyle,
                      ),
                      new Text(
                        '${widget.player.singleRanking}',
                        style: _valueStyle,
                      ),
                    ],
                  ),
                ),
                new Container(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      new Text(
                        'Double points:',
                        style: _labelStyle,
                      ),
                      new Text(
                        '${widget.player.doublePoints}',
                        textAlign: TextAlign.right,
                        style: _valueStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );

    final singleMatchesList = new Container(
      child: new ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            widget.singleMatches.isExpanded = !isExpanded;
          });
        },
        children: <ExpansionPanel>[
          widget.singleMatches.build(widget.player.singleMatches[thisYear]),
        ],
      ),
    );
    final singleInterclubMatchesList = new Container(
      child: new ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            widget.singleInterclubMatches.isExpanded = !isExpanded;
          });
        },
        children: <ExpansionPanel>[
          widget.singleInterclubMatches
              .build(widget.player.singleInterclubMatches[thisYear]),
        ],
      ),
    );

    return new Scaffold(
      drawer: mainDrawer,
      appBar: new AppBar(
        title: new Text("${widget.player.firstName} ${widget.player.lastName}"),
        actions: <Widget>[
          new IconButton(
            onPressed: () {
              widget.playersRegister
                  .toggleFavorited(widget.player)
                  .then((result) => setState(() {}));
            },
            icon: new Icon(
              widget.player.isFavorited
                  ? Icons.favorite
                  : Icons.favorite_border,
            ),
          ),
        ],
      ),
      body: new ListView(
        children: <Widget>[
          new Image(
            image: getImageProvider(widget.player.photoUrl),
            fit: BoxFit.cover,
            gaplessPlayback: true,
          ),
          mainInfoPanel,
          singleMatchesList,
          singleInterclubMatchesList,
          new Container(
            padding: EdgeInsets.all(24.0),
            child: new Center(
              child: new Text(
                  "That's everything we know about ${widget.player.firstName}"),
            ),
          ),
        ],
      ),
    );
  }

  final _labelStyle = new TextStyle(
    color: Colors.grey[500],
  );
  final _valueStyle = new TextStyle(
    fontSize: 18.0,
    fontStyle: FontStyle.italic,
  );
  final _idStyle = new TextStyle(
    fontSize: 24.0,
    fontStyle: FontStyle.italic,
  );
}

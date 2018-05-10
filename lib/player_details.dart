import 'package:flutter/material.dart';

import 'main_drawer.dart';
import 'types/player.dart';
import 'image_tools.dart';


class PlayerDetails extends StatefulWidget {
  final Player player;

  PlayerDetails(this.player);

  @override
  createState() => new _PlayerDetailsState();
}


class _PlayerDetailsState extends State<PlayerDetails> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        drawer: mainDrawer,
        appBar: new AppBar(
            title: new Text(
                "${widget.player.firstName} ${widget.player.lastName}")),
        body: new ListView(
            children: <Widget>[
              new Image(
                image: getImageProvider(widget.player.photoUrl),
                fit: BoxFit.cover,
                gaplessPlayback: true,
              ),
              new Container(
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
                                        'Affiliated since:',
                                        style: _labelStyle,
                                      ),
                                      new Text(
                                        '20/08/2010',
                                        style: _labelStyle,
                                      ),
                                    ]
                                )
                            ),
                          ]
                      ),
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
                                    ]
                                ),
                              ),
                            ]
                        )
                    )
                  ],
                ),
              )
            ]
        )
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


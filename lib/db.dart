import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'types/player.dart';

class SousMarinDb {
  static final SousMarinDb instance = new SousMarinDb._internal();
  var _db;

  Future ensureOpened() async {
    if (_db == null) {
      await _openDatabase();
    }
    return instance;
  }

  Future put(name, value) async {
    final key = await _db.put(value, name);
    return key;
  }

  Future get(name) async {
    final result = await _db.get(name);
    return result;
  }

  Future savePlayer(Player player) async {
    Store playerStore = _db.getStore("players");
    var playerMap = player.toMap();
    var result = await _db.putRecord(
        new Record(playerStore, playerMap, player.id)
    );
    return result.key;
  }

  Stream getPlayers() async* {
    Store playerStore = _db.getStore("players");
    yield playerStore.records;
  }

  Future deletePlayer(Player player) async {
    Store playerStore = _db.getStore("players");
  }

  SousMarinDb._internal();

  _openDatabase() async {
    final dataDir = await getApplicationDocumentsDirectory();
    String dbPath = join(dataDir.path, "sousmarin.db");
//    String dbPath = join(dirname(Platform.script.toFilePath()), "sousmarin.db");
    DatabaseFactory dbFactory = ioDatabaseFactory;
    _db = await dbFactory.openDatabase(dbPath);
  }
}

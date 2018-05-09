import 'dart:async';
import 'dart:core';

import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'types/player.dart';

class SousMarinDb {
  static final SousMarinDb instance = new SousMarinDb._internal();
  Database _db;

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
    final playerMap = player.toMap();
    final record = new Record(playerStore, playerMap, player.id);
    final Record result = await _db.putRecord(record);
    return result;
  }

  Stream getPlayers() async* {
    Store playerStore = _db.getStore("players");
    yield playerStore.records;
  }

  Future getPlayer(id) async {
    Store playerStore = _db.getStore("players");
    final dbPlayer = await playerStore.get(id);
    return dbPlayer;
  }

  Future deletePlayer(Player player) async {
    Store playerStore = _db.getStore("players");
    final result = playerStore.delete(player.id);
    return result;
  }

  SousMarinDb._internal();

  _openDatabase() async {
    final dataDir = await getApplicationDocumentsDirectory();
    String dbPath = join(dataDir.path, "sousmarin.db");
    DatabaseFactory dbFactory = ioDatabaseFactory;
    _db = await dbFactory.openDatabase(dbPath);
  }
}

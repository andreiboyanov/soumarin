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
    StoreRef store = StoreRef.main();
    final key = await store.record(name).put(_db, value);
    return key;
  }

  Future get(name) async {
    StoreRef store = StoreRef.main();
    final result = await store.record(name).get(_db);
    return result;
  }

  Future savePlayer(Player player) async {
    StoreRef playerStore = intMapStoreFactory.store("players");
    final playerMap = player.toMap();
    await playerStore.record(player.id).put(_db, playerMap);
  }

  Stream getPlayers({start=0, limit=20}) async* {
    StoreRef playerStore = intMapStoreFactory.store("players");
    final finder = new Finder(limit: limit, offset: start);
    final players = await playerStore.find(_db, finder: finder);

    for (final dbPlayer in players)
      yield dbPlayer;
  }

  Future getPlayer(id) async {
    StoreRef playerStore = intMapStoreFactory.store("players");
    final dbPlayer = await playerStore.record(id).get(_db);
    return dbPlayer;
  }

  Future deletePlayer(Player player) async {
    StoreRef playerStore = intMapStoreFactory.store("players");
    final result = playerStore.record(player.id).delete(_db);
    return result;
  }

  SousMarinDb._internal();

  _openDatabase() async {
    final dataDir = await getApplicationDocumentsDirectory();
    String dbPath = join(dataDir.path, "sousmarin.db");
    DatabaseFactory dbFactory = databaseFactoryIo;
    _db = await dbFactory.openDatabase(dbPath);
  }
}

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:sembast/sembast_io.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'quote.dart';

class DbHelper {
  DatabaseFactory dbFactory = kIsWeb ? databaseFactoryWeb : databaseFactoryIo;
  Database? database;
  final store = intMapStoreFactory.store('quotes');
  static final DbHelper _instance = DbHelper._internal();
  DbHelper._internal();
  factory DbHelper() {
    return _instance;
  }

  Future<Database> get _database async {
    return (database ??= await _openDb());
  }

  Future<Database> _openDb() async {
    var path = '/assets/db';
    if (!kIsWeb) {
      final docsDir = await getApplicationDocumentsDirectory();
      path = docsDir.path;
    }
    final dbPath = join(path, 'quotes.db');
    final db = await dbFactory.openDatabase(dbPath);
    return db;
  }

  Future<int> insertQuote(Quote quote) async {
    try {
      Database db = await _database;
      final finder = Finder(filter: Filter.equals('q', quote.text));
      final snapshot = await store.find(db, finder: finder);
      if (snapshot.isNotEmpty) {
        return snapshot[0].key;
      }
      final id = await store.add(db, quote.toMap());
      return id;
    } on Exception catch (_) {
      return 0;
    }
  }

  Future<List<Quote>> getQuotes() async {
    Database db = await _database;
    final finder = Finder(sortOrders: [SortOrder('a')]);
    final snapshot = await store.find(db, finder: finder);
    final quotes = snapshot
        .map((item) => Quote.fromJSON(item.value, key: item.key))
        .toList();
    return quotes;
  }

  Future<int?> removeQuote(Quote quote) async {
    try {
      Database db = await _database;
      if (quote.id == null) {
        return null;
      }
      final removed = store.record(quote.id!).delete(db);
      return removed;
    } on Exception catch (_) {
      return null;
    }
  }
}

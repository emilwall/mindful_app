import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast_io.dart';
import 'quote.dart';

class DbHelper {
  DatabaseFactory dbFactory = databaseFactoryIo;
  Database? database;
  final store = intMapStoreFactory.store('quotes');

  Future<Database> _openDb() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final dbPath = join(docsDir.path, 'quotes.db');
    final db = await dbFactory.openDatabase(dbPath);
    return db;
  }

  Future<int> insertQuote(Quote quote) async {
    try {
      Database db = await _openDb();
      int id = await store.add(db, quote.toMap());
      return id;
    } on Exception catch (_) {
      return 0;
    }
  }

  Future<List<Quote>> getQuotes() async {
    Database db = await _openDb();
    final finder = Finder(sortOrders: [SortOrder('a')]);
    final snapshot = await store.find(db, finder: finder);
    final quotes = snapshot
        .map((item) => Quote.fromJSON(item.value, key: item.key))
        .toList();
    return quotes;
  }

  Future<int?> removeQuote(Quote quote) async {
    try {
      Database db = await _openDb();
      Finder finder = Finder(filter: Filter.equals('q', quote.text));
      int removed = await store.delete(db, finder: finder);
      return removed;
    } on Exception catch (_) {
      return null;
    }
  }
}

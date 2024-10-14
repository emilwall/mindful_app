import 'package:flutter/material.dart';
import '../data/quote.dart';
import '../data/db_helper.dart';

class QuotesListScreen extends StatelessWidget {
  const QuotesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved quotes'),
      ),
      body: FutureBuilder(
          future: getQuotes(),
          builder: (context, snapshot) {
            final List<Dismissible> tiles = [];
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError || snapshot.data == null) {
              return Center(
                child: Text('Error ${snapshot.error}'),
              );
            } else {
              for (Quote quote in snapshot.data!) {
                tiles.add(
                  Dismissible(
                    key: Key(quote.id.toString()),
                    onDismissed: (_) {
                      DbHelper dbHelper = DbHelper();
                      dbHelper.removeQuote(quote);
                    },
                    child: ListTile(
                      title: Text(quote.text),
                      subtitle: Text(quote.author),
                    ),
                  ),
                );
              }
              return ListView(
                children: tiles,
              );
            }
          }),
    );
  }

  Future<List<Quote>> getQuotes() async {
    DbHelper dbHelper = DbHelper();
    final quotes = await dbHelper.getQuotes();
    return quotes;
  }
}

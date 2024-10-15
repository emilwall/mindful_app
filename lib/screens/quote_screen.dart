import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mindful_app/data/db_helper.dart';
import 'package:mindful_app/data/quote.dart';
import 'package:mindful_app/screens/quotes_list_screen.dart';
import 'package:mindful_app/screens/settings_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  static const zenUrl = 'https://zenquotes.io';
  Quote quote = Quote(text: '', author: '');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mindful Quote'),
        actions: [
          IconButton(
            onPressed: _goTo('settings'),
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            onPressed: _goTo('list'),
            icon: const Icon(Icons.list),
          ),
          IconButton(
            onPressed: () {
              _fetchQuote().then((value) {
                setState(() {});
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
          future: _fetchQuote(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error; ${snapshot.error}'),
              );
            }
            quote = snapshot.data ?? Quote(text: '', author: '');
            return GestureDetector(
              onTap: () => _fetchQuote().then((_) {
                setState(() {});
              }),
              child: Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: deviceWidth * 0.2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        quote.text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Text(
                        quote.author,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          DbHelper dbHelper = DbHelper();
          dbHelper.insertQuote(quote).then((id) {
            if (context.mounted) {
              final message = (id == 0) ? 'Error' : 'Success';
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          });
        },
      ),
    );
  }

  Future _fetchQuote() async {
    final isLocalhost = Uri.base.authority.contains('localhost');
    final baseUrl = kIsWeb
        ? isLocalhost
            ? 'http://localhost:7071'
            : Uri.base
        : zenUrl;
    final Uri apiUrl = Uri.parse('$baseUrl/api/random');
    http.Response response;
    try {
      response = await http.get(apiUrl);
      if (response.statusCode == 200) {
        final List quoteJson = json.decode(response.body);
        Quote quote = Quote.fromJSON(quoteJson[0]);
        return quote;
      }
    } on Exception catch (e) {
      log('Error ${e.toString()}', error: e);
    }
    return Quote(text: 'Error retrieving quote', author: 'Too many requests');
  }

  VoidCallback _goTo(String page) => () =>
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => switch (page) {
                'settings' => const SettingsScreen(),
                'list' => const QuotesListScreen(),
                _ => const QuotesListScreen(),
              }
      ));
}

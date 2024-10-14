class Quote {
  final String text;
  final String author;
  int? id;

  Quote({
    required this.text,
    required this.author,
  });

  Quote.fromJSON(Map<String, dynamic> map, {int? key})
      : text = map['q'] ?? '',
        author = map['a'] ?? '',
        id = key;

  Map<String, String> toMap() => {
        'q': text,
        'a': author,
      };
}

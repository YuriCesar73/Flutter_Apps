import 'package:flutter/material.dart';
import 'quote.dart';
import 'quote_card.dart';

void main() => runApp(MaterialApp(
  home: QuoteList(),
));

class QuoteList extends StatefulWidget {
  @override
  State<QuoteList> createState() => _QuoteListState();
}

class _QuoteListState extends State<QuoteList> {

  List <Quote> quotes = [
    Quote(author: 'Mario Quintana', text: 'A saudade é o que faz as coisas pararem no tempo.'),
    Quote(author: 'Jostein Gaarder', text: 'Os que questionam são sempre os mais perigosos. Responder não é perigoso. Uma única pergunta pode ser mais explosiva do que mil respostas'),
    Quote(author: 'Carl Sagan', text: 'O universo não parece ser nem benevolente nem hostil, apenas indiferente.')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Awesome Quotes'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: quotes.map((quote) => QuoteCard(
          quote: quote,
          delete: () {
            setState(() {
              quotes.remove(quote);
            });
          }
        )).toList(),
      ),
    );
  }
}


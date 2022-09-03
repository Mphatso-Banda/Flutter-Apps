import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      home: const RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  //add a _saved Set for favorited names, sets don't have duplicates
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18);

  //Navigate to favorites
  void _pushSaved(){
    Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) {
            final tiles = _saved.map(
                  (pair) {
                return ListTile(
                  title: Text(
                    pair.asPascalCase,
                    style: _biggerFont,
                  ),
                );
              },
            );
            //the divideTiles() adds horizontal space between ListTiles
            //The divided variable holds the final rows converted to a list by
            // the convenience function, toList()
            final divided = tiles.isNotEmpty
                ? ListTile.divideTiles(
              context: context,
              tiles: tiles,
            ).toList()
                : <Widget>[];

            return Scaffold(
              appBar: AppBar(
                title: const Text('Saved Suggestions'),
              ),
              body: ListView(
                padding: const EdgeInsets.all(16.0),
                children: divided,
              ),
            );
          },

    ),
    );

  }

  //build methos need to return a widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [
        IconButton(
        icon: const Icon(Icons.list),
        onPressed: _pushSaved,
        tooltip: 'Saved Suggestions',
        ),
        ],
        ),
      body: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          //i is the row index
          itemBuilder: (context, i) {
            //for the first row which is zero it returns the ListTile
            //then the next roll returns a Divider Widget
            if (i.isOdd) return const Divider();

            //if i = 18 then there are 9 Divider Widgets and 9 ListTiles
            //divide by 2 then index equals _suggestions length which fit in ListTiles
            final index = i ~/ 2;
            if (index >= _suggestions.length) {
              _suggestions.addAll(generateWordPairs().take(10));
            }
            //add alreadySaved check to ensure wordpair has not already been favorited
            final alreadySaved = _saved.contains(_suggestions[index]);
            return ListTile(
              title: Text(
                _suggestions[index].asPascalCase,
                style: _biggerFont,
              ),
              //  In the ListTile construction you'll add heart-shaped icons to the
              //  ListTile objects to enable favoriting
              trailing: Icon(
                alreadySaved ? Icons.favorite : Icons.favorite_border,
                color: alreadySaved ? Colors.red : null,
                semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
              ),
              //add interactivity to the heart icon
              onTap: () {
                setState(() {
                  if (alreadySaved) {
                    _saved.remove(_suggestions[index]);
                  } else {
                    _saved.add(_suggestions[index]);
                  }
                });
              },
            );
          },
        ),
    );
  }
}

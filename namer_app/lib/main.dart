import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme:
              ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 48, 2, 218)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var liked = [];
  void toggleLiked() {
    if (liked.contains(current)) {
      liked.remove(current);
    } else {
      liked.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritePage();
        break;
      default:
        throw UnimplementedError('No Widget for ${selectedIndex}');
    }
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
              child: NavigationRail(
            extended: true,
            destinations: [
              NavigationRailDestination(
                  icon: Icon(Icons.home), label: Text('Home')),
              NavigationRailDestination(
                  icon: Icon(Icons.favorite), label: Text('Liked')),
            ],
            selectedIndex: selectedIndex,
            onDestinationSelected: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
          )),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ),
          ),
        ],
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BigCard(pair: pair),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    appState.toggleLiked();
                  },
                  child: Row(
                    children: [
                      Icon(
                        (!appState.liked.contains(pair))
                            ? Icons.favorite_border_outlined
                            : Icons.favorite,
                        size: 18,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Like'),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      appState.getNext();
                    },
                    child: Text('Click me!')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = TextStyle(color: Colors.white, fontSize: 70);

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: pair.asSnakeCase,
        ),
      ),
    );
  }
}

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.liked.isEmpty) {
      return Center(
        child: Text(
          'Not saved yet!',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      );
    }
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.all(30),
          child: Text(
            'You have saved ${appState.liked.length} number of Items',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
          ),
        ),
        for (var it in appState.liked)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('$it'),
          ),
      ],
    );
  }
}

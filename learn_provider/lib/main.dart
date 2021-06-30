import 'package:flutter/material.dart';
import 'package:learn_provider/pages/home_screen.dart';
import 'package:learn_provider/pages/second_screen.dart';
import 'package:learn_provider/providers/counter_provider.dart';
import 'package:learn_provider/providers/item_provider.dart';
import 'package:provider/provider.dart';

void main() {
  // runApp(MyApp());
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<CounterModel>(create: (_) => CounterModel()),
      ChangeNotifierProvider<ItemListModel>(create: (_) => ItemListModel()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Provider Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        // '/': (context) => ChangeNotifierProvider<CounterModel>(create: (_) => CounterModel(), child: HomePage()),
        '/': (context) => HomePage(),
        '/secondPage': (context) => SecondPage(),
        // '/secondPage': (context) => ChangeNotifierProvider<ItemListModel>(create: (_) => ItemListModel(), child: SecondPage()),
      },
    );
  }
}


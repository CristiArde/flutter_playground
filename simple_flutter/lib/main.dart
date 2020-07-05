import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text("I Am ritch"),
        backgroundColor: Colors.lightGreenAccent,
      ),
      backgroundColor: Colors.amberAccent,
      body: Center(
        child: Image(image: NetworkImage("https://raw.githubusercontent.com/go-flutter-desktop/go-flutter/master/mascot.png"),
        ),
      ),
    ),
  ));
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pim_app/tasks/TaskWidget.dart';
import 'notes/NoteWidget.dart';
import "utils.dart" as utils;

void main() {
  startMeUp() async {
    Directory docsDir = await getApplicationDocumentsDirectory();
    utils.docsDir = docsDir;
    runApp(MyApp());
  }

  WidgetsFlutterBinding.ensureInitialized();
  startMeUp();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
            appBar: AppBar(
              title: Text("Bobobo"),
              bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.date_range), text: "Appointments"),
                  Tab(icon: Icon(Icons.contacts), text: "Contacts"),
                  Tab(icon: Icon(Icons.note), text: "Notes"),
                  Tab(icon: Icon(Icons.assignment_turned_in), text: "Tasks")
                ],
              ),
            ),
            body: TabBarView(
                // children: [Appointments(), Contacts(), Notes(), Tasks()])),
                children: [Container(), Container(), NoteWidget(), TaskWidget()])),
      ),
    );
  }
}

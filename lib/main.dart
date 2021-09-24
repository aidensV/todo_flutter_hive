import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:myapp/database/profile.dart';
import 'package:myapp/database/todo.dart';
import 'package:myapp/screen/starter_page.dart';
import 'package:path_provider/path_provider.dart' as pathProvide;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await pathProvide.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(TodoAdapter());
  Hive.registerAdapter(ProfileAdapter());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue, scaffoldBackgroundColor: Colors.white),
      home: StarterPage(),
    );
  }
}

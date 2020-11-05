import 'package:flutter/material.dart';
import 'package:media_player/controller_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        primaryColorDark: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 25,  fontWeight: FontWeight.normal),
          headline2: TextStyle(fontSize: 15,  fontWeight: FontWeight.normal),
        )
      ),
      home: Controller(),
    );
  }
}

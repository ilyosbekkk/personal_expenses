import 'package:flutter/material.dart';
import 'package:flutter_widgets/widget 1: safe area.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        'safe_area': (context) => SafeAreaWIdget(),
      },
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> buttons = [];

  Widget page_buttons(String buttonName, String rootName) {
    return RaisedButton(
      child: Text("$buttonName"),
      onPressed: () {
        Navigator.pushNamed(context, rootName);
      },
    );
  }

  List<Widget> vvv() {
    buttons = [page_buttons("Safe Area", 'safe_area')];

    return buttons;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: new ListView.builder(
              itemCount: buttons.length,
              itemBuilder: (BuildContext context, int index) {
                return vvv()[index];
              })),
    );
  }
}

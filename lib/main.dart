import 'package:flutter/material.dart';
import 'package:flutter_widgets/widget 1: safe area.dart';
import 'package:flutter_widgets/widget%202:%20expanded.dart';
import 'package:flutter_widgets/widget 3: wrap.dart';
import 'package:flutter_widgets/widget 4: animated container.dart';

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
        'expanded': (context) => ExpandedWidget(),
        'wrap': (context) => WrapWidget(),
        'animated container': (context) => AnimatedContainerWidget(),
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

  List<Widget> buildWidgetList() {
    buttons = [
      page_buttons("Safe Area", 'safe_area'),
      page_buttons("Expanded", "expanded"),
      page_buttons("Wrap", 'wrap'),
      page_buttons("Animated Container", "animated container")];


    return
      buttons;
  }

  @override
  void initState() {
    super.initState();
    buildWidgetList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Widgets"),
      ),
      body: Container(
          child: ListView.builder(
              itemCount: buttons.length,
              itemBuilder: (BuildContext context, int index) {
                return buildWidgetList()[index];
              })),
    );
  }
}

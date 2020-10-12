import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_expenses/mainscreen_components/chart.dart';
import 'package:personal_expenses/mainscreen_components/items%20list.dart';
import 'package:personal_expenses/modal_views/add%20item%20modalview.dart';
import 'package:personal_expenses/models/transaction.dart';
import 'package:intl/intl.dart';

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
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  BuildContext mContext;

  MyHomePage({Key key, this.title}) : super(key: key);

  void _openAddItemModalView() async {
    await showModalBottomSheet(
        context: mContext, builder: (mContext) => InsertData());
  }

  @override
  Widget build(BuildContext context) {
    mContext = context;
    return Scaffold(
        appBar: AppBar(
          title: Text("$title"),
          actions: [
            IconButton(
              onPressed: () => _openAddItemModalView(),
              icon: Icon(Icons.add),
            )
          ],
        ),
        body: Column(
          children: [
            Chart(),
            ItemsList(),
          ],
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

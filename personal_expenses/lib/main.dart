
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_expenses/mainscreen_components/chart.dart';
import 'package:personal_expenses/mainscreen_components/items%20list.dart';
import 'package:personal_expenses/models/transaction.dart';

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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
//region vars
final title = TextEditingController();
final price = TextEditingController();
 List<Transaction> transactions = new List();
//endregion

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BuildContext mContext;



  //region modal bottom sheet
  void _openAddItemModalView() async {
    await showModalBottomSheet(
        context: mContext, builder: (mContext){
          return Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.all(10.0),
                      child: Text(
                        "ADD ITEM",
                        style: TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.bold,
                            fontSize: 23),
                      ),
                    ),
                    TextField(
                      controller: widget.title,
                      decoration: InputDecoration(labelText: "Item"),
                    ),
                    TextField(
                      controller: widget.price,
                      decoration: InputDecoration(labelText: "Price"),
                    ),
                    RaisedButton(
                      onPressed: (){
                        addItems(widget.title.text, double.parse(widget.price.text));
                      },
                      child: Text("Add Item"),
                    )
                  ],
                ),
              ),
            ),
          );
    });
  }
  //endregion
  //region add items
  void addItems(String title,  double price){

    setState(() {
      widget.transactions.add(new Transaction(id: "1", title: title, amount: price,  date: DateTime.now()));
    });
  }
  //endregion
  @override
  Widget build(BuildContext context) {
    mContext = context;
    return Scaffold(
        appBar: AppBar(
          title: Text("Personal Expenses"),
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
            ItemsList(widget.transactions),
          ],
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

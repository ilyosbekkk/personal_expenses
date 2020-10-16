import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_expenses/mainscreen_components/chart.dart';
import 'package:personal_expenses/mainscreen_components/items%20list.dart';
import 'package:personal_expenses/models/transaction.dart';
import 'package:personal_expenses/utils/utils.dart';

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

  //region recentTransactions
  List<Transaction> get _recentTransactions{
    return widget.transactions.where((element) {
      return element.date.isAfter(DateTime.now().subtract(Duration(days: 7),),);
    }).toList();
  }
  //endregion
  //region modal bottom sheet
  void _openAddItemModalView() async {
    await showModalBottomSheet(
        context: mContext,
        builder: (mContext) {
          return Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
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
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: TextField(
                        controller: widget.title,
                        decoration: InputDecoration(
                            labelText: "Item", hintText: "Product name"),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: widget.price,
                        decoration: InputDecoration(
                            labelText: "Amount", hintText: "Overall amount"),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("No date chosen"),
                          FlatButton(
                            textColor: Colors.blue,
                            child: Text("Pick a date"),
                            onPressed: () {},
                          )
                        ],
                      ),
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                      ),
                      color: Colors.red,
                      textColor: Colors.white,
                      onPressed: () {
                        if (widget.title.text.isEmpty ||
                            widget.price.text.isEmpty) {
                          toast("Product/Amount cannot be empty");
                        } else {
                          addItems(widget.title.text,
                              double.parse(widget.price.text));
                          Navigator.pop(context);
                          toast("${widget.title.text} added");
                           widget.title.text = "";
                          widget.price.text = "";
                        }
                      },
                      child: Text("add item"),
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
  void addItems(String title, double price) {
    setState(() {
      widget.transactions.add(new Transaction(
          id: "1", title: title, amount: price, date: DateTime.now()));
    });
  }

  //endregion
  //region overrides
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Chart(_recentTransactions),
            ItemsList(widget.transactions),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddItemModalView(),
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  //endregion
}

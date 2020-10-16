

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses/database_operations/database.dart';
import 'package:personal_expenses/mainscreen_components/chart.dart';
import 'package:personal_expenses/mainscreen_components/items%20list.dart';
import 'package:personal_expenses/models/transaction.dart';
import 'package:personal_expenses/utils/utils.dart';
import 'package:sqflite/sqflite.dart';

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
  final _title = TextEditingController();
  final _price = TextEditingController();

  ExpenseTransaction _transaction;
  DateTime _selectedDate;
  List<ExpenseTransaction> _transactions = new List();
  BuildContext _mContext;
  bool _isModalOpen = false;

  //endregion

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //region overrides
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }
  @override
  Widget build(BuildContext context) {
    widget._mContext = context;


    return Scaffold(
      appBar: AppBar(
        title: Text("Personal Expenses"),
        actions: [
          !widget._isModalOpen
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      widget._isModalOpen = true;
                    });
                    _openAddItemModalView();
                  },
                  icon: Icon(Icons.add),
                )
              : Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Icon(Icons.close),
                )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Chart(_recentTransactions),

            ItemsList(widget._transactions,  _deleteTransaction),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            widget._isModalOpen = true;
          });
          _openAddItemModalView();
        },
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

//endregion-
  //region methods
  //region modalbottomsheet
  void _openAddItemModalView() async {
    await showModalBottomSheet(
        context: widget._mContext,
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
                        controller: widget._title,
                        decoration: InputDecoration(
                            labelText: "Item", hintText: "Product name"),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: widget._price,
                        decoration: InputDecoration(
                            labelText: "Amount", hintText: "Overall amount"),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget._selectedDate == null
                              ? "No date chosen"
                              : DateFormat.yMd().format(widget._selectedDate)),
                          FlatButton(
                              textColor: Colors.blue,
                              child: Text("Pick a date"),
                              onPressed: _presentDatePicker)
                        ],
                      ),
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      color: Colors.red,
                      textColor: Colors.white,
                      onPressed: () {
                        if (widget._title.text.isEmpty ||
                            widget._price.text.isEmpty ||
                            widget._selectedDate == null) {
                          toast("Product/Amount/Date cannot be empty!");
                        } else if (double.tryParse(widget._price.text) ==
                            null) {
                          toast("Price accepts numeric value only!");
                        } else {
                          addItems(widget._title.text,
                              double.parse(widget._price.text));
                          Navigator.pop(context);
                        }
                      },
                      child: Text("add item"),
                    )
                  ],
                ),
              ),
            ),
          );
        }).whenComplete(() {
      widget._title.text = "";
      widget._price.text = "";
      widget._selectedDate = null;
      setState(() {
        widget._isModalOpen = false;
      });
    });
  }

  //endregion
  //region presentDatePicker
  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(
              (2020),
            ),
            lastDate: DateTime.now())
        .then((value) {
      if (value != null) {
        widget._selectedDate = value;
      }
    });
  }

  //endregion
  //region recentTransactions
  List<ExpenseTransaction> get _recentTransactions {
    return widget._transactions.where((element) {
      DateTime time = DateTime.parse(element.date);
      return time.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  //endregion
  //region save transaction to database

  //endregion
  //region add transaction
  void addItems(String title, double price) async {
    setState(() {
      BuildDatabase.saveToDatabase(new ExpenseTransaction(id: null, title: title, amount: price , date: widget._selectedDate.toString()));

      /*BuildDatabase.expenses().then((value) {
         for(int i = 0; i<value.length; i++){
           print(value[i].title + " " + value[i].id.toString() + " " + value[i].amount.toString());
           print(value[i].date);
         }
      });*/
      widget._transactions.add(new ExpenseTransaction(
          id: 1, title: title, amount: price, date: widget._selectedDate.toString()));
    });
  }

  //endregion
  //region deleteTransaction
  void _deleteTransaction(ExpenseTransaction transaction) {
    setState(() {
      widget._transactions.remove(transaction);
    });
  }
//endregion

 //region fetch data from database
    void fetchData(){

    BuildDatabase.expenses().then((value) {
      setState(() {
        if(widget._transactions.isNotEmpty){
          widget._transactions.clear();
        }
        widget._transactions.addAll(value);
        for(int i = 0; i<value.length; i++){
          print(value[i].title);
        }

      });




    });


   }
 //endregion
//endregion

}

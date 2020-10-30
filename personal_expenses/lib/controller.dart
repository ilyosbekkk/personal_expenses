import 'package:personal_expenses/database_operations/database.dart';
import 'package:personal_expenses/widgets/items%20list.dart';
import 'package:personal_expenses/models/transaction.dart';
import 'package:personal_expenses/widgets/chart.dart';
import 'package:personal_expenses/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses/widgets/new_transaction.dart';

class AppController extends StatefulWidget {
  //region vars
  final _title = TextEditingController();
  final _price = TextEditingController();
  bool isChartOrListVisible = true;
  DateTime _selectedDate;
  List<ExpenseTransaction> _transactions = new List();
  bool _isModalOpen = false;

  //endregion

  @override
  _AppControllerState createState() => _AppControllerState();
}

class _AppControllerState extends State<AppController> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _app_bar(),
      body: app_body(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            widget._isModalOpen = true;
          });
          _openAddItemModalView(context, false, null);
        },
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  //region app_body
  SafeArea app_body(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = (mediaQuery.orientation == Orientation.landscape);
    final app_bar = _app_bar();
    final listItems = Container(
      height: (mediaQuery.size.height -
              app_bar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: ItemsList(widget._transactions, _deleteTransaction,
          _updateTransaction, _openAddItemModalView),
    );
    final switch_widget = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(widget.isChartOrListVisible ? "show list" : "show chart"),
        Switch.adaptive(
            value: widget.isChartOrListVisible,
            onChanged: (val) {
              setState(() {
                widget.isChartOrListVisible = val;
              });
            })
      ],
    );
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (isLandscape) switch_widget,
            if (!isLandscape)
              Container(
                  height: (mediaQuery.size.height -
                          app_bar.preferredSize.height -
                          mediaQuery.padding.top) *
                      0.3,
                  child: Chart(_recentTransactions)),
            if (!isLandscape) listItems,
            if (isLandscape)
              widget.isChartOrListVisible
                  ? Container(
                      height: (mediaQuery.size.height -
                              app_bar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.7,
                      child: Chart(_recentTransactions))
                  : listItems,
          ],
        ),
      ),
    );
  }

  //endregion
  //region app_bar
  AppBar _app_bar() {
    return AppBar(
      title: Text("Personal Expenses"),
      actions: [
        !widget._isModalOpen
            ? IconButton(
                onPressed: () {
                  setState(() {
                    widget._isModalOpen = true;
                  });
                  _openAddItemModalView(context, false, null);
                },
                icon: Icon(Icons.add),
              )
            : Container(
                margin: EdgeInsets.only(right: 10),
                child: Icon(Icons.close),
              )
      ],
    );
  }

  //endregion
  //region modalbottomsheet
  void _openAddItemModalView(BuildContext mContext, bool isInUpdateMode,
      ExpenseTransaction transaction) async {
    await showModalBottomSheet(
        context: mContext,
        builder: (_) {
          return Container(
            child: NewTransaction(
                isInUpdateMode,
                transaction,
                saveItemsToDatabase,
                _updateTransaction,
                widget._title,
                widget._price,
                widget._selectedDate,
                _presentDatePicker),
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
  //region utility methods
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
        setState(() {
          widget._selectedDate = value;
        });
      }
    });
  }

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
  //region database operations
  void saveItemsToDatabase(String title, double price) async {
    setState(() {
      BuildDatabase.saveToDatabase(new ExpenseTransaction(
          id: null,
          title: title,
          amount: price,
          date: widget._selectedDate.toString()));
      widget._transactions.add(new ExpenseTransaction(
          id: 1,
          title: title,
          amount: price,
          date: widget._selectedDate.toString()));
    });
  }

  void _deleteTransaction(ExpenseTransaction transaction) {
    setState(() {
      BuildDatabase.deleteFromDatabase(transaction.id);
      widget._transactions.remove(transaction);
    });
  }

  void _updateTransaction(
      ExpenseTransaction transaction, String title, double amount) {
    setState(() {
      BuildDatabase.updateTransaction(new ExpenseTransaction(
          id: transaction.id,
          title: title,
          amount: amount,
          date: widget._selectedDate.toString()));

      transaction.title = title;
      transaction.amount = amount;
      transaction.date = widget._selectedDate.toString();
    });
  }

  void fetchData() {
    BuildDatabase.expenses().then((value) {
      setState(() {
        if (widget._transactions.isNotEmpty) {
          widget._transactions.clear();
        }
        widget._transactions.addAll(value);
        for (int i = 0; i < value.length; i++) {
          print(value[i].title);
        }
      });
    });
  }
//endregion

}
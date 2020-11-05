import 'package:personal_expenses/database_operations/database.dart';
import 'package:personal_expenses/widgets/new_transaction.dart';
import 'package:personal_expenses/widgets/items%20list.dart';
import 'package:personal_expenses/models/transaction.dart';
import 'package:personal_expenses/widgets/chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class AppController extends StatefulWidget {
  @override
  _AppControllerState createState() => _AppControllerState();
}

class _AppControllerState extends State<AppController> {
  //region vars
  final _title = TextEditingController();
  final _price = TextEditingController();
  bool isChartOrListVisible = true;
  DateTime _selectedDate;
  List<ExpenseTransaction> _transactions = new List();
  bool _isModalOpen = false;
  bool isIos = Platform.isIOS;
  //endregion
  //region overrides
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return isIos
        ? CupertinoPageScaffold(
            child: appBody(context),
            navigationBar: _navogationBar(),
          )
        : Scaffold(
            appBar: _appBar(),
            body: appBody(context),
            floatingActionButton: floatingActionButton(), // This trailing comma makes auto-formatting nicer for build methods.
          );
  }
  //endregion

  //region app_body
  SafeArea appBody(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = (mediaQuery.orientation == Orientation.landscape);
    final appBar = _appBar();
    final listItems = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: ItemsList(_transactions, _deleteTransaction, _updateTransaction,
          _openAddItemModalView),
    );
    final switchWidget = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(isChartOrListVisible ? "show list" : "show chart"),
        Switch.adaptive(
            value: isChartOrListVisible,
            onChanged: (val) {
              setState(() {
                isChartOrListVisible = val;
              });
            })
      ],
    );
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (isLandscape)
              ..._landscapeMode(switchWidget, listItems, mediaQuery, appBar),
            if (!isLandscape) ..._portraitMode(mediaQuery, appBar, listItems),
          ],
        ),
      ),
    );
  }

  //endregion
  //region app_bar
  AppBar _appBar() {
    return AppBar(
      title: Text("Personal Expenses"),
      actions: [
        !_isModalOpen
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _isModalOpen = true;
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

  CupertinoNavigationBar _navogationBar() {
    return CupertinoNavigationBar(
        leading: Text("Personal Expenses"),
        trailing: !_isModalOpen
            ? GestureDetector(
                child: Icon(CupertinoIcons.add),
              )
            : Container(
                margin: EdgeInsets.only(right: 10),
                child: Icon(CupertinoIcons.clear),
              ));
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
                _title,
                _price,
                _selectedDate,
                _presentDatePicker),
          );
        }).whenComplete(() {
      _title.text = "";
      _price.text = "";
      _selectedDate = null;
      setState(() {
        _isModalOpen = false;
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
          _selectedDate = value;
        });
      }
    });
  }

  List<ExpenseTransaction> get _recentTransactions {
    return _transactions.where((element) {
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
          date: _selectedDate.toString()));
      _transactions.add(new ExpenseTransaction(
          id: 1, title: title, amount: price, date: _selectedDate.toString()));
    });
  }

  void _deleteTransaction(ExpenseTransaction transaction) {
    setState(() {
      BuildDatabase.deleteFromDatabase(transaction.id);
      _transactions.remove(transaction);
    });
  }

  void _updateTransaction(
      ExpenseTransaction transaction, String title, double amount) {
    setState(() {
      BuildDatabase.updateTransaction(new ExpenseTransaction(
          id: transaction.id,
          title: title,
          amount: amount,
          date: _selectedDate.toString()));

      transaction.title = title;
      transaction.amount = amount;
      transaction.date = _selectedDate.toString();
    });
  }

  void fetchData() {
    BuildDatabase.expenses().then((value) {
      setState(() {
        if (_transactions.isNotEmpty) {
          _transactions.clear();
        }
        _transactions.addAll(value);
        for (int i = 0; i < value.length; i++) {
          print(value[i].title);
        }
      });
    });
  }

//endregion
  //region landscape_mode
  List<Widget> _landscapeMode(Row switchWidget, Container listItems,
      MediaQueryData mediaQuery, AppBar appBar) {
    return [
      switchWidget,
      isChartOrListVisible
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(_recentTransactions))
          : listItems
    ];
  }

  //endregion
  //region  portrait_mode
  List<Widget> _portraitMode(
      MediaQueryData mediaQuery, AppBar appBar, Container listItem) {
    return [
      Container(
          height: (mediaQuery.size.height -
                  appBar.preferredSize.height -
                  mediaQuery.padding.top) *
              0.3,
          child: Chart(_recentTransactions)),
      listItem
    ];
  }

//endregion
  //region floatingActionButton
  Widget floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        setState(() {
          _isModalOpen = true;
        });
        _openAddItemModalView(context, false, null);
      },
      child: Icon(Icons.add),
    );
  }
//endregion

}

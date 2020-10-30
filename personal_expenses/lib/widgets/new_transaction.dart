import 'package:personal_expenses/models/transaction.dart';
import 'package:personal_expenses/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final _isInUpdateMode;
  final ExpenseTransaction _transaction;
  final Function _saveItemsToDatabase;
  final Function _updateDatabase;
  final Function _presentDatePicker;
  final DateTime _selectedDate;
  final TextEditingController _title;
  final TextEditingController _price;


  NewTransaction(
      this._isInUpdateMode, this._transaction, this._saveItemsToDatabase, this._updateDatabase, this._title,  this._price, this._selectedDate,  this._presentDatePicker);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.all(10.0),
              child: !widget._isInUpdateMode
                  ? Text(
                      "ADD NEW TRANSACTION",
                      style: TextStyle(
                          color: Colors.purple,
                          fontWeight: FontWeight.bold,
                          fontSize: 23),
                    )
                  : Text(
                      "UPDATE  ${widget._transaction.title}",
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
                autofocus: true,
                decoration: InputDecoration(
                    labelText: "Item", hintText: "Product name"),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: widget._price,
                autofocus: true,
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
                      onPressed: () {
                        widget._presentDatePicker();
                      })
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
                } else if (double.tryParse(widget._price.text) == null) {
                  toast("Price accepts numeric value only!");
                } else {
                  !widget._isInUpdateMode
                      ? widget._saveItemsToDatabase(
                          widget._title.text, double.parse(widget._price.text))
                      : widget._updateDatabase(widget._transaction, widget._title.text,
                          double.parse(widget._price.text));
                  Navigator.pop(context);
                }
              },
              child: Text("add item"),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses/mainscreen_components/chart.dart';
import 'package:personal_expenses/models/transaction.dart';

class ItemsList extends StatefulWidget {
  //region vars&constructor
  List<ExpenseTransaction> transactions;
  final Function _deleteTransaction;
  final Function _updateTransaction;

  ItemsList(this.transactions, this._deleteTransaction,  this._updateTransaction);

  //endregion

  @override
  ItemsListState createState() => ItemsListState();
}

class ItemsListState extends State<ItemsList> {
  //region overrides
  @override
  Widget build(BuildContext context) {
    return Container(
        child: widget.transactions == null || widget.transactions.isEmpty
            ? Text(
                "Waiting...",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )
            : Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.transactions.length,
                    itemBuilder: (BuildContext context, int index) {
                      return itemViewholder(widget.transactions[index]);
                    }),
              ));
  }

//endregion
  //region UI builder methods
  //region Card View Children
  Widget deleteTransactionWidget(ExpenseTransaction transaction) {
    return Container(
      alignment: Alignment.topRight,
      child: IconButton(
        onPressed: () {
          showDeleteDialog(transaction);
        },
        icon: Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ),
    );
  }


  Widget editTransactionWidget(ExpenseTransaction transaction) {
    return Container(
      alignment: Alignment.topRight,
      child: IconButton(
        onPressed: () {

        },
        icon: Icon(
          Icons.edit,
          color: Colors.blue,
        ),
      ),
    );
  }


  Widget priceBoxWidget(ExpenseTransaction tx) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: CircleAvatar(
        radius: 25,
        foregroundColor: Colors.red,
        backgroundColor: Colors.yellow,
        child: FittedBox(
          child: Text(
            '\$' + tx.amount.toString(),
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple),
          ),
        ),
      ),
      /* decoration: BoxDecoration(
        border: Border.all(color: Colors.purple, width: 2),
      ),*/
    );
  }

  Widget ItemInfoWidget(ExpenseTransaction tx) {
    DateTime time = DateTime.parse(tx.date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text(
            tx.title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          child: Text(
            DateFormat('yyyy-MM-dd').format(time),
            style: TextStyle(color: Colors.grey),
          ),
        )
      ],
    );
  }

//endregion
  //region alert dialog
  Future<void> showDeleteDialog(ExpenseTransaction transaction) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext contex) {
          return AlertDialog(
            title: Text("Delete a transaction"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [Text("Are you sure to delete a transaction?")],
              ),
            ),
            actions: [
              Row(
                children: [
                  FlatButton(
                    onPressed: () {
                      widget._deleteTransaction(transaction);
                      Navigator.of(context).pop();
                    },
                    child: Text("Yes"),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("No"),
                  ),
                ],
              )
            ],
          );
        });
  }

//endregion
  //region Item ViewHolder
  Widget itemViewholder(ExpenseTransaction tx) {
    return Card(
        shadowColor: Colors.blue,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.green),
            borderRadius: BorderRadius.circular(10)),
        elevation: 5.0,
        child: Row(
          children: [
            priceBoxWidget(tx),
            ItemInfoWidget(tx),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  editTransactionWidget(tx),
                  deleteTransactionWidget(tx)
                ],
              ),
            ),

          ],
        ));
  }

//endregion
//endregion

}

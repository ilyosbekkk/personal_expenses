import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses/models/transaction.dart';

class ItemsList extends StatefulWidget {
  //region list of transactions
  List<Transaction> transactions;

  ItemsList(this.transactions);

  @override
  ItemsListState createState() => ItemsListState();
}

class ItemsListState extends State<ItemsList> {
  //region onClicks
  void deleteTransaction(Transaction transaction) {
    setState(() {
      widget.transactions.remove(transaction);

    });
  }

  //endregion
  //region Card View Children
  Widget deleteTransactionWidget(Transaction transaction) {
    return Container(
      alignment: Alignment.topRight,
      child: IconButton(
        onPressed: () {
          deleteTransaction(transaction);
        },
        icon: Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ),
    );
  }

  Widget priceBoxWidget(Transaction tx) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Text(
        '\$' + tx.amount.toString(),
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple),
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purple, width: 2),
      ),
    );
  }

  Widget ItemInfoWidget(Transaction tx) {
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
            DateFormat('yyyy-MM-dd').format(tx.date),
            style: TextStyle(color: Colors.grey),
          ),
        )
      ],
    );
  }

  //endregion
  //region Item ViewHolder
  Widget itemViewholder(Transaction tx){
    return  Card(
        elevation: 5.0,
        child: Row(
          children: [
            priceBoxWidget(tx),
            ItemInfoWidget(tx),
            Expanded(
              child: deleteTransactionWidget(tx),
            )
          ],
        ));
  }
  //endregion
  //region overrides
  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.transactions == null || widget.transactions.isEmpty
          ? Text(
        "Nothing to show",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      )
          : ListView.builder(shrinkWrap: true, physics: NeverScrollableScrollPhysics(),itemCount: widget.transactions.length,itemBuilder: (BuildContext context,  int index){
            return itemViewholder(widget.transactions[index]);

      })
    );
  }
//endregion
}




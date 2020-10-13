import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses/models/transaction.dart';

class ItemsList extends StatefulWidget {
  //region list of transactions
  List<Transaction> transactions;

  ItemsList(@required this.transactions);

  @override
  ItemsListState createState() => ItemsListState();
}

class ItemsListState extends State<ItemsList> {



  @override
  Widget build(BuildContext context) {
    print("build is called");
    return Container(
      child: widget.transactions == null || widget.transactions.isEmpty ? Text(
          "Nothing to show") : Column(
        children: widget.transactions.map((tx) {
          return Card(
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Text(
                      '\$' + tx.amount.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.purple),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.purple, width: 2),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          tx.title,
                          style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        child: Text(
                          DateFormat('yyyy-MM-dd').format(tx.date),
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    ],
                  )
                ],
              ));
        }).toList(),
      ),
    );
  }
}

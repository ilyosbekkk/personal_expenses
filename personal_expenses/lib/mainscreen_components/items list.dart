import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses/models/transaction.dart';
class ItemsList extends StatelessWidget {

  final List<Transaction> transactions = [
    Transaction(
        id: "Id1", title: "New CAR", amount: 12.3, date: DateTime.now()),
    Transaction(
        id: "Id2", title: "Old Car", amount: 12.36, date: DateTime.now())
  ];
  @override
  Widget build(BuildContext context) {
     return Container(
         child:  Column(
           children: transactions.map((tx) {
             return Card(
                 child: Row(
                   children: [
                     Container(
                       padding: EdgeInsets.all(10),
                       margin:
                       EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                             style: TextStyle(
                                 fontSize: 16, fontWeight: FontWeight.bold),
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

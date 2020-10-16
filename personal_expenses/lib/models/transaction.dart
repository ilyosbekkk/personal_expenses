import 'package:flutter/foundation.dart';

class ExpenseTransaction {
  //region vars and constructor
  int id;
  String title;
  double amount;
  String date;

  ExpenseTransaction({this.id, this.title, this.amount, this.date});

  //endregion

  //region Converting to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toString()
    };
  }
//endregion

}

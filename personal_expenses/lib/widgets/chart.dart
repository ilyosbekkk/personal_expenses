import 'package:personal_expenses/models/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'chart bar.dart';

class Chart extends StatelessWidget {

  //region vars&constructor
  final List<ExpenseTransaction> recentTransactions;
  const Chart(this.recentTransactions);
  //endregion
  //region overrides
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.green, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          color: Color.fromRGBO(240, 255, 255, 1),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: groupedTransactionValues.map((e) {
                return Flexible(

                  fit: FlexFit.tight ,
                    child: ChartBar(e['day'], e['amount'],
                        (e['amount'] as double) / totalSpending));
              }).toList())),
    );
  }
//endregion
  //region methods
  //region grouped transaction values
  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      double totalSum = 0.0;
      DateTime time;
      for (var i = 0; i < recentTransactions.length; i++) {
        time = DateTime.parse(recentTransactions[i].date);
        if (time.day == weekDay.day &&
            time.month == weekDay.month &&
            time.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum
      };
    });
  }

  //endregion
  //region total spending
  double get totalSpending {
    double sum = 0.00000000000000000000001;
    for (int i = 0; i < groupedTransactionValues.length; i++) {
      sum += groupedTransactionValues[i]['amount'];
    }

    return sum;
  }
  //endregion
  //endregion
}

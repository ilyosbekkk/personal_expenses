import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_expenses/mainscreen_components/chart%20bar.dart';
import 'package:personal_expenses/models/transaction.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  const Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      double totalSum = 0.0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      print(DateFormat.E().format(weekDay));
      print(totalSum);


      return {'day': DateFormat.E().format(weekDay).substring(0,1), 'amount': totalSum};
    });
  }

  //region total spending
  double get totalSpending{
    return groupedTransactionValues.fold(1.0,(sum,  item) {
       return sum + item['amount'];
    });
  }
  //endregion

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height * 0.2,
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
               return ChartBar(e['day'], e['amount'],  (e['amount'] as double) / totalSpending);
            }).toList()


          )),
    );
  }
}

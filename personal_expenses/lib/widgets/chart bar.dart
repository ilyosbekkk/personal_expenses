import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  //region vars&constructor
  final String label;
  final double spendingAmount;
  final double spendingPcOfTotal;

  ChartBar(this.label, this.spendingAmount, this.spendingPcOfTotal);

  //endregion
  //region overrides
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return chartBar(constraints);
      },
    );
  }
//endregion

 //region  chartBar
  Widget chartBar(BoxConstraints constraints){
    return Column(
      children: [
        Container(
            height: constraints.maxHeight * 0.15,
            child: FittedBox(
                child: Text("\$${spendingAmount.toStringAsFixed(0)}"))),
        SizedBox(
          height: constraints.maxHeight * 0.05,
        ),
        Container(
            height: constraints.maxHeight * 0.6,
            width: 10,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0),
                      color: Color.fromRGBO(220, 220, 220, 1),
                      borderRadius: BorderRadius.circular(10)),
                ),
                FractionallySizedBox(
                  heightFactor: spendingPcOfTotal,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                )
              ],
            )),
        SizedBox(
          height: constraints.maxHeight * 0.05,
        ),
        Container(height: constraints.maxHeight * 0.15, child: FittedBox(child: Text(label)))
      ],
    );
  }
 //endregion
}

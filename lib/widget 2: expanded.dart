import 'package:flutter/material.dart';

class ExpandedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  height: 200,
                  color: Colors.red,
                ),
              ),
              Container(height: 200, width: 100, color: Colors.green),
              Expanded(
                flex: 10,
                child: Container(
                  child: Text(
                    "It is an example of Expanded Widget:)",
                    textAlign: TextAlign.center,
                  ),
                  height: 200,
                  color: Colors.yellow,
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              width: 200,
              child: Text(
                "Rest of column...",
                textAlign: TextAlign.center,
              ),
              color: Colors.orange,
            ),
          )
        ],
      ),
    ));
  }
}

import 'package:flutter/material.dart';



class Chart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return   Container(
      width: double.infinity,
      child: Card(
        child: Container(
            color: Colors.blue,
            width: double.infinity,
            child: Text("Chart")),
        elevation: 5,
      ),
    );
  }
}

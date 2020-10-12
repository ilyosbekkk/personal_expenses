import 'package:flutter/material.dart';

class InsertData extends StatefulWidget {
  @override
  _InsertDataState createState() => _InsertDataState();
}






class _InsertDataState extends State<InsertData> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.all(10.0),
              child: Text(
                "ADD ITEM",
                style:
                    TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 23),
              ),
            ),
          Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: TextField(
                decoration: InputDecoration(labelText: "Item"),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: TextField(
                decoration: InputDecoration(labelText: "Price"),
              ),
            ),
            RaisedButton(
              onPressed: () {},
              child: Text("Add Item"),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class WrapWidget extends StatelessWidget {
  List<Widget> buttons = [];

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Wrap(
            direction: Axis.horizontal,
            children: [
              Chip(
                label: Text(
                  "My Chip",
                ),
                avatar: CircleAvatar(
                  backgroundColor: Colors.red,
                ),
              ),
              RaisedButton(
                onPressed: () {},
                child: Text("Button"),
              ),
              RaisedButton(
                onPressed: () {},
                child: Text("Button"),
              ),
              RaisedButton(
                onPressed: () {},
                child: Text("Button"),
              ),
              RaisedButton(
                onPressed: () {},
                child: Text("Button"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

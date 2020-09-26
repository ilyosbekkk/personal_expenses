import 'package:flutter/material.dart';

class OpacityWidget extends StatefulWidget {
  @override
  _OpacityWidgetState createState() => _OpacityWidgetState();
}

class _OpacityWidgetState extends State<OpacityWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Opacity(
          opacity: 0.3,
          child: Chip(
            label: Text("My Chip"),
            backgroundColor: Colors.red,
          ),
        ),
      ),
    );
  }
}

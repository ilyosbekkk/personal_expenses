import 'package:flutter/material.dart';

class AnimatedContainerWidget extends StatefulWidget {
  @override
  _AnimatedContainerWidgetState createState() => _AnimatedContainerWidgetState();
}

class _AnimatedContainerWidgetState extends State<AnimatedContainerWidget> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedContainer(
          child: Column(
            children: [
              RaisedButton(
                onPressed: () {
                  setState(() {
                    selected = !selected;
                  });
                },
                child: Text("press me"),
              ),
              Text("press him"),
            ],
          ),
          height: selected ? 200 : 100,
          width: 200,
          duration: Duration(milliseconds: 500),
          // color: selected ? Colors.green : Colors.red,
          decoration: BoxDecoration(color: Colors.green, borderRadius: selected ? BorderRadius.circular(50.0) : BorderRadius.circular(25.0)),
        ),
      ),
    );
  }
}

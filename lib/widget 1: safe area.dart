import 'package:flutter/material.dart';

class SafeAreaWIdget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Text("DefinitionSafe Area  -  A widget that insets its child by sufficient padding to avoid instrusions by the operating systemIf you wrap your widget with Safe Area you can prevent your widget is blocked by the system status bar,  corners, notches and so on..."),
          right: true,
          left: true,
          bottom: true,
          top: true,
          // minimum: EdgeInsets.all(100),
          maintainBottomViewPadding: true,
        ),
      ),
    );
  }
}

import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

void toast(String toastMessage){
  Fluttertoast.showToast(
      msg: toastMessage,
      textColor:Colors.blue,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      fontSize: 16.0
  );
}
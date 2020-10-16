import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:personal_expenses/models/transaction.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';

class BuildDatabase {
  //region open database
  static Future<Database> open_database() async {
    WidgetsFlutterBinding.ensureInitialized();

    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'personal_expenses.db'),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE transactions(id INTEGER PRIMARY KEY, title TEXT,  amount DOUBLE,  date TEXT)");
      },
      version: 1,
    );
    return database;
  }

  //endregion

  //region save to database
  static Future<void> saveToDatabase(ExpenseTransaction transaction) async {
    Database db;
    BuildDatabase.open_database().then((value) {
      db = value;
      db.insert('transactions', transaction.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }

  //endregion

  //region retrieve database
  static Future<List<ExpenseTransaction>> expenses() async {
    final Database db = await BuildDatabase.open_database();

    final List<Map<String, dynamic>> expenses = await db.query('transactions');

    return List.generate(expenses.length, (index) {
      return ExpenseTransaction(
        id: expenses[index]['id'],
        title: expenses[index]['title'],
        amount: expenses[index]['amount'],
        date: expenses[index]['date'],
      );
    });
  }
//endregion

}

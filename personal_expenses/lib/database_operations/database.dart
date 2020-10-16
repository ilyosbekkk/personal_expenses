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

    BuildDatabase.open_database().then((value) {
      value.insert('transactions', transaction.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }

  //endregion
  //region delete from database
  static Future<void> deleteFromDatabase(int id) async {
    BuildDatabase.open_database().then((value) {
      value.delete('transactions', where: "id = ?", whereArgs: [id]);
    });
  }

  //endregion
  //region update database
  static Future<void> updateTransaction(ExpenseTransaction transaction) {
       BuildDatabase.open_database().then((value){
         value.update('transactions', transaction.toMap(), where: "id = ?",  whereArgs: [transaction.id]);
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

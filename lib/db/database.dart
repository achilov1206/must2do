import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

import '../models/category_model.dart';
import '../models/todo_model.dart';

class DB {
  //Datebase filename
  static const dataBaseName = 'medicinereminder.db';
  //Database version
  static const dataBaseVersion = 1;

  //Singleton
  static final DB _dbHelper = DB._internal();

  //Factory constructor
  DB._internal();
  factory DB() {
    return _dbHelper;
  }
  //Database entry point
  static Database? _db;
  Future<Database> get db async {
    _db ??= await _initializeDb();
    return _db!;
  }

  //Initialize the database
  Future<Database> _initializeDb() async {
    Directory d = await getApplicationDocumentsDirectory();
    String p = d.path + dataBaseName;
    //await deleteDatabase(p);
    var db =
        await openDatabase(p, version: dataBaseVersion, onCreate: _createDB);
    return db;
  }

  //SQL to create the database
  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE $categoryTableName (
${CategoryFields.id} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
${CategoryFields.title} TEXT NOT NULL,
${CategoryFields.icon} TEXT)''');

    await db.execute('''
CREATE TABLE $todoTableName (
${TodoFields.id} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
${TodoFields.categoryId} TEXT NOT NULL,
${TodoFields.title} TEXT NOT NULL,
${TodoFields.description} TEXT,
${TodoFields.dateTime} INT NOT NULL,
${TodoFields.completed} INT NOT NULL)''');

    db.transaction((txn) async {
      Category personal = const Category(title: 'Personal', icon: Icons.person);
      Category work = const Category(title: 'Work', icon: Icons.work);
      await txn.insert(categoryTableName, personal.toMap());
      await txn.insert(categoryTableName, work.toMap());
      // Todo firstTodo = Todo(
      //   categoryId: '1',
      //   title: 'Do homework',
      //   dateTime: DateTime.now(),
      //   description: '',
      // );
      // Todo secondTodo = Todo(
      //   categoryId: '1',
      //   title: 'Go to Market',
      //   dateTime: DateTime.now(),
      //   description: 'Buy food',
      // );
      // Todo thirdTodo = Todo(
      //   categoryId: '2',
      //   title: 'Finish site optimization',
      //   dateTime: DateTime.now(),
      //   description: 'Do 5 sites optimization',
      // );
      // await txn.insert(todoTableName, firstTodo.toMap());
      // await txn.insert(todoTableName, secondTodo.toMap());
      // await txn.insert(todoTableName, thirdTodo.toMap());
    });
  }
}

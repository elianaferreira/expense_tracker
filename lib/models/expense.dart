import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uui = Uuid();
final formatter = DateFormat.yMd();

enum Category { food, travel, laisure, work }

const categoryIcons = {
  Category.food: Icons.launch_outlined,
  Category.travel: Icons.flight_takeoff_outlined,
  Category.laisure: Icons.movie_outlined,
  Category.work: Icons.work_outlined
};

class Expense {
  Expense(
      {required this.title,
      required this.amount,
      required this.date,
      required this.category})
      : id = uui.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formatedDate {
    return formatter.format(date);
  }
}

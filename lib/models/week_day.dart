import 'package:ecommerce/models/task.dart';
import 'package:flutter/painting.dart';

class WeekDay {
  // id for unplaced
  static const unplaced = 0;
  // id for late tasks
  static const lateTasks = 8;
  // id for achivements
  static const achivements = 9;
  // minimum id
  static const min = 0;
  // maximum id
  static const max = 9;
  // id of first day
  static const daysStart = 1;
  // id of last day
  static const daysEnd = 7;
  final int id;
  final String name;
  final Color color;
  final List<Task> tasks;
  WeekDay({
    required this.id,
    required this.name,
    required this.color,
    required this.tasks,
  });
}

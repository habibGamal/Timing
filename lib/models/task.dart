import 'package:ecommerce/db.dart';
import 'package:ecommerce/models/week_day.dart';

class Task {
  static const _table = 'tasks';
  int? id;
  String name;
  double percent;
  int weekDayId;
  int timeConsume; // in minutes
  Task({
    this.id,
    required this.name,
    this.percent = 0,
    required this.weekDayId,
    this.timeConsume = 0,
  });
  toMap() {
    return {
      'name': name,
      'percent': percent,
      'day': weekDayId,
      'time_consume': timeConsume,
    };
  }

  static Future<List<Task>> getAll() async {
    final database = await db;
    final res = await database.query(_table);
    return [...res.map((element) => toObject(element)).toList()];
  }

  static Future<Task> getRow(int id) async {
    final database = await db;
    final res = await database.query(_table, where: 'id=?', whereArgs: [id]);
    return [...res.map((element) => toObject(element)).toList()][0];
  }

  static Future<Task> getLast() async {
    final database = await db;
    final res = await database.query(_table, orderBy: 'id', limit: 1);
    return [...res.map((element) => toObject(element)).toList()][0];
  }

  static Task toObject(Map<String, Object?> map) {
    final id = map['id'] as int;
    final name = map['name'] as String;
    final percent = map['percent'] as double;
    final weekDayId = map['day'] as int;
    final timeConsume = map['time_consume'] as int;
    return Task(
        id: id,
        percent: percent,
        name: name,
        weekDayId: weekDayId,
        timeConsume: timeConsume);
  }

  static Future<int> insert(Map<String, Object?> values) async {
    final database = await db;
    return await database.insert(_table, values);
  }

  Future<void> update(Task newTask) async {
    final database = await db;
    await database
        .update(_table, newTask.toMap(), where: 'id = ?', whereArgs: [id]);
    name = newTask.name;
    percent = newTask.percent;
    weekDayId = newTask.weekDayId;
    timeConsume = newTask.timeConsume;
  }

  Future<void> moveTo(int weekDayId) async {
    this.weekDayId = weekDayId;
    final database = await db;
    await database.update(_table, toMap(), where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> delete(id) async {
    final database = await db;
    return await database.delete(_table, where: 'id = ?', whereArgs: [id]);
  }
}

import 'package:ecommerce/db.dart';

class Session {
  static const _table = 'history';
  final int? id;
  final String date;
  final int workedMinutes;
  final int modeId;
  Session({
    this.id,
    required this.date,
    required this.workedMinutes,
    required this.modeId,
  });
  int get getWorkedHours => (workedMinutes / 60).floor();
  int get getWorkedMinutes => workedMinutes - getWorkedHours * 60;
  int get getYear => int.parse(date.split('-')[0]);
  int get getMonth => int.parse(date.split('-')[1]);
  int get getDay => int.parse(date.split('-')[2]);
  DateTime get getDate => DateTime.parse(date);
  toMap() {
    return {
      'date': date,
      'worked_minutes': workedMinutes,
      'mode_id': modeId,
    };
  }

  static Future<List<Session>> getAll() async {
    final database = await db;
    final res = await database.query(_table);
    return [...res.map((element) => toObject(element)).toList().reversed];
  }

  static Session toObject(Map<String, Object?> map) {
    final id = map['id'] as int;
    final date = map['date'] as String;
    final workedMinutes = int.parse(map['worked_minutes'] as String);
    final modeId = map['mode_id'] as int;
    return Session(
      id: id,
      date: date,
      workedMinutes: workedMinutes,
      modeId: modeId,
    );
  }

  static Future<void> insert(Map<String, Object?> values) async {
    final database = await db;
    await database.insert(_table, values);
  }

  Future<void> update(Map<String, Object?> values) async {
    final database = await db;
    await database.update(_table, values, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> delete(int id) async {
    final database = await db;
    return await database.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> deleteGroup(List<int> id) async {
    final database = await db;
    final params = id.map((e) => '?').join(',');
    return await database
        .delete(_table, where: 'id IN ($params)', whereArgs: [...id]);
  }
}

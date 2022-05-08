import 'package:ecommerce/db.dart';
import 'package:flutter/material.dart';

class Mode {
  static const _table = 'modes';
  final int? id;
  final String name;
  final Color color;
  final IconData icon;
  // @override
  // final String table = '';
  const Mode(
      {this.id, required this.name, required this.color, required this.icon});

  // handle db
  Map<String, String> toMap() {
    return {
      'name': name,
      'color': color.value.toString(),
      'icon': '${icon.codePoint},${icon.fontFamily},${icon.fontPackage}'
    };
  }

  static Future<List<Mode>> getAll() async {
    final database = await db;
    final res = await database.query(_table);
    return [...res.map((mode) => toObject(mode)).toList()];
  }

  static Mode toObject(Map<String, Object?> map) {
    final id = map['id'] as int;
    final name = map['name'] as String;
    final color = map['color'] as String;
    final icon = map['icon'] as String;
    final iconData = icon.split(',');
    return Mode(
      id: id,
      name: name,
      color: Color(int.parse(color)),
      icon: IconData(
        int.parse(iconData[0]),
        fontFamily: iconData[1],
        fontPackage: iconData[2],
      ),
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

  Future<void> delete() async {
    final database = await db;
    await database.delete(_table, where: 'id = ?', whereArgs: [id]);
  }
}

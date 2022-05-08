import 'package:ecommerce/colors.dart';
import 'package:ecommerce/models/achivement.dart';
import 'package:ecommerce/models/session.dart';
import 'package:ecommerce/store.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

class Achivements extends StatefulWidget {
  const Achivements({Key? key}) : super(key: key);

  @override
  State<Achivements> createState() => _AchivementsState();
}

class _AchivementsState extends State<Achivements> {
  int _days = 1;
  int get minutes {
    return _days * 24 * 60;
  }

  List<Achivement> sessionsToAchivements() {
    final store = Provider.of<Store>(context);
    final List<Map<String, Object>> list = [
      // {id,color,percent}
    ];
    for (Session session in store.sessionsFrom) {
      final index =
          list.indexWhere((element) => element['id'] == session.modeId);
      if (index == -1) {
        // if the mode isn't in the list add it
        list.add({
          'id': session.modeId,
          'color': store.getModeById(session.modeId).color,
          'percent': session.workedMinutes / minutes
        });
      } else {
        // if it exists , increase the percent
        final oldPercent = list[index]['percent'] as double;
        list[index]['percent'] = oldPercent + session.workedMinutes / minutes;
      }
    }
    return list
        .map((item) => Achivement(
            color: item['color'] as Color, percent: item['percent'] as double))
        .toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Provider.of<Store>(context, listen: false)
          .setSessionsFrom(DateTime.now().subtract(Duration(days: 1)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Achivements'),
      ),
      body: ListView(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DropdownButton<int>(
                dropdownColor: MyColors.white,
                value: _days,
                underline: const SizedBox(),
                items: [
                  DropdownMenuItem(
                    child: Text('Today'),
                    value: 1,
                    onTap: () {
                      setState(() {
                        _days = 1;
                      });
                      Provider.of<Store>(context, listen: false)
                          .setSessionsFrom(
                              DateTime.now().subtract(Duration(days: 1)));
                    },
                  ),
                  DropdownMenuItem(
                    child: Text('Last week'),
                    value: 7,
                    onTap: () {
                      setState(() {
                        _days = 7;
                      });
                      Provider.of<Store>(context, listen: false)
                          .setSessionsFrom(
                              DateTime.now().subtract(Duration(days: 7)));
                    },
                  ),
                  DropdownMenuItem(
                    child: Text('Last month'),
                    value: 30,
                    onTap: () {
                      setState(() {
                        _days = 30;
                      });
                      Provider.of<Store>(context, listen: false)
                          .setSessionsFrom(
                              DateTime.now().subtract(Duration(days: 30)));
                    },
                  ),
                  DropdownMenuItem(
                    child: Text('Last year'),
                    value: 360,
                    onTap: () {
                      setState(() {
                        _days = 360;
                      });
                      Provider.of<Store>(context, listen: false)
                          .setSessionsFrom(
                              DateTime.now().subtract(Duration(days: 360)));
                    },
                  ),
                ],
                onChanged: (value) {}),
            IconButton(
              onPressed: () {
                Provider.of<Store>(context, listen: false).setSessionsFrom(
                    DateTime.now().subtract(Duration(days: _days)));
              },
              color: Colors.black54,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
          child: CustomPaint(
            child: Container(),
            painter: AchivCircle(sessionsToAchivements()),
          ),
        ),
      ]),
    );
  }
}

class AchivCircle extends CustomPainter {
  final List<Achivement> list;
  const AchivCircle(this.list);
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    double start = 0;
    for (var item in list) {
      paint.color = item.color;
      final percent = item.percent * 2 * math.pi;
      canvas.drawArc(Rect.fromLTRB(10, 10, size.width - 10, size.height - 10),
          start, percent, true, paint);
      print(start);
      print(percent);
      print('----------');
      start += percent;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

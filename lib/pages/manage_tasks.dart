import 'package:ecommerce/colors.dart';
import 'package:ecommerce/models/week_day.dart';
import 'package:ecommerce/pages/day_tasks.dart';
import 'package:ecommerce/store.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ManageTasks extends StatelessWidget {
  const ManageTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage tasks')),
      body: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          // mainAxisSpacing: 5,
          // crossAxisSpacing: 5,
          childAspectRatio: 1,
        ),
        children: Provider.of<Store>(context, listen: false)
            .weekDays
            .map((weekDay) => WeekDayWidget(weekDay))
            .toList(),
      ),
    );
  }
}

class WeekDayWidget extends StatelessWidget {
  final WeekDay weekDay;
  late final today = DateFormat('EEEE').format(DateTime.now()) == weekDay.name;
  WeekDayWidget(
    this.weekDay, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => DayTasks(weekDay),
          ),
        );
      },
      child: Ink(
        color: weekDay.color,
        child: Container(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                weekDay.name,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              if (today)
                const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

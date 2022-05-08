import 'dart:ffi';

import 'package:ecommerce/colors.dart';
import 'package:ecommerce/enums.dart';
import 'package:ecommerce/models/mode.dart';
import 'package:ecommerce/models/session.dart';
import 'package:ecommerce/packages/notifications.dart';
import 'package:ecommerce/pages/fullscreen_clock.dart';
import 'package:ecommerce/painter/clock_painter.dart';
import 'package:ecommerce/store.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

class Clock extends StatefulWidget {
  const Clock({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _Clock();
  }
}

class _Clock extends State<Clock> with SingleTickerProviderStateMixin {
  TimeState timeState = TimeState.notStarted;
  int _hours = 0;
  int _min = 45;
  late Mode _currentMode;
  double _x = 0;

  late Animation<double> linePositionAnimation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    // init animation controller
    controller = AnimationController(vsync: this);
    linePositionAnimation =
        Tween<double>(begin: 0, end: 100).animate(controller);
    controller.addListener(() {
      setState(() {
        _x = linePositionAnimation.value;
      });
    });
    // make screen wake
    Wakelock.enable();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _hours = Provider.of<Store>(context).blockTimeHour;
    _min = Provider.of<Store>(context).blockTimeMin;
    _currentMode = Provider.of<Store>(context).currentMode;

    controller.duration = Duration(
      // hours: _hours,
      // minutes: _min,
      // for debuging
      seconds: 1,
    );
  }

  void saveSession(status) {
    if (_currentMode.id != null && status == AnimationStatus.completed) {
      Provider.of<Store>(context, listen: false).addNewSession(Session(
          date: DateFormat("yyyy-MM-dd").format(DateTime.now()),
          workedMinutes: _hours * 60 + _min,
          modeId: _currentMode.id!));
      reset();
      NotificationAPI.showNotification(
          title: '🥳 Break Time !', body: 'Your session is ended');
      Wakelock.disable();
    }
  }

  void accedentSaveSession() {
    if (_currentMode.id != null) {
      Provider.of<Store>(context, listen: false).addNewSession(Session(
          date: DateFormat("yyyy-MM-dd").format(DateTime.now()),
          workedMinutes: (((_hours * 60 + _min) / 100) * _x).floor(),
          modeId: _currentMode.id!));
      reset();
    }
  }

  void reset() {
    controller.reset();
    setState(() {
      timeState = TimeState.notStarted;
    });
  }

  void resume() {
    // clear any status listener
    controller.removeStatusListener(saveSession);
    controller.forward();
    setState(() {
      timeState = TimeState.running;
    });
    controller.addStatusListener(saveSession);
  }

  void pause() {
    controller.stop();
    setState(() {
      timeState = TimeState.paused;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RepaintBoundary(
          child: Container(
            alignment: AlignmentDirectional.center,
            margin: const EdgeInsets.only(bottom: 50),
            child: SizedBox(
              width: 200,
              height: 200,
              child: CustomPaint(
                child: Container(
                  alignment: AlignmentDirectional.center,
                  child: Text(
                    _x.toInt().toString(),
                    style: const TextStyle(fontSize: 100),
                  ),
                ),
                painter: ClockPainter(_x),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              child: Text('Reset'),
              onPressed: reset,
            ),
            if (timeState == TimeState.paused)
              ElevatedButton(
                child: const Text('Save'),
                onPressed: accedentSaveSession,
              ),
            if (timeState == TimeState.running)
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FullScreenClock(_x)));
                },
                icon: const Icon(Icons.fit_screen),
              ),
            timeState == TimeState.notStarted
                ? ElevatedButton(
                    child: const Text('start'),
                    onPressed: resume,
                  )
                : (timeState == TimeState.running
                    ? OutlinedButton(
                        child: const Text('Pause'),
                        onPressed: pause,
                      )
                    : OutlinedButton(
                        child: const Text('Resume'),
                        onPressed: resume,
                      )),
          ],
        )
      ],
    );
  }
}

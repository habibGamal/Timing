import 'package:ecommerce/painter/clock_painter.dart';
import 'package:ecommerce/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

class MiniClock extends StatefulWidget {
  final double x;
  const MiniClock(this.x, {Key? key}) : super(key: key);

  @override
  State<MiniClock> createState() => _MiniClockState();
}

class _MiniClockState extends State<MiniClock>
    with SingleTickerProviderStateMixin {
  late double _x = widget.x;
  late Animation<double> linePositionAnimation;
  late AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this);
    linePositionAnimation =
        Tween<double>(begin: _x, end: 100).animate(controller);
    controller.addListener(() {
      setState(() {
        _x = linePositionAnimation.value;
      });
    });
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final hours = Provider.of<Store>(context).blockTimeHour;
    final min = Provider.of<Store>(context).blockTimeMin;

    controller.duration = Duration(
      hours: hours,
      minutes: min,
    );
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
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
    );
  }
}

import 'package:ecommerce/widgets/mini_clock.dart';
import 'package:flutter/material.dart';

class FullScreenClock extends StatelessWidget {
  final double x;
  const FullScreenClock(this.x, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Center(
        child: MiniClock(x),
      ),
    );
  }
}

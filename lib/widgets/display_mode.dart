import 'package:ecommerce/models/mode.dart';
import 'package:flutter/material.dart';

class DisplayMode extends StatelessWidget {
  final Mode mode;
  const DisplayMode(
    this.mode, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(mode.icon),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: FittedBox(child: Text(mode.name)),
        ),
      ],
    );
  }
}

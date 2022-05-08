import 'package:flutter/material.dart';

class SlidePage extends PageRouteBuilder<Widget> {
  final Widget page;
  SlidePage({required this.page})
      : super(
          pageBuilder: (context, animation, animationTwo) => page,
          transitionsBuilder: (context, animation, animationTwo, child) {
            const begin = Offset(1, 0);
            const end = Offset.zero;
            final tween = Tween(begin: begin, end: end);
            final position = animation.drive(tween);
            return SlideTransition(position: position, child: child);
          },
        );
}

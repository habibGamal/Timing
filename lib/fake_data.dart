import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'models/mode.dart';

const List<Mode> modes = [
  Mode(
      name: 'Study',
      color: Color.fromARGB(255, 78, 3, 3),
      icon: FontAwesomeIcons.book),
  Mode(
      name: 'Play',
      color: Color.fromARGB(255, 68, 6, 183),
      icon: FontAwesomeIcons.footballBall),
  Mode(
      name: 'Develop',
      color: Color.fromARGB(255, 99, 2, 119),
      icon: Icons.code),
  Mode(name: 'Work', color: Color.fromARGB(255, 122, 0, 0), icon: Icons.work),
];

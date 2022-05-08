import 'package:ecommerce/colors.dart';
import 'package:ecommerce/constants.dart';
import 'package:ecommerce/pages/achivements.dart';
import 'package:ecommerce/widgets/edit_block_time.dart';
import 'package:ecommerce/widgets/modal.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Navbar extends StatelessWidget {
  const Navbar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: [
        const SizedBox(
          height: 50,
          child: DrawerHeader(
            decoration: BoxDecoration(color: MyColors.vilot),
            child: Text(
              'Navbar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).pushNamed(Routes.manageTasks);
          },
          leading: const Icon(FontAwesomeIcons.tasks, color: MyColors.sky),
          title: const Text('Tasks'),
          subtitle: const Text('Organize the taskes of the week'),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).push(Modal(builder: (context) {
              return EditBlockTime();
            }));
          },
          leading: const Icon(Icons.edit, color: MyColors.sky),
          title: const Text('Edit'),
          subtitle: const Text('Edit the block of time'),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).pushNamed(Routes.sessions);
          },
          leading: const Icon(Icons.history, color: MyColors.sky),
          title: const Text('Log'),
          subtitle: const Text('See your productivity'),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const Achivements()));
          },
          leading:
              const Icon(FontAwesomeIcons.circleNotch, color: MyColors.sky),
          title: const Text('Achivements'),
          subtitle: const Text('See your Achivements'),
        ),
      ],
    ));
  }
}

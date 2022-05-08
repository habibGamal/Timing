import 'package:ecommerce/fake_data.dart';
import 'package:ecommerce/models/mode.dart';
import 'package:ecommerce/models/session.dart';
import 'package:ecommerce/store.dart';
import 'package:ecommerce/widgets/display_mode.dart';
import 'package:ecommerce/widgets/modal.dart';
import 'package:ecommerce/widgets/session_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SessionLog extends StatelessWidget {
  final Session session;
  const SessionLog(
    this.session, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mode = Provider.of<Store>(context)
        .modes
        .firstWhere((mode) => mode.id == session.modeId);
    return ListTile(
      tileColor: mode.color,
      textColor: Colors.white,
      iconColor: Colors.white,
      leading: Container(
        width: 55,
        margin: const EdgeInsets.only(top: 4),
        child: DisplayMode(mode),
      ),
      title: Row(
        children: [
          Text('H : ${session.getWorkedHours}'),
          Container(
            margin: const EdgeInsets.only(left: 8),
            child: Text('M : ${session.getWorkedMinutes}'),
          ),
        ],
      ),
      subtitle: Text(session.date),
      onTap: () {
        Navigator.of(context).push(
            Modal(builder: (context) => SessionController(session, mode)));
      },
    );
  }
}

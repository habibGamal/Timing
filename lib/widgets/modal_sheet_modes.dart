import 'package:ecommerce/enums.dart';
import 'package:ecommerce/models/mode.dart';
import 'package:ecommerce/store.dart';
import 'package:ecommerce/widgets/modes_controller.dart';
import 'package:ecommerce/widgets/modal.dart';
import 'package:ecommerce/widgets/mode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModalSheetModes extends StatelessWidget {
  const ModalSheetModes({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 100,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      padding: const EdgeInsets.all(10),
      children: [
        ...Provider.of<Store>(context)
            .modes
            .map((mode) => ModeWidget(mode))
            .toList(),
        addMode(context),
      ],
    );
  }

  ModeWidget addMode(BuildContext context) {
    return ModeWidget(
      const Mode(
          name: 'Add', color: Color.fromARGB(255, 0, 0, 0), icon: Icons.add),
      specialOnTap: () {
        Navigator.of(context).push(Modal(builder: (context) {
          return const ModesController(
            action: CRUDActions.add,
          );
        }));
      },
    );
  }
}

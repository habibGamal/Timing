import 'package:ecommerce/models/mode.dart';
import 'package:ecommerce/store.dart';
import 'package:ecommerce/widgets/modal.dart';
import 'package:ecommerce/widgets/modes_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/enums.dart';

class ModeWidget extends StatelessWidget {
  final Mode mode;
  final Function? specialOnTap;
  late bool editable;
  ModeWidget(this.mode, {Key? key, this.specialOnTap, this.editable = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (specialOnTap != null) {
          specialOnTap!();
        } else {
          Provider.of<Store>(context, listen: false).setCurrentMode(mode);
          Navigator.of(context).pop();
        }
      },
      onLongPress: () {
        if (editable) {
          Navigator.of(context).push(Modal(builder: (context) {
            return ModesController(mode: mode, action: CRUDActions.edit);
          }));
        }
      },
      splashColor: const Color.fromARGB(19, 255, 255, 255),
      child: Ink(
        color: mode.color,
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  mode.icon,
                  color: Colors.white,
                  size: 25,
                ),
              ),
              FittedBox(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    mode.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

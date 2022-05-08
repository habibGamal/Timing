import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

void pickIcon(
    BuildContext context, void Function(IconData? icon) callback) async {
  IconData? icon = await FlutterIconPicker.showIconPicker(
    context,
    adaptiveDialog: true,
    showTooltips: false,
    showSearchBar: true,
    iconSize: 30,
    iconPickerShape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    iconPackModes: [
      IconPack.fontAwesomeIcons,
      IconPack.lineAwesomeIcons,
    ],
  );
  callback(icon);
}

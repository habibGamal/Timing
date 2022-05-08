import 'package:ecommerce/enums.dart';
import 'package:ecommerce/helpers.dart';
import 'package:ecommerce/models/mode.dart';
import 'package:ecommerce/packages/color_picker.dart';
import 'package:ecommerce/store.dart';
import 'package:ecommerce/widgets/modal_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModesController extends StatefulWidget {
  final Mode? mode;
  final CRUDActions action;
  const ModesController({this.mode, required this.action, Key? key})
      : super(key: key);

  @override
  State<ModesController> createState() => _ModesController();
}

class _ModesController extends State<ModesController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _name = '';
  IconData _icon = Icons.settings;
  Color _color = Colors.amber;
  @override
  void initState() {
    super.initState();
    if (widget.mode != null) {
      _name = widget.mode!.name;
      _icon = widget.mode!.icon;
      _color = widget.mode!.color;
    }
  }

  void changeColor(Color color) {
    setState(() {
      _color = color;
    });
  }

  void addMode() {
    final mode = Mode(name: _name!, color: _color, icon: _icon);
    Provider.of<Store>(context, listen: false).addNewMode(mode);
  }

  void editMode() {
    if (widget.mode != null) {
      final int id = widget.mode!.id!;
      final mode = Mode(name: _name!, color: _color, icon: _icon);
      Provider.of<Store>(context, listen: false).editMode(id, mode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        borderRadius: BorderRadius.circular(10),
        child: Container(
            padding: const EdgeInsets.all(8),
            width: MediaQuery.of(context).size.width * .8,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ModalTitle(
                    widget.action == CRUDActions.add
                        ? 'Add new mode'
                        : 'Edit ${widget.mode!.name} mode',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 8.0,
                    ),
                    child: TextFormField(
                      initialValue: _name,
                      onSaved: (value) => setState(() {
                        _name = value;
                      }),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the mode name';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Mode name',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(8),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => pickIcon(context, (icon) {
                      setState(() {
                        if (icon != null) {
                          _icon = icon;
                        }
                      });
                    }),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            child: const Text('Select an icon'),
                          ),
                          Icon(_icon),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: FastColorPicker(
                      selectedColor: _color,
                      onColorSelected: (color) {
                        setState(() {
                          _color = color;
                        });
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        child: Text(
                            widget.action == CRUDActions.add ? 'Add' : 'Edit'),
                        onPressed: () {
                          final bool valid = _formKey.currentState!.validate();
                          if (valid) {
                            _formKey.currentState!.save();
                            if (widget.action == CRUDActions.add) {
                              addMode();
                            } else {
                              editMode();
                            }
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                      if (widget.action == CRUDActions.edit)
                        IconButton(
                          onPressed: () {
                            Provider.of<Store>(context, listen: false)
                                .deleteMode(widget.mode!.id!);
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.delete),
                        ),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

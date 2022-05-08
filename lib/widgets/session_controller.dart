import 'package:ecommerce/colors.dart';
import 'package:ecommerce/fake_data.dart';
import 'package:ecommerce/models/mode.dart';
import 'package:ecommerce/models/session.dart';
import 'package:ecommerce/store.dart';
import 'package:ecommerce/widgets/display_mode.dart';
import 'package:ecommerce/widgets/modal_title.dart';
import 'package:ecommerce/widgets/mode.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SessionController extends StatefulWidget {
  final Session session;
  final Mode mode;
  const SessionController(this.session, this.mode, {Key? key})
      : super(key: key);
  @override
  State<SessionController> createState() => _SessionController();
}

class _SessionController extends State<SessionController> {
  final _formKey = GlobalKey<FormState>();
  late Mode _mode;
  late int _hours;
  late int _minutes;
  late DateTime _date;
  @override
  void initState() {
    super.initState();
    _mode = widget.mode;
    _hours = widget.session.getWorkedHours;
    _minutes = widget.session.getWorkedMinutes;
    _date = widget.session.getDate;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                  const ModalTitle('Edit Session'),
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DisplayMode(_mode),
                        OutlinedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return GridView(
                                      gridDelegate:
                                          const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 100,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      children: [
                                        ...Provider.of<Store>(context)
                                            .modes
                                            .map((mode) => ModeWidget(
                                                  mode,
                                                  specialOnTap: () {
                                                    setState(() {
                                                      _mode = mode;
                                                    });
                                                  },
                                                  editable: false,
                                                ))
                                            .toList(),
                                      ],
                                    );
                                  });
                            },
                            child: Text('Change Mode')),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text('Hours :'),
                        SizedBox(
                          width: 50,
                          child: TextFormField(
                              initialValue: _hours.toString(),
                              decoration: const InputDecoration(
                                isDense: false,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                              ),
                              scrollPadding: EdgeInsets.zero,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a value';
                                }
                                final v = int.parse(value);
                                if (v < 0 || v > 24) {
                                  return 'Please enter a valid hours';
                                }
                              },
                              onSaved: (value) {
                                setState(() {
                                  _hours = int.parse(value!);
                                });
                              }),
                        ),
                        const Text('Minutes :'),
                        SizedBox(
                          width: 50,
                          child: TextFormField(
                            initialValue: _minutes.toString(),
                            decoration: const InputDecoration(
                              isDense: false,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                            ),
                            scrollPadding: EdgeInsets.zero,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null) {
                                return 'Please enter a value';
                              }
                              final v = int.parse(value);
                              if (v < 0 || v > 60) {
                                return 'Please enter a valid minutes';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _minutes = int.parse(value!);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(DateFormat('yyyy-MM-dd').format(_date)),
                        IconButton(
                          onPressed: () async {
                            // show date
                            final newDate = await showDatePicker(
                              context: context,
                              initialDate: _date,
                              firstDate:
                                  _date.subtract(const Duration(days: 10)),
                              lastDate: DateTime.now(),
                              currentDate: _date,
                            );
                            setState(() {
                              _date = newDate!;
                            });
                          },
                          icon: const Icon(
                            Icons.date_range,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            final valid = _formKey.currentState!.validate();
                            if (valid) {
                              _formKey.currentState!.save();
                              Provider.of<Store>(context, listen: false)
                                  .editSession(
                                      widget.session.id!,
                                      Session(
                                        date: DateFormat('yyyy-MM-dd')
                                            .format(_date),
                                        workedMinutes: _hours * 60 + _minutes,
                                        modeId: _mode.id!,
                                      ));
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text('Save'),
                        ),
                        IconButton(
                          onPressed: () {
                            Provider.of<Store>(context, listen: false)
                                .deleteSession(widget.session.id!);
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.delete),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

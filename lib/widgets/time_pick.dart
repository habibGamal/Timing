import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class TimePick extends StatefulWidget {
  final Function _upValue;
  final int _maxValue;
  final int _initValue;
  const TimePick(this._upValue, this._initValue, this._maxValue, {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TimePick();
  }
}

class _TimePick extends State<TimePick> {
  late int _currentValue;
  @override
  void initState() {
    super.initState();
    _currentValue = widget._initValue;
    widget._upValue(_currentValue);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: NumberPicker(
          minValue: 0,
          maxValue: widget._maxValue,
          value: _currentValue,
          onChanged: (value) {
            setState(() {
              _currentValue = value;
              widget._upValue(value);
            });
          }),
    );
  }
}

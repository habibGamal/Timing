import 'package:flutter/material.dart';

class Modal<T> extends PageRoute<T> {
  final WidgetBuilder _builder;
  Modal({
    required WidgetBuilder builder,
    bool fullscreenDialog = false,
  })  : _builder = builder,
        super(fullscreenDialog: fullscreenDialog);

  @override
  bool get opaque => false;
  @override
  bool get maintainState => true;
  @override
  bool get barrierDismissible => true;
  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
  @override
  Color get barrierColor => Colors.black54;
  @override
  String get barrierLabel => 'Popup dialog open';

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return _builder(context);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}

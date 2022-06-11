// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';

class Routes {
  static to(BuildContext context, Widget screen) {
    return Navigator.push(
      context,
      CupertinoPageRoute(builder: (_) => screen),
    );
  }

  static toReplacement(BuildContext context, Widget screen) {
    return Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (_) => screen),
    );
  }

  static toRemovUntil(BuildContext context, Widget screen) {
    return Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(builder: (_) => screen),
      (route) => false,
    );
  }

  static toPop(BuildContext context) {
    return Navigator.pop(context);
  }

  static toPopUntil(BuildContext context) {
    return Navigator.popUntil(context, (route) => route.isFirst);
  }
}

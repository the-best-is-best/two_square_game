import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

void pushReplacementAll({
  required Widget widget,
  required BuildContext context,
  Duration duration = const Duration(milliseconds: 500),
}) {
  Navigator.pushReplacement(
      context, PageTransition(type: PageTransitionType.fade, child: widget));
}

void push({
  required Widget widget,
  required BuildContext context,
  Duration duration = const Duration(milliseconds: 500),
}) {
  Navigator.push(
      context, PageTransition(type: PageTransitionType.fade, child: widget));
}

import 'package:flutter/material.dart';

mixin NavigateMixin {
  void navigateToWidgetReplacement(BuildContext context, Widget widget) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) {
          return widget;
        },
      ),
    );
  }
}

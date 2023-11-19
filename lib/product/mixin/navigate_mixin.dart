import 'package:flutter/material.dart';

mixin NavigateMixin {
  Future<void> navigateToWidgetReplacement(BuildContext context, Widget widget) async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) {
          return widget;
        },
      ),
    );
  }
}

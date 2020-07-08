import 'package:flutter/material.dart';

class Utilities {
  static void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(text),
        ),
      );

  static Future<void> displayDialogActions(
      context, title, text, List<Widget> widgets, c) {
    showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
                title: Text(title),
                content: Text(text),
                actions: widgets
        ));
  }
}

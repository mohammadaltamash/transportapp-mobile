import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

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

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  static Future<File> getLocalFile(String file) async {
    final path = await _localPath;
    return File('$path/$file');
  }

}

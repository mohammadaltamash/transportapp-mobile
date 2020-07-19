import 'package:flutter/material.dart';
import 'package:transportappmobile/view/screen_arguments.dart';

class ButtonNavigation extends StatelessWidget {
  final int orderId;
  final String text;
  final String routeName;
  final IconData iconData;
  final ScreenArguments arguments;

  const ButtonNavigation(
      {Key key,
      this.orderId,
      this.text,
      this.routeName,
      this.iconData,
      this.arguments})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      icon: Icon(
        iconData,
      ),
      label: Text(text),
      color: Colors.amber,
      onPressed: () {
        Navigator.pushNamed(context, routeName, arguments: arguments);
      },
    );
  }
}

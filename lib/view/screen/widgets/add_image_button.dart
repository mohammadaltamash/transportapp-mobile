import 'package:flutter/material.dart';
import 'package:transportappmobile/constants.dart' as Constants;
import 'package:transportappmobile/view/screen/image_input.dart';
import 'package:transportappmobile/view/screen_arguments.dart';

class AddImageButton extends StatelessWidget {

  final int orderId;
  final String buttonText;
  final String imageType;
  const AddImageButton({Key key, @required this.orderId, @required this.buttonText, @required this.imageType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      icon: Icon(
        Icons.photo_camera,
      ),
      label: Text(buttonText),
      color: Colors.amber,
      onPressed: () {
        Navigator.pushNamed(
            context,
            ImageInput.routeName,
            arguments: ScreenArguments(
                orderId: orderId,
                location: 'Pickup',
                imageType: imageType
            )
        );
      },
    );
  }
}


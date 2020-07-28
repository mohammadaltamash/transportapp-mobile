import 'dart:typed_data';
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_simple_sticker_view/flutter_simple_sticker_view.dart';
import 'package:intl/intl.dart';
import 'package:transportappmobile/model/order.dart';
import 'package:transportappmobile/view/screen/order_detail.dart';
import 'package:transportappmobile/view/screen/utilities.dart';
import 'package:transportappmobile/view/screen/utility/file_uploader.dart';
import 'package:transportappmobile/view/screen_arguments.dart';

//import 'package:image_gallery_saver/image_gallery_saver.dart';
//import 'package:permission_handler/permission_handler.dart';
import '../../constants.dart' as Constants;

class ImageCanvas extends StatefulWidget {
  static const routeName = '/canvas';
  final Order order;
  final String location;
//  final String icon;
  ImageCanvas({this.order, this.location});

  @override
  _ImageCanvasState createState() => _ImageCanvasState(order: order, location: location);
}

class _ImageCanvasState extends State<ImageCanvas> {
  Order order;
  String location;
//  String icon;
  FileUploader fileUploader;
//
//  static Image icon2;
  _ImageCanvasState({this.order, this.location}) {
    fileUploader = FileUploader(order);
//    isPickup = location == Constants.PICKUP;
//    icon2 = location == Constants.PICKUP ? Image.asset("images/gold_dot4.png") : Image.asset("images/red_dot4.png");
  }

//  @override
//  void initState() {
//    super.initState();
//    icon2 = location == Constants.PICKUP ? Image.asset("images/gold_dot4.png") : Image.asset("images/red_dot4.png");
//  }

  ByteData _img = ByteData(0);
  io.File _imageFile;
  String baseUrl = Constants.API_SERVER + '/upload';

  FlutterSimpleStickerView _stickerView = FlutterSimpleStickerView(
    Container(
      decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
              fit: BoxFit.contain,
              image: AssetImage("images/wireframe.png")
//              NetworkImage(
//                  "https://images.unsplash.com/photo-1544032527-042957c6f7ce?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60")

          )),
    ),
    [
//      Image.asset("images/default_profile.png"),
//      Image.asset("images/profile_pic.png"),
//      Image.asset("images/orange.png"),
//      Image.asset("images/gold_dot4.png"),
//      Image.asset("images/red_dot4.png"),
//      icon2,
      Image.asset("images/gold_dot4.png"),
      Image.asset("images/red_dot4.png"),
//      if (location == Constants.PICKUP) Image.asset("images/red_dot4.png"),
//      if (location == Constants.DELIVERY) Image.asset("images/gold_dot4.png"),
//      _buildIcon()
//      _buildIcon(),
      /*Image.asset("assets/icons8-avengers-50.png"),
      Image.asset("assets/icons8-iron-man-50.png"),
      Image.asset("assets/icons8-batman-50.png"),
      Image.asset("assets/icons8-thor-50.png"),
      Image.asset("assets/icons8-venom-head-50.png"),
      Image.asset("assets/icons8-homer-simpson-50.png"),
      Image.asset("assets/icons8-spider-man-head-50.png"),
      Image.asset("assets/icons8-harry-potter-50.png"),
      Image.asset("assets/icons8-genie-lamp-50.png"),
      Image.asset("assets/icons8-cyborg-50.png"),
      Image.asset("assets/icons8-one-ring-50.png"),*/
    ],
    // panelHeight: 150,
    // panelBackgroundColor: Colors.blue,
    // panelStickerBackgroundColor: Colors.pink,
    // panelStickercrossAxisCount: 4,
    // panelStickerAspectRatio: 1.0,
  );

  static Widget _buildIcon() {
//    Widget icon = Container(
//      child: location == Constants.PICKUP ? Image.asset("images/gold_dot4.png") : Image.asset("images/red_dot4.png")
//    );
//    return icon;
//    var icon = <Image>[];
//    icon.add(value)
//    return
//      location == Constants.PICKUP ? Image.asset("images/gold_dot4.png") : Image.asset("images/red_dot4.png");
//    return Image.asset(icon);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Inspection on " + (location == Constants.PICKUP ? "Pickup" : "Delivery")),
          centerTitle: true,
        ),
        body: WillPopScope(
          child: _stickerView,
          onWillPop: () => setOnWillPop(),
        ),
      floatingActionButton: RaisedButton.icon(
        icon: Icon(
          Icons.file_upload,
        ),
        label: Text("Upload"),
        color: Colors.blue,
        onPressed:  () async {
          Uint8List image = await _stickerView.exportImage();
          setState(() {
            _img = ByteData.view(image.buffer);
          });
          _imageFile = await writeData(_img);
//                print(_imageFile);
//                Map<PermissionGroup, PermissionStatus> permissions =
//                await PermissionHandler()
//                    .requestPermissions([PermissionGroup.storage]);
//                await ImageGallerySaver.saveImage(image);
          doUpload();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0)
        ),
      ),
    );
  }

  setOnWillPop() {
    setOrientationAndNavigate();
  }

  setOrientationAndNavigate() {
//    icon2 = null;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pushNamed(
      context,
      OrderDetail.routeName,
      arguments: ScreenArguments(order: this.order),
    );
  }

  Future<io.File> writeData(ByteData img) async {
    final file = await Utilities.getLocalFile('${order.id}_${location}_marking.png');

    // Write the file.
    return await file.writeAsBytes(img.buffer.asUint8List(img.offsetInBytes, img.lengthInBytes));
  }

  doUpload() {
    fileUploader.startUploading(
        baseUrl + '/' + order.id.toString() + '/' + location + '/true/' +
            DateFormat('yyyy-MM-dd - kk:mm').format(DateTime.now()),
        _imageFile, context);
    _resetState();
  }

  void _resetState() {
    setState(() {
      _imageFile = null;
    });
  }

//  @override
//  void dispose() {
////    location = null;
//    icon2 = null;
//    super.dispose();
//  }

  /*Widget _buildUploadBtn() {
    Widget btnWidget = Container();

    if (fileUploader.isUploading) {
      // File is being uploaded then show a progress indicator
      btnWidget = Container(
          margin: EdgeInsets.only(top: 10.0),
          child: CircularProgressIndicator());
    } else if (!fileUploader.isUploading && _imageFile == null) {
//       If image is picked by the user then show a upload btn

      btnWidget = Container(
//      margin: EdgeInsets.only(top: 10.0),
          child: MaterialButton(
            child: Text('Upload'),

            onPressed: () async {
              final sign = _sign.currentState;
              //retrieve image data, do whatever you want with it (send to server, save locally...)
              final image = await sign.getData();
              var data = await image.toByteData(
                  format: ui.ImageByteFormat.png);
              sign.clear();
//          final encoded =
//          base64.encode(data.buffer.asUint8List());
              setState(() {
                _img = data;
              });
              _imageFile = await writeData(_img);
//          debugPrint("onPressed " + encoded);
//          startUploading(baseUrl + '/' + order.id.toString() + '/' + signedBy);
              doUpload();
            },
            color: Colors.green,
            textColor: Colors.white,
          )
      );
    }

    return btnWidget;
  }*/
}

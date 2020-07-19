import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:toast/toast.dart';
import 'package:transportappmobile/constants.dart' as Constants;
import 'package:transportappmobile/model/order.dart';
import 'package:transportappmobile/view/screen/order_detail.dart';
import 'package:transportappmobile/view/screen/utilities.dart';
import 'package:transportappmobile/view/screen_arguments.dart';

class SignaturePad extends StatefulWidget {
  static const routeName = '/signoff';
  final Order order;
  final String signedBy;

  SignaturePad({Key key, @required this.order, this.signedBy}) : super(key: key);

  @override
  _SignaturePadState createState() => _SignaturePadState(order: order, signedBy: signedBy);
}

class _WatermarkPaint extends CustomPainter {
//  final String price;
  final String watermark;

  _WatermarkPaint(this.watermark);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
//    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 10.8,
//        Paint()..color = Colors.blue);
    /*final paragraphStyle = ui.ParagraphStyle(textAlign: TextAlign.center);
    final textStyle = ui.TextStyle(fontSize: 20.0, color: Colors.grey);
    final paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText('Transport App | Order ID # ');
    final paragraph = paragraphBuilder.build()
      ..layout(ui.ParagraphConstraints(width: 100));
    canvas.drawParagraph(paragraph, Offset(size.width / 2 - paragraph.width / 2, size.height / 2));*/
  }

  @override
  bool shouldRepaint(_WatermarkPaint oldDelegate) {
    return oldDelegate != this;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _WatermarkPaint &&
          runtimeType == other.runtimeType &&
//          price == other.price &&
          watermark == other.watermark;

  @override
//  int get hashCode => price.hashCode ^ watermark.hashCode;
  int get hashCode => watermark.hashCode;
}

class _SignaturePadState extends State<SignaturePad> {
  ByteData _img = ByteData(0);
  var color = Colors.black;
  var strokeWidth = 5.0;
  final _sign = GlobalKey<SignatureState>();

  final Order order;
  final String signedBy;
  bool _isUploading = false;
  File _imageFile;
  String baseUrl = Constants.API_SERVER + '/upload';
  int _count = 0;

  _SignaturePadState({this.order, this.signedBy});

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Signature(
                      color: color,
                      key: _sign,
                      onSign: () {
                        final sign = _sign.currentState;
                        debugPrint(
                            '${sign.points.length} points in the signature');
                      },
                      backgroundPainter: _WatermarkPaint("2.0"),
                      strokeWidth: strokeWidth,
                    ),
                  ),
                  color: Colors.black12,
                ),
              ),
              /*_img.buffer.lengthInBytes == 0
                  ? Container()
                  : LimitedBox(
                      maxHeight: 200.0,
                      child: Image.memory(_img.buffer.asUint8List())),*/
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                          onPressed: () {
                            setState(() {
//                              setColor();
//                              color = color == Colors.green
//                                  ? Colors.red
//                                  : Colors.green;
                              if (color == Colors.blue) {
                                color = Colors.red;
                              } else if (color == Colors.red) {
                                color = Colors.green;
                              } else if (color == Colors.green) {
                                color = Colors.black;
                              } else {
                                color = Colors.blue;
                              }
                            });
                            debugPrint("change color");
                          },
                          child: Text("Change color")),
                      MaterialButton(
                          onPressed: () {
                            setState(() {
                              int min = 1;
                              int max = 10;
                              int selection =
                                  min + (Random().nextInt(max - min));
                              strokeWidth = selection.roundToDouble();
                              debugPrint("change stroke width to $selection");
                            });
                          },
                          child: Text("Change width")),
                      _buildUploadBtn(),
                      MaterialButton(
                          color: Colors.grey,
                          onPressed: () {
                            final sign = _sign.currentState;
                            sign.clear();
                            setState(() {
                              _img = ByteData(0);
                            });
                            debugPrint("cleared");
                          },
                          child: Text("Clear")),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
        onWillPop: () => setOnWillPop());
  }

  setOnWillPop() {
    setOrientationAndNavigate();
  }

  setOrientationAndNavigate() {
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

  Widget _buildUploadBtn() {
    Widget btnWidget = Container();

    if (_isUploading) {
      // File is being uploaded then show a progress indicator
      btnWidget = Container(
          margin: EdgeInsets.only(top: 10.0),
          child: CircularProgressIndicator());
    } else if (!_isUploading && _imageFile == null) {
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
          startUploading(baseUrl + '/' + order.id.toString() + '/' + signedBy);
        },
        color: Colors.green,
        textColor: Colors.white,
      )
    );
    }

    return btnWidget;
  }

  Future<File> writeData(ByteData img) async {
    final file = await Utilities.getLocalFile('${order.id}_${signedBy}_signature.png');

    // Write the file.
    return await file.writeAsBytes(img.buffer.asUint8List(img.offsetInBytes, img.lengthInBytes));
  }

  //write to app path
  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  void startUploading(String uploadUrl) async {
    final Map<String, dynamic> response =
    await _uploadImage(uploadUrl);
    print(response);
    // Check if any error occured
    if (response == null || response.containsKey("error")) {
//    if (response == "") {
      Toast.show("Image Upload Failed!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else {
      Toast.show("Image Uploaded Successfully!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      setOrientationAndNavigate();
    }
  }

  Future<Map<String, dynamic>> _uploadImage(
     String uploadUrl) async {
    setState(() {
      _isUploading = true;
    });

    // Find the mime type of the selected file by looking at the header bytes of the file
    final mimeTypeData =
    lookupMimeType(_imageFile.path, headerBytes: [0xFF, 0xD8]).split('/');

    // Intilize the multipart request
//    final imageUploadRequest =
//    http.MultipartRequest('POST', Uri.parse(baseUrl));

    // Attach the file in the request
//    final file = await http.MultipartFile.fromPath('file', image.path,
//        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));

    // Explicitly pass the extension of the image with request body
    // Since image_picker has some bugs due which it mixes up
    // image extension with file name like this filenamejpge
    // Which creates some problem at the server side to manage
    // or verify the file extension
//    imageUploadRequest.fields['ext'] = mimeTypeData[1];

//    imageUploadRequest.files.add(file);

    try {
//      final streamedResponse = await imageUploadRequest.send();

//      final response = await http.Response.fromStream(streamedResponse);

      ////
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(_imageFile.path,
            filename: _imageFile.path.split('/').last,
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1])
        ),
      });
      var dio = Dio();
      final response = await dio.post(uploadUrl, data: formData);
      //      var t= await formData.readAsBytes();  // Stream size.
      //      print(formData.length==t.length);
      ////

//      if (response.statusCode != 200) {
//        return null;
//      }

//      final Map<String, dynamic> responseData = json.decode(response.body);
//      final Map<String, dynamic> responseData = json.decode(response.data);
      final Map<String, dynamic> responseData = response.data;

//    var res = await upload(_imageFile.path, uploadUrl);

    _resetState();

      return responseData;
//    return res;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String> upload(String filename, String url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(http.MultipartFile.fromBytes(
        'file', File(filename).readAsBytesSync(),
        filename: filename.split("/").last,
        contentType: MediaType('image', 'png')
    )
    );
    var res = await request.send();
    return res.reasonPhrase;
  }

  void _resetState() {
    setState(() {
      _isUploading = false;
      _imageFile = null;
    });
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:toast/toast.dart';
import 'package:dio/dio.dart';
import 'package:transportappmobile/model/order.dart';
import 'package:transportappmobile/view/screen/order_detail.dart';
import 'package:transportappmobile/view/screen_arguments.dart';
import 'package:transportappmobile/constants.dart' as Constants;

class FileUploader {

  bool isUploading = false;
  Order order;
  File imageFile;
  String baseUrl = Constants.API_SERVER + '/upload';
  FileUploader(this.order);

  void startUploading(String uploadUrl, File imageFile, BuildContext context) async {
    this.imageFile = imageFile;
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
      setOrientationAndNavigate(context);
    }
  }

  setOrientationAndNavigate(BuildContext context) {
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

  Future<Map<String, dynamic>> _uploadImage(
      String uploadUrl) async {
    /*setState(() {
      _isUploading = true;
    });*/
    isUploading = true;

    // Find the mime type of the selected file by looking at the header bytes of the file
    final mimeTypeData =
    lookupMimeType(imageFile.path, headerBytes: [0xFF, 0xD8]).split('/');

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
        'file': await MultipartFile.fromFile(imageFile.path,
            filename: imageFile.path.split('/').last,
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

//      _resetState();

      return responseData;
//    return res;
    } catch (e) {
      print(e);
      return null;
    }
  }

}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_driving_directions/flutter_driving_directions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DrivingDirections extends StatefulWidget {

  static const routeName = '/directions';
  final double latitude;
  final double longitude;
  final String address;
  DrivingDirections({Key key, @required this.latitude, @required this.longitude, @required this.address}) : super(key: key);

  @override
  _DrivingDirectionsState createState() => _DrivingDirectionsState(latitude: latitude, longitude: longitude, address: address);
}

class _DrivingDirectionsState extends State<DrivingDirections> {

  final double latitude;
  final double longitude;
  final String address;
  _DrivingDirectionsState({this.latitude, this.longitude, this.address});

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      await FlutterDrivingDirections.launchDirections(
          latitude: 42.319935,
          longitude: -84.020364,
          address: '320 Main Street');
    } on PlatformException {
      debugPrint('Failed to launch directions.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Launching navigation\n'),
        ),
      ),
    );
  }
}

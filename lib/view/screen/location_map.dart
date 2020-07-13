import 'dart:async';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_driving_directions/flutter_driving_directions.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transportappmobile/model/order.dart';

class LocationMap extends StatefulWidget {
  static const routeName = '/map';

  final LatLng pickupLatLng;
  final LatLng deliveryLatLng;
  final Order order;

  LocationMap({Key key, @required this.pickupLatLng, @required this.deliveryLatLng, @required this.order}) : super(key: key);

  @override
  State<LocationMap> createState() => LocationMapState(
      pickupLatLng: pickupLatLng, deliveryLatLng: deliveryLatLng, order: order);
}

class LocationMapState extends State<LocationMap> {
  static const double CAMERA_ZOOM = 18;
  static const double CAMERA_TILT = 59.440717697143555;
  static const double CAMERA_BEARING = 30;
  static const double MARKERS_PADDING = 70.0;
  List<Marker> _markers = <Marker>[];
  final LatLng pickupLatLng;
  final LatLng deliveryLatLng;
  final Order order;
  static LatLng midLatLng;
  double latMin;
  double latMax;
  double longMin;
  double longMax;
  bool goToPickupVisible = true;
  bool goToDeliveryVisible = true;
  bool goToInitialVisible = false;
  Color polylineColor = Colors.amber.withOpacity(.5);
  MapType _currentMapType = MapType.normal;
  // for generated polylines
  Set<Polyline> _polylines = {};
  // for each polyline coordinate as Lat and Lng pairs
  List<LatLng> polylineCoordinates = [];
  // this is the key object - the PolylinePoints
  // which generates every polyline
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPIKey = "AIzaSyBsvjitJAvjP780J3gDop7SJ-992B7GU4M";

  LocationMapState({@required this.pickupLatLng, @required this.deliveryLatLng, @required this.order});

  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
//    target: LatLng(37.42796133580664, -122.085749655962),
    target: midLatLng,
//    zoom: 14.4746,
  );

//  static CameraPosition _pickup = CameraPosition(
////      bearing: 192.8334901395799,
//      target: pickupLatLngStatic,
////      tilt: 59.440717697143555,
//      zoom: 19.151926040649414);

//  static final CameraPosition _delivery = CameraPosition(
//      bearing: 192.8334901395799,
//      target: LatLng(37.43296265331129, -122.08832357078792),
//      tilt: 59.440717697143555,
//      zoom: 19.151926040649414);

  @override
  void initState() {
    super.initState();
    _initialize(pickupLatLng, deliveryLatLng);
//    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            myLocationEnabled: true,
            compassEnabled: true,
            tiltGesturesEnabled: true,
            mapToolbarEnabled: true,
//        myLocationButtonEnabled: true,
            markers: Set<Marker>.of(_markers),
            polylines: _polylines,
            mapType: _currentMapType,
            initialCameraPosition: _kGooglePlex,
//        initialCameraPosition: CameraPosition(target: LatLng(0.0, 0.0)),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              controller.animateCamera(CameraUpdate.newLatLngBounds(
                  LatLngBounds(
                    southwest: LatLng(latMin, longMin),
                    northeast: LatLng(latMax, longMax),
                  ),
                  MARKERS_PADDING));
//          _controller.complete(controller);
              setMarkers();
              setPolylines();
            },
          ),
          Positioned(
              bottom: 25,
              left: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RawMaterialButton(
                  onPressed: initPlatformState,
                  child: Icon(
                    Icons.directions,
                    size: 25.0,
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(10.0),
                  shape: CircleBorder(),
                  fillColor: Colors.grey.withOpacity(.5),
                ),
                ConditionalBuilder(
                  condition: goToPickupVisible,
                  builder: (context) {
                    return RawMaterialButton(
                      onPressed: _goToPickup,
                      child: Icon(
                        Icons.arrow_upward,
                        size: 25.0,
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.all(10.0),
                      shape: CircleBorder(),
                      fillColor: Colors.blue.withOpacity(.5),
                    );
                  },
                ),
                ConditionalBuilder(
                  condition: goToDeliveryVisible,
                  builder: (context) {
                    return RawMaterialButton(
                      onPressed: _goToDelivery,
                      child: Icon(
                        Icons.arrow_downward,
                        size: 25.0,
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.all(10.0),
                      shape: CircleBorder(),
                      fillColor: Colors.green.withOpacity(.5),
                    );
                  },
                ),
                ConditionalBuilder(
                    condition: goToInitialVisible,
                    builder: (context) {
                      return RawMaterialButton(
                        onPressed: _goToInitial,
                        child: Icon(
                          Icons.arrow_back,
                          size: 25.0,
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.all(10.0),
                        shape: CircleBorder(),
                        fillColor: Colors.grey.withOpacity(.5),
                      );
                    },
                ),
              ],
            )
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 35.0, horizontal: 15.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: FloatingActionButton(
                onPressed: _onMapTypePressed,
                child: Icon(Icons.map, size: 36.0,),
                backgroundColor: Colors.amber.withOpacity(0.5),
              ),
            )
          )
        ],
      ),
    );
  }

  Future<void> _goToPickup() async {
    setState(() {
      goToPickupVisible = false;
      goToDeliveryVisible = true;
      goToInitialVisible = true;
    });
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: CAMERA_BEARING,
        target: pickupLatLng,
        tilt: CAMERA_TILT,
        zoom: CAMERA_ZOOM)));
  }

  Future<void> _goToDelivery() async {
    setState(() {
      goToPickupVisible = true;
      goToDeliveryVisible = false;
      goToInitialVisible = true;
    });
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: CAMERA_BEARING,
        target: deliveryLatLng,
        tilt: CAMERA_TILT,
        zoom: CAMERA_ZOOM)));
  }

  Future<void> _goToInitial() async {
    setState(() {
      goToPickupVisible = true;
      goToDeliveryVisible = true;
      goToInitialVisible = false;
    });
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(latMin, longMin),
          northeast: LatLng(latMax, longMax),
        ),
        MARKERS_PADDING));
  }

  _initialize(pickupLatLng, deliveryLatLng) {
    setState(() {
      latMin = pickupLatLng.latitude < deliveryLatLng.latitude
          ? pickupLatLng.latitude
          : deliveryLatLng.latitude;
      latMax = pickupLatLng.latitude > deliveryLatLng.latitude
          ? pickupLatLng.latitude
          : deliveryLatLng.latitude;
      longMin = pickupLatLng.longitude < deliveryLatLng.longitude
          ? pickupLatLng.longitude
          : deliveryLatLng.longitude;
      longMax = pickupLatLng.longitude > deliveryLatLng.longitude
          ? pickupLatLng.longitude
          : deliveryLatLng.longitude;
      midLatLng = LatLng((pickupLatLng.latitude + deliveryLatLng.latitude) / 2,
          (pickupLatLng.longitude + deliveryLatLng.longitude) / 2);
//    midLatLng = pickupLatLng;
//    pickupLatLngStatic = pickupLatLng;
    });
  }

  void setMarkers() {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId(pickupLatLng.toString()),
          position: pickupLatLng,
          infoWindow: InfoWindow(
            title: 'Pickup',
            snippet: pickupLatLng.toString(),
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)
      ));
      _markers.add(Marker(
          markerId: MarkerId(deliveryLatLng.toString()),
          position: deliveryLatLng,
          infoWindow: InfoWindow(
              title: 'Drop off',
              snippet: pickupLatLng.toString()
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
      ));
    });
  }

  setPolylines() async {
//    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPIKey,
        PointLatLng(pickupLatLng.latitude, pickupLatLng.longitude),
        PointLatLng(deliveryLatLng.latitude, deliveryLatLng.longitude),
      travelMode: TravelMode.walking
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    /*PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPIKey, // Google Maps API Key
      PointLatLng(pickupLatLng.latitude, pickupLatLng.longitude),
      PointLatLng(deliveryLatLng.latitude, deliveryLatLng.longitude),
      travelMode: TravelMode.transit,
    );

    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }*/
    setState(() {
      Polyline polyline = Polyline(
        polylineId: PolylineId("poly"),
//        color: Color.fromARGB(150, 200, 122, 198),
//          color: Color.fromARGB(100, 172, 174, 1),
          color: polylineColor,
//        color: Colors.red,
        points: polylineCoordinates);
      _polylines.add(polyline);
    });
  }

  void _onMapTypePressed() {
    var mapType;
    setState(() {
      if (_currentMapType == MapType.terrain) {
        _currentMapType = MapType.satellite;
        mapType = "satellite";
      } else if (_currentMapType == MapType.satellite) {
        _currentMapType = MapType.hybrid;
        mapType = "hybrid";
      } else if (_currentMapType == MapType.hybrid) {
        _currentMapType = MapType.normal;
        mapType = "normal";
      } else if (_currentMapType == MapType.normal) {
        _currentMapType = MapType.terrain;
        mapType = "terrain";
      }
    });
    Fluttertoast.showToast(
        msg: "Set to " + mapType,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      await FlutterDrivingDirections.launchDirections(
          latitude: order.pickupLatitude,
          longitude: order.pickupLongitude,
          address: order.deliveryAddress);
    } on PlatformException {
      debugPrint('Failed to launch directions.');
    }
//    try {
//      await FlutterDrivingDirections.launchDirections(
//          latitude: 40.6467233,
//          longitude: -74.0208955,
//          address: '3955 Montgomery Rd');
//    } on PlatformException {
//      debugPrint('Failed to launch directions.');
//    }
//    DrivingDirections(latitude: 40.6467233,
//        longitude: -74.0208955,
//        address: '3955 Montgomery Rd')
//    )
  }
}

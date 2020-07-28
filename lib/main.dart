import 'package:flutter/material.dart';
import 'package:transportappmobile/view/screen/carousel.dart';
import 'package:transportappmobile/view/screen/driving_directions.dart';
import 'package:transportappmobile/view/screen/image_canvas.dart';
import 'package:transportappmobile/view/screen/image_input.dart';
import 'package:transportappmobile/view/screen/images_list.dart';
import 'package:transportappmobile/view/screen/location_map.dart';
import 'package:transportappmobile/view/screen/order_detail.dart';
import 'package:transportappmobile/view/screen/order_list.dart';
import 'package:transportappmobile/view/screen/signature_pad.dart';
import 'package:transportappmobile/view/screen/transport_app.dart';
import 'package:transportappmobile/view/screen_arguments.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();
//  // Obtain a list of the available cameras on the device.
//  final cameras = await availableCameras();
//  // Get a specific camera from the list of available cameras.
//  final firstCamera = cameras.first;
  runApp(MaterialApp(
    home: TransportApp(),
//    home: ImageCanvas(),
//    routes: {
//      OrderDetail.routeName: (context) => OrderDetail(),
//    },
    onGenerateRoute: (settings) {
      if (settings.name == OrderList.routeName) {
        final ScreenArguments args = settings.arguments;
        return MaterialPageRoute(
          builder: (context) {
            return OrderList.fromBase64(args.jwt);
          },
        );
      }
      if (settings.name == OrderDetail.routeName) {
        final ScreenArguments args = settings.arguments;
        return MaterialPageRoute(
          builder: (context) {
            return OrderDetail(order: args.order);
          },
        );
      }
      if (settings.name == LocationMap.routeName) {
        final ScreenArguments args = settings.arguments;
        return MaterialPageRoute(
          builder: (context) {
            return LocationMap(pickupLatLng: args.pickupLatLng, deliveryLatLng: args.deliveryLatLng, order: args.order);
          },
        );
      }
      if (settings.name == DrivingDirections.routeName) {
        final ScreenArguments args = settings.arguments;
        return MaterialPageRoute(
          builder: (context) {
            return DrivingDirections(latitude: args.latitude, longitude: args.longitude, address: args.address);
          },
        );
      }
      if (settings.name == ImageInput.routeName) {
        final ScreenArguments args = settings.arguments;
        return MaterialPageRoute(
          builder: (context) {
            // Get a specific camera from the list of available cameras.
//            final firstCamera = cameras.first;
            return ImageInput(orderId: args.orderId, location: args.location, imageType: args.imageType,);
          },
        );
      }
      if (settings.name == ImagesList.routeName) {
        final ScreenArguments args = settings.arguments;
        return MaterialPageRoute(
          builder: (context) {
            return ImagesList();
          },
        );
      }
      if (settings.name == Carousel.routeName) {
        final ScreenArguments args = settings.arguments;
        return MaterialPageRoute(
          builder: (context) {
            return Carousel(index: args.index, order: args.order, location: args.location, marking: args.marking,);
          },
        );
      }
      if (settings.name == SignaturePad.routeName) {
        final ScreenArguments args = settings.arguments;
        return MaterialPageRoute(
          builder: (context) {
            return SignaturePad(order: args.order, signedBy: args.signedBy);
          },
        );
      }
      if (settings.name == ImageCanvas.routeName) {
        final ScreenArguments args = settings.arguments;
        return MaterialPageRoute(
          builder: (context) {
            return ImageCanvas(order: args.order, location: args.location);
          },
        );
      }
      return null;
    },
  ));
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transportappmobile/model/order.dart';
import 'package:transportappmobile/view/app_drawer.dart';
import 'package:transportappmobile/view/screen/carousel.dart';
import 'package:transportappmobile/view/screen/image_input.dart';
import 'package:transportappmobile/view/screen/location_map.dart';
import 'package:transportappmobile/view/screen/widgets/add_image_button.dart';
import 'package:transportappmobile/view/screen_arguments.dart';
import '../../constants.dart' as Constants;

class OrderDetail extends StatelessWidget {

//  final Order order;
//  OrderDetail({Key key, @required this.order}) : super(key: key);

  static const routeName = '/detail';

  final Order order;
  const OrderDetail({Key key, @required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
//    final ScreenArguments arguments = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(order.brokerOrderId),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text('Pickup: ' + order.pickupAddress + '\n' + 'Delivery: ' + order.deliveryAddress),
              RaisedButton.icon(
                icon: Icon(
                  Icons.map,
                ),
                label: Text('Map'),
                color: Colors.amber,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    LocationMap.routeName,
                    arguments: ScreenArguments(
                        pickupLatLng: LatLng(order.pickupLatitude, order.pickupLongitude),
                        deliveryLatLng: LatLng(order.deliveryLatitude, order.deliveryLongitude),
                        order: order
                    ),
                  );
                },
              ),
              /*RaisedButton.icon(
                icon: Icon(
                  Icons.camera,
                ),
                label: Text('Camera'),
                color: Colors.amber,
                onPressed: () async {
                  final cameras = await availableCameras();
                  // Get a specific camera from the list of available cameras.
                  final firstCamera = cameras.first;
//                  var camera = firstCamera().then((value) => value);
                  Navigator.pushNamed(
                    context,
                    TakePicture.routeName,
                    arguments: ScreenArguments(
                        cameraDescription: firstCamera
                    ),
                  );
                },
              ),*/
              AddImageButton(
                orderId: order.id,
                buttonText: Constants.ADD_PICKUP_IMAGE,
                imageType: Constants.PICKUP,
              ),
              /*RaisedButton.icon(
                icon: Icon(
                  Icons.image,
                ),
                label: Text('Images'),
                color: Colors.amber,
                onPressed: () {
//                  var camera = firstCamera().then((value) => value);
                  Navigator.pushNamed(
                      context,
                      ImagesList.routeName
                  );
                },
              ),*/
              RaisedButton.icon(
                icon: Icon(
                  Icons.view_carousel,
                ),
                label: Text(Constants.PICKUP_IMAGES),
                color: Colors.amber,
                onPressed: () {
//                  var camera = firstCamera().then((value) => value);
                  Navigator.pushNamed(
                    context,
                    Carousel.routeName,
                    arguments: ScreenArguments(
                      index: 0,
                      orderId: order.id,
                      location: 'Pickup'
                    )
                  );
                },
              )
            ],
          ),

//          Text('Pickup: ' + order.pickupAddress + '\n' + 'Delivery: ' + order.deliveryAddress),
        ),
      ),
      drawer: AppDrawer(),
    );
  }

  /*Future<CameraDescription> firstCamera() async {
    // Ensure that plugin services are initialized so that `availableCameras()`
    // can be called before `runApp()`
    WidgetsFlutterBinding.ensureInitialized();

    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    return cameras.first;
  }*/
}

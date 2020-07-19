import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transportappmobile/controller/network_helper.dart';
import 'package:transportappmobile/model/order.dart';
import 'package:transportappmobile/view/app_drawer.dart';
import 'package:transportappmobile/view/screen/carousel.dart';
import 'package:transportappmobile/view/screen/image_input.dart';
import 'package:transportappmobile/view/screen/location_map.dart';
import 'package:transportappmobile/view/screen/signature_pad.dart';
import 'package:transportappmobile/view/screen/widgets/button_navigation.dart';
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
          child: ListView(
            children: <Widget>[
              Text('Pickup: ' + order.pickupAddress),
              Text('Delivery: ' + order.deliveryAddress),
              ButtonNavigation(
                  orderId: order.id,
                  text: Constants.MAP,
                  routeName: LocationMap.routeName,
                  iconData: Icons.map,
                  arguments: ScreenArguments(
                        pickupLatLng: LatLng(order.pickupLatitude, order.pickupLongitude),
                        deliveryLatLng: LatLng(order.deliveryLatitude, order.deliveryLongitude),
                        order: order
                  )),
              ButtonNavigation(
                  orderId: order.id,
                  text: Constants.ADD_PICKUP_IMAGE,
                  routeName: ImageInput.routeName,
                  iconData: Icons.photo_camera,
                  arguments: ScreenArguments(
                    orderId: order.id,
                    location: 'Pickup',
                    imageType: Constants.PICKUP
                  )),
              ButtonNavigation(
                  orderId: order.id,
                  text: Constants.PICKUP_IMAGES,
                  routeName: Carousel.routeName,
                  iconData: Icons.view_carousel,
                  arguments: ScreenArguments(
                    index: 0,
                    orderId: order.id,
                    location: 'Pickup'
                  )),
              SizedBox(
                height: 20.0,
              ),
              Card(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 150.0,
                        child: ButtonNavigation(
                          orderId: order.id,
                          text: Constants.CONSIGNOR_SIGNATURE,
                          routeName: SignaturePad.routeName,
                          iconData: Icons.edit,
                          arguments: ScreenArguments(
                            order: order,
                            signedBy: Constants.CONSIGNOR
                          )
                        ),
                      ),
                    ),
                    _getSignatureImage(Constants.CONSIGNOR)
                  ]
                ),
                elevation: .5,
              ),
              Card(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 150.0,
                        child: ButtonNavigation(
                            orderId: order.id,
                            text: Constants.DRIVER_SIGNATURE,
                            routeName: SignaturePad.routeName,
                            iconData: Icons.edit,
                            arguments: ScreenArguments(
                              order: order,
                              signedBy: Constants.DRIVER
                            )
                        ),
                      ),
                    ),
                    _getSignatureImage(Constants.DRIVER)
                  ],
                ),
                elevation: .5,
              ),

              Card(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 150.0,
                        child: ButtonNavigation(
                            orderId: order.id,
                            text: Constants.CONSIGNEE_SIGNATURE,
                            routeName: SignaturePad.routeName,
                            iconData: Icons.edit,
                            arguments: ScreenArguments(
                              order: order,
                              signedBy: Constants.CONSIGNEE
                            )
                        ),
                      ),
                    ),
                    _getSignatureImage(Constants.CONSIGNEE)
                  ],
                ),
                elevation: .5,
              ),
            ],
          ),

//          Text('Pickup: ' + order.pickupAddress + '\n' + 'Delivery: ' + order.deliveryAddress),
        ),
      ),
      drawer: AppDrawer(),
    );
  }

  FutureBuilder _getSignatureImage(signedBy) {
    return FutureBuilder<String>(
      future: NetworkHelper().getImagesgetByOrderIdAndSignedBy(order.id, signedBy),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          String url = snapshot.data;
          return Expanded(
//            child: Card(
              child: Image.network(
                url,
                fit: BoxFit.contain,
                height: 140.0,
//            alignment: Alignment.topCenter,
              width: MediaQuery.of(context).size.width,
              ),
//            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
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

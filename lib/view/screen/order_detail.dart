import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transportappmobile/controller/network_helper.dart';
import 'package:transportappmobile/model/order.dart';
import 'package:transportappmobile/view/app_drawer.dart';
import 'package:transportappmobile/view/screen/carousel.dart';
import 'package:transportappmobile/view/screen/image_canvas.dart';
import 'package:transportappmobile/view/screen/image_input.dart';
import 'package:transportappmobile/view/screen/location_map.dart';
import 'package:transportappmobile/view/screen/signature_pad.dart';
import 'package:transportappmobile/view/screen/widgets/button_navigation.dart';
import 'package:transportappmobile/view/screen_arguments.dart';

import '../../constants.dart' as Constants;

class OrderDetail extends StatelessWidget {

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
          padding: EdgeInsets.all(10.0),
          child: ListView(
            children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      cardHeading('Summary'),
                      Text('Pickup address: ' + order.pickupAddress),
                      Text('Delivery address: ' + order.deliveryAddress),
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
                    ],
                  ),
                ),
                elevation: .5,
              ),
              SizedBox(
                height: 10.0,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      cardHeading('Pickup'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ButtonNavigation(
                            orderId: order.id,
                            text: Constants.ADD_PICKUP_IMAGE,
                            routeName: ImageInput.routeName,
                            iconData: Icons.photo_camera,
                            arguments: ScreenArguments(
                              orderId: order.id,
                              location: Constants.PICKUP,
                              imageType: Constants.PICKUP
                            )),
                          ButtonNavigation(
                              orderId: order.id,
                              text: Constants.PICKUP_IMAGES,
                              routeName: Carousel.routeName,
                              iconData: Icons.view_carousel,
                              arguments: ScreenArguments(
                                  index: 0,
                                  order: order,
                                  location: Constants.PICKUP,
                                  marking: false
                              )),
                        ],
                      ),
//                  SizedBox(width: 15.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ButtonNavigation(
                              orderId: order.id,
                              text: Constants.INSPECT_ON_PICKUP,
                              routeName: ImageCanvas.routeName,
                              iconData: Icons.directions_car,
                              arguments: ScreenArguments(
                                order: order,
                                location: Constants.PICKUP,
                              )),
                          ButtonNavigation(
                              orderId: order.id,
                              text: Constants.PICKUP_INSPECTIONS,
                              routeName: Carousel.routeName,
                              iconData: Icons.view_carousel,
                              arguments: ScreenArguments(
                                  index: 0,
                                  order: order,
                                  location: Constants.PICKUP,
                                  marking: true
                              )),
                        ],
                      ),
                    ]
                  ),
                ),
                elevation: .5,
              ),
              SizedBox(
                height: 10.0,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      cardHeading('Delivery'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ButtonNavigation(
                              orderId: order.id,
                              text: Constants.ADD_DELIVERY_IMAGE,
                              routeName: ImageInput.routeName,
                              iconData: Icons.photo_camera,
                              arguments: ScreenArguments(
                                orderId: order.id,
                                location: Constants.DELIVERY,
                                imageType: Constants.DELIVERY
                              )),
                          ButtonNavigation(
                              orderId: order.id,
                              text: Constants.DELIVERY_IMAGES,
                              routeName: Carousel.routeName,
                              iconData: Icons.view_carousel,
                              arguments: ScreenArguments(
                                  index: 0,
                                  order: order,
                                  location: Constants.DELIVERY,
                                  marking: false
                              )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ButtonNavigation(
                              orderId: order.id,
                              text: Constants.INSPECT_ON_DELIVERY,
                              routeName: ImageCanvas.routeName,
                              iconData: Icons.directions_car,
                              arguments: ScreenArguments(
                                  order: order,
                                  location: Constants.DELIVERY
                              )),
                          ButtonNavigation(
                              orderId: order.id,
                              text: Constants.DELIVERY_INSPECTIONS,
                              routeName: Carousel.routeName,
                              iconData: Icons.view_carousel,
                              arguments: ScreenArguments(
                                  index: 0,
                                  order: order,
                                  location: Constants.DELIVERY,
                                  marking: true
                              )),
                        ],
                      ),
                      ]
                  ),
                ),
                elevation: .5,
              ),
              SizedBox(
                height: 10.0,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      cardHeading('Sign Off'),
                      Row(
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
                      Row(
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
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 140.0,
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
                      )
                    ]
                  ),
                ),
                elevation: .5,
              ),
//              SizedBox(
//                height: 10.0,
//              ),
             /* Card(
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
              SizedBox(
                height: 10.0,
              ),
              Card(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 140.0,
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
              ),*/
            ],
          ),

//          Text('Pickup: ' + order.pickupAddress + '\n' + 'Delivery: ' + order.deliveryAddress),
        ),
      ),
      drawer: AppDrawer(),
    );
  }

  cardHeading(heading) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(heading,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 20.0,
            color: Colors.grey
        ),
      ),
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
}

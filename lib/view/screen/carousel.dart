import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:photo_view/photo_view.dart';
import 'package:transportappmobile/controller/network_helper.dart';
import 'package:transportappmobile/model/order.dart';
import 'package:transportappmobile/view/screen/image_canvas.dart';
import 'package:transportappmobile/view/screen/image_input.dart';
import 'package:transportappmobile/view/screen/widgets/button_navigation.dart';
import 'package:transportappmobile/view/screen_arguments.dart';

import '../../constants.dart' as Constants;

class Carousel extends StatelessWidget {
  static const routeName = '/carousel';

  final int index;
  final Order order;
  final String location;
  final bool marking;
  Carousel({this.index, this.order, this.location, this.marking});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
//        appBar: AppBar(
//          title: Text("ExampleHorizontal"),
//        ),
        /* body: new Swiper(
          itemBuilder: (BuildContext context, int index) {
//            return new Image.asset(
//              images[index],
//              fit: BoxFit.fill,
//            );
            return PhotoView(
              imageProvider: AssetImage(images[index]),
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: 4.0,
            );
          },
          indicatorLayout: PageIndicatorLayout.COLOR,
          autoplay: false,
          itemCount: images.length,
          pagination: new SwiperPagination(),
          control: new SwiperControl(),
        )*/
        body: Center(
          child: FutureBuilder<List<dynamic>>(
//          future: NetworkHelper().getImagesByOrderIdAndLocation(orderId, location),
            future: marking ? NetworkHelper().getByOrderIdLocationAndMarking(order.id, location) : NetworkHelper().getImagesByOrderIdAndLocation(order.id, location) ,
            builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {

            if (snapshot.hasData) {
              List<dynamic> data = snapshot.data;
              if (data.length == 0) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(getTitle()),
                    centerTitle: true,
                  ),
                  body: Center(
                    /*child: AddImageButton(
                      orderId: orderId,
                      buttonText: location == 'Pickup' ? Constants.ADD_PICKUP_IMAGE : Constants.ADD_DELIVERY_IMAGE,
                      imageType: Constants.PICKUP,
                    )*/
                    child: getAddImageButton(),
                  )

                );
              }
//              return _images(data, context);
              return new Swiper(
                itemBuilder: (BuildContext context, int index) {
//                  return new Image.network(
//                    data[index],
//                    fit: BoxFit.contain,
//                  );
                  return PhotoView(
                    imageProvider: NetworkImage(data[index]),
                    minScale: PhotoViewComputedScale.contained * 0.8,
                    maxScale: 4.0,
                  );
                },
                indicatorLayout: PageIndicatorLayout.COLOR,
                index: index,
                autoplay: false,
                itemCount: data.length,
                pagination: new SwiperPagination(),
                control: new SwiperControl(),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        )));
  }

  getTitle() {
    if (marking) {
      return location == 'Pickup' ? Constants.PICKUP_INSPECTIONS : Constants.DELIVERY_INSPECTIONS;
    } else {
      return location == 'Pickup' ? Constants.PICKUP_IMAGES : Constants.DELIVERY_IMAGES;
    }
  }

  getAddImageButton() {
    if (marking) {
      return location == 'Pickup' ?
      ButtonNavigation(
          orderId: order.id,
          text: Constants.INSPECT_ON_PICKUP,
          routeName: ImageCanvas.routeName,
          iconData: Icons.directions_car,
          arguments: ScreenArguments(
            order: order,
            location: Constants.PICKUP,
          )) :
      ButtonNavigation(
          orderId: order.id,
          text: Constants.INSPECT_ON_DELIVERY,
          routeName: ImageCanvas.routeName,
          iconData: Icons.directions_car,
          arguments: ScreenArguments(
            order: order,
            location: Constants.DELIVERY,
          ));
    } else {
      return location == 'Pickup' ?
      ButtonNavigation(
          orderId: order.id,
          text: Constants.ADD_PICKUP_IMAGE,
          routeName: ImageInput.routeName,
          iconData: Icons.photo_camera,
          arguments: ScreenArguments(
              orderId: order.id,
              location: Constants.PICKUP,
              imageType: Constants.PICKUP
          )) :
      ButtonNavigation(
          orderId: order.id,
          text: Constants.ADD_DELIVERY_IMAGE,
          routeName: ImageInput.routeName,
          iconData: Icons.photo_camera,
          arguments: ScreenArguments(
              orderId: order.id,
              location: Constants.DELIVERY,
              imageType: Constants.DELIVERY
          ));
    }
  }


}

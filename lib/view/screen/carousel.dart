import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:photo_view/photo_view.dart';
import 'package:transportappmobile/controller/network_helper.dart';
import 'package:transportappmobile/view/screen/widgets/add_image_button.dart';
import '../../constants.dart' as Constants;

class Carousel extends StatelessWidget {
  static const routeName = '/carousel';

  final int index;
  final int orderId;
  final String location;
  Carousel({this.index, this.orderId, this.location});

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
          future: NetworkHelper().getImagesByOrderIdAndLocation(orderId, location),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {

            if (snapshot.hasData) {
              List<dynamic> data = snapshot.data;
              if (data.length == 0) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(location == 'Pickup' ? Constants.PICKUP_IMAGES : Constants.DELIVERY_IMAGES),
                    centerTitle: true,
                  ),
                  body: Center(
                    child: AddImageButton(
                      orderId: orderId,
                      buttonText: location == 'Pickup' ? Constants.ADD_PICKUP_IMAGE : Constants.ADD_DELIVERY_IMAGE,
                      imageType: Constants.PICKUP,
                    )
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
}

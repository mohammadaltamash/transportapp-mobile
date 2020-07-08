import 'package:transportappmobile/model/order.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ScreenArguments {
  final Order order;
  final LatLng pickupLatLng;
  final LatLng deliveryLatLng;
  final double latitude;
  final double longitude;
  final String address;
  final int orderId; // ImageInput, Carousel
  final String location; // ImageInput, Carousel
  final String imageType; // ImageInput
  final int index; // Carousel
  final String jwt;
  ScreenArguments(
      {this.order,
      this.pickupLatLng,
      this.deliveryLatLng,
      this.latitude,
      this.longitude,
      this.address,
      this.orderId,
      this.location,
      this.imageType,
      this.index,
      this.jwt});
}

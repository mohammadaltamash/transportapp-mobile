import 'package:transportappmobile/model/order.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ScreenArguments {
  final Order order;
  final LatLng pickupLatLng;
  final LatLng deliveryLatLng;
  final double latitude; // DrivingDirections
  final double longitude; // DrivingDirections
  final String address; // DrivingDirections
  final int orderId; // ImageInput, Carousel
  final String location; // ImageInput, Carousel
  final String imageType; // ImageInput
  final int index; // Carousel
  final String jwt;
  final String signedBy; // SignaturePad
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
      this.jwt,
      this.signedBy});
}

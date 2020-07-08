import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

@JsonSerializable()
class Order {
  final int id;
  final String brokerOrderId;
  final bool enclosedTrailer;
  final bool m22Inspection;
  final String pickupContactName;
  final String pickupCompanyName;
  final String pickupAddress;
  final String pickupAddressState;
  final String pickupZip;
  final double pickupLatitude;
  final double pickupLongitude;
  final Map<String, String> pickupPhones;
  final bool pickupSignatureNotRequired;
  final Map<String, DateTime> pickupDates;
  final DateTime preferredPickupDate;
  final DateTime committedPickupDate;
  final String pickupDatesRestrictions;
  final String deliveryContactName;
  final String deliveryCompanyName;
  final String deliveryAddress;
  final String deliveryAddressState;
  final String deliveryZip;
  final double deliveryLatitude;
  final double deliveryLongitude;
  final Map<String, String> deliveryPhones;
  final bool deliverySignatureNotRequired;
  final Map<String, DateTime> deliveryDates;
  final DateTime preferredDeliveryDate;
  final DateTime committedDeliveryDate;
  final String deliveryDatesRestrictions;
  final int vehicleYear;
  final String vehicleMake;
  final String vehicleModel;
  final String vehicleAutoType;
  final String vehicleColor;
  final String vehicleVIN;
  final String vehicleLOTNumber;
  final String vehicleBuyerId;
  final bool vehicleInoperable;
  final String dispatchInstructions;
  final double carrierPay;
  final String daysToPay;
  final double amountOnPickup;
  final String paymentOnPickupMethod;
  final double amountOnDelivery;
  final String paymentOnDeliveryMethod;
  final String paymentTermBusinessDays;
  final String paymentMethod;
  final String paymentTermBegins;
  final String paymentNotes;
  final String brokerContactName;
  final String brokerCompanyName;
  final String brokerAddress;
  final String brokerZip;
  final double brokerLatitude;
  final double brokerLongitude;
  final Map<String, String> shipperPhones;
  final String brokerEmail;
  final String orderStatus;
  final String orderCategory;
//  final List<OrderCarrierDto> bookingRequestCarriers;
//  final List<OrderCarrierDto> bookedCarriers;
//  final UserDto assignedToCarrier;
//  final UserDto assignedToDriver;
  final int distance;
  final double perMile;
  final double radiusPickupDistance;
  final double radiusDeliveryDistance;
  final String termsAndConditions;

//  final UserDto createdBy;
//  final LocalDateTime createdAt;
//  final LocalDateTime updatedAt;
  Order(this.id, this.brokerOrderId, this.enclosedTrailer, this.m22Inspection, this.pickupContactName, this.pickupCompanyName, this.pickupAddress, this.pickupAddressState, this.pickupZip, this.pickupLatitude, this.pickupLongitude, this.pickupPhones, this.pickupSignatureNotRequired, this.pickupDates, this.preferredPickupDate, this.committedPickupDate, this.pickupDatesRestrictions, this.deliveryContactName, this.deliveryCompanyName, this.deliveryAddress, this.deliveryAddressState, this.deliveryZip, this.deliveryLatitude, this.deliveryLongitude, this.deliveryPhones, this.deliverySignatureNotRequired, this.deliveryDates, this.preferredDeliveryDate, this.committedDeliveryDate, this.deliveryDatesRestrictions, this.vehicleYear, this.vehicleMake, this.vehicleModel, this.vehicleAutoType, this.vehicleColor, this.vehicleVIN, this.vehicleLOTNumber, this.vehicleBuyerId, this.vehicleInoperable, this.dispatchInstructions, this.carrierPay, this.daysToPay, this.amountOnPickup, this.paymentOnPickupMethod, this.amountOnDelivery, this.paymentOnDeliveryMethod, this.paymentTermBusinessDays, this.paymentMethod, this.paymentTermBegins, this.paymentNotes, this.brokerContactName, this.brokerCompanyName, this.brokerAddress, this.brokerZip, this.brokerLatitude, this.brokerLongitude, this.shipperPhones, this.brokerEmail, this.orderStatus, this.orderCategory, this.distance, this.perMile, this.radiusPickupDistance, this.radiusDeliveryDistance, this.termsAndConditions);

  factory Order.fromJson(Map<String, dynamic> json) =>_$OrderFromJson(json);
  Map<String, dynamic> toJson() =>_$OrderToJson(this);
}


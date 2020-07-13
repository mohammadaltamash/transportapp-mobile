import 'package:http/http.dart' as http;
import 'package:transportappmobile/model/order.dart';
import 'package:transportappmobile/model/user.dart';
import '../constants.dart' as Constants;
import 'dart:convert';

class NetworkHelper {

//  getAllOrders() {
//
//  }

  Future<String> test() async {
    final res = await http.get(Constants.API_SERVER + '/test');
    if (res.statusCode == 200) {
//      var json = jsonDecode(res.body);
      return res.body;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<List<Order>> getOrders() async {
    final res = await http.get(Constants.API_SERVER + '/order/get');
    if (res.statusCode == 200) {
//      var json = jsonDecode(res.body);
      List json = jsonDecode(res.body);
//      List data = json['data'];
      return json.map((o) => Order.fromJson(o)).toList();
//      return List<Order>.from(jason).map((Map order) => Order.fromJson(order)).toList();
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<List<Order>> getOrdersByAssignedToDriver(String email, String jwt) async {
    final res = await http.get(Constants.API_SERVER + '/order/driver/$email', headers: {"Authorization": "Bearer " + jwt});
    if (res.statusCode == 200) {
//      var json = jsonDecode(res.body);
      List json = jsonDecode(res.body);
//      List data = json['data'];
      return json.map((o) => Order.fromJson(o)).toList();
//      return List<Order>.from(jason).map((Map order) => Order.fromJson(order)).toList();
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<List<dynamic>> getImages() async {
    final res = await http.get(Constants.API_SERVER + '/files/image');
    if (res.statusCode == 200) {
//      var json = jsonDecode(res.body);
      List<dynamic> json = jsonDecode(res.body);
//      List data = json['data'];
      return json;
//      return List<Order>.from(jason).map((Map order) => Order.fromJson(order)).toList();
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<List<dynamic>> getImagesByOrderIdAndLocation(int orderId, String location) async {
    final res = await http.get(Constants.API_SERVER + '/files/image/$orderId/$location');
    if (res.statusCode == 200) {
//      var json = jsonDecode(res.body);
      List<dynamic> json = jsonDecode(res.body);
//      List data = json['data'];
      return json;
//      return List<Order>.from(jason).map((Map order) => Order.fromJson(order)).toList();
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<List<dynamic>> getAllCompanies() async {
    final res = await http.get(Constants.API_SERVER + '/company/get');
    if (res.statusCode == 200) {
//      var json = jsonDecode(res.body);
//      List<dynamic> json = jsonDecode(res.body);
//      List data = json['data'];
      return jsonDecode(res.body).map((e) => e['companyName']).toList();
//      List<User>.from(json).map((Map company) => User.fromJson(company)).toList();
//      return json;
//      return List<User>.from(json).map((Map company) => User.fromJson(company)).toList();
    } else {
      throw Exception('Failed to fetch data');
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:transportappmobile/controller/network_helper.dart';
import 'package:transportappmobile/model/order.dart';
import 'package:transportappmobile/view/screen/auth/login_page.dart';
import 'package:transportappmobile/view/screen/order_detail.dart';
import 'package:transportappmobile/view/screen/utilities.dart';
import 'package:transportappmobile/view/screen_arguments.dart';
import 'package:transportappmobile/view/app_drawer.dart';
import '../../constants.dart' as Constants;
import 'dart:convert' show json, base64, utf8;

class OrderList extends StatefulWidget {
  static const routeName = '/order_list';
  final String jwt;
  final Map<String, dynamic> payload;

  OrderList(this.jwt, this.payload);

  factory OrderList.fromBase64(String jwt) => OrderList(
        jwt,
        json.decode(
            utf8.decode(base64.decode(base64.normalize(jwt.split(".")[1])))),
      );

  @override
  _OrderListState createState() => _OrderListState(jwt: jwt, payload: payload);
}

class _OrderListState extends State<OrderList> {
  String jwt;
  Map<String, dynamic> payload;
  _OrderListState({this.payload, this.jwt});
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
                  title: Text('Warning'),
                  content: Text('Do you really want to exit'),
                  actions: [
                    FlatButton(
                      child: Text('Yes'),
                      onPressed: () {
                        Navigator.pop(c, true);
                      },
                    ),
                    FlatButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.pop(c, false);
                      },
                    )
                  ])),
      child: Scaffold(
        appBar: AppBar(
          title: Text(Constants.ORDERS_TITLE),
          centerTitle: true,
        ),
        body: Center(
          child: _ordersData(payload['sub'], jwt),
        ),
        drawer: AppDrawer(),
      ),
    );
  }
}

FutureBuilder _ordersData(String email, String jwt) {
  return FutureBuilder<List<Order>>(
    future: NetworkHelper().getOrdersByAssignedToDriver(email, jwt),
    builder: (BuildContext context, AsyncSnapshot<List<Order>> snapshot) {
      if (snapshot.hasData) {
        List<Order> data = snapshot.data;
        return _orders(data, context);
      } else if (snapshot.hasError) {
        return Text("${snapshot.error}");
      }
      return CircularProgressIndicator();
    },
  );
}

ListView _orders(data, context) {
  return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Card(
          child: _tile(data[index], context),
        );
      });
}

ListTile _tile(Order order, context) {
  return ListTile(
    title: Text(
      order.brokerOrderId + ' #' + order.id.toString() + ' ' + order.orderStatus,
      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
    ),
    subtitle: Text(order.pickupAddress),
//    onTap: () => _showOrderDetail(context, order),
    onTap: () {
      Navigator.pushNamed(
        context,
        OrderDetail.routeName,
        arguments: ScreenArguments(order: order),
      );
    },
  );
}

//_showOrderDetail(context, ord) {
//    Navigator.push(
//      context,
//      MaterialPageRoute(
//        builder: (context) => OrderDetail(order: ord),
//      ),
//    );
//}

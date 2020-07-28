import 'dart:convert';
import 'dart:convert' show json, base64, utf8;

import 'package:flutter/material.dart';
import 'package:stomp/stomp.dart';
import 'package:transportappmobile/constants.dart' as Constants;
import 'package:transportappmobile/controller/network_helper.dart';
import 'package:transportappmobile/model/order.dart';
import 'package:transportappmobile/service/app_stomp_client.dart' show connect;
import 'package:transportappmobile/view/app_drawer.dart';
import 'package:transportappmobile/view/screen/order_detail.dart';
import 'package:transportappmobile/view/screen_arguments.dart';

class OrderList extends StatefulWidget {
  static const routeName = '/order_list';
  final String jwt;
  final Map<String, dynamic> payload;
//  WebSocketChannel channel = WebSocketChannel.connect(Uri.parse('ws://echo.websocket.org'));

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
  final inputController = TextEditingController();
  int count = 0;
  StompClient stompClient;
  FutureBuilder _ordersData;
  String message = 'No message';

  _OrderListState({this.payload, this.jwt}) {
    /*dynamic Function(StompClient, StompFrame) onConnect = (StompClient client, StompFrame frame) {
      print('printed on console');
    client.subscribe(
        destination: '/topic/message',
        callback: (StompFrame frame) {
          List<dynamic> result = json.decode(frame.body);
          print(result);
        });
    };*/
//    stompClient = StompClientHelper.getStompClient(onConnect);
//    stompClient.activate();
    _ordersData = _getOrdersData(payload['sub'], jwt);
//    stompClient.subscribe(destination: '/topic/message',
//        callback: (StompFrame frame) {
//          List<dynamic> result = json.decode(frame.body);
//          print(result);
//        });
  }

  @override
  void initState() {
    super.initState();
    /*stompClient.activate();
    stompClient.subscribe(destination: '/topic/message',
        callback: (StompFrame frame) {
          List<dynamic> result = json.decode(frame.body);
          print(result);
        });*/

    connect(Constants.STOMP_CLIENT_URL).then((stompClient) {
      this.stompClient = stompClient;
      stompClient.subscribeString("123", "/topic/message", (Map<String, String> headers, String message) {
        print("receive message: " + message);
        if (message == 'DRIVER_ASSIGNED') {
          setState(() {
            this.message = message;
            _ordersData = _getOrdersData(payload['sub'], jwt);
          });
        }
      });
    }, onError: (error) {
      print("connect failed");
    });
  }

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
          child: _ordersData,
            /*child: Center(
              child: RaisedButton(
                onPressed: () {
                  setState(() {
                    count++;
                  });
                  stompClient.send(destination: '/app/message', body: 'Hello ' + count.toString());
                },
                child: Text("Send message"),
              ),
            )*/
        ),
        drawer: AppDrawer(),
      ),
    );
  }

  @override
  void dispose() {
//    stompClient.deactivate();
    super.dispose();
  }

  /*static dynamic onConnect(StompClient client, StompFrame frame) {
    print('printed on console');
    client.subscribe(
        destination: '/topic/message',
        callback: (StompFrame frame) {
//          List<dynamic> result = json.decode(frame.body);
          String message = frame.body;
//          print(result);
          print(message);
          if (message == 'REFRESH') {
            _ordersData = _getOrdersData(payload['sub'], jwt);
          }
        });

//  Timer.periodic(Duration(seconds: 10), (_) {
//    client.send(
//        destination: '/app/message', body: json.encode({'From flutter app': 123}));
//  });
  }

  final stompClient = StompClient(
      config: StompConfig(
        url: Constants.STOMP_CLIENT_URL,
        onConnect: onConnect,
        onWebSocketError: (dynamic error) => print(error.toString()),
//        stompConnectHeaders: {'Authorization': 'Bearer ' + jwt},
//        webSocketConnectHeaders: {'Authorization': 'Bearer ' + jwt}
      ));*/
}

FutureBuilder _getOrdersData(String email, String jwt) {
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
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          order.brokerOrderId + ' #' + order.id.toString(),
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        ),
        Text(
            order.orderStatus
        )
      ],
    ),
    subtitle: listItem(context, order),
    /*leading: Text(
      order.orderStatus,
      style: TextStyle(fontWeight: FontWeight.w100, fontSize: 10, color: Colors.green),
    ),*/
//    trailing: Icon(Icons.save),
    onTap: () {
      Navigator.pushNamed(
        context,
        OrderDetail.routeName,
        arguments: ScreenArguments(order: order),
      );
    },
  );
}

Widget listItem(BuildContext context, Order order) {
  return Column(
    children: <Widget>[
      /*Container(
        child: Text(
          order.brokerOrderId + ' #' + order.id.toString() + ' ' + order.orderStatus,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        )
      ),*/
      Container(
        child: Text(order.pickupAddress)
      ),
      Container(
          child: Text(order.deliveryAddress)
      )
    ],
  );
}

/*
dynamic onConnect(StompClient client, StompFrame frame) {
  print('printed on console');
  client.subscribe(
      destination: '/topic/message',
      callback: (StompFrame frame) {
//          List<dynamic> result = json.decode(frame.body);
        String message = frame.body;
//          print(result);
        print(message);
        if (message == 'REFRESH') {
//          _ordersData = _getOrdersData(payload['sub'], jwt);

//          Navigator.push(
//            null,
//            OrderList.routeName
////            arguments: ScreenArguments(jwt: token),
//          );
//          new GlobalKey<NavigatorState>().currentState.pushNamed(OrderList.routeName);
        }
      });

//  Timer.periodic(Duration(seconds: 10), (_) {
//    client.send(
//        destination: '/app/message', body: json.encode({'From flutter app': 123}));
//  });
}

final stompClient = StompClient(
    config: StompConfig(
  url: Constants.STOMP_CLIENT_URL,
  onConnect: onConnect,
  onWebSocketError: (dynamic error) => print(error.toString()),
//        stompConnectHeaders: {'Authorization': 'Bearer ' + jwt},
//        webSocketConnectHeaders: {'Authorization': 'Bearer ' + jwt}
));*/

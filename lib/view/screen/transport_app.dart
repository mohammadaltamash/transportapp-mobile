import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:transportappmobile/constants.dart' as Constants;
import 'package:transportappmobile/view/screen/auth/login_page.dart';
import 'dart:convert' show json, base64, utf8;

import 'package:transportappmobile/view/screen/order_list.dart';

final storage = FlutterSecureStorage();

class TransportApp extends StatelessWidget {

  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if (jwt == null) {
      return "";
    }
    return jwt;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: jwtOrEmpty,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          if (snapshot.data != "") {
            var str = snapshot.data;
            var jwt = str.split(".");
            if (jwt.length != 3) {
              return LoginPage();
            } else {
              var payload = json.decode(utf8.decode(base64.decode(base64.normalize(jwt[1]))));
              if (DateTime.fromMicrosecondsSinceEpoch(payload["exp"]*1000).isAfter(DateTime.now())) {
                return OrderList(jwt, payload);
              } else {
                return LoginPage();
              }
            }
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}

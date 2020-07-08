import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:transportappmobile/constants.dart' as Constants;
import 'package:transportappmobile/model/jwt_request.dart';
import 'package:transportappmobile/model/user.dart';
import 'package:transportappmobile/view/screen/auth/sign_up_page.dart';
import 'package:transportappmobile/view/screen/order_list.dart';
import 'package:transportappmobile/view/screen/utilities.dart';
import 'package:transportappmobile/view/screen_arguments.dart';

final storage = FlutterSecureStorage();

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
//  final storage = FlutterSecureStorage();

  Future<String> attemptLogin(JwtRequest jwtRequest) async {
    var res = await http.post(
      Constants.API_SERVER + '/login',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(jwtRequest)
    );
    if (res.statusCode == 200) {
      return res.body;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Log In"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username'
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password'
              ),
            ),
            FlatButton(
              onPressed: () async {
                var email = _usernameController.text;
                var password = _passwordController.text;
                var jwt = await attemptLogin(JwtRequest(email: email, password: password));
                if (jwt != null) {
                  storage.write(key: jwt, value: jwt);
//                  Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                        builder: (context) => OrderList.fromBase64(jwt)
//                      )
//                  );
                  Navigator.pushNamed(
                    context,
                    OrderList.routeName,
                    arguments: ScreenArguments(jwt: jwt),
                  );
                } else {
                  Utilities.displayDialog(context, "An error occurred", "No account was found matching matching that username and password");
                }
              },
              child: Text("Log In"),
            ),
            FlatButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SignupPage()
                    )
                );
              },
              child: Text("Sign Up"),
            )
          ],
        ),
      ),
    );
  }
}
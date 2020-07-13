import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:transportappmobile/model/user.dart';
import 'package:transportappmobile/view/screen/auth/login_page.dart';

class AppDrawer extends StatelessWidget {
  final storage = FlutterSecureStorage();
//  final name = await storage.read(key: 'user');
  Future<String> getUser() async {
    var user = await storage.read(key: "user");
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                      backgroundImage: AssetImage('images/profile_pic.png'),
                      radius: 40.0),
                  SizedBox(
                    height: 20.0,
                  ),
                  FutureBuilder(
                    future: getUser(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var user = snapshot.data;
//                        String email = jsonDecode(user)["sub"];
                        return Text(
                            jsonDecode(user)['email'],
                            style: TextStyle(
                              color: Colors.white
                            ),);
                      } else if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        return null;
                      }
                    },
                  )
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Logout'),
              trailing: Icon(Icons.exit_to_app),
              onTap: () {
                // Update the state of the app.
                // ...
                storage.delete(key: "jwt");
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
            ListTile(
              title: Text('Close'),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
  }
}

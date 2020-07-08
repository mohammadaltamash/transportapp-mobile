import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:transportappmobile/model/user.dart';
import 'package:transportappmobile/view/screen/auth/login_page.dart';
import 'package:transportappmobile/view/screen/utilities.dart';
import 'package:http/http.dart' as http;
import 'package:transportappmobile/constants.dart' as Constants;

class SignupPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final storage = FlutterSecureStorage();

  Future<int> attemptSignup(User user) async {
    var res = await http.post(
        Constants.API_SERVER + '/register',
        body: {
          user: user
        }
    );
    return res.statusCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
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
                if (email.length < 4) {
                  Utilities.displayDialog(context, "Invalid Username", "The username should be at least 4 characters long");
                } else if (password.length < 4) {
                  Utilities.displayDialog(context, "Invalid Password", "The password should be at least 4 characters long");
                } else {
                  var res = await attemptSignup(User(email: email, password: password));
                  if (res == 200) {
                    Utilities.displayDialog(context, "Success", "The user was created. Log in now.");
                  } else if (res == 409) {
                    Utilities.displayDialog(context, "The username is already registered", "Please try to sign up using another username or log in if you already have an account.");
                  } else {
                    Utilities.displayDialog(context, "Error", "An unknown error occured.");
                  }
                }
              },
              child: Text("Sign Up"),
            ),
            FlatButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage()
                    )
                );
                child: Text("Log In");
              },
            )
          ],
        ),
      ),
    );
  }
}

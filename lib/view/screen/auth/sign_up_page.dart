import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:transportappmobile/controller/network_helper.dart';
import 'package:transportappmobile/model/user.dart';
import 'package:transportappmobile/view/screen/auth/login_page.dart';
import 'package:transportappmobile/view/screen/custom_search_scaffold.dart';
import 'package:transportappmobile/view/screen/address_autocomplete.dart';
import 'package:transportappmobile/view/screen/utilities.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;
import 'package:transportappmobile/constants.dart' as Constants;

const kGoogleApiKey = "AIzaSyBsvjitJAvjP780J3gDop7SJ-992B7GU4M";
// to get places detail (lat/lng)
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();

class SignupPage extends StatelessWidget {
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();

  final storage = FlutterSecureStorage();

  String _type;
  String _company;
  String _address;
  double _latitude;
  double _longitude;
  int _zip = 1234;
  var maskFormatter = new MaskTextInputFormatter(mask: '+# (###) ###-##-##', filter: { "#": RegExp(r'[0-9]') });

  Future<int> attemptSignup(User user) async {
    var res =
        await http.post(Constants.API_SERVER + '/register',
//            body: {user: user}
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8'
            },
            body: jsonEncode(user));
    return res.statusCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sign Up"),
          centerTitle: true,
        ),
        body: ListView(
                padding: const EdgeInsets.all(10.0),
                children: <Widget>[
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _fullnameController,
                    decoration: InputDecoration(labelText: 'Full name'),
                  ),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(labelText: 'User name', hintText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                  /*TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      suffixIcon: IconButton(
                        onPressed: () {
                          _handlePressButton(context);
                        },
                        icon: Icon(Icons.location_searching),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _zipController,
                    decoration: InputDecoration(labelText: 'Zip'
                    ),
                    maxLength: 5,
                    inputFormatters: <TextInputFormatter> [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    keyboardType: TextInputType.number
                  ),*/
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(labelText: 'Phone',
                        hintText: "+1 (123) 123-45-67"),
                    inputFormatters: [maskFormatter],
                    autocorrect: false,
                  ),
                  /*TextField(
                    controller: _typeController,
                    decoration: InputDecoration(labelText: 'Type'),
                  ),*/
                  DropdownButtonFormField<String>(
                    value: _type,
//                    underline: Container(
//                      height: 1,
//                      color: Colors.grey,
//                    ),
//                    elevation: 16,
//                    icon: Icon(Icons.arrow_downward, color: Colors.grey,),
                    iconSize: 24.0,
//                    style: TextStyle(color: Colors.black54,),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(0, 18, 0, 18),
                    ),
                    onChanged: (String value) { _type = value; },
                    items: <String>['Broker', 'Carrier', 'Driver']
                      .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                    }).toList(),
                    hint: Text('Type'),
//                    isDense: true,
//                  style: TextStyle(),
                  ),
                  /*TextFormField(
                    controller: _companyController,
                    decoration: InputDecoration(labelText: 'Company'),
                  ),*/
                  FutureBuilder<List<dynamic>>(
                    future: NetworkHelper().getAllCompanies(),
                    builder:
                      (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                        if (snapshot.hasData) {
                          return DropdownButtonFormField<String>(
//                    value: _type,
//                    underline: Container(
//                      height: 1,
//                      color: Colors.grey,
//                    ),
//                    elevation: 16,
//                    icon: Icon(Icons.arrow_downward, color: Colors.grey,),
                            iconSize: 24.0,
//                    style: TextStyle(color: Colors.black54,),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(0, 18, 0, 18),
                            ),
                            onChanged: (String value) { _company = value; },
                            items: snapshot.data.map<DropdownMenuItem<String>>((dynamic value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            hint: Text('Company'),
//                    isDense: true,
//                  style: TextStyle(),
                          );
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                          return Center(child: CircularProgressIndicator());
                      }
                  ),

                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      suffixIcon: IconButton(
                        onPressed: () {
                          _handlePressButton(context);
                        },
                        icon: Icon(Icons.location_searching),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  TextFormField(
                      controller: _zipController,
                      decoration: InputDecoration(labelText: 'Zip'
                      ),
                      maxLength: 5,
                      inputFormatters: <TextInputFormatter> [
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      keyboardType: TextInputType.number
                  ),
                  SizedBox(height: 20.0),
                  Center(
                    child: RaisedButton(
                      onPressed: () async {
                        var email = _usernameController.text;
                        var password = _passwordController.text;
                        if (email.length < 4) {
                          Utilities.displayDialog(context, "Invalid Username",
                              "The username should be at least 4 characters long");
                        } else if (password.length < 4) {
                          Utilities.displayDialog(context, "Invalid Password",
                              "The password should be at least 4 characters long");
                        } else {
                          var res = await attemptSignup(getUserObject());
                          if (res == 200) {
                            Utilities.displayDialog(context, "Success",
                                "The user was created. Log in now.");
                          } else if (res == 409) {
                            Utilities.displayDialog(
                                context,
                                "The username is already registered",
                                "Please try to sign up using another username or log in if you already have an account.");
                          } else {
                            Utilities.displayDialog(
                                context, "Error", "An unknown error occured.");
                          }
                        }
                      },
                      child: Text("Sign Up"),
                      color: Colors.amber,
                    ),
                  ),
                  Center(
                    child: FlatButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => LoginPage()));
                        },
                        child: Text("Log In")),
                  )
                ],
              ),
    );
  }

  User getUserObject() {
    return User(
        userName: _usernameController.text,
        password: _passwordController.text,
        fullName: _fullnameController.text,
        companyName: _company,
        address: _addressController.text,
        zip: _zipController.text,
        latitude: _latitude,
        longitude: _longitude,
        phones: {'phone': _phoneController.text},
        email: _usernameController.text,
        type: _type,
    );
  }

//  Future<List<DropdownMenuItem<String>>> getAllCompanyNames() async {
//    final Future<List<dynamic>> res = await NetworkHelper().getAllCompanies();
//
//    res.map((e) => null);
//    if (res.statusCode == 200) {
////      var json = jsonDecode(res.body);
//      List<dynamic> json = jsonDecode(res.body);
////      List data = json['data'];
////      return json;
////      return List<User>.from(json).map((Map company) => User.fromJson(company)).toList();
//    } else {
//      throw Exception('Failed to fetch data');
//    }
//
//    <String>['Broker', 'Carrier', 'Driver']
//        .map<DropdownMenuItem<String>>((String value) {
//      return DropdownMenuItem<String>(
//        value: value,
//        child: Text(value),
//      );
//    }).toList();
//    return null;
//  }

  Future<void> _handlePressButton(BuildContext context) async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      mode: Mode.overlay,
      language: "us",
      components: [Component(Component.country, "us")],
      logo: Row(
//        children: [FlutterLogo()],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );

    displayPrediction(p, homeScaffoldKey.currentState);
  }

  Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
    if (p != null) {
      // get detail (lat/lng)
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;

//      scaffold.showSnackBar(
//        SnackBar(content: Text("${p.description} - $lat/$lng")),
//      );
      _addressController.text = p.description;
      _latitude = lat;
      _longitude = lng;
    }
  }

  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:transportappmobile/view/screen/carousel.dart';
import 'package:transportappmobile/view/screen/image_input.dart';
import 'package:transportappmobile/view/screen/images_list.dart';
import 'package:transportappmobile/view/screen/location_map.dart';
import 'package:transportappmobile/view/screen/order_detail.dart';
import 'package:transportappmobile/view/screen/order_list.dart';
import 'package:transportappmobile/view/screen/transport_app.dart';
import 'package:transportappmobile/view/screen_arguments.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();
//  // Obtain a list of the available cameras on the device.
//  final cameras = await availableCameras();
//  // Get a specific camera from the list of available cameras.
//  final firstCamera = cameras.first;
  runApp(MaterialApp(
    home: TransportApp(),
//    routes: {
//      OrderDetail.routeName: (context) => OrderDetail(),
//    },
    onGenerateRoute: (settings) {
      if (settings.name == OrderList.routeName) {
        final ScreenArguments args = settings.arguments;
        return MaterialPageRoute(
          builder: (context) {
            return OrderList.fromBase64(args.jwt);
          },
        );
      }
      if (settings.name == OrderDetail.routeName) {
        final ScreenArguments args = settings.arguments;
        return MaterialPageRoute(
          builder: (context) {
            return OrderDetail(order: args.order);
          },
        );
      }
      if (settings.name == LocationMap.routeName) {
        final ScreenArguments args = settings.arguments;
        return MaterialPageRoute(
          builder: (context) {
            return LocationMap(pickupLatLng: args.pickupLatLng, deliveryLatLng: args.deliveryLatLng, order: args.order);
          },
        );
      }
//      if (settings.name == DrivingDirections.routeName) {
//        final ScreenArguments args = settings.arguments;
//        return MaterialPageRoute(
//          builder: (context) {
//            return DrivingDirections(latitude: args.latitude, longitude: args.longitude, address: args.address);
//          },
//        );
//      }
      if (settings.name == ImageInput.routeName) {
        final ScreenArguments args = settings.arguments;
        return MaterialPageRoute(
          builder: (context) {
            // Get a specific camera from the list of available cameras.
//            final firstCamera = cameras.first;
            return ImageInput(orderId: args.orderId, location: args.location, imageType: args.imageType,);
          },
        );
      }
      if (settings.name == ImagesList.routeName) {
        final ScreenArguments args = settings.arguments;
        return MaterialPageRoute(
          builder: (context) {
            return ImagesList();
          },
        );
      }
      if (settings.name == Carousel.routeName) {
        final ScreenArguments args = settings.arguments;
        return MaterialPageRoute(
          builder: (context) {
            return Carousel(index: args.index, orderId: args.orderId, location: args.location,);
          },
        );
      }
      return null;
    },
  ));
}

/*
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      await FlutterDrivingDirections.launchDirections(
          latitude: 42.319935,
          longitude: -84.020364,
          address: '320 Main Street');
    } on PlatformException {
      debugPrint('Failed to launch directions.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Launching navigation\n'),
        ),
      ),
    );
  }
}*/

/*
import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: TakePictureScreen(
        // Pass the appropriate camera to the TakePictureScreen widget.
        camera: firstCamera,
      ),
    ),
  );
}

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a picture')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Construct the path where the image should be saved using the
            // pattern package.
            final path = join(
              // Store the picture in the temp directory.
              // Find the temp directory using the `path_provider` plugin.
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );

            // Attempt to take a picture and log where it's been saved.
            await _controller.takePicture(path);

            // If the picture was taken, display it on a new screen.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(imagePath: path),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}

*/
/*
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> render(BuildContext context, List children) {
    return ListTile.divideTiles(
        context: context,
        tiles: children.map((dynamic data) {
          return buildListTile(context, data[0], data[1], data[2]);
        })).toList();
  }

  Widget buildListTile(
      BuildContext context, String title, String subtitle, String url) {
    return new ListTile(
      onTap: () {
        Navigator.of(context).pushNamed(url);
      },
      isThreeLine: true,
      dense: false,
      leading: null,
      title: new Text(title),
      subtitle: new Text(subtitle),
      trailing: new Icon(
        Icons.arrow_right,
        color: Colors.blueAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // DateTime moonLanding = DateTime.parse("1969-07-20");

    return new Scaffold(
      appBar: new AppBar(
        title: Text(widget.title),
      ),
      body: new ListView(
        children: render(context, [
          ["Horizontal", "Scroll Horizontal", "/example01"],
          ["Vertical", "Scroll Vertical", "/example02"],
          ["Fraction", "Fraction style", "/example03"],
          ["Custom Pagination", "Custom Pagination", "/example04"],
          ["Phone", "Phone view", "/example05"],
          ["ScrollView ", "In a ScrollView", "/example06"],
          ["Custom", "Custom all properties", "/example07"]
        ]),
      ),
    );
  }
}*/

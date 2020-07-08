import 'package:flutter/material.dart';
import 'package:transportappmobile/controller/network_helper.dart';
import 'package:transportappmobile/model/order.dart';
import 'package:transportappmobile/view/screen/order_detail.dart';
import 'package:transportappmobile/view/screen_arguments.dart';
import '../../constants.dart' as Constants;

class ImagesList extends StatefulWidget {

  static const routeName = '/images_list';

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<ImagesList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.APP_TITLE),
        centerTitle: true,
      ),
      body: Center(
        child: _imagesUris(),
      ),
    );
  }
}

FutureBuilder _imagesUris() {
  return FutureBuilder<List<dynamic>>(
    future: NetworkHelper().getImages(),
    builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
      if (snapshot.hasData) {
        List<dynamic> data = snapshot.data;
        return _images(data, context);
      } else if (snapshot.hasError) {
        return Text("${snapshot.error}");
      }
      return CircularProgressIndicator();
    },
  );
}

ListView _images(data, context) {
  return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Card(
          child: _tile(data[index], context),
        );
      }
  );
}

ListTile _tile(String uri, context) {
  return ListTile(
    subtitle: Image.network(uri),
    );
//    subtitle: Text('data'),
//    onTap: () => _showOrderDetail(context, order),
//    onTap: () {
//      Navigator.pushNamed(
//        context,
//        OrderDetail.routeName,
//        arguments: ScreenArguments(order: order),
//      );
//    },
//  );


}

//_showOrderDetail(context, ord) {
//    Navigator.push(
//      context,
//      MaterialPageRoute(
//        builder: (context) => OrderDetail(order: ord),
//      ),
//    );
//}
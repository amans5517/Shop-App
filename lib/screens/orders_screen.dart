import 'package:ShopApp/providers/orders.dart';
import 'package:ShopApp/widgets/app_drawer.dart';
import 'package:ShopApp/widgets/orders_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

//   @override
//   _OrdersScreenState createState() => _OrdersScreenState();
// }

// class _OrdersScreenState extends State<OrdersScreen> {
  //var _isLoading = false;

  // @override
  // void initState() {
  //   // Future.delayed(Duration.zero).then((_) async {
  //   //   setState(() {
  //   //     _isLoading = true;
  //   //   });
  //   //   await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  //   //   setState(() {
  //   //     _isLoading = false;
  //   //   });
  //   // });

  //   _isLoading = true;

  //   Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then((_) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    //final orderItems = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders!'),
      ),
      drawer: AppDrawer(),
      // body: (_isLoading == true)
      //     ? Center(
      //         child: CircularProgressIndicator(),
      //       )
      //     : ListView.builder(
      //         itemCount: orderItems.orders.length,
      //         itemBuilder: (ctx, i) => OrdersItem(
      //           orderItems.orders[i],
      //         ),
      //       ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataState) {
          if (dataState.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (dataState.error != null) {
            //error handling here
            return Center(
              child: Text('Error occured while loading orders.'),
            );
          } else {
            return Consumer<Orders>(
              builder: (ctx, orderItems, child) => ListView.builder(
                itemCount: orderItems.orders.length,
                itemBuilder: (ctx, i) => OrdersItem(
                  orderItems.orders[i],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

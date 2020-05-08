import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart' show Orders;
import 'package:shop_app/widgets/main_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {

  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.error == null) {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) {
                  return orderData.ordersList.length <= 0
                      ? RefreshIndicator(
                          child: Center(
                            child: Text(
                              'No Orders Here Yet!\nStart Placing Some!',
                              style: Theme.of(context).textTheme.title,
                            ),
                          ),
                          onRefresh: () =>
                              Provider.of<Orders>(context, listen: false)
                                  .fetchAndSetOrders(),
                        )
                      : RefreshIndicator(
                          child: ListView.builder(
                            itemBuilder: (ctx, index) =>
                                OrderItem(orderData.ordersList[index]),
                            itemCount: orderData.ordersList.length,
                          ),
                          onRefresh: () =>
                              Provider.of<Orders>(context, listen: false)
                                  .fetchAndSetOrders(),
                        );
                },
              );
            } else {
              return Center(
                child: Text('An error ocurred!'),
              );
            }
          }
        },
      ),
    );
  }
}

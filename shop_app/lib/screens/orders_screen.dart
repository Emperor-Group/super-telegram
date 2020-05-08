import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart' show Orders;
import 'package:shop_app/widgets/main_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isInit = false;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Orders>(context).fetchAndSetOrders().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = true;
  }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);
    var theOrders = orders.ordersList;

    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : theOrders.length <= 0
              ? RefreshIndicator(
                  child: Center(
                    child: Text(
                      'No Orders Here Yet!\nStart Placing Some!',
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                  onRefresh: () => Provider.of<Orders>(context, listen: false)
                      .fetchAndSetOrders(),
                )
              : RefreshIndicator(
                  child: ListView.builder(
                    itemBuilder: (ctx, index) => OrderItem(theOrders[index]),
                    itemCount: theOrders.length,
                  ),
                  onRefresh: () => Provider.of<Orders>(context, listen: false)
                      .fetchAndSetOrders(),
                ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key key}) : super(key: key);

  Widget _buildListTile(
    BuildContext ctx,
    String title,
    Icon icon,
    Function tapFunction,
  ) {
    return Container(
      color: Colors.grey[200],
      child: ListTile(
        leading: icon,
        title: Text(
          title,
          style: Theme.of(ctx).textTheme.display1,
        ),
        onTap: tapFunction,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 100,
            width: double.infinity,
            padding: EdgeInsets.all(10),
            alignment: Alignment.bottomCenter,
            color: Theme.of(context).primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  'Let\'s Go Shopping!',
                  style: Theme.of(context).appBarTheme.textTheme.body1,
                ),
                Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                  size: 10,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          _buildListTile(
            context,
            'Shop Overview',
            Icon(
              Icons.store,
              color: Theme.of(context).primaryColor,
            ),
            () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          _buildListTile(
            context,
            'Check Orders',
            Icon(
              Icons.view_stream,
              color: Theme.of(context).primaryColor,
            ),
            () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          _buildListTile(
            context,
            'Manage Products',
            Icon(
              Icons.business_center,
              color: Theme.of(context).primaryColor,
            ),
            () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductScreen.routeName);
            },
          )
        ],
      ),
    );
  }
}

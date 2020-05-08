import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart' show Cart;
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.display2,
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  (cart.itemsCount == 0)
                      ? FlatButton(
                          child: Text(
                            'Place Order',
                            style: Theme.of(context).textTheme.caption,
                          ),
                          onPressed: () {},
                        )
                      : FlatButton(
                          child: Text(
                            'Place Order',
                            style: Theme.of(context).textTheme.display3,
                          ),
                          onPressed: () {
                            Provider.of<Orders>(context, listen: false)
                                .addOrder(
                              cart.items.values.toList(),
                              cart.totalAmount,
                            );
                            cart.clear();
                          },
                        ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                return CartItem(
                  id: cart.items.values.toList()[index].id,
                  prodID: cart.items.keys.toList()[index],
                  price: cart.items.values.toList()[index].pricePerProduct,
                  quantity: cart.items.values.toList()[index].quantity,
                  title: cart.items.values.toList()[index].title,
                );
              },
              itemCount: cart.itemsCount,
            ),
          )
        ],
      ),
    );
  }
}

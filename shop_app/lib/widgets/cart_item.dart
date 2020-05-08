import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String prodID;
  final double price;
  final int quantity;
  final String title;

  CartItem({
    this.id,
    this.prodID,
    this.price,
    this.quantity,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: ValueKey(id),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeById(prodID);
      },
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              'Really?',
              style: Theme.of(context).textTheme.display3,
            ),
            content: Text(
              'Do you want to remove the item from the cart?',
              style: Theme.of(context).textTheme.display1,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'NO, of course',
                  style: Theme.of(context).textTheme.display3,
                ),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              FlatButton(
                child: Text(
                  'Ugh, Yes...',
                  style: Theme.of(context).textTheme.caption,
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
        );
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete_forever,
          color: Colors.white,
          size: 50,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    '\$${price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.display2,
                  ),
                ),
              ),
            ),
            title: Text(
              title,
              style: Theme.of(context).textTheme.subhead,
            ),
            subtitle: Text(
              'Total: ${(price * quantity)}',
              style: Theme.of(context).textTheme.body2,
            ),
            trailing: Text(
              'x$quantity',
              style: Theme.of(context).textTheme.body1,
            ),
          ),
        ),
      ),
    );
  }
}

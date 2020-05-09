import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/widgets/badge.dart';

class ProductOverviewItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Product item = Provider.of<Product>(context);
    final Cart cart = Provider.of<Cart>(context);
    final Auth auth = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(ProductDetailScreen.routeName, arguments: item.id);
          },
          child: Image.network(
            item.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          title: Container(
            alignment: Alignment.center,
            child: Text(
              item.title,
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          subtitle: Container(
            alignment: Alignment.center,
            child: Text(
              '\$${item.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            icon: Icon(
              (item.isFavourite ? Icons.favorite : Icons.favorite_border),
              color: (item.isFavourite
                  ? Colors.redAccent[700]
                  : Theme.of(context).accentColor),
              size: 30,
            ),
            onPressed: () {
              item.toggleFavourtieStatus(auth.token);
            },
          ),
          trailing: Badge(
            child: IconButton(
              icon: Icon(
                Icons.shopping_basket,
                color: Theme.of(context).accentColor,
                size: 30,
              ),
              onPressed: () {
                cart.addItem(item.id, item.price, item.title);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${item.title} added to cart!',
                    ),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removeSingelItem(item.id);
                      },
                    ),
                    duration: Duration(seconds: 1, milliseconds: 500),
                  ),
                );
              },
            ),
            value: cart.getItemCountForProd(item.id).toString(),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

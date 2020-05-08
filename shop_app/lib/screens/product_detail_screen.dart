import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final String id = ModalRoute.of(context).settings.arguments;
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).getByID(id);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loadedProduct.title,
          style: Theme.of(context).appBarTheme.textTheme.title,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                loadedProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '${loadedProduct.title} \n\$${loadedProduct.price}',
              style: Theme.of(context).textTheme.body1,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '${loadedProduct.description}',
              style: Theme.of(context).textTheme.body2,
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/widgets/product_overview_item.dart';

class ProductsGrid extends StatelessWidget {

  final bool showFavs;

  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final Products productsData = Provider.of<Products>(context);
    final List<Product> loadedProducts = showFavs ? productsData.favourites : productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          value: loadedProducts[index],
          child: ProductOverviewItem(),
        );
      },
      itemCount: loadedProducts.length,
    );
  }
}

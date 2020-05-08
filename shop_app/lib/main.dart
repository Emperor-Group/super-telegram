import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Products(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          accentColor: Colors.lightGreenAccent,
          errorColor: Colors.amber,
          appBarTheme: AppBarTheme(
            textTheme: TextTheme(
              title: TextStyle(
                fontFamily: 'Lato',
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              body1: TextStyle(
                fontFamily: 'Lato',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          textTheme: TextTheme(
            body1: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            body2: TextStyle(
                color: Colors.grey,
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold),
            display1: TextStyle(
                color: Colors.black,
                fontFamily: 'Quicksand',
                fontSize: 15,
                fontWeight: FontWeight.bold),
            display2: TextStyle(
                color: Colors.white,
                fontFamily: 'Quicksand',
                fontSize: 15,
                fontWeight: FontWeight.bold),
            display3: TextStyle(
                color: Colors.green,
                fontFamily: 'Quicksand',
                fontSize: 18,
                fontWeight: FontWeight.w500),
            display4: TextStyle(
                color: Colors.white,
                fontFamily: 'Quicksand',
                fontSize: 12,
                fontWeight: FontWeight.w500),
            subhead: TextStyle(
                color: Colors.black,
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold),
            caption: TextStyle(
                color: Colors.grey,
                fontFamily: 'Quicksand',
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (ctx) => ProductsOverviewScreen(),
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          UserProductScreen.routeName: (ctx) => UserProductScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(builder: (ctx) => ProductsOverviewScreen());
        },
      ),
    );
  }
}

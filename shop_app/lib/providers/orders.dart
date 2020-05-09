import 'package:flutter/foundation.dart';
import 'package:shop_app/providers/cart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  ///orders.dart
  ///
  ///
  List<OrderItem> _orders = [];

  ///orders.dart
  ///
  ///
  List<OrderItem> get ordersList {
    return [..._orders];
  }

  String _token;

  String userId;

  Orders(this._token, this._orders, this.userId);

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = 'https://flutter-shopapp-trial.firebaseio.com/orders/$userId.json?auth=${this._token}';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'amount': total,
            'date': DateTime.now().toIso8601String(),
            'cartItems': cartProducts
                .map(
                  (cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.pricePerProduct,
                  },
                )
                .toList(),
          },
        ),
      );
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: DateTime.now(),
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchAndSetOrders() async {
    final url = 'https://flutter-shopapp-trial.firebaseio.com/orders/$userId.json?auth=${this._token}';
    try {
      final response = await http.get(url);
      final Map<String, dynamic> extractedOrders = json.decode(response.body);
      final List<OrderItem> loadedOrders = [];
      if (extractedOrders == null) {
        return;
      }
      extractedOrders.forEach(
        (key, value) {
          loadedOrders.add(OrderItem(
              id: key,
              amount: value['amount'],
              products: (value['cartItems'] as List<dynamic>)
                  .map(
                    (cp) => CartItem(
                      id: cp['id'],
                      quantity: cp['quantity'],
                      pricePerProduct: cp['price'],
                      title: cp['title'],
                    ),
                  )
                  .toList(),
              dateTime: DateTime.parse(value['date'])));
        },
      );
      _orders = loadedOrders;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}

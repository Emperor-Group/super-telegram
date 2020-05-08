import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double pricePerProduct;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.pricePerProduct,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }


  void addItem(
    String prodId,
    double price,
    String title,
  ) {
    if (_items.containsKey(prodId)) {
      _items.update(
          prodId,
          (existing) => CartItem(
              id: existing.id,
              title: existing.title,
              pricePerProduct: existing.pricePerProduct,
              quantity: existing.quantity + 1));
    } else {
      _items.putIfAbsent(
          prodId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              pricePerProduct: price,
              quantity: 1));
    }
    notifyListeners();
  }

  int get itemsCount {
    return _items.length;
  }

  int getItemCountForProd(String prodId) {
    return _items.containsKey(prodId) ? _items[prodId].quantity : 0;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.quantity * cartItem.pricePerProduct;
    });
    return total;
  }

  void removeById(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void removeSingelItem(String prodId) {
    if (_items.containsKey(prodId)) {
      if (_items[prodId].quantity <= 1) {
        _items.remove(prodId);
      } else {
        _items.update(
          prodId,
          (existing) => CartItem(
            id: existing.id,
            pricePerProduct: existing.pricePerProduct,
            quantity: existing.quantity - 1,
            title: existing.title,
          ),
        );
      }
      notifyListeners();
    }
  }
}

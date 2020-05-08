import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import './product.dart';

class Products with ChangeNotifier {
  ///products_provider.dart
  ///
  ///
  List<Product> _items = [];

  ///products_provider.dart
  ///
  ///
  List<Product> get items {
    return [..._items];
  }

  List<Product> get favourites {
    return items.where((Product item) => item.isFavourite == true).toList();
  }

  Product getByID(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    const url = 'https://flutter-shopapp-trial.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      final Map<String, dynamic> extractedData = json.decode(response.body);
      final List<Product> loadedProducts = [];
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((key, value) {
        loadedProducts.add(Product(
          id: key,
          description: value['description'],
          title: value['title'],
          imageUrl: value['imageURL'],
          price: value['price'],
          isFavourite: value['isFavourite'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  ///products_provider.dart
  ///
  ///
  Future<void> addProduct(Product product) async {
    const url = 'https://flutter-shopapp-trial.firebaseio.com/products.json';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageURL': product.imageUrl,
            'price': product.price,
            'isFavourite': product.isFavourite,
          },
        ),
      );
      final newProduct = Product(
        description: product.description,
        title: product.title,
        imageUrl: product.imageUrl,
        price: product.price,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product product) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://flutter-shopapp-trial.firebaseio.com/products/$id.json';
      try {
        await http.patch(
          url,
          body: json.encode(
            {
              'title': product.title,
              'description': product.description,
              'imageURL': product.imageUrl,
              'price': product.price,
            },
          ),
        );
        _items[prodIndex] = product;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://flutter-shopapp-trial.firebaseio.com/products/$id.json';
    final index = _items.indexWhere((element) => element.id == id);
    Product existingProduct = _items[index];
    _items.removeAt(index);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(index, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingProduct = null;
  }
}

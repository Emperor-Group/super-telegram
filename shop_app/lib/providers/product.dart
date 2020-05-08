import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  ///product.dart
  ///
  ///
  final String id;

  ///product.dart
  ///
  ///
  final String title;

  ///product.dart
  ///
  ///
  final String description;

  ///product.dart
  ///
  ///
  final double price;

  ///product.dart
  ///
  ///
  final String imageUrl;

  ///product.dart
  ///
  ///
  bool isFavourite;

  ///product.dart
  ///
  ///
  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false,
  });

  ///product.dart
  ///
  ///
  void toggleFavourtieStatus() async {
    final url =
        'https://flutter-shopapp-trial.firebaseio.com/products/$id.json';
    try {
      final response = await http.patch(
        url,
        body: json.encode(
          {'isFavourite': !isFavourite},
        ),
      );
      isFavourite = !isFavourite;
      if (response.statusCode >= 400){
        isFavourite = !isFavourite;
      }
      notifyListeners();
    } catch (error){
      notifyListeners();
      throw error;
    } 
  }
}

import 'package:flutter/material.dart';

import '../connectors/backend_connector.dart';
import 'ProductResponse.dart';

class ProductsInfo extends ChangeNotifier {
  late List<Product> _products = [];
  late Product _selectedProduct;

  List<Product> get getProducts => _products;

  Product get getSingleProduct => _selectedProduct;

  BackendConnector backendConnector = BackendConnector();

  Future<void> populateList() async {
    backendConnector
        .callProducts()
        .then((value) => {_products = value, notifyListeners()});
  }

  void unPopulateList() {
    _products = [];
    notifyListeners();
  }

  void foundProduct(Product product) {
    _selectedProduct = product;
    notifyListeners();
  }
}

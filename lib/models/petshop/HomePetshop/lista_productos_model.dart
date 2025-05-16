import 'package:flutter/foundation.dart';
import 'package:vet_sotf_app/models/petshop/HomePetshop/producto_model.dart';

class ProductListModel extends ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  // Método para agregar un producto a la lista de búsqueda
  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  // Método para eliminar un producto de la lista de búsqueda
  void removeProduct(int index) {
    _products.removeAt(index);
    notifyListeners();
  }

  // Puedes agregar más métodos según tus necesidades
}

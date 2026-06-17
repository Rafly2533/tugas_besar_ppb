import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  final String baseUrl = "http://192.168.100.77/tubes_api";

  Future<bool> createProduct({
    required int userId,
    required String name,
    required double price,
    required String description,
    required int stock,
    required String imageUrl,
    required String category,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final url = Uri.parse("$baseUrl/create_product.php");
      
      final body = {
        'user_id': userId,
        'name': name,
        'price': price,
        'description': description,
        'stock': stock,
        'image_url': imageUrl,
        'category': category,
      };

      print("=== CREATE PRODUCT ===");
      print("URL: $url");
      print("Body: $body");

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(body),
      ).timeout(const Duration(seconds: 10));

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'success') {
          final newProduct = Product.fromJson(data['data']);
          _products.insert(0, newProduct);
          _isLoading = false;
          notifyListeners();
          return true;
        } else {
          _errorMessage = data['message'] ?? 'Gagal menambahkan produk';
          _isLoading = false;
          notifyListeners();
          return false;
        }
      } else {
        _errorMessage = 'HTTP Error: ${response.statusCode}';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print("Exception: $e");
      _errorMessage = 'Error: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> fetchProducts(int userId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final url = Uri.parse("$baseUrl/get_products.php?user_id=$userId");
      
      print("=== FETCH PRODUCTS ===");
      print("URL: $url");

      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Decoded Data: $data");
        
        if (data['status'] == 'success') {
          List<dynamic> productData = data['data'] ?? [];
          print("Product Data Length: ${productData.length}");
          
          // KOSONGKAN DULU SEBELUM DIISI
          _products = [];
          
          for (var item in productData) {
            try {
              final product = Product.fromJson(item);
              _products.add(product);
              print("Added Product: ${product.name}");
            } catch (e) {
              print("Error parsing product: $e");
              print("Item: $item");
            }
          }
          
          print("Total Products: ${_products.length}");
          _isLoading = false;
          notifyListeners(); // PASTIKAN NOTIFY LISTENERS
          return true;
        } else {
          _errorMessage = data['message'] ?? 'Gagal mengambil data';
          _isLoading = false;
          notifyListeners();
          return false;
        }
      } else {
        _errorMessage = 'HTTP Error: ${response.statusCode}';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print("Exception: $e");
      _errorMessage = 'Error: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(Product product) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final url = Uri.parse("$baseUrl/update_product.php");
      
      final body = {
        'id': product.id,
        'name': product.name,
        'price': product.price,
        'description': product.description,
        'stock': product.stock,
        'image_url': product.imageUrl,
        'category': product.category,
      };

      print("=== UPDATE PRODUCT ===");
      print("URL: $url");
      print("Body: $body");

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(body),
      ).timeout(const Duration(seconds: 10));

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'success') {
          final index = _products.indexWhere((p) => p.id == product.id);
          if (index != -1) {
            _products[index] = Product.fromJson(data['data']);
          }
          _isLoading = false;
          notifyListeners();
          return true;
        } else {
          _errorMessage = data['message'] ?? 'Gagal mengupdate produk';
          _isLoading = false;
          notifyListeners();
          return false;
        }
      } else {
        _errorMessage = 'HTTP Error: ${response.statusCode}';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print("Exception: $e");
      _errorMessage = 'Error: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct(int productId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final url = Uri.parse("$baseUrl/delete_product.php");
      
      final body = {'id': productId};

      print("=== DELETE PRODUCT ===");
      print("URL: $url");
      print("Body: $body");

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(body),
      ).timeout(const Duration(seconds: 10));

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'success') {
          _products.removeWhere((p) => p.id == productId);
          _isLoading = false;
          notifyListeners();
          return true;
        } else {
          _errorMessage = data['message'] ?? 'Gagal menghapus produk';
          _isLoading = false;
          notifyListeners();
          return false;
        }
      } else {
        _errorMessage = 'HTTP Error: ${response.statusCode}';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print("Exception: $e");
      _errorMessage = 'Error: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearProducts() {
    _products = [];
    notifyListeners();
  }
}
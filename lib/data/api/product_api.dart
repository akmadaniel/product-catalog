import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:product_catalog/data/api/api_exception.dart';
import 'package:product_catalog/data/model/product_list.dart';
import 'package:product_catalog/data/model/product.dart';

class ProductApi {
  static const _baseUrl = 'https://dummyjson.com';

  Future<ProductList> fetchProducts({
    int limit = 20,
    int skip = 0,
  }) async {
    final uri = Uri.parse('$_baseUrl/products')
        .replace(queryParameters: {'limit': '$limit', 'skip': '$skip'});
    final json = await _get(uri);
    return ProductList.fromJson(json);
  }

  Future<Product> fetchProduct(int id) async {
    final json = await _get(Uri.parse('$_baseUrl/products/$id'));
    return Product.fromJson(json);
  }

  Future<ProductList> searchProducts(
    String query, {
    int limit = 20,
    int skip = 0,
  }) async {
    final uri = Uri.parse('$_baseUrl/products/search').replace(
      queryParameters: {'q': query, 'limit': '$limit', 'skip': '$skip'},
    );
    final json = await _get(uri);
    return ProductList.fromJson(json);
  }

  Future<Map<String, dynamic>> _get(Uri uri) async {
    final response = await http.get(uri).timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      throw ApiException('Server error ${response.statusCode}');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}

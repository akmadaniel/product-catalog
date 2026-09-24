import 'dart:async';
import 'dart:io';
import 'package:product_catalog/data/api/product_api.dart';
import 'package:product_catalog/data/model/product.dart';
import 'package:product_catalog/data/model/product_list.dart';
import 'package:product_catalog/data/api/api_exception.dart';

class ProductRepository {
  final ProductApi _api;

  ProductRepository(this._api);

  Future<ProductList> getProducts({int limit = 20, int skip = 0}) {
    return _guard(() => _api.fetchProducts(limit: limit, skip: skip));
  }

  Future<ProductList> searchProducts(String query,
      {int limit = 20, int skip = 0}) {
    return _guard(
        () => _api.searchProducts(query, limit: limit, skip: skip));
  }

  Future<Product> getProduct(int id) {
    return _guard(() => _api.fetchProduct(id));
  }

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on SocketException {
      throw ApiException('No internet connection');
    } on TimeoutException {
      throw ApiException('Request timed out');
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException('Something went wrong');
    }
  }
}

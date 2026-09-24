import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog/data/model/product.dart';

void main() {
  group('Product.fromJson', () {
    test('parses int price as double', () {
      final product = Product.fromJson({
        'id': 1,
        'title': 'Phone',
        'description': 'A phone',
        'price': 10,
        'rating': 4.5,
        'thumbnail': 'https://x/t.webp',
        'images': ['https://x/1.webp'],
      });

      expect(product.price, 10.0);
      expect(product.rating, 4.5);
    });

    test('keeps rating, thumbnail and images null when missing', () {
      final product = Product.fromJson({
        'id': 2,
        'title': 'Case',
        'description': 'A case',
        'price': 5.5,
      });

      expect(product.rating, isNull);
      expect(product.thumbnail, isNull);
      expect(product.images, isNull);
    });
  });
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_catalog/presentation/bindings/products_binding.dart';
import 'package:product_catalog/presentation/views/products_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Product Catalog',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ProductsPage(),
      initialBinding: ProductsBinding(),
    );
  }
}
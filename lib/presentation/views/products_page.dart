import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_catalog/presentation/controllers/products_controller.dart';

class ProductsPage extends GetView<ProductListController> {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: Obx(() => Center(child: Text('State: ${controller.state.value}'))),
    );
  }
}
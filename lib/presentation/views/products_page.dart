import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_catalog/presentation/controllers/products_controller.dart';

class ProductsPage extends GetView<ProductListController> {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search products',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),

      body: Obx(() {
        switch (controller.state.value) {
          case ViewState.loading:
            return const Center(child: CircularProgressIndicator());
          case ViewState.error:
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(controller.errorMessage.value),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: controller.loadInitial,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          case ViewState.empty:
            return const Center(child: Text('No products found'));
          case ViewState.success:
            return ListView.builder(
              controller: controller.scrollController,
              itemCount: controller.products.length,
              itemBuilder: (context, index) {
                final product = controller.products[index];
                return ListTile(
                  title: Text(product.title),
                  subtitle: Text('\$${product.price}'),
                );
              },
            );
        }
      }),
    );
  }
}

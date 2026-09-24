import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_catalog/presentation/controllers/product_detail_controller.dart';
import 'package:product_catalog/presentation/controllers/products_controller.dart';

class ProductDetailPage extends GetView<ProductDetailController> {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product detail')),
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
                    onPressed: controller.load,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          case ViewState.empty:
          case ViewState.success:
            final p = controller.product.value!;
            final images = p.images ?? [];
            return ListView(
              children: [
                SizedBox(
                  height: 260,
                  child: images.isEmpty
                      ? const Center(
                          child: Icon(Icons.image_not_supported, size: 64),
                        )
                      : PageView.builder(
                          itemCount: images.length,
                          itemBuilder: (context, i) => Image.network(
                            images[i],
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, progress) =>
                                progress == null
                                ? child
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                            errorBuilder: (context, error, stack) =>
                                const Center(
                                  child: Icon(Icons.broken_image, size: 64),
                                ),
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${p.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      if (p.rating != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(p.rating!.toStringAsFixed(1)),
                          ],
                        ),
                      ],
                      const SizedBox(height: 16),
                      Text(p.description),
                    ],
                  ),
                ),
              ],
            );
        }
      }),
    );
  }
}

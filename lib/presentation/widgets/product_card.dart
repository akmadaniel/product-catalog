import 'package:flutter/material.dart';
import 'package:product_catalog/data/model/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 56,
          height: 56,
          child: product.thumbnail == null
              ? const Icon(Icons.image_not_supported)
              : Image.network(
                  product.thumbnail!,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  },
                  errorBuilder: (context, error, stack) =>
                      const Icon(Icons.broken_image),
                ),
        ),
      ),
      title: Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
    );
  }
}
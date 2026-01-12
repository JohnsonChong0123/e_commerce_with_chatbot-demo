import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../domain/entity/product_view_entity.dart';
import '../screens/product/product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  final ProductViewEntity product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, ProductDetailScreen.route(product));
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: product.image.isNotEmpty
                          ? Image.network(
                              product.image,
                              fit: BoxFit.fill,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: double.infinity,
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    size: 100,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            )
                          : Container(
                              width: double.infinity,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.image_not_supported,
                                size: 100,
                                color: Colors.grey,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product.name,
                style: const TextStyle(color: AppColor.primary, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  if (product.hasDiscount) ...[
                    Text(
                      "\$${product.initialPrice.toStringAsFixed(2)}",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColor.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Text(
                    "\$${product.productPrice.toStringAsFixed(2)}",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColor.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.star, size: 13, color: Colors.amber),
                  Text(
                    '${product.rating} (${product.reviewsCount})',
                    style: const TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

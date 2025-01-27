import 'package:ecommerce_app/features/product/domain/entities/product_model.dart';
import 'package:ecommerce_app/features/product/presentation/widget/product_card.dart';
import 'package:flutter/material.dart';

class ProductGridWidget extends StatelessWidget {
  final List<ProductModel> products;
  final bool isWishList;

  const ProductGridWidget({super.key, required this.products, required this.isWishList});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {

        int crossAxisCount = (constraints.maxWidth ~/ 200).clamp(2, 3); 
        double childAspectRatio = constraints.maxWidth < 600 ? 0.7 : 0.85;

        return GridView.builder(
          shrinkWrap: true,
          physics: isWishList ? null : const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ProductCard(product: products[index]);
          },
        );
      },
    );
  }
}

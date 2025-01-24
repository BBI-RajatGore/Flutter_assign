import 'package:flutter/material.dart';
import 'package:ecommerce_app/features/product/domain/entities/product_model.dart';
import 'package:ecommerce_app/features/product/presentation/widget/product_rating_widget.dart';

class ProductDetails extends StatelessWidget {
  final ProductModel product;

  const ProductDetails({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '\$${(product.price * 1.5).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ProductRatingWidget(rating: product.rate),
              const SizedBox(width: 8),
              Text('(${product.rate} reviews)'),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            product.description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 16),
          _buildColorSection(),
          const SizedBox(height: 8),
          _buildSizeSection(),
        ],
      ),
    );
  }

  Widget _buildColorSection() {
    return Row(
      children: [
        const Text('Colors:', style: TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        ...List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              radius: 14,
              backgroundColor: Colors.primaries[index],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSizeSection() {
    return Row(
      children: [
        const Text('Size:', style: TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        ...['XS', 'S', 'M', 'L', 'XL'].map((size) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Chip(
                label: Text(size),
                backgroundColor: Colors.grey.shade200,
              ),
            )),
      ],
    );
  }
}

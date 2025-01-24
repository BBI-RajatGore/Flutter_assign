import 'package:ecommerce_app/features/product/presentation/bloc/cart_bloc/cart_event.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/features/product/domain/entities/product_model.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/cart_bloc/cart_bloc.dart';
import 'package:ecommerce_app/core/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductBottomSection extends StatelessWidget {
  final ProductModel product;

  const ProductBottomSection({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () => _addToCart(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.teal,
              ),
              child: const Text(
                "Add to Cart",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => {},
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black,
              ),
              child: const Text(
                "Buy Now",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart(BuildContext context) {
    BlocProvider.of<CartBloc>(context)
        .add(AddToCartEvent(productId: product.id, quantity: 1));
    Constants.showSuccessSnackBar(context, "Product added to cart");
  }
}

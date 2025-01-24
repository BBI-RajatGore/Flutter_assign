import 'package:ecommerce_app/features/product/domain/entities/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/cart_bloc/cart_bloc.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/cart_bloc/cart_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartItemWidget extends StatelessWidget {
  final CartModel cartItem;

  const CartItemWidget({Key? key, required this.cartItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = cartItem.product;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        elevation: 5,
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: product?.image != null
                    ? Image.network(
                        product!.image,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      )
                    : const Icon(
                        Icons.shopping_cart,
                        size: 60,
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product?.title ?? "Unknown Product",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "\$${product?.price.toStringAsFixed(2) ?? 'N/A'} USD",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.remove_circle_outline,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      if (cartItem.quantity > 1) {
                        BlocProvider.of<CartBloc>(context).add(
                          AddToCartEvent(
                            productId: cartItem.productId,
                            quantity: cartItem.quantity - 1,
                          ),
                        );
                      } else {
                        BlocProvider.of<CartBloc>(context).add(
                          RemoveFromCartEvent(
                            productId: cartItem.productId,
                            quantity: cartItem.quantity,
                          ),
                        );
                      }
                    },
                  ),
                  Text(
                    cartItem.quantity.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      BlocProvider.of<CartBloc>(context).add(
                        AddToCartEvent(
                          productId: cartItem.productId,
                          quantity: cartItem.quantity + 1,
                        ),
                      );
                    },
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () {
                  BlocProvider.of<CartBloc>(context).add(
                    RemoveFromCartEvent(
                      productId: cartItem.productId,
                      quantity: cartItem.quantity,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

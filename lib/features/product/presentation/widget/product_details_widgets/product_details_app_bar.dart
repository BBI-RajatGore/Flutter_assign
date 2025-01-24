import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/features/product/domain/entities/product_model.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/product_bloc/product_bloc.dart';

class ProductAppBar extends StatelessWidget {
  final ProductModel product;

  const ProductAppBar({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.4,
      pinned: true,
      backgroundColor: Colors
          .primaries[product.id % Colors.primaries.length]
          .withOpacity(0.1),
      leading: Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
        ),
        child: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.teal,
          ),
          iconSize: 24,
        ),
      ),
      actions: [
        BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoaded) {
              final product = state.products
                  .firstWhere((prod) => prod.id == this.product.id);
              return IconButton(
                icon: (product.isFavorite)
                    ? const Icon(Icons.favorite, color: Colors.red)
                    : const Icon(Icons.favorite_border, color: Colors.black),
                onPressed: () {
                  BlocProvider.of<ProductBloc>(context)
                      .add(ToggleFavoriteEvent(product.id));
                },
              );
            }
            return const SizedBox();
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Image.network(
            product.image,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

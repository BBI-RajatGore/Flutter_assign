import 'package:ecommerce_app/features/product/presentation/widget/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/product_bloc.dart';

class WishlistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: const TextSpan(children: [
            TextSpan(
              text: "Your ",
              style: TextStyle(
                fontSize: 24,
                color: Colors.teal,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: "WishList",
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ]),
        ),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {

            final favoriteProducts = state.products.where((product) => product.isFavorite).toList();

            return favoriteProducts.isEmpty
                ? Center(child: Image.asset("assets/images/cart-empty.png"),)
                : GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 12.0,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: favoriteProducts.length,
                    itemBuilder: (context, index) {
                      return ProductCard( product: favoriteProducts[index]);
                    },
                  );
          } else if (state is ProductError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return Container();
        },
      ),
    );
  }
}

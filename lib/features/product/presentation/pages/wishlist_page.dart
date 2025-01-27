import 'package:ecommerce_app/core/widgets/app_bar_widget.dart';
import 'package:ecommerce_app/features/product/presentation/widget/product_grid_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/product_bloc/product_bloc.dart';

class WishlistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const AppBarWidget(title: "Your ", subtitle: "WishList"),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            final favoriteProducts =
                state.products.where((product) => product.isFavorite).toList();

            return favoriteProducts.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset("assets/images/no_favourite.png"),
                      ),
                      const Text(
                        "No WishList",
                        style: TextStyle(
                            color: Colors.teal,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  )
                : ProductGridWidget(
                    products: favoriteProducts,
                    isWishList: true,
                  );
          } else if (state is ProductError) {
            return Center(
              child: Text('Error: ${state.message}'),
            );
          }
          return Container();
        },
      ),
    );
  }
}

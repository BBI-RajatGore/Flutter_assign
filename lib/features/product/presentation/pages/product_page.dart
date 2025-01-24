import 'package:ecommerce_app/features/product/domain/entities/product_model.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/product_bloc/product_bloc.dart';
import 'package:ecommerce_app/core/widgets/app_bar_widget.dart';
import 'package:ecommerce_app/features/product/presentation/widget/product_page_widgets/carousel_slider_widget.dart';
import 'package:ecommerce_app/features/product/presentation/widget/product_page_widgets/error_widget.dart';
import 'package:ecommerce_app/features/product/presentation/widget/product_page_widgets/shimmer_carousel_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/features/product/presentation/widget/product_grid_widget.dart';

class ProductPage extends StatefulWidget {
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProductBloc>(context).add(GetProductEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const  AppBarWidget(title: "Product ", subtitle: "Catalog")
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildCarouselSlider(),
            const SizedBox(height: 20),
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return _buildShimmerEffect();
                } else if (state is ProductLoaded) {
                  return ProductGridWidget(products: state.products,isWishList: false,); 
                } else if (state is ProductError) {
                  return ErorWidget(message: state.message);
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselSlider() {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return ShimmerCarouselWidget();
        } else if (state is ProductLoaded) {
          List<ProductModel> carouselProducts = state.products.take(5).toList();
          return CarouselSliderWidget(products: carouselProducts);
        }
        return Container();
      },
    );
  }

  Widget _buildShimmerEffect() {
    return ShimmerGridWidget();
  }

}




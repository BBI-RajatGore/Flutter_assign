import 'package:ecommerce_app/features/product/presentation/widget/product_details_widgets/product_details_app_bar.dart';
import 'package:ecommerce_app/features/product/presentation/widget/product_details_widgets/product_details_bottom_section.dart';
import 'package:ecommerce_app/features/product/presentation/widget/product_details_widgets/product_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/features/product/domain/entities/product_model.dart';

class ProductDetailsPage extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              ProductAppBar(product: product),
              SliverToBoxAdapter(
                child: ProductDetails(product: product),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ProductBottomSection(product: product),
          ),
        ],
      ),
    );
  }
}


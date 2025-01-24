import 'package:ecommerce_app/features/product/domain/entities/product_model.dart';
import 'package:ecommerce_app/features/product/presentation/widget/product_card.dart';
import 'package:flutter/material.dart';

class ProductGridWidget extends StatelessWidget {

  final  List<ProductModel> products;

  final isWishList;
  
  const ProductGridWidget({super.key,required this.products,required this.isWishList});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,  
      physics: (isWishList)? null : const  NeverScrollableScrollPhysics(), 
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        childAspectRatio: 0.75,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductCard(product: products[index]);
      },
    );;
  }
}
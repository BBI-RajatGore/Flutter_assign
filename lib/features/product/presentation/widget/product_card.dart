import 'package:ecommerce_app/features/product/presentation/bloc/product_bloc.dart';
import 'package:ecommerce_app/features/product/presentation/pages/product_details_page.dart';
import 'package:ecommerce_app/features/product/presentation/widget/product_rating_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCard extends StatefulWidget {
  final product;

  const ProductCard({super.key,required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(product:  widget.product),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                    ),
                    child: Container(
                      color: Colors
                          .primaries[widget.product.id % Colors.primaries.length]
                          .withOpacity(0.1),
                      child: Image.network(
                        widget.product.image,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )),
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: (widget.product.isFavorite)
                          ? const Icon(Icons.favorite, color: Colors.red)
                          : const Icon(Icons.favorite_border),
                      onPressed: () {
                         BlocProvider.of<ProductBloc>(context)
                            .add(ToggleFavoriteEvent(widget.product.id));
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${widget.product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ProductRatingWidget(rating: widget.product.rate),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/core/utils/constants.dart';
import 'package:ecommerce_app/features/product/domain/entities/product_model.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/cart_bloc/cart_bloc.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/cart_bloc/cart_event.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/product_bloc/product_bloc.dart';
import 'package:ecommerce_app/features/product/presentation/widget/product_rating_widget.dart';

class ProductDetailsPage extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildAppBar(context),
              SliverToBoxAdapter(
                child: _buildProductDetails(context),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomSection(context),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.4,
      pinned: true,
      backgroundColor: Colors.primaries[widget.product.id % Colors.primaries.length]
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
                  .firstWhere((prod) => prod.id == widget.product.id);
              return IconButton(
                icon: (product.isFavorite)
                    ? const Icon(Icons.favorite, color: Colors.red)
                    : const Icon(Icons.favorite_border, color: Colors.black),
                onPressed: () {
                  BlocProvider.of<ProductBloc>(context)
                      .add(ToggleFavoriteEvent(widget.product.id));
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
            widget.product.image,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildProductDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.product.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '\$${widget.product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '\$${(widget.product.price * 1.5).toStringAsFixed(2)}',
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
              ProductRatingWidget(rating: widget.product.rate),
              const SizedBox(width: 8),
              Text('(${widget.product.rate} reviews)'),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.product.description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 16),
          Row(
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
          ),
          const SizedBox(height: 8),
          Row(
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
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

          GestureDetector(
            onTap: () => _addToCart(context),
            child: Container(
              padding: const  EdgeInsets.symmetric(horizontal: 30,vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.teal,
              ),
              child: const Text(
                "Add to Cart",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: () =>{},
            child: Container(
              padding: const  EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black,
              ),
              child: const Text(
                "Buy Now",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
          ),

          
        ],
      ),
    );
  }

  void _addToCart(BuildContext context) {
    BlocProvider.of<CartBloc>(context)
        .add(AddToCartEvent(productId: widget.product.id, quantity: 1));
    Constants.showSuccessSnackBar(context, "Product added to cart");
  }
}
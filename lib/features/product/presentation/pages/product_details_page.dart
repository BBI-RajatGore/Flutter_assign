import 'package:ecommerce_app/features/product/presentation/bloc/product_bloc.dart';
import 'package:ecommerce_app/features/product/presentation/widget/product_rating_widget.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/features/product/domain/entities/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      expandedHeight: MediaQuery.of(context).size.height * 0.5,
      pinned: true,
      backgroundColor: Colors
          .primaries[widget.product.id % Colors.primaries.length]
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
                    : const Icon(Icons.favorite_border),
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
        background: Image.network(
          widget.product.image,
          fit: BoxFit.cover,
          height: MediaQuery.of(context).size.height * 0.5,
        ),
      ),
    );
  }

  Widget _buildProductDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.product.title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${widget.product.price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 8),
          ProductRatingWidget(rating: widget.product.rate),
          const SizedBox(height: 12),
          Text(
            widget.product.description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '\$${widget.product.price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.teal,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 8,
            ),
            onPressed: () {
              _addToCart(context);
            },
            child: const Text(
              'Add to Cart',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added to Cart')),
    );
  }
}

import 'package:ecommerce_app/features/product/domain/entities/product_model.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/product_bloc.dart';
import 'package:ecommerce_app/features/product/presentation/pages/product_details_page.dart';
import 'package:ecommerce_app/features/product/presentation/widget/product_card.dart';
import 'package:ecommerce_app/features/product/presentation/widget/product_rating_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shimmer/shimmer.dart';

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
      appBar: AppBar(
        title: RichText(
          text: const TextSpan(children: [
            TextSpan(
              text: "Product ",
              style: TextStyle(
                fontSize: 24,
                color: Colors.teal,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: "Catlog",
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ]),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          _buildCarouselSlider(),
          const SizedBox(height: 20),
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return _buildShimmerEffect();
                } else if (state is ProductLoaded) {
                  return _buildProductGrid(state.products);
                } else if (state is ProductError) {
                  return _buildError(state.message);
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselSlider() {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return _buildShimmerCarousel();
        } else if (state is ProductLoaded) {
          List<ProductModel> carouselProducts = state.products.take(5).toList();

          return CarouselSlider(
            options: CarouselOptions(
              height: 250,
              autoPlay: true,
              enlargeCenterPage: true,
              autoPlayInterval: const Duration(seconds: 3),
              viewportFraction: 0.85,
              aspectRatio: 16 / 9,
              autoPlayCurve: Curves.easeInOut,
              onPageChanged: (index, reason) {},
            ),
            items: carouselProducts.map((product) {
              return Builder(
                builder: (BuildContext context) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      image: DecorationImage(
                        image: NetworkImage(product.image),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.4),
                                  Colors.transparent,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          child: Text(
                            product.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }).toList(),
          );
        }
        return Container();
      },
    );
  }

  Widget _buildShimmerCarousel() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 220,
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.grey[300],
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          childAspectRatio: 0.75,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return _buildShimmerCard();
        },
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 8,
      shadowColor: Colors.tealAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              Container(
                height: 150,
                color: Colors.grey[300],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 16,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 4),
                Container(
                  width: 60,
                  height: 16,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(color: Colors.red, fontSize: 18),
      ),
    );
  }

  Widget _buildProductGrid(List<ProductModel> products) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        childAspectRatio: 0.75,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        // return _buildProductCard(products[index]);
        return ProductCard( product:  products[index]);
      },
    );
  }

//   Widget _buildProductCard(ProductModel product) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ProductDetailsPage(product: product),
//           ),
//         );
//       },
//       child: Card(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15.0),
//         ),
//         elevation: 8,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Stack(
//               children: [
//                 ClipRRect(
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(15.0),
//                       topRight: Radius.circular(15.0),
//                     ),
//                     child: Container(
//                       color: Colors
//                           .primaries[product.id % Colors.primaries.length]
//                           .withOpacity(0.1),
//                       child: Image.network(
//                         product.image,
//                         height: 150,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       ),
//                     )),
//                 Positioned(
//                   top: 8,
//                   right: 8,
//                   child: CircleAvatar(
//                     backgroundColor: Colors.white,
//                     child: IconButton(
//                       icon: (product.isFavorite)
//                           ? const Icon(Icons.favorite, color: Colors.red)
//                           : const Icon(Icons.favorite_border),
//                       onPressed: () {
//                          BlocProvider.of<ProductBloc>(context)
//                             .add(ToggleFavoriteEvent(product.id));
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     product.title,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black87,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     '\$${product.price.toStringAsFixed(2)}',
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   ProductRatingWidget(rating: product.rate),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
}

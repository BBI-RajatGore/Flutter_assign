import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductPage extends StatelessWidget {
  final List<String> productImages = [
    'https://nobero.com/cdn/shop/files/black_e4d19185-c19d-4e7c-a14a-8d2a29c7bad3.jpg?v=1711976456',
    'https://nobero.com/cdn/shop/files/black_e4d19185-c19d-4e7c-a14a-8d2a29c7bad3.jpg?v=1711976456',
    'https://nobero.com/cdn/shop/files/black_e4d19185-c19d-4e7c-a14a-8d2a29c7bad3.jpg?v=1711976456',
    'https://nobero.com/cdn/shop/files/black_e4d19185-c19d-4e7c-a14a-8d2a29c7bad3.jpg?v=1711976456',
    'https://nobero.com/cdn/shop/files/black_e4d19185-c19d-4e7c-a14a-8d2a29c7bad3.jpg?v=1711976456',
  ];

  final List<Map<String, dynamic>> products = [
    {'name': 'Product 1', 'price': '\$10.00', 'image': 'https://nobero.com/cdn/shop/files/black_e4d19185-c19d-4e7c-a14a-8d2a29c7bad3.jpg?v=1711976456'},
    {'name': 'Product 2', 'price': '\$15.00', 'image': 'https://nobero.com/cdn/shop/files/black_e4d19185-c19d-4e7c-a14a-8d2a29c7bad3.jpg?v=1711976456'},
    {'name': 'Product 3', 'price': '\$20.00', 'image': 'https://nobero.com/cdn/shop/files/black_e4d19185-c19d-4e7c-a14a-8d2a29c7bad3.jpg?v=1711976456'},
    {'name': 'Product 4', 'price': '\$25.00', 'image': 'https://nobero.com/cdn/shop/files/black_e4d19185-c19d-4e7c-a14a-8d2a29c7bad3.jpg?v=1711976456'},
    {'name': 'Product 5', 'price': '\$30.00', 'image': 'https://nobero.com/cdn/shop/files/black_e4d19185-c19d-4e7c-a14a-8d2a29c7bad3.jpg?v=1711976456'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          SizedBox(
            height: 50,
           
          ),
          _buildCarouselSlider(),
          const SizedBox(height: 16),
          Expanded(child: _buildProductGrid()),
        ],
      ),
    );
  }

  Widget _buildCarouselSlider() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 220,
        autoPlay: true,
        enlargeCenterPage: true,
        autoPlayInterval: const Duration(seconds: 3),
        viewportFraction: 0.85,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.easeInOut,
      ),
      items: productImages.map((imageUrl) {
        return Builder(
          builder: (BuildContext context) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildProductGrid() {
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
        return _buildProductCard(products[index]);
      },
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        // Handle product click
      },
      child: Card(
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
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                  child: Image.network(
                    product['image'],
                    height: 150,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.favorite_border, color: Colors.red),
                      onPressed: () {
                        // Handle favorite toggle
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
                    product['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product['price'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

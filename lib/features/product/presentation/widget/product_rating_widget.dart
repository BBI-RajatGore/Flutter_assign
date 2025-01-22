import 'package:flutter/material.dart';

class ProductRatingWidget extends StatelessWidget {
  final rating;

  const ProductRatingWidget({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    int fullStars = rating.floor();
    double fraction = rating - fullStars;
    return Row(
      children: List.generate(
        5,
        (index) {
          if (index < fullStars) {
            return const Icon(Icons.star,
                color: Color.fromARGB(255, 255, 230, 0), size: 20);
          } else if (index == fullStars && fraction > 0) {
            return const Icon(Icons.star_half,
                color: Color.fromARGB(255, 255, 230, 0), size: 20);
          } else {
            return const Icon(Icons.star_border,
                color: Color.fromARGB(255, 255, 230, 0), size: 20);
          }
        },
      ),
    );
  }
}

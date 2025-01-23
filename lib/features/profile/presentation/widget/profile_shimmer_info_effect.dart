import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileShimmerInfoEffect extends StatelessWidget {
  const ProfileShimmerInfoEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );;
  }
}
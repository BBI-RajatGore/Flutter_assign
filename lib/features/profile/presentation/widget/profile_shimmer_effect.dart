import 'package:ecommerce_app/features/profile/presentation/widget/profile_shimmer_info_effect.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileShimmerEffect extends StatelessWidget {
  const ProfileShimmerEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 20),

          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 200,
              height: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),

          const ProfileShimmerInfoEffect(),
          const SizedBox(height: 10),
          const ProfileShimmerInfoEffect(),
          const SizedBox(height: 10),
          const  ProfileShimmerInfoEffect(),
        ],
      ),
    );;
  }
}
import 'package:ecommerce_app/core/utils/constants.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/product_bloc/product_bloc.dart';
import 'package:ecommerce_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:ecommerce_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:ecommerce_app/features/profile/presentation/widget/profile_avtar_widget.dart';
import 'package:ecommerce_app/features/profile/presentation/widget/profile_info_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/features/profile/domain/entities/profile_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class ProfileContent extends StatelessWidget {
  final ProfileModel profileModel;

  const ProfileContent({Key? key, required this.profileModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ProfileAvatar(profileModel: profileModel),
        const SizedBox(height: 20),
        Text(
          profileModel.username.isNotEmpty
              ? profileModel.username
              : 'Username Not Provided',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        const SizedBox(height: 10),
        ProfileInfoCard(
          icon: Icons.phone,
          text: profileModel.phoneNumber.isNotEmpty
              ? profileModel.phoneNumber
              : 'Phone Number Not Provided',
        ),
        const SizedBox(height: 10),
        ProfileInfoCard(
          icon: Icons.location_on,
          text: profileModel.address.isNotEmpty
              ? profileModel.address
              : 'Address Not Provided',
        ),
        const SizedBox(height: 10),
        ProfileInfoCard(
          icon: Icons.logout,
          text: "Logout",
          onTap: () => _showLogoutConfirmationDialog(context),
        ),
      ],
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.teal)),
          ),
          TextButton(
            onPressed:()=> _logout(context),
            child: const Text('Logout', style: TextStyle(color: Colors.teal)),
          ),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      BlocProvider.of<ProfileBloc>(context).add(ClearProfileModelEvent());

      BlocProvider.of<AuthBloc>(context).add(SignOutEvent());

      BlocProvider.of<ProductBloc>(context).add(ClearProductListEvent());

      Navigator.pop(context);

    } catch (e) {
      Constants.showErrorSnackBar(context, "Error while logging out");
    }
  }
}

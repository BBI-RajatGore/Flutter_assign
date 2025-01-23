import 'package:ecommerce_app/core/utils/constants.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/product_bloc/product_bloc.dart';
import 'package:ecommerce_app/features/profile/domain/entities/profile_model.dart';
import 'package:ecommerce_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:ecommerce_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:ecommerce_app/features/profile/presentation/widget/profile_shimmer_effect.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePage extends StatefulWidget {

  @override
  _ProfilePageState createState() => _ProfilePageState();

}

class _ProfilePageState extends State<ProfilePage> {

  var profileModel = ProfileModel(
    username: "",
    phoneNumber: "",
    address: "",
    imageUrl: "",
  );

  Future<ProfileModel> _getProfile() async {
    final profileBloc = context.read<ProfileBloc>();
    await Future.delayed(const Duration(milliseconds: 500));
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final profile = await profileBloc.onGetProfileForProfilePage(userId);
    return profile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: RichText(
          text: const TextSpan(children: [
            TextSpan(
              text: "Your ",
              style: TextStyle(
                fontSize: 24,
                color: Colors.teal,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: "Cart",
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ]),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.edit, color: Colors.teal),
              onPressed: () {
                Navigator.pushNamed(context, '/profile-form', arguments: true)
                    .then((value) async {
                  await Future.delayed(const Duration(milliseconds: 100),
                      () async {
                    setState(() {});
                  });
                });
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder(
          future: _getProfile(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              profileModel = snapshot.data!;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildProfileContent(),
              );
            } else {
              return const ProfileShimmerEffect();
            }
          }),
    );
  }


  Widget _buildProfileContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            _showImageDialog();
          },
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            shadowColor: Colors.teal.withOpacity(0.5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: CircleAvatar(
                radius: 60,
                backgroundImage: (profileModel.imageUrl.isNotEmpty)
                    ? NetworkImage(profileModel.imageUrl)
                    : const NetworkImage(
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ4YreOWfDX3kK-QLAbAL4ufCPc84ol2MA8Xg&s"),
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
        ),
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
        _buildProfileInfo(
          icon: Icons.phone,
          text: profileModel.phoneNumber.isNotEmpty
              ? profileModel.phoneNumber
              : 'Phone Number Not Provided',
        ),
        const SizedBox(height: 10),
        _buildProfileInfo(
          icon: Icons.location_on,
          text: profileModel.address.isNotEmpty
              ? profileModel.address
              : 'Address Not Provided',
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => _showLogoutConfirmationDialog(),
          child: _buildProfileInfo(icon: Icons.logout, text: "Logout"),
        )
      ],
    );
  }

  Widget _buildProfileInfo({required IconData icon, required String text}) {
    return Card(
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
            Icon(icon, color: Colors.teal),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: text.contains('Not Provided')
                      ? Colors.grey
                      : Colors.black,
                  fontWeight: text.contains('Not Provided')
                      ? FontWeight.w400
                      : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  color: Colors.black.withOpacity(0.6),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        profileModel.imageUrl.isNotEmpty
                            ? profileModel.imageUrl
                            : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ4YreOWfDX3kK-QLAbAL4ufCPc84ol2MA8Xg&s",
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.7,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutConfirmationDialog() {
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
            onPressed: _logout,
            child: const Text('Logout', style: TextStyle(color: Colors.teal)),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
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


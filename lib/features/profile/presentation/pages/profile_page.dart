import 'package:ecommerce_app/core/widgets/app_bar_widget.dart';
import 'package:ecommerce_app/features/profile/domain/entities/profile_model.dart';
import 'package:ecommerce_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:ecommerce_app/features/profile/presentation/widget/profile_content_widget.dart';
import 'package:ecommerce_app/features/profile/presentation/widget/profile_shimmer_effect.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        title: const AppBarWidget(title: "Profile ", subtitle: "Details"),
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
                child: ProfileContent(profileModel: profileModel),
              );
            } else {
              return const ProfileShimmerEffect();
            }
          }),
    );
  }
}

import 'package:ecommerce_app/core/utils/constants.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:ecommerce_app/features/auth/presentation/pages/login_page.dart';
import 'package:ecommerce_app/features/product/presentation/pages/bottom_nav_page.dart';
import 'package:ecommerce_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:ecommerce_app/features/profile/presentation/bloc/profile_state.dart';
import 'package:ecommerce_app/features/profile/presentation/pages/profile_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthStateWrapper extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          Constants.showErrorSnackBar(context,state.message);
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return _buildLoadingScreen();
        } else if (state is AuthSignedIn) {
          return _handleProfileState(context);
        } else {
          return LoginPage();
        }
      },
    );
  }

  Widget _buildLoadingScreen() {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _handleProfileState(BuildContext context) {
    BlocProvider.of<ProfileBloc>(context).getProfile();

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        if (profileState is ProfileSetupComplete ||
            profileState is ProfileStatusCompleteState) {
          return BottomNavigationPage();
        } else if (profileState is ProfileInitialState ||
            profileState is ProfileLoadingState) {
          return _buildLoadingScreen();
        } else {
          return _buildProfileForm();
        }
      },
    );
  }

  Widget _buildProfileForm() {
    return ProfileForm(isEdit: false);
  }

}
import 'package:ecommerce_app/core/utils/constants.dart';
import 'package:ecommerce_app/core/widgets/app_bar_widget.dart';
import 'package:ecommerce_app/features/profile/domain/entities/profile_model.dart';
import 'package:ecommerce_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:ecommerce_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:ecommerce_app/features/profile/presentation/bloc/profile_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ProfileForm extends StatefulWidget {
  final bool isEdit;
  ProfileForm({required this.isEdit});

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {

  final User? user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String selectedImageUrl = "";

  @override
  void initState() {
    super.initState();
    if (user != null && user!.email != null) {
      _usernameController.text = user!.email!.split('@')[0];
    }

    final profileBloc = context.read<ProfileBloc>();
    final profileModel = profileBloc.profileModel;

    if (profileModel.username != "") {
      _usernameController.text = profileModel.username;
    }
    _phoneController.text = profileModel.phoneNumber;
    _addressController.text = profileModel.address;
    selectedImageUrl = profileModel.imageUrl;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: (widget.isEdit) ? const  AppBarWidget(title: "Update ", subtitle: "Profile") : const AppBarWidget(title: "Setup ", subtitle: "Profile"),
        actions: [
          (widget.isEdit)
              ? Container()
              : TextButton(
                  onPressed: _skipProfile,
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ),
        ],
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildProfileImageSection(),
              const SizedBox(height: 24),
              _buildTextField(
                controller: _usernameController,
                labelText: 'Username',
                validator: (value) {
                  if (value == null || value.isEmpty || value.trim() == "") {
                    return 'Please enter your username';
                  }
                  return null;
                },
                icon: Icons.person,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _phoneController,
                labelText: 'Phone Number',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim() == "" ||
                      value.startsWith("0")) {
                    return 'Please enter your phone number';
                  } else if (value.length != 10) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
                icon: Icons.phone,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _addressController,
                labelText: 'Shipping Address',
                validator: (value) {
                  if (value == null || value.isEmpty || value.trim() == "") {
                    return 'Please enter your shipping address';
                  }
                  return null;
                },
                icon: Icons.location_on,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: (widget.isEdit) ? _updateProfile : _saveProfile,
                style: ElevatedButton.styleFrom(
                  elevation: 10,
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  (widget.isEdit) ? 'Update Profile' : 'Save Profile',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return GestureDetector(
      onTap: _chooseProfileImage,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: selectedImageUrl.isNotEmpty
                ? NetworkImage(selectedImageUrl)
                : null,
            child: selectedImageUrl.isEmpty
                ? const Icon(Icons.camera_alt, color: Colors.teal, size: 30)
                : null,
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.teal,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.edit,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _chooseProfileImage() async {
    final String? selectedImageUrl = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text(
          'Select Profile Image',
          style: TextStyle(color: Colors.teal),
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Wrap(
              spacing: 16.0,
              runSpacing: 16.0,
              alignment: WrapAlignment.spaceAround,
              children: Constants.imageUrls
                  .map(
                    (url) => GestureDetector(
                      onTap: () {
                        Navigator.pop(context, url);
                      },
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(url),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );

    if (selectedImageUrl != null) {
      setState(() {
        this.selectedImageUrl = selectedImageUrl;
      });
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon, color: Colors.teal) : null,
          labelText: labelText,
          labelStyle: const TextStyle(
            color: Colors.teal,
            fontWeight: FontWeight.w500,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.teal, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.teal, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
        validator: validator,
      ),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<ProfileBloc>(context).add(
        SaveProfileEvent(
          ProfileModel(
            username: _usernameController.text.trim(),
            phoneNumber: _phoneController.text.trim(),
            address: _addressController.text.trim(),
            imageUrl: selectedImageUrl,
          ),
          user!.uid,
        ),
      );
    }
  }

  void _updateProfile() {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<ProfileBloc>(context).add(
        UpdateProfileEvent(
          ProfileModel(
            username: _usernameController.text.trim(),
            phoneNumber: _phoneController.text.trim(),
            address: _addressController.text.trim(),
            imageUrl: selectedImageUrl,
          ),
          user!.uid,
        ),
      );

      showTopSnackBar(
        displayDuration: const Duration(milliseconds: 3),
        Overlay.of(context),
        const CustomSnackBar.success(
          backgroundColor: Colors.teal,
          message: 'Profile updated successfully',
        ),
      );

      Navigator.pop(context);
    }
  }

  void _skipProfile() {
    final profileState = BlocProvider.of<ProfileBloc>(context).state;

    String? username;

    if (profileState is ProfileStatusIncompleteState) {
      username =
          profileState.profileModel.username ?? user!.email!.split('@')[0];

      BlocProvider.of<ProfileBloc>(context).add(
        SaveProfileEvent(
          ProfileModel(
            username: username,
            phoneNumber: profileState.profileModel.phoneNumber ?? '',
            address: profileState.profileModel.address ?? '',
            imageUrl: profileState.profileModel.imageUrl ?? '',
          ),
          user!.uid,
        ),
      );
    } else {
      username = user!.email!.split('@')[0];

      BlocProvider.of<ProfileBloc>(context).add(
        SaveProfileEvent(
          ProfileModel(
            username: user!.email!.split('@')[0],
            phoneNumber: '',
            address: '',
            imageUrl: '',
          ),
          user!.uid,
        ),
      );
    }
  }
}

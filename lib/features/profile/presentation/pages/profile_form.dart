import 'dart:io';
import 'package:ecommerce_app/features/profile/domain/entities/profile_model.dart';
import 'package:ecommerce_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:ecommerce_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:ecommerce_app/features/profile/presentation/bloc/profile_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfileForm extends StatefulWidget {

  @override
  _ProfileFormState createState() => _ProfileFormState();

}

class _ProfileFormState extends State<ProfileForm> {

  final User? user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    if (user != null && user!.email != null) {
      _usernameController.text = user!.email!.split('@')[0];
    }

    final profileState = BlocProvider.of<ProfileBloc>(context).state;


    if (profileState is ProfileSuccessState) {

      if(profileState.profileModel.username != ""){
        _usernameController.text = profileState.profileModel.username;
      }
      _phoneController.text = profileState.profileModel.phoneNumber;
      _addressController.text = profileState.profileModel.address;
    }

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
        automaticallyImplyLeading: false,
        title: const Text(
          'Complete Profile',
          style: TextStyle(
            color: Colors.teal,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
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
                  if (value == null || value.isEmpty || value.trim()=="") {
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
                  if (value == null || value.isEmpty || value.trim()==""  || value.startsWith("0")) {
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
                  if (value == null || value.isEmpty || value.trim()=="") {
                    return 'Please enter your shipping address';
                  }
                  return null;
                },
                icon: Icons.location_on,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  elevation: 10,
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Save Profile',
                  style: TextStyle(
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
            backgroundImage:
                _profileImage != null ? FileImage(_profileImage!) : null,
            child: _profileImage == null
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
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Profile Image'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, ImageSource.camera);
            },
            child: const Text('Take a Photo',
                style:
                    TextStyle(color: Colors.teal, fontWeight: FontWeight.w500)),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, ImageSource.gallery);
            },
            child: const Text('Choose from Gallery',
                style:
                    TextStyle(color: Colors.teal, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );

    if (source != null) {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
        });
      }
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
            imageUrl:
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ4YreOWfDX3kK-QLAbAL4ufCPc84ol2MA8Xg&s",
          ),
          user!.uid,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Welcome ${_usernameController.text.trim()}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
    );

    }
  }

  void _skipProfile() {
    final profileState = BlocProvider.of<ProfileBloc>(context).state;

    String? username;

    if (profileState is ProfileSuccessState) {

      username = profileState.profileModel.username ?? user!.email!.split('@')[0];

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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Welcome ${username}',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
    );

  }
}

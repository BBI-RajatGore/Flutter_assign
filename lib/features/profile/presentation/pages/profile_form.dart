import 'dart:io';
import 'package:ecommerce_app/features/profile/domain/entities/profile_model.dart';
import 'package:ecommerce_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:ecommerce_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:ecommerce_app/features/profile/presentation/bloc/profile_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  
  final User? user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  var _usernameController = TextEditingController();
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

    // if (user != null) {
    //   BlocProvider.of<ProfileBloc>(context).add(
    //     CheckProfileStatusEvent(user!.uid),
    //   );
    // }
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
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileStatusCompleteState) {
          // Navigate directly to the home screen if the profile is complete
          // Navigator.pushReplacementNamed(context, '/home');
        } else if (state is ProfileStatusIncompleteState) {
          // Stay on the profile form if the profile is incomplete
          // No action needed, just remain on the current screen
        }
      },
      child: Scaffold(
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
                    if (value == null || value.isEmpty) {
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
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    } else if (value.length < 10) {
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
                    if (value == null || value.isEmpty) {
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
                TextButton(
                  onPressed: _skipProfile,
                  child: const Text(
                    'Skip Profile',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
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
            backgroundImage: _profileImage != null
                ? FileImage(_profileImage!)
                : const AssetImage('assets/images/img1.png') as ImageProvider,
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
      print("saving pprodile...............");
      BlocProvider.of<ProfileBloc>(context).add(
       SaveProfileEvent(
          ProfileModel(
            username: _usernameController.text,
            phoneNumber: _phoneController.text,
            address: _addressController.text,
            imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ4YreOWfDX3kK-QLAbAL4ufCPc84ol2MA8Xg&s",
          ),
          user!.uid,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile Saved!')),
      );

      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _skipProfile() {
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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile Saved!')),
    );

    Navigator.pushReplacementNamed(context, '/home');
  }
}

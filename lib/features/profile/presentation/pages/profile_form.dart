
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
  final ImagePicker _picker = ImagePicker();

  final List<String> imageUrls = [
    'https://sketchok.com/images/articles/06-anime/002-one-piece/26/16.jpg',
    'https://imgcdn.stablediffusionweb.com/2024/9/14/fb1914b4-e462-4741-b25d-6e55eeeacd0c.jpg',
    'https://preview.redd.it/my-boa-hancock-attempt-v0-30ze1pt9g58c1.png?width=1280&format=png&auto=webp&s=31933400f61edfcd2007e6949af56e24d0522c07',
    'https://imgcdn.stablediffusionweb.com/2024/10/7/16f5e32e-0833-425f-9c2a-6c07aae8c5ee.jpg',
    'https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/040dc617-5ca2-49ad-9518-65fd6ac1e816/anim=false,width=450/00218-2389552877.jpeg',
    'https://i.pinimg.com/564x/78/fc/26/78fc26efc924e11c992afcf80c966a0f.jpg',
    'https://wallpapers.com/images/hd/anime-girl-profile-pictures-kr6trv4dmtrqrbez.jpg',
    'https://img.freepik.com/free-vector/young-man-with-glasses-avatar_1308-175763.jpg?t=st=1737359102~exp=1737362702~hmac=cf0e40c06d9f4e9c6ea250b792651bbde1673760167ac5215a93c7f85264f3e5&w=740',
    
  ];

  @override
  void initState() {
    super.initState();
    if (user != null && user!.email != null) {
      _usernameController.text = user!.email!.split('@')[0];
    }

    final profileState = BlocProvider.of<ProfileBloc>(context).state;
    if (profileState is ProfileSuccessState) {
      if (profileState.profileModel.username != "") {
        _usernameController.text = profileState.profileModel.username;
      }
      _phoneController.text = profileState.profileModel.phoneNumber;
      _addressController.text = profileState.profileModel.address;
      selectedImageUrl = profileState.profileModel.imageUrl; 
    } else {
      
      final profileBloc = context.read<ProfileBloc>();
      final profileModel = profileBloc.profileModel;

      if (profileModel.username != "") {
        _usernameController.text = profileModel.username;
      }
      _phoneController.text = profileModel.phoneNumber;
      _addressController.text = profileModel.address;
      selectedImageUrl = profileModel.imageUrl;  
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
        title: const Text(
          'Complete Profile',
          style: TextStyle(
            color: Colors.teal,
            fontWeight: FontWeight.w600,
          ),
        ),
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
            backgroundImage:
                selectedImageUrl.isNotEmpty ? NetworkImage(selectedImageUrl) : null,
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
      title: const Text('Select Profile Image',style: TextStyle(color: Colors.teal),),
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          child: Wrap(
            spacing: 16.0,  
            runSpacing: 16.0,  
            alignment: WrapAlignment.spaceAround,
            children: imageUrls
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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Profile updated successfully',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.teal,
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Welcome ${username}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
    );
  }
}

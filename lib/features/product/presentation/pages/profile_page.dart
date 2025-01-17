// import 'dart:io';
// import 'package:ecommerce_app/features/profile/domain/entities/profile_model.dart';
// import 'package:ecommerce_app/features/profile/presentation/bloc/profile_bloc.dart';
// import 'package:ecommerce_app/features/profile/presentation/bloc/profile_event.dart';
// import 'package:ecommerce_app/features/profile/presentation/bloc/profile_state.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';

// class ProfilePage extends StatefulWidget {
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   final _formKey = GlobalKey<FormState>();
//   final _usernameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _addressController = TextEditingController();
//   File? _profileImage;
//   final ImagePicker _picker = ImagePicker();

//   @override
//   void initState() {

//     super.initState();

//     BlocProvider.of<ProfileBloc>(context).add(GetProfileForProfilePage(FirebaseAuth.instance.currentUser!.uid));




//     if(profileState is ProfileStatusCompleteState){
//       _usernameController.text = profileState.profileModel.username;
//       _phoneController.text = profileState.profileModel.phoneNumber;
//       _addressController.text = profileState.profileModel.address;
//     } 

//   }

//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _phoneController.dispose();
//     _addressController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocConsumer<ProfileBloc, ProfileState>(
//         listener: (context, state) {
//           if (state is ProfileErrorState) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.message)),
//             );
//           } else if (state is ProfileStatusCompleteState) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Profile updated successfully!')),
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state is ProfileLoadingState) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is ProfileSuccessState) {
//             _usernameController.text = state.profileModel.username;
//             _phoneController.text = state.profileModel.phoneNumber;
//             _addressController.text = state.profileModel.address;
//             return _buildProfileForm(state.profileModel);
//           } else {
//             return _buildProfileForm(null);
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildProfileForm(ProfileModel? profileModel) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           children: [
//             _buildProfileImageSection(),
//             const SizedBox(height: 24),
//             _buildTextField(
//               controller: _usernameController,
//               labelText: 'Username',
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your username';
//                 }
//                 return null;
//               },
//               icon: Icons.person,
//             ),
//             const SizedBox(height: 16),
//             _buildTextField(
//               controller: _phoneController,
//               labelText: 'Phone Number',
//               keyboardType: TextInputType.phone,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your phone number';
//                 } else if (value.length != 10) {
//                   return 'Please enter a valid phone number';
//                 }
//                 return null;
//               },
//               icon: Icons.phone,
//             ),
//             const SizedBox(height: 16),
//             _buildTextField(
//               controller: _addressController,
//               labelText: 'Shipping Address',
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your shipping address';
//                 }
//                 return null;
//               },
//               icon: Icons.location_on,
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: _saveProfile,
//               style: ElevatedButton.styleFrom(
//                 elevation: 10,
//                 backgroundColor: Colors.teal,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//               child: const Text(
//                 'Update Profile',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileImageSection() {
//     return GestureDetector(
//       onTap: _chooseProfileImage,
//       child: Stack(
//         alignment: Alignment.bottomRight,
//         children: [
//           CircleAvatar(
//             radius: 60,
//             backgroundColor: Colors.grey.shade300,
//             backgroundImage:
//                 _profileImage != null ? FileImage(_profileImage!) : null,
//             child: _profileImage == null
//                 ? const Icon(Icons.camera_alt, color: Colors.teal, size: 30)
//                 : null,
//           ),
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: const BoxDecoration(
//               color: Colors.teal,
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.edit,
//               color: Colors.white,
//               size: 20,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _chooseProfileImage() async {
//     final ImageSource? source = await showDialog<ImageSource>(
//       context: context,
//       builder: (context) => SimpleDialog(
//         title: const Text('Select Profile Image'),
//         children: [
//           SimpleDialogOption(
//             onPressed: () {
//               Navigator.pop(context, ImageSource.camera);
//             },
//             child: const Text('Take a Photo',
//                 style: TextStyle(color: Colors.teal, fontWeight: FontWeight.w500)),
//           ),
//           SimpleDialogOption(
//             onPressed: () {
//               Navigator.pop(context, ImageSource.gallery);
//             },
//             child: const Text('Choose from Gallery',
//                 style: TextStyle(color: Colors.teal, fontWeight: FontWeight.w500)),
//           ),
//         ],
//       ),
//     );

//     if (source != null) {
//       final XFile? image = await _picker.pickImage(source: source);
//       if (image != null) {
//         setState(() {
//           _profileImage = File(image.path);
//         });
//       }
//     }
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String labelText,
//     bool obscureText = false,
//     TextInputType keyboardType = TextInputType.text,
//     String? Function(String?)? validator,
//     IconData? icon,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextFormField(
//         controller: controller,
//         obscureText: obscureText,
//         keyboardType: keyboardType,
//         decoration: InputDecoration(
//           prefixIcon: icon != null ? Icon(icon, color: Colors.teal) : null,
//           labelText: labelText,
//           labelStyle: const TextStyle(
//             color: Colors.teal,
//             fontWeight: FontWeight.w500,
//           ),
//           filled: true,
//           fillColor: Colors.white,
//           contentPadding:
//               const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: Colors.teal, width: 1),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: Colors.teal, width: 2),
//           ),
//           errorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: Colors.red, width: 2),
//           ),
//         ),
//         validator: validator,
//       ),
//     );
//   }

//   void _saveProfile() {
//     if (_formKey.currentState!.validate()) {
//       context.read<ProfileBloc>().add(
//             UpdateProfileEvent(
//               ProfileModel(
//                 username: _usernameController.text.trim(),
//                 phoneNumber: _phoneController.text.trim(),
//                 address: _addressController.text.trim(),
//                 imageUrl: '',
//               ),
//               FirebaseAuth.instance.currentUser!.uid,
//             ),
//           );
//     }
//   }
// }


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
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    print("CALLLEDDDDDDDD");
    // Fetch the user profile on initialization
    // BlocProvider.of<ProfileBloc>(context).add(
    //   GetProfileForProfilePage(FirebaseAuth.instance.currentUser!.uid),
    // );
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

      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } 
        },
        builder: (context, state) {
          if (state is ProfileLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileSuccessState) {

            return Center(
              child: Column(
                children: [
                  Text(state.profileModel.username),
                  Text(state.profileModel.phoneNumber),
                  Text(state.profileModel.address),
                ],
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
//   Widget _buildProfileForm(ProfileModel? profileModel) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           children: [
//             _buildProfileImageSection(),
//             const SizedBox(height: 24),
//             _buildTextField(
//               controller: _usernameController,
//               labelText: 'Username',
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your username';
//                 }
//                 return null;
//               },
//               icon: Icons.person,
//             ),
//             const SizedBox(height: 16),
//             _buildTextField(
//               controller: _phoneController,
//               labelText: 'Phone Number',
//               keyboardType: TextInputType.phone,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your phone number';
//                 } else if (value.length != 10) {
//                   return 'Please enter a valid phone number';
//                 }
//                 return null;
//               },
//               icon: Icons.phone,
//             ),
//             const SizedBox(height: 16),
//             _buildTextField(
//               controller: _addressController,
//               labelText: 'Shipping Address',
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your shipping address';
//                 }
//                 return null;
//               },
//               icon: Icons.location_on,
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: _saveProfile,
//               style: ElevatedButton.styleFrom(
//                 elevation: 10,
//                 backgroundColor: Colors.teal,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//               child: const Text(
//                 'Update Profile',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileImageSection() {
//     return GestureDetector(
//       onTap: _chooseProfileImage,
//       child: Stack(
//         alignment: Alignment.bottomRight,
//         children: [
//           CircleAvatar(
//             radius: 60,
//             backgroundColor: Colors.grey.shade300,
//             backgroundImage:
//                 _profileImage != null ? FileImage(_profileImage!) : null,
//             child: _profileImage == null
//                 ? const Icon(Icons.camera_alt, color: Colors.teal, size: 30)
//                 : null,
//           ),
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: const BoxDecoration(
//               color: Colors.teal,
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.edit,
//               color: Colors.white,
//               size: 20,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _chooseProfileImage() async {
//     final ImageSource? source = await showDialog<ImageSource>(
//       context: context,
//       builder: (context) => SimpleDialog(
//         title: const Text('Select Profile Image'),
//         children: [
//           SimpleDialogOption(
//             onPressed: () {
//               Navigator.pop(context, ImageSource.camera);
//             },
//             child: const Text('Take a Photo',
//                 style: TextStyle(color: Colors.teal, fontWeight: FontWeight.w500)),
//           ),
//           SimpleDialogOption(
//             onPressed: () {
//               Navigator.pop(context, ImageSource.gallery);
//             },
//             child: const Text('Choose from Gallery',
//                 style: TextStyle(color: Colors.teal, fontWeight: FontWeight.w500)),
//           ),
//         ],
//       ),
//     );

//     if (source != null) {
//       final XFile? image = await _picker.pickImage(source: source);
//       if (image != null) {
//         setState(() {
//           _profileImage = File(image.path);
//         });
//       }
//     }
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String labelText,
//     bool obscureText = false,
//     TextInputType keyboardType = TextInputType.text,
//     String? Function(String?)? validator,
//     IconData? icon,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextFormField(
//         controller: controller,
//         obscureText: obscureText,
//         keyboardType: keyboardType,
//         decoration: InputDecoration(
//           prefixIcon: icon != null ? Icon(icon, color: Colors.teal) : null,
//           labelText: labelText,
//           labelStyle: const TextStyle(
//             color: Colors.teal,
//             fontWeight: FontWeight.w500,
//           ),
//           filled: true,
//           fillColor: Colors.white,
//           contentPadding:
//               const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: Colors.teal, width: 1),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: Colors.teal, width: 2),
//           ),
//           errorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: Colors.red, width: 2),
//           ),
//         ),
//         validator: validator,
//       ),
//     );
//   }

//   void _saveProfile() {
//     if (_formKey.currentState!.validate()) {
//       context.read<ProfileBloc>().add(
//             UpdateProfileEvent(
//               ProfileModel(
//                 username: _usernameController.text.trim(),
//                 phoneNumber: _phoneController.text.trim(),
//                 address: _addressController.text.trim(),
//                 imageUrl: _profileImage?.path ?? '',
//               ),
//               FirebaseAuth.instance.currentUser!.uid,
//             ),
//           );
//     }
//   }
// }



// import 'dart:io';
// import 'package:ecommerce_app/features/profile/domain/entities/profile_model.dart';
// import 'package:ecommerce_app/features/profile/presentation/bloc/profile_bloc.dart';
// import 'package:ecommerce_app/features/profile/presentation/bloc/profile_event.dart';
// import 'package:ecommerce_app/features/profile/presentation/bloc/profile_state.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';

// class ProfilePage extends StatefulWidget {
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   final _formKey = GlobalKey<FormState>();
//   final _usernameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _addressController = TextEditingController();
//   File? _profileImage;
//   final ImagePicker _picker = ImagePicker();

//   @override
//   void initState() {
//     super.initState();

//     // Fetch the user profile on initialization
//     final String userId = FirebaseAuth.instance.currentUser!.uid;
//     BlocProvider.of<ProfileBloc>(context).add(GetProfileForProfilePage(userId));
//   }

//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _phoneController.dispose();
//     _addressController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//         backgroundColor: Colors.teal,
//       ),
//       body: BlocConsumer<ProfileBloc, ProfileState>(
//         listener: (context, state) {
//           if (state is ProfileErrorState) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.message)),
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state is ProfileLoadingState) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is ProfileSuccessState) {
//             // Populate text fields with profile data from state
//             _usernameController.text = state.profileModel.username;
//             _phoneController.text = state.profileModel.phoneNumber;
//             _addressController.text = state.profileModel.address;

//             // Optionally, load profile image if available
//             if (_profileImage == null && state.profileModel.imageUrl.isNotEmpty) {
//               _profileImage = File(state.profileModel.imageUrl);
//             }

//             return _buildProfileForm(state.profileModel);
//           } else {
//             return const Center(child: Text("No profile data available"));
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildProfileForm(ProfileModel? profileModel) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           children: [
//             _buildProfileImageSection(),
//             const SizedBox(height: 24),
//             _buildTextField(
//               controller: _usernameController,
//               labelText: 'Username',
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your username';
//                 }
//                 return null;
//               },
//               icon: Icons.person,
//             ),
//             const SizedBox(height: 16),
//             _buildTextField(
//               controller: _phoneController,
//               labelText: 'Phone Number',
//               keyboardType: TextInputType.phone,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your phone number';
//                 } else if (value.length != 10) {
//                   return 'Please enter a valid phone number';
//                 }
//                 return null;
//               },
//               icon: Icons.phone,
//             ),
//             const SizedBox(height: 16),
//             _buildTextField(
//               controller: _addressController,
//               labelText: 'Shipping Address',
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your shipping address';
//                 }
//                 return null;
//               },
//               icon: Icons.location_on,
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: _saveProfile,
//               style: ElevatedButton.styleFrom(
//                 elevation: 10,
//                 backgroundColor: Colors.teal,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//               child: const Text(
//                 'Update Profile',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileImageSection() {
//     return GestureDetector(
//       onTap: _chooseProfileImage,
//       child: Stack(
//         alignment: Alignment.bottomRight,
//         children: [
//           CircleAvatar(
//             radius: 60,
//             backgroundColor: Colors.grey.shade300,
//             backgroundImage:
//                 _profileImage != null ? FileImage(_profileImage!) : null,
//             child: _profileImage == null
//                 ? const Icon(Icons.camera_alt, color: Colors.teal, size: 30)
//                 : null,
//           ),
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: const BoxDecoration(
//               color: Colors.teal,
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.edit,
//               color: Colors.white,
//               size: 20,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _chooseProfileImage() async {
//     final ImageSource? source = await showDialog<ImageSource>(
//       context: context,
//       builder: (context) => SimpleDialog(
//         title: const Text('Select Profile Image'),
//         children: [
//           SimpleDialogOption(
//             onPressed: () {
//               Navigator.pop(context, ImageSource.camera);
//             },
//             child: const Text('Take a Photo',
//                 style: TextStyle(color: Colors.teal, fontWeight: FontWeight.w500)),
//           ),
//           SimpleDialogOption(
//             onPressed: () {
//               Navigator.pop(context, ImageSource.gallery);
//             },
//             child: const Text('Choose from Gallery',
//                 style: TextStyle(color: Colors.teal, fontWeight: FontWeight.w500)),
//           ),
//         ],
//       ),
//     );

//     if (source != null) {
//       final XFile? image = await _picker.pickImage(source: source);
//       if (image != null) {
//         setState(() {
//           _profileImage = File(image.path);
//         });
//       }
//     }
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String labelText,
//     bool obscureText = false,
//     TextInputType keyboardType = TextInputType.text,
//     String? Function(String?)? validator,
//     IconData? icon,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextFormField(
//         controller: controller,
//         obscureText: obscureText,
//         keyboardType: keyboardType,
//         decoration: InputDecoration(
//           prefixIcon: icon != null ? Icon(icon, color: Colors.teal) : null,
//           labelText: labelText,
//           labelStyle: const TextStyle(
//             color: Colors.teal,
//             fontWeight: FontWeight.w500,
//           ),
//           filled: true,
//           fillColor: Colors.white,
//           contentPadding:
//               const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: Colors.teal, width: 1),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: Colors.teal, width: 2),
//           ),
//           errorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: Colors.red, width: 2),
//           ),
//         ),
//         validator: validator,
//       ),
//     );
//   }

//   void _saveProfile() {
//     if (_formKey.currentState!.validate()) {
//       context.read<ProfileBloc>().add(
//             UpdateProfileEvent(
//               ProfileModel(
//                 username: _usernameController.text,
//                 phoneNumber: _phoneController.text,
//                 address: _addressController.text,
//                 imageUrl: _profileImage?.path ?? '',
//               ),
//               FirebaseAuth.instance.currentUser!.uid,
//             ),
//           );
//     }
//   }
// }

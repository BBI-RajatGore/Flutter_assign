import 'package:flutter/material.dart';
import 'package:ecommerce_app/features/profile/domain/entities/profile_model.dart';

class ProfileAvatar extends StatelessWidget {
  final ProfileModel profileModel;

  const ProfileAvatar({Key? key, required this.profileModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showImageDialog(context),
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
    );
  }

  void _showImageDialog(BuildContext context) {
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
}

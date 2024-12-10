import 'package:flutter/material.dart';
import 'package:weather_app/constants/app_constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isDark;
  final VoidCallback toggleTheme;
  final VoidCallback onSearch;

  const CustomAppBar({
    Key? key,
    required this.isDark,
    required this.toggleTheme,
    required this.onSearch,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: isDark ? AppConstants.darkAppBarColor : AppConstants.lightAppBarColor,
      title: const Text(
        'Posts',
        style: TextStyle(color: AppConstants.iconColor),
      ),
      actions: [
        IconButton(
          icon: Icon(
            isDark ? Icons.brightness_7 : Icons.brightness_2,
            color: AppConstants.iconColor,
          ),
          onPressed: toggleTheme,
        ),
        IconButton(
          icon: const Icon(
            Icons.search,
            color: AppConstants.iconColor,
          ),
          onPressed: onSearch,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:weather_app/constants/app_constants.dart';

Widget postCard(int id, String title, String subtitle, bool isDark) {
  
  final textColor = isDark ? AppConstants.darkTextColor : AppConstants.lightTextColor;
  final cardColor = isDark ? AppConstants.darkCardColor : AppConstants.lightCardColor;
  final borderColor = isDark ? AppConstants.darkBorderColor : AppConstants.lightBorderColor;

  return Card(
    color: cardColor,
    elevation: 6,
    margin: const EdgeInsets.symmetric(vertical: 8.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.all(16),
      leading: Container(
        width: 50,
        height: 50,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: borderColor,
            width: 2.0,
          ),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            id.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: borderColor,
            ),
          ),
        ),
      ),
      title: Text(
        title,
        style: AppConstants.titleTextStyle.copyWith(color: textColor),
      ),
      subtitle: Text(
        subtitle,
        style: AppConstants.subtitleTextStyle.copyWith(color: textColor),
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  );
}

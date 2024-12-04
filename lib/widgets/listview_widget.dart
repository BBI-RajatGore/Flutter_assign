import 'package:flutter/material.dart';

Widget listViewWidget(int id, String title, String subtitle, bool isDark) {

  final textColor = isDark ? Colors.white : Colors.black;
  final cardColor = isDark ? Colors.grey[800] : Colors.white;
  final borderColor = isDark ? Colors.grey : Colors.orange;

  return Card(
    color: cardColor,
    elevation: 6,
    margin: const EdgeInsets.symmetric(vertical: 8.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    child: ListTile(
      contentPadding: const  EdgeInsets.all(16),
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
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
          color: textColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 16,
          color: textColor,
        ),
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  );
}

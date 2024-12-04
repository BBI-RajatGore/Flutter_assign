import 'package:flutter/material.dart';

Widget listViewWidget(int id, String title, String subtitle) {

  return Card(
    color: Colors.white,
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
            color: Colors.orange,
            width: 2.0,
          ),
          shape: BoxShape.circle, 
        ),
        child: Center(
          child: Text(
            id.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14, 
              color: Colors.orange,
            ),
          ),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
          color: Colors.orange,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:task_manager/core/utils/constant.dart';

class DuedateDropdownWidget extends StatelessWidget {
  final String? value;
  final String hintText;
  final List<String> items;
  final Function(String?) onChanged;

  const DuedateDropdownWidget({
    Key? key,
    required this.value,
    required this.hintText,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grey, width: 1),
      ),
      child: DropdownButton<String>(
        value: value,
        hint: Text(
          hintText,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        dropdownColor: AppColors.dropdownColor,
        icon: const Icon(Icons.arrow_drop_down, color: AppColors.white, size: 24),
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }).toList(),
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 16,
        ),
        underline: const SizedBox(),
      ),
    );
  }
}

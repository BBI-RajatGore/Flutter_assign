import 'package:flutter/material.dart';
import 'package:task_manager/core/utils/constant.dart';
import 'package:task_manager/features/task/domain/entities/priority.dart';

class PriorityDropdown extends StatelessWidget {
  final Priority selectedPriority;
  final Function(Priority) onPriorityChanged;

  const PriorityDropdown({
    required this.selectedPriority,
    required this.onPriorityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Priority>(
      value: selectedPriority,
      focusColor: AppColors.grey,  
      decoration: const InputDecoration(
        labelText: 'Priority',
        labelStyle: TextStyle(color: AppColors.grey),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.grey), 
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.grey), 
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      ),
      onChanged: (Priority? newPriority) {
        if (newPriority != null) {
          onPriorityChanged(newPriority);
        }
      },
      items: Priority.values.map((Priority priority) {
        return DropdownMenuItem<Priority>(
          value: priority,
          child: Text(priority.toString().split('.').last.capitalize()),
        );
      }).toList(),
    );
  }
}

extension StringCasingExtension on String {
  String capitalize() {
    if (isEmpty) {
      return this;
    }
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

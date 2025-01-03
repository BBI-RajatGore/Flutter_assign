import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/core/utils/constant.dart';

class DueDatePicker extends StatelessWidget {
  final DateTime dueDate;
  final Function(DateTime) onDateChanged;

  DueDatePicker({required this.dueDate, required this.onDateChanged});

  String getFormattedDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date); 
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        "Due Date: ${getFormattedDate(dueDate)}",
        style: const TextStyle(fontSize: 16),
      ),
      trailing: const Icon(Icons.calendar_today, color: AppColors.grey),
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: dueDate,
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null && pickedDate.isAfter(DateTime.now())) {
          onDateChanged(pickedDate);
        }
      },
    );
  }
}

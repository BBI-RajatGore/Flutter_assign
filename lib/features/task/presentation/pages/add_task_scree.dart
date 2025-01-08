import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/utils/constant.dart';
import 'package:task_manager/features/task/domain/entities/usertask.dart';
import 'package:task_manager/features/task/presentation/bloc/task_bloc.dart';
import 'package:task_manager/features/task/presentation/bloc/task_event.dart';
import 'package:task_manager/features/task/domain/entities/priority.dart';
import 'package:task_manager/features/task/presentation/widgets/add_task_screen_widgets/due_date_picker_widget.dart';
import 'package:task_manager/features/task/presentation/widgets/add_task_screen_widgets/priority_widget.dart';
import 'package:task_manager/features/task/presentation/widgets/add_task_screen_widgets/task_form_filed_widget.dart';

class AddTaskScreen extends StatefulWidget {
  final String userId;
  final UserTask? task;

  AddTaskScreen({required this.userId, this.task});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _dueDate = DateTime.now();
  Priority _priority = Priority.high;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _dueDate = widget.task!.dueDate;
      _priority = widget.task!.priority;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.task == null
              ? AddTaskScreenConstants.addTaskText
              : AddTaskScreenConstants.editTaskText,
          style: AppTextStyles.appBarStyle.copyWith(
            fontSize: 25,
          ),
        ),
        elevation: 0,
        backgroundColor: AppColors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TaskFormField(
                  controller: _titleController,
                  label: AddTaskScreenConstants.taskTitle,
                  validator: (value) => value == null || value.trim().isEmpty 
                      ? AddTaskScreenConstants.taskTitleValidationText
                      : null,
                 
                ),
                const SizedBox(height: 16),
                TaskFormField(
                  controller: _descriptionController,
                  label: AddTaskScreenConstants.taskDescription,
                  maxLines: 8,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? AddTaskScreenConstants.taskDescValidationText
                      : null,
                ),
                const SizedBox(height: 16),
                DueDatePicker(
                  dueDate: _dueDate,
                  onDateChanged: (newDate) {
                    setState(() {
                      _dueDate = newDate;
                    });
                  },
                ),
                const SizedBox(height: 16),
                PriorityDropdown(
                  selectedPriority: _priority,
                  onPriorityChanged: (newPriority) {
                    setState(() {
                      _priority = newPriority;
                    });
                  },
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                        widget.task == null
                            ? AddTaskScreenConstants.addTaskText
                            : AddTaskScreenConstants.saveChangesText,
                        style: AppTextStyles.buttonTextStyle),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final task = UserTask(
        id: widget.task?.id ?? '',
        title: _titleController.text,
        description: _descriptionController.text,
        dueDate: _dueDate,
        priority: _priority,
      );

      if (widget.task == null) {
        context
            .read<TaskBloc>()
            .add(AddTaskEvent(userId: widget.userId, task: task));
      } else {
        final updatedTask = widget.task!.copyWith(
          title: _titleController.text,
          description: _descriptionController.text,
          dueDate: _dueDate,
          priority: _priority,
        );
        context.read<TaskBloc>().add(EditTaskEvent(
            userId: widget.userId, taskId: widget.task!.id, task: updatedTask));
      }
      Navigator.pop(context);
    }
  }
}

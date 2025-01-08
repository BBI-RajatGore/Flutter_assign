import 'package:flutter/material.dart';
import 'package:task_manager/features/task/domain/entities/usertask.dart';
import 'package:task_manager/core/utils/constant.dart';

class TaskCard extends StatelessWidget {

  final UserTask task;
  final bool isExpanded;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskCard({
    required this.task,
    required this.isExpanded,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            ListTile(
              leading: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.getPriorityColor(task.priority),
                  shape: BoxShape.circle,
                ),
              ),
              title: Text(
                task.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Due: ${task.dueDate}',
                  style: const TextStyle(color: AppColors.grey)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(
                      Icons.edit,
                      color: AppColors.deepPurple,
                    ),
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(
                      Icons.delete,
                      color: AppColors.redAccent,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              firstChild: Container(),
              secondChild: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: const Color.fromARGB(255, 144, 144, 144),
                      height: 0.5,
                    ),
                    const SizedBox(height: 8),
                    textWidget('Title:  ', task.title, context),
                    const SizedBox(height: 8),
                    textWidget('Description:  ', task.description, context),
                    const SizedBox(height: 8),
                    textWidget('Due Date:  ', task.dueDate.toString(), context),
                    const SizedBox(height: 8),
                    textWidget('Priority:  ', task.priority.name, context),
                  ],
                ),
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
          ],
        ),
      ),
    );
  }

  Widget textWidget(String title, String subtitle, BuildContext context) {
    return RichText(
      maxLines: 5,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: <TextSpan>[
          TextSpan(
            text: title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 15,
            ),
          ),
          TextSpan(
            text: subtitle,
            style: const TextStyle(
              color: Color.fromARGB(255, 84, 84, 84),
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
  
}

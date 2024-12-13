import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_app/common/utils/index.dart';

import '../../../../common/styles/text_styles.dart';
import '../../../../constants/index.dart';
import '../../model/task.dart';

class TaskTile extends HookWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.onCompletionChanged,
    this.onTap,
    required this.onDelete,
  });

  final Task task;
  final ValueChanged<bool> onCompletionChanged;
  final VoidCallback? onTap;
  final VoidCallback onDelete; // Add onDelete callback for deletion

  @override
  Widget build(BuildContext context) {
    final isChecked = useState(task.isCompleted);

    return Dismissible(
      key: Key(task.id),
      onDismissed: (_) => onDelete(),
      background: Container(
        color: Colors.red.withOpacity(0.9),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20.w),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: ListTile(
        contentPadding: EdgeInsets.only(right: 16.r),
        hoverColor: Colors.transparent,
        leading: TileCheckBox(
          value: isChecked.value,
          onChanged: (value) {
            isChecked.value = value;
            onCompletionChanged(value);
          },
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              task.time.getDateTime(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.body(
                fontSize: 15,
                color: AppColors.black.withOpacity(0.8),
                textDecoration:
                    isChecked.value ? TextDecoration.lineThrough : null,
              ),
            ),
            const Spacer(),
            PriorityCircle(priority: task.priority)
          ],
        ),
        title: Text(
          task.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: TextStyles.body(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            textDecoration: isChecked.value ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: task.subTitle != null
            ? Text(
                task.subTitle!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.body(
                  color: AppColors.black.withOpacity(0.8),
                  textDecoration:
                      isChecked.value ? TextDecoration.lineThrough : null,
                ),
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}

class PriorityCircle extends StatelessWidget {
  final TaskPriority priority;

  const PriorityCircle({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22.r,
      height: 22.r,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            priority.icon,
            size: 20.r,
            color: Colors.transparent,
          ),
          Icon(
            priority.icon,
            size: 20.r,
            color: priority.iconColor, // Color only the filled part
          ),
        ],
      ),
    );
  }
}

class TileCheckBox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const TileCheckBox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        color: Colors.transparent, // Ensures the container remains invisible
        padding: EdgeInsets.all(8.r), // Increase the gesture area
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 20.r,
          height: 20.r,
          decoration: BoxDecoration(
            color: value ? Colors.blue : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: value ? Colors.blue : AppColors.hintTextColor,
              width: 2,
            ),
          ),
          child: value
              ? const Icon(
                  Icons.check,
                  size: 16,
                  color: Colors.white,
                )
              : null,
        ),
      ),
    );
  }
}

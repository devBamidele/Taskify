import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_app/common/utils/index.dart';
import 'package:task_app/core/providers/providers.dart';
import 'package:uuid/uuid.dart';

import '../../../../common/components/index.dart';
import '../../../../common/styles/text_styles.dart';
import '../../../../constants/index.dart';
import '../../model/task.dart';
import '../widgets/index.dart';

class TaskScreen extends HookConsumerWidget {
  const TaskScreen({super.key, this.task});

  final Task? task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isNew = task == null;

    final taskNotifier = ref.read(taskCudProvider.notifier);

    final titleFocusNode = useFocusNode();
    final descFocusNode = useFocusNode();

    final title = useTextEditingController(text: isNew ? '' : task!.title);
    final desc = useTextEditingController(text: isNew ? '' : task!.subTitle);

    final titleFormKey = useState(GlobalKey<FormState>());
    final descFormKey = useState(GlobalKey<FormState>());

    final titleShakeState = useState(GlobalKey<ShakeState>());

    final selectedDate = useState<DateTime>(
      isNew ? DateTime.now() : task?.time ?? DateTime.now(),
    );

    final selectedTime = useState<TimeOfDay>(
      isNew ? TimeOfDay.now() : TimeOfDay.fromDateTime(task!.time),
    );

    final selectedPriority = useState<TaskPriority>(
      isNew ? TaskPriority.low : task!.priority,
    );

    void editDate() async {
      final now = DateTime.now();
      final date = await showDatePicker(
        context: context,
        initialDate: selectedDate.value,
        firstDate: DateTime(now.year - 5),
        lastDate: DateTime(now.year + 5),
      );
      if (date != null) {
        selectedDate.value = date;
      }
    }

    void editTime() async {
      final time = await showTimePicker(
        context: context,
        initialTime: selectedTime.value,
      );
      if (time != null) {
        selectedTime.value = time;
      }
    }

    Future<void> saveTask() async {
      final newTask = Task(
        id: isNew ? const Uuid().v4() : task!.id,
        title: title.text,
        subTitle: desc.text.isNotEmpty ? desc.text : null,
        time: DateTime(
          selectedDate.value.year,
          selectedDate.value.month,
          selectedDate.value.day,
          selectedTime.value.hour,
          selectedTime.value.minute,
        ),
        priority: selectedPriority.value,
      );

      if (isNew) {
        await taskNotifier.createTask(newTask);
      } else {
        await taskNotifier.updateTask(newTask);
      }
    }

    validateCreate() {
      bool titleValid = titleFormKey.value.currentState?.validate() ?? false;

      if (titleValid) {
        saveTask();

        return;
      }

      if (!titleValid) titleShakeState.value.currentState?.shake();
    }

    bool isSaving() {
      return ref.watch(taskCudProvider).maybeWhen(
            loading: () => true,
            orElse: () => false,
          );
    }

    ref.listen(taskCudProvider, (previous, next) {
      next.maybeWhen(
        orElse: () => null,
        error: (msg) => showSnackbar(context, msg),
        success: () => context.pop(),
      );
    });

    // Hook for character count
    final characterCount = useState<int>(0);

    useEffect(() {
      void updateCharCount() {
        characterCount.value = title.text.length;
      }

      title.addListener(updateCharCount);

      return () => title.removeListener(updateCharCount);
    }, [title]);

    const int maxCharacterCount = 50;

    return AppScaffold(
      canNavigateBack: true,
      isScrollable: false,
      shouldResize: false,
      children: [
        addHeight(16),
        Text(
          isNew ? 'Add a task' : 'Edit Task',
          style: TextStyles.base.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 25.asp,
          ),
        ),
        addHeight(30),
        Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Text(
            'Title',
            style: TextStyles.body(fontWeight: FontWeight.w500),
          ),
        ),
        Form(
          key: titleFormKey.value,
          child: Shake(
            key: titleShakeState.value,
            child: AppTextField(
              enabled: !isSaving(),
              focusNode: titleFocusNode,
              lengthLimit: maxCharacterCount,
              textController: title,
              hintText: 'What is the task about?',
              validation: (text) => text?.validateString('Title'),
            ),
          ),
        ),
        addHeight(4),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${characterCount.value}/$maxCharacterCount',
            style: TextStyles.body(),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Text(
            'Description',
            style: TextStyles.body(fontWeight: FontWeight.w500),
          ),
        ),
        Form(
          key: descFormKey.value,
          child: AppTextField(
            enabled: !isSaving(),
            focusNode: descFocusNode,
            textController: desc,
            keyboardType: TextInputType.multiline,
            hintText: "Describe the task in detail",
          ),
        ),
        addHeight(24),
        DateTimePicker(
          icon: Icons.calendar_today,
          valueText: selectedDate.value.getFormattedDay(),
          onTap: editDate,
          editIconColor: Colors.black,
          valueTextStyle: TextStyles.body(fontWeight: FontWeight.w500),
        ),
        DateTimePicker(
          icon: Icons.access_time,
          valueText: selectedTime.value.getTime(),
          onTap: editTime,
          editIconColor: Colors.black,
          valueTextStyle: TextStyles.body(fontWeight: FontWeight.w500),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Text(
            'Priority',
            style: TextStyles.body(fontWeight: FontWeight.w500),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: TaskPriority.values.map((priority) {
            return GestureDetector(
              onTap: () => selectedPriority.value = priority,
              child: Row(
                children: [
                  Radio<TaskPriority>(
                    value: priority,
                    groupValue: selectedPriority.value,
                    onChanged: (value) {
                      if (value != null) {
                        selectedPriority.value = value;
                      }
                    },
                    activeColor: priority.iconColor,
                  ),
                  Text(
                    priority.data,
                    style: TextStyles.body(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        const Spacer(),
        Padding(
          padding: EdgeInsets.only(bottom: 30.h),
          child: AppButton(
            onPress: validateCreate,
            text: isNew ? 'Add Task' : 'Save Changes',
            loading: isSaving(),
          ),
        ),
      ],
    );
  }
}

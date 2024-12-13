import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_app/common/components/index.dart';

import '../../../../common/styles/text_styles.dart';
import '../../../../common/utils/index.dart';
import '../../../../constants/index.dart';
import '../../../../core/providers/providers.dart';
import '../../model/task.dart';
import '../widgets/index.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskStreamState = ref.watch(taskStreamProvider);
    final taskNotifier = ref.read(taskCudProvider.notifier);

    void onChanged(Task task, bool isCompleted) {
      taskNotifier.updateTask(task.copyWith(isCompleted: isCompleted));
    }

    buildLoader() => const AppLoader(color: AppColors.primary, size: 24);

    ref.listen(taskCudProvider, (previous, next) {
      next.maybeWhen(
        orElse: () => null,
        error: (msg) => showSnackbar(context, msg),
      );
    });

    Future<void> showLogoutDialog() async {
      final shouldLogout = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Logout'),
          content: const Text(AppStrings.logoutDialogMessage),
          actions: [
            TextButton(
              onPressed: () => context.pop(false),
              child: Text(
                'Cancel',
                style: TextStyles.body(),
              ),
            ),
            TextButton(
              onPressed: () => context.pop(true),
              child: Text(
                'Logout',
                style: TextStyles.body(
                  color: Colors.red.withOpacity(0.9),
                ),
              ),
            ),
          ],
        ),
      );

      if (shouldLogout == true) {
        await ref.read(authNotifierProvider.notifier).logout();

        if (context.mounted) context.push(AppRoutes.login);
      }
    }

    return AppScaffold(
      shouldResize: false,
      fab: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.task),
        backgroundColor: Colors.blue,
        tooltip: "Add Item",
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
      isScrollable: false,
      children: [
        addHeight(8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.appName,
              style: TextStyles.base.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 25.asp,
                color: Colors.blue,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.blue,
                size: 28,
              ),
              onPressed: () => showLogoutDialog(),
            ),
          ],
        ),
        addHeight(4),
        Expanded(
          child: taskStreamState.maybeWhen(
            orElse: buildLoader,
            streaming: (tasks) {
              if (tasks.isEmpty) {
                return Center(
                  child: Text(
                    AppStrings.noTasksAvailable,
                    style: TextStyles.body(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return TaskTile(
                    task: task,
                    onCompletionChanged: (value) => onChanged(task, value),
                    onTap: () => context.push(AppRoutes.task, extra: task),
                    onDelete: () => taskNotifier.deleteTask(task.id),
                  );
                },
              );
            },
            streamError: (message) => Center(
              child: Text(
                'Stream Error',
                style: TextStyles.body(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

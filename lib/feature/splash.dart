import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:task_app/common/components/index.dart';

import '../common/styles/text_styles.dart';
import '../common/utils/index.dart';
import '../constants/index.dart';
import '../core/providers/providers.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authNotifierProvider, (previous, next) {
      next.maybeWhen(
        orElse: () => null,
        authenticated: (user) {
          Future.delayed(const Duration(seconds: 2), () {
            if (context.mounted) context.go(AppRoutes.home);
          });
        },
        unauthenticated: (msg) {
          Future.delayed(const Duration(seconds: 2), () {
            if (context.mounted) context.go(AppRoutes.login);
          });
        },
      );
    });

    return AppScaffold(
      isScrollable: false,
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppStrings.appName,
                  style: TextStyles.heading(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

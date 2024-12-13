import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/index.dart';
import '../../styles/component_style.dart';
import '../../styles/text_styles.dart';
import '../Loader/app_loader.dart';

class AppButton extends StatelessWidget {
  final VoidCallback? onPress;
  final Color? color;
  final double height;
  final bool loading;
  final String? text; // Change to nullable
  final Widget? child;

  const AppButton({
    super.key,
    required this.onPress,
    this.color,
    this.height = 46,
    this.loading = false,
    this.text, // Change to nullable
    this.child,
  }) : assert(text == null || child == null,
            'You cannot provide both text and child. Please provide either one.');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: MaterialButton(
        height: height.h,
        color: color ?? AppColors.buttonColor,
        onPressed: loading || onPress == null ? null : onPress,
        textColor: Colors.white,
        elevation: 0,
        highlightElevation: 0,
        shape: circularBorder,
        disabledColor: AppColors.buttonColor.withOpacity(0.8),
        child: loading
            ? const AppLoader()
            : child ??
                Text(
                  text ?? '',
                  style: TextStyles.body(
                      fontWeight: FontWeight.w500, color: Colors.white),
                ),
      ),
    );
  }
}

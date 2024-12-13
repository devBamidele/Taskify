import 'package:flutter/material.dart';
import 'package:task_app/constants/index.dart';

import '../../styles/component_style.dart';
import '../../styles/text_styles.dart';

class AppTheme {
  static ThemeData theme() => ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyles.body(color: AppColors.hintTextColor),
          isDense: true,
          errorStyle: TextStyles.error(),
          enabledBorder: inputBorder,
          errorBorder: errorBorder,
          focusedErrorBorder: focusedErrorBorder,
          disabledBorder: inputBorder,
          border: inputBorder,
          focusedBorder: focusedBorder,
        ),
        dialogTheme: DialogTheme(
          shape: dialogShape,
          titleTextStyle: TextStyles.body(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
          contentTextStyle: TextStyles.body(),
        ),
      );
}

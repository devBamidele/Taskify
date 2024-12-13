import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../styles/text_styles.dart';

SizedBox addHeight(double height, {bool isRsv = true}) =>
    SizedBox(height: isRsv ? height.h : height);

SizedBox addWidth(double width, {bool isRsv = true}) =>
    SizedBox(width: isRsv ? width.w : width);

void showSnackbar(BuildContext context, String? message) {
  if (message == null) return;

  showTopSnackBar(
    Overlay.of(context),
    CustomSnackBar.error(
      message: message,
      textStyle: TextStyles.snackbarText(),
    ),
  );
}

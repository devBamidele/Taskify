import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants/index.dart';
import '../../styles/text_styles.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.focusNode,
    required this.textController,
    required this.hintText,
    this.validation,
    this.suffixIcon,
    this.obscureText = false,
    this.error = false,
    this.action = TextInputAction.next,
    this.onFieldSubmitted,
    this.maxLength,
    this.lengthLimit,
    this.prefixIcon,
    this.enabled = true,
    this.keyboardType,
    this.padding = 16,
    this.maxLines = 1,
  });

  final FocusNode focusNode;
  final TextEditingController textController;
  final void Function(String)? onFieldSubmitted;
  final String hintText;

  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validation;
  final TextInputAction action;
  final bool obscureText;

  final Color textColor = AppColors.black;
  final int? maxLength;
  final int? lengthLimit;
  final bool enabled;
  final bool error;
  final double padding;
  final TextInputType? keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final Color effectiveTextColor =
        enabled ? textColor : textColor.withOpacity(0.7);

    return TextFormField(
      keyboardType: keyboardType,
      style: TextStyles.body(color: effectiveTextColor),
      maxLength: maxLength,
      cursorColor: textColor,
      focusNode: focusNode,
      controller: textController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: obscureText,
      textInputAction: action,
      validator: validation,
      onFieldSubmitted: onFieldSubmitted,
      enabled: enabled,
      maxLines: maxLines,
      inputFormatters: [
        LengthLimitingTextInputFormatter(maxLength ?? lengthLimit),
      ],
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(
          vertical: padding,
          horizontal: padding / 2,
        ),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
      ),
    );
  }
}

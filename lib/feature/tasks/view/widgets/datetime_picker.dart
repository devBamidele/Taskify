import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DateTimePicker extends StatelessWidget {
  const DateTimePicker({
    super.key,
    required this.icon,
    required this.valueText,
    required this.onTap,
    required this.editIconColor,
    required this.valueTextStyle,
  });

  final IconData icon;
  final String valueText;
  final VoidCallback onTap;
  final Color editIconColor;
  final TextStyle valueTextStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.black),
                  SizedBox(width: 12.w),
                  Text(
                    valueText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: valueTextStyle,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 0, 8),
                child: Icon(
                  Icons.edit,
                  color: editIconColor,
                  size: 18.r,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

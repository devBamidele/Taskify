import 'package:flutter/material.dart';
import 'package:task_app/common/utils/index.dart';

import '../../../../common/styles/text_styles.dart';
import '../../../../constants/index.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.title,
    required this.subtitle,
    this.topSpacing = 60,
    this.gapSpacing = 4,
    this.bottomSpacing = 30,
  });

  final String title;
  final String subtitle;
  final double topSpacing;
  final double gapSpacing;
  final double bottomSpacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        addHeight(topSpacing),
        Text(
          title,
          style: TextStyles.base.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 25.asp,
          ),
        ),
        addHeight(gapSpacing),
        Text(
          subtitle,
          style: TextStyles.base.copyWith(
            // fontWeight: FontWeight.w500,
            fontSize: 17,
            color: AppColors.hintTextColor,
          ),
        ),
        addHeight(bottomSpacing),
      ],
    );
  }
}

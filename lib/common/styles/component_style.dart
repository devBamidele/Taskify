import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/colors.dart';

final pagePadding = EdgeInsets.symmetric(horizontal: 14.r);

final dialogShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(8), // Less curve
);

final inputBorder = UnderlineInputBorder(
  borderSide: BorderSide(
    color: AppColors.black.withOpacity(0.6),
    width: 1.0,
  ),
);

final errorBorder = UnderlineInputBorder(
  borderSide: BorderSide(
    color: AppColors.errorBorderColor.withOpacity(0.6),
    width: 1,
  ),
);

final focusedErrorBorder = UnderlineInputBorder(
  borderSide: BorderSide(
    color: AppColors.errorBorderColor.withOpacity(0.9),
    width: 1.5,
  ),
);

final focusedBorder = UnderlineInputBorder(
  borderSide: BorderSide(
    color: AppColors.black.withOpacity(0.9),
    width: 1,
  ),
);

const curvySide = BorderRadius.all(Radius.circular(12));

final circularBorder = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(8.r),
);

final sheetDecoration = BoxDecoration(
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.1), // Shadow color
      blurRadius: 10,
      offset: const Offset(0, -4),
    ),
  ],
);

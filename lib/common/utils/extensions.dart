import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension StringExtention on String? {
  String? validateEmail() {
    if (this != null && !EmailValidator.validate(this!)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? validateString(String name) {
    if (this == null || this!.isEmpty) {
      return '$name is required';
    }
    return null;
  }

  bool validatePassword() {
    final requirements = [
      RegExp(r'.{8,}'),
      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])'),
      RegExp(r'(?=.*\d)'),
      RegExp(r'(?=.*[@$!%*?&])'),
    ];

    for (var regex in requirements) {
      if (!regex.hasMatch(this!)) return false;
    }
    return true;
  }

  String? validateConfirmPwd(TextEditingController password) {
    if (this == null || this!.isEmpty) {
      return 'Confirm password is required';
    }
    if (this != password.text) {
      return 'Passwords do not match';
    }
    return null;
  }
}

extension AdaptiveTextSize on num {
  double get asp {
    final scaleFactor = ScreenUtil().scaleWidth * 0.9;
    return (this * scaleFactor).clamp(toDouble(), this * 1.4);
  }
}

extension DateTimeFormatting on DateTime {
  String getDateTime() {
    final now = DateTime.now();
    final differenceInDays = now.difference(this).inDays;
    final isSameDay = differenceInDays == 0 && now.day == day;
    final isTomorrow = differenceInDays == -1;
    final isYesterday = differenceInDays == 1;
    final isWithinNextMonth = isAfter(now) && month == now.month + 1;
    final isWithinThisYear = year == now.year;

    final hour = this.hour % 12 == 0 ? 12 : this.hour % 12;
    final minute = this.minute.toString().padLeft(2, '0');
    final period = this.hour >= 12 ? 'pm' : 'am';
    final time = '$hour:$minute $period';

    if (isSameDay) {
      return time;
    } else if (isTomorrow) {
      return 'Tomorrow, $time';
    } else if (isYesterday) {
      return 'Yesterday, $time';
    } else if (differenceInDays.abs() <= 7 && isBefore(now)) {
      return 'Last ${getDayOfWeek(weekday)}, $time';
    } else if (differenceInDays.abs() <= 7 && isAfter(now)) {
      return '${getDayOfWeek(weekday)}, $time';
    } else if (isWithinThisYear || isWithinNextMonth) {
      return '${getDayOfWeek(weekday)}, $day${getDaySuffix(day)} ${getMonthName(month)}';
    } else {
      return '${getDayOfWeek(weekday)}, $day${getDaySuffix(day)} ${getMonthName(month)}';
    }
  }

  String getDayOfWeek(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[weekday - 1];
  }

  String getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th'; // Handle 11th, 12th, 13th
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  String getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  String getFormattedDay() {
    // Get the day of the week
    final dayOfWeek = toLocal().weekday;
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    // Get the day of the month and append suffix (st, nd, rd, th)
    final dayOfMonth = day;
    String suffix;
    if (dayOfMonth == 1 || dayOfMonth == 21 || dayOfMonth == 31) {
      suffix = 'st';
    } else if (dayOfMonth == 2 || dayOfMonth == 22) {
      suffix = 'nd';
    } else if (dayOfMonth == 3 || dayOfMonth == 23) {
      suffix = 'rd';
    } else {
      suffix = 'th';
    }

    // Get the month
    final month = toLocal().month;
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    // Construct the formatted string
    return '${days[dayOfWeek - 1]}, $dayOfMonth$suffix ${months[month - 1]}';
  }

  // Helper functions to compare dates
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isTomorrow(DateTime other) {
    final tomorrow = add(const Duration(days: 1));
    return tomorrow.isSameDay(other);
  }

  bool isThisWeek(DateTime other) {
    final startOfWeek = subtract(Duration(days: weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return other.isAfter(startOfWeek) && other.isBefore(endOfWeek);
  }

  bool isThisMonth(DateTime other) {
    return year == other.year && month == other.month;
  }
}

extension TimeOfDayFormatting on TimeOfDay {
  String getTime() {
    final hour = this.hour % 12 == 0 ? 12 : this.hour % 12;
    final minute = this.minute.toString().padLeft(2, '0');
    final period = this.hour >= 12 ? 'pm' : 'am';

    return '$hour:$minute $period';
  }
}

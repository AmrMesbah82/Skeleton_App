// Shared visual tokens & helpers for the reusable Figma card widgets.
// Theme source: Knowticed app (AppColors / AppFontWeights).
// All sizes are responsive via flutter_screenutil (.sp / .w / .h / .r).

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_font_weights.dart';
import '../theme/app_colors.dart';

/// SVG icon assets used by the card widgets.
abstract class CardSvg {
  static const String _base = 'assets/new/card_widget';
  static const String _baseNew = 'assets/new';

  static const String services = '$_base/services_icon.svg';
  static const String serviceProvider = '$_base/services_provider.svg';
  static const String jobTitle = '$_base/job_titile.svg';
  static const String duration = '$_base/duration_of_services.svg';
  static const String approval = '$_base/approval.svg';
  static const String personalInfo = '$_base/personal_information.svg';
  static const String department = '$_base/department.svg';
  static const String message = '$_baseNew/message_new_icon.svg';
  static const String email = '$_base/email_icon.svg';
  static const String phone = '$_base/phone_icon.svg';
  static const String male = '$_base/male.svg';
  static const String approve = '$_baseNew/approved.svg';
  static const String reject = '$_baseNew/reject.svg';
  static const String remove = '$_baseNew/remove.svg';

  /// Builds an SVG icon, optionally tinted with [color].
  static Widget icon(String path, {Color? color, double? size}) =>
      SvgPicture.asset(
        path,
        width: size?.r,
        height: size?.r,
        colorFilter:
            color == null ? null : ColorFilter.mode(color, BlendMode.srcIn),
      );
}

abstract class CardStyles {
  /// Default card corner radius (8 in Figma).
  static BorderRadius radius([double r = 8]) => BorderRadius.circular(r.r);

  /// Figma drop shadow: (-3, 4) blur 20, black 2%.
  static List<BoxShadow> get shadow => [
        BoxShadow(
          color: const Color(0x05000000),
          offset: Offset(-3.w, 4.h),
          blurRadius: 20.r,
        ),
      ];

  /// Grey label style (e.g. "Job Title:").
  static TextStyle label(double size) => GoogleFonts.cairo(
        fontSize: size.sp,
        color: AppColors.secondaryText,
        fontWeight: AppFontWeights.regular,
      );

  /// Dark value style (e.g. "Marketing Manager").
  static TextStyle value(double size) => GoogleFonts.cairo(
        fontSize: size.sp,
        color: AppColors.text,
        fontWeight: AppFontWeights.regular,
      );

  /// Card title style.
  static TextStyle title(double size) => GoogleFonts.cairo(
        fontSize: size.sp,
        color: AppColors.text,
        fontWeight: AppFontWeights.medium,
      );
}

/// A "label: value" entry used by the cards, with an optional leading icon.
class CardInfo {
  final String label;
  final String value;
  final Widget? icon;

  const CardInfo({required this.label, required this.value, this.icon});
}

/// Renders: [icon] label value   (e.g. "👤 Service Provider: Ahmed Mohammed")
class CardInfoRow extends StatelessWidget {
  final CardInfo info;
  final double fontSize;
  final double iconSize;

  const CardInfoRow({
    super.key,
    required this.info,
    this.fontSize = 14,
    this.iconSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (info.icon != null) ...[
          SizedBox(
            width: iconSize.r,
            height: iconSize.r,
            child: FittedBox(child: info.icon),
          ),
          SizedBox(width: 4.w),
        ],
        Flexible(
          child: Text.rich(
            TextSpan(
              text: '${info.label} ',
              style: CardStyles.label(fontSize),
              children: [
                TextSpan(
                  text: info.value,
                  style: CardStyles.value(fontSize),
                ),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

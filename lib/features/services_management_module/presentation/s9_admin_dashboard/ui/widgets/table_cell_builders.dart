/// ******************* FILE INFO *******************
/// File Name: table_cell_builders.dart
/// Description: Widget-level cell builders for ServiceRequestTableWidget.
///              Receives already-resolved strings — no data reading here.
/// Created by: Amr Mesbah

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:demo_app/core/helper/services_management/format_helper.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';

class TableCellBuilders {
  const TableCellBuilders._();

  // ─── Styles ────────────────────────────────────────────────────────────────

  static TextStyle headerStyle() =>
      AppTextStyles.font14BlackSemiBoldCairo.copyWith(color: AppColors.white);

  static TextStyle cellStyle(BuildContext context) =>
      AppTextStyles.font13SecondaryBlackCairo.copyWith(
        color: Theme.of(context).brightness == Brightness.light
            ? AppColors.blackButton
            : AppColors.white,
      );

  // ─── Base cell ─────────────────────────────────────────────────────────────

  static Widget cell(
      BuildContext context,
      Widget child, {
        EdgeInsets? padding,
      }) {
    return Container(
      padding: padding ??
          EdgeInsets.symmetric(horizontal: 10.sp, vertical: 8.sp),
      child: DefaultTextStyle.merge(
        style: cellStyle(context),
        child: child,
      ),
    );
  }

  // ─── Text cell ─────────────────────────────────────────────────────────────

  static Widget textCell(
      BuildContext context,
      String text, {
        int maxLines = 2,
        TextAlign textAlign = TextAlign.start,
        Color? textColor,
        FontWeight? fontWeight,
      }) {
    return cell(
      context,
      Text(
        FormatHelper.capitalize(text.isEmpty ? '-' : text),
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        textAlign: textAlign,
        style: cellStyle(context).copyWith(
          color: textColor,
          fontWeight: fontWeight,
        ),
      ),
    );
  }

  // ─── Person cell (name + avatar) ───────────────────────────────────────────

  static Widget personCell(
      BuildContext context,
      String name,
      bool isMale, {
        required bool isArabic,
      }) {
    final avatar = ClipOval(
      child: SvgPicture.asset(
        isMale ? 'assets/male.svg' : 'assets/female.svg',
        width: 22.sp,
        height: 22.sp,
      ),
    );

    final nameText = Flexible(
      child: Text(
        FormatHelper.capitalize(name),
        overflow: TextOverflow.ellipsis,
        textAlign: isArabic ? TextAlign.end : TextAlign.start,
        style: cellStyle(context),
      ),
    );

    // In Arabic: name → avatar. In English: avatar → name.
    final children = isArabic
        ? <Widget>[nameText, SizedBox(width: 6.w), avatar]
        : <Widget>[avatar, SizedBox(width: 6.w), nameText];

    return cell(
      context,
      Directionality(
        textDirection:
        isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }

  // ─── Tap wrapper ───────────────────────────────────────────────────────────

  static Widget tappable(Widget child, VoidCallback onTap) =>
      InkWell(onTap: onTap, child: child);
}

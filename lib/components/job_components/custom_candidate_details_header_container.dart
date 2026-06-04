import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:demo_app/core/widgets/buttons/custom_icon_button.dart';


import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';

class CustomCandidateDetailsHeaderContainer extends StatefulWidget {
  final VoidCallback? onChatPressed;
  final VoidCallback? onDownlaodPressed;
  final String candidateName;
  final String candidateTitle;
  final String candidateLocation;
  final String submitDate;

  const CustomCandidateDetailsHeaderContainer({
    Key? key,
    this.onChatPressed,
    this.onDownlaodPressed,
    required this.candidateName,
    required this.candidateTitle,
    required this.candidateLocation,
    required this.submitDate,
  }) : super(key: key);

  @override
  State<CustomCandidateDetailsHeaderContainer> createState() =>
      _CustomCandidateDetailsHeaderContainerState();
}

class _CustomCandidateDetailsHeaderContainerState
    extends State<CustomCandidateDetailsHeaderContainer> {
  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inversePrimary,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(0.02.h),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: isPortrait ? 0.03.h : 0.06.h,
                backgroundImage: AssetImage("assets/images/profile1.png"),
              ),
              SizedBox(
                width: 0.02.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    //   color: Colors.amber,
                    width: isPortrait ? 0.3.w : 0.5.w,
                    child: Text(
                      widget.candidateName,
                      style: AppFontStyle.cairoRegularStyle.copyWith(
                          fontSize: isTablet
                              ? (isPortrait
                                  ? FontConstants.fontSize020.h
                                  : FontConstants.fontSize033.h)
                              : FontConstants.fontSize026.h,
                          fontWeight: FontWeight.w600,
                           letterSpacing: Get.locale.toString().contains('en')
                                      ?  1.1 :null,
                          color: Theme.of(context).colorScheme.inverseSurface,
                          height: 1.4),
                    ),
                  ),
                  SizedBox(
                      height:
                          isTablet ? (!isPortrait ? 0.02.h : 0.015.h) : 0.01.h),
                  Container(
                    //  color: Colors.amber,
                    width: isPortrait ? 0.3.w : 0.5.w,
                    child: Text(
                      widget.candidateTitle,
                      style: AppFontStyle.cairoRegularStyle.copyWith(
                        fontSize: isTablet
                            ? (isPortrait
                                ? FontConstants.fontSize016.h
                                : FontConstants.fontSize028.h)
                            : FontConstants.fontSize020.h,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.scrim,
                      ),
                    ),
                  ),
                  SizedBox(
                      height:
                          isTablet ? (!isPortrait ? 0.02.h : 0.015.h) : 0.01.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDetailWidget('Location:', widget.candidateLocation),
                      if (!isPortrait)
                        SizedBox(
                          width: 0.04.w,
                        ),
                      if (!isPortrait)
                        _buildDetailWidget('Date:', widget.submitDate),
                    ],
                  ),
                  if (isPortrait) SizedBox(height: 0.01.h),
                  if (isPortrait)
                    _buildDetailWidget('Date:', widget.submitDate),
                ],
              ),
              if (isTablet) Spacer(),
              if (isTablet)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: isPortrait ? 0.31.w : 0.2.w,
                      child: CustomIconButton(
                        isReviewPage: true,
                        buttonText: 'Chat With Applicant',
                        imagePath: 'assets/icons/ChatWithApplicants.svg',
                        textColor: MyThemeData().contrastColor(),
                        onPressed: widget.onChatPressed ?? () {},
                      ),
                    ),
                    SizedBox(
                      height: isPortrait ? 0.035.h : 0.02.h,
                    ),
                    Container(
                      width: isPortrait ? 0.31.w : 0.2.w,
                      child: CustomIconButton(
                        buttonText: 'Download Application',
                        isReviewPage: true,
                        textColor: MyThemeData().contrastColor(),
                        imagePath: 'assets/icons/downloadIcon.svg',
                        onPressed: widget.onDownlaodPressed ?? () {},
                      ),
                    ),
                  ],
                ),
            ],
          ),
          if (!isTablet)
            Column(
              children: [
                SizedBox(
                  height: 0.01.h,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomIconButton(
                        isReviewPage: true,
                        buttonText: 'Chat',
                        imagePath: 'assets/icons/ChatWithApplicants.svg',
                        textColor: MyThemeData().contrastColor(),
                        onPressed: widget.onChatPressed ?? () {},
                      ),
                    ),
                    SizedBox(width: 0.02.w),
                    Expanded(
                      child: CustomIconButton(
                        buttonText: 'Download',
                        isReviewPage: true,
                        textColor: MyThemeData().contrastColor(),
                        imagePath: 'assets/icons/downloadIcon.svg',
                        onPressed: widget.onDownlaodPressed ?? () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildDetailWidget(String title, String value) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFontStyle.cairoRegularStyle.copyWith(
            fontSize: isTablet
                ? (isPortrait
                    ? FontConstants.fontSize016.h
                    : FontConstants.fontSize028.h)
                : FontConstants.fontSize020.h,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.scrim,
          ),
        ),
        SizedBox(
          width: 0.01.w,
        ),
        Container(
        //  color: Colors.amber,
          width: 0.18.w,
          child: Text(
            value,
            style: AppFontStyle.cairoRegularStyle.copyWith(
              fontSize: isTablet
                  ? (isPortrait
                      ? FontConstants.fontSize016.h
                      : FontConstants.fontSize028.h)
                  : FontConstants.fontSize020.h,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.inverseSurface,
            ),
          ),
        ),
      ],
    );
  }
}

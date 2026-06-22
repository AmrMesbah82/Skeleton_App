import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_icon_button.dart';
import 'package:demo_app/core/widgets/custom_toggle.dart';
import 'package:demo_app/core/widgets/filters_appbar.dart';
import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/core/theme/app_colors.dart';

class RejectedRequestDialog extends StatefulWidget {
  const RejectedRequestDialog({super.key});

  @override
  State<RejectedRequestDialog> createState() => _RejectedRequestDialogState();
}

class _RejectedRequestDialogState extends State<RejectedRequestDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 0.15.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
       decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        height: 0.44.h,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.02.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.02.h),
                  child: const FiltersAppBar(
                      hideIcon: true,
                      imageUrl: "assets/images/departme.svg",
                      title: "Rejected Request"),
                ),
                Text(
                  "Comment".tr,
                  style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: FontConstants.fontSize016.w,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.inverseSurface),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 0.015.h, bottom: 0.02.h),
                  child: CustomToggle(
                      enabled: true,
                      horizontalMargin: false,
                      isExpanded: false,
                      borded: true,
                      fillColor: Theme.of(context).colorScheme.inversePrimary,
                      onToggleChanged: () {},
                      onExpand: () {},
                      onCollapse: () {},
                      sizeMultiplicationFactor: 0.7,
                      hint: "",
                      textController: TextEditingController()),
                ),
                Padding(
                  padding:  EdgeInsets.symmetric(vertical:0.02.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MainCustomIconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        buttonText: "Send Reject Request".tr,
                        buttonStyle: ElevatedButton.styleFrom(
                          minimumSize: Size(0.19.w, 0.055.h),
                          backgroundColor: AppColors.signOut,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                            Radius.circular(6),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

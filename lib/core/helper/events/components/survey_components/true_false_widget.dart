import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/core/helper/events/controllers/events_controllers/event_controller.dart';

class TrueFalseWidget extends StatefulWidget {
  String onSelection;
  final ValueChanged<String>? onAnswerChanged;

  TrueFalseWidget({
    super.key,
    required this.onSelection,
    this.onAnswerChanged,
  });

  @override
  _TrueFalseWidgetState createState() => _TrueFalseWidgetState();
}

class _TrueFalseWidgetState extends State<TrueFalseWidget> {
  List<String> options = ["True".tr, "False".tr];
  int? selectedOptionIndex;

  @override
  void initState() {
    if (options[0] == widget.onSelection.tr) {
      selectedOptionIndex = 0;
    } else if (options[1] == widget.onSelection.tr) {
      selectedOptionIndex = 1;
    }
    super.initState();
  }

  void handleSelection(int index) {
    setState(() {
      selectedOptionIndex = index;
      widget.onSelection = Get.locale.toString().contains("en")
          ? options[index]
          : englishTrueAndFalse[index];
      widget.onAnswerChanged!(widget.onSelection);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.02.h),
      child: Column(
        children: [
          ListView.builder(
padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Row(
                    children: [
                      Transform.scale(
                        scale: 0.7,
                        child: SvgPicture.asset(
                          "assets/icons/circle.svg",
                          color: Theme.of(context).colorScheme.onInverseSurface,
                          height: isTablet
                              ? (isPortrait ? 0.04.w : 0.02.w)
                              : 0.05.w,
                        ),
                      ),
                      SizedBox(
                        width: isTablet ? 0.01.w : 0.02.w,
                      ),
                      Text(
                        options[index],
                        style: AppFontStyle.cairoRegularStyle.copyWith(
                          height: 1.6,
                          fontSize: isTablet
                              ? (isPortrait
                                  ? FontConstants.fontSize016.h
                                  : FontConstants.fontSize020.h)
                              : FontConstants.fontSize020.h,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onInverseSurface,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  SizedBox(
                    height: 0.02.h,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

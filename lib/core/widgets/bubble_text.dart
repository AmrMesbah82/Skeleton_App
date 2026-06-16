import 'package:flutter/material.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:get/get.dart';


import 'package:demo_app/core/theme/app_font_size.dart';

const double bubbleRadius = 16;

// date:April/6/2023
// by:mohamedFouad
// lastUpdate:April/16/2023

///basic chat bubble type
///
///chat bubble [BorderRadius] can be customized using [bubbleRadius]
///chat bubble color can be customized using [color]
///chat bubble tail can be customized  using [tail]
///chat bubble display message can be changed using [text]
///[text] is the only required parameter
///message sender can be changed using [isSender]
///[sent],[delivered] and [seen] can be used to display the message state
///chat bubble [TextStyle] can be customized using [textStyle]

class BubbleText extends StatelessWidget {
  final double bubbleRadius;
  final bool isSender;
  late final Color color =
      isSender ? AppColors.bubbleColor : AppColors.colorGrey;
  final String text;
  //final String time;
  final bool tail;
  final bool sent;
  final bool delivered;
  final bool seen;

  BubbleText({
    Key? key,
    required this.text,
    // required this.time,
    this.bubbleRadius = 20,
    this.isSender = true,
    this.tail = true,
    this.sent = false,
    this.delivered = false,
    this.seen = false,
  }) : super(key: key);

  ///chat bubble builder method

  @override
  Widget build(BuildContext context) {
    bool stateTick = false;
    Icon? stateIcon;
    if (sent) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done,
        size: 18,
        color: Colors.white,
      );
    }
    if (delivered) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (seen) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 18,
        color: Color.fromARGB(255, 57, 59, 59),
      );
    }

    return Container(
      color: Colors.transparent,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * .8,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(bubbleRadius),
            bottomRight: Radius.circular(bubbleRadius),
            topLeft: Get.locale.toString().contains('en')
                ? Radius.circular(!tail
                    ? isSender
                        ? bubbleRadius
                        : 0
                    : bubbleRadius)
                : Radius.circular(!tail
                    ? isSender
                        ? 0
                        : bubbleRadius
                    : bubbleRadius),
            topRight: Get.locale.toString().contains('en')
                ? Radius.circular(!tail
                    ? isSender
                        ? 0
                        : bubbleRadius
                    : bubbleRadius)
                : Radius.circular(!tail
                    ? isSender
                        ? bubbleRadius
                        : 0
                    : bubbleRadius),
          ),
        ),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: isSender
                  ? const EdgeInsets.fromLTRB(12, 10, 28, 8)
                  : const EdgeInsets.fromLTRB(12, 10, 12, 8),
              child: Text(
                text,
                style: AppFontStyle.cairoRegularStyle.copyWith(
                  fontSize: 0.025.w,
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            isSender
                ? stateIcon != null && stateTick
                    ? Positioned(
                        bottom: 4,
                        right: 6,
                        child: stateIcon,
                      )
                    : const SizedBox()
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
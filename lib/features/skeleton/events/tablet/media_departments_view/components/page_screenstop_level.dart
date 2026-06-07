import 'package:flutter/material.dart';
import 'package:demo_app/core/widgets/custom_appbar.dart';
import 'package:demo_app/core/theme/screen_size.dart';

class PageScreenTopLevel extends StatefulWidget {
  PageScreenTopLevel({super.key, required this.children,
  this.hasScrollView=false,
  });
  List<Widget> children;
  bool? hasScrollView;

  @override
  State<PageScreenTopLevel> createState() => _PageScreenTopLevelState();
}

class _PageScreenTopLevelState extends State<PageScreenTopLevel> {
  @override
  Widget build(BuildContext context) {
    bool orientation =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
              color: Theme.of(context).colorScheme.inversePrimary,
              child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomAppBar(),
        Expanded(
            child: Container(
          color: Theme.of(context).colorScheme.surfaceVariant,
          child: Padding(
            padding: EdgeInsets.only(
              top: orientation ? 0.02.h : 0.03.h,
              left:orientation?0.01.w: 0.02.w,
              right:orientation?0.01.w: 0.02.w
            ),
            child:widget.hasScrollView==true?SingleChildScrollView(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.children,
            ),
            ): Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.children,
            ),
          ),
        ))
      ],
              ),
            ),
    );
  }
}

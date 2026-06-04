import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:demo_app/core/widgets/custom_appbar.dart';
import 'package:demo_app/core/widgets/row_title.dart';

class PageScreenTopLevel extends StatefulWidget {
  PageScreenTopLevel({
    super.key,
    required this.children,
    this.hasScroll = true,
    this.besideAppBarWidget,
    this.hasBackArrow = false,
    required this.title,
    this.functions,
    this.scrum = false,
    this.titles,
  });
  List<Widget> children;
  final bool hasScroll;
  final bool hasBackArrow;
  final String title;
  final Widget? besideAppBarWidget;
  final bool scrum;
  final List<String>? titles;
  final List<Function()>? functions;

  @override
  State<PageScreenTopLevel> createState() => _PageScreenTopLevelState();
}

class _PageScreenTopLevelState extends State<PageScreenTopLevel> {
  @override
  Widget build(BuildContext context) {
    bool orientation =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
            child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Container(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: orientation ? 0.02.h : 0.03.h,
                      left: orientation ? 0.01.w : 0.02.w,
                      right: orientation ? 0.01.w : 0.02.w),
                  child: widget.hasScroll
                      ? SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: titleRow(
                                        scrum: widget.scrum,
                                        functions: widget.functions,
                                        titles: widget.titles,
                                        context,
                                        orientation,
                                        widget.title, () {
                                      Navigator.pop(context);
                                    }, hasArrow: widget.hasBackArrow),
                                  ),
                                  widget.besideAppBarWidget ??
                                      const SizedBox.shrink()
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 0.015.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: widget.children,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: titleRow(
                                      scrum: widget.scrum,
                                      functions: widget.functions,
                                      titles: widget.titles,
                                      context,
                                      orientation,
                                      widget.title, () {
                                    Navigator.pop(context);
                                  }, hasArrow: widget.hasBackArrow),
                                ),
                                widget.besideAppBarWidget ??
                                    const SizedBox.shrink()
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 0.015.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: widget.children,
                              ),
                            ),
                          ],
                        ),
                ),
              ))
            ],
          ),
        )),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:demo_app/components/terms_components/mark_down.dart';
import 'package:demo_app/core/widgets/filters_appbar.dart';
import 'package:demo_app/core/theme/screen_size.dart';

class TermsDialog extends StatefulWidget {
  const TermsDialog({super.key});

  @override
  State<TermsDialog> createState() => _TermsDialogState();
}

class _TermsDialogState extends State<TermsDialog> {
  @override
  Widget build(BuildContext context) {
      bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal:isPortrait?0.17.w :0.25.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      
      ),
      child: Container(
       decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.02.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 0.02.h),
                child: const FiltersAppBar(
                    hideIcon: true,
                    imageUrl: "assets/images/requests.svg",
                    title: "Terms And Conditions"),
              ),
              SizedBox(
                height:isPortrait?0.6.h :0.5.h,
                child: const MarkDownWidget())
            ],
          ),
        ),
      ),
    );
  }
}

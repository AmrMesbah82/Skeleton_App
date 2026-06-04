import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/custom_drop_down_menu.dart';
import 'package:demo_app/components/multiselect_files/multiselect.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:multi_dropdown/enum/app_enums.dart';
import 'package:multi_dropdown/models/chip_config.dart';
import 'package:multi_dropdown/models/value_item.dart';

// ignore: must_be_immutable
class CompanyServiceView extends StatefulWidget {
  CompanyServiceView(
      {super.key,
      required this.industry,
      required this.modules,
      required this.role,
      required this.size,
      required this.companyService,
      required this.moduState,
      required this.induState,
      required this.roleState,
      required this.sizeState,
      required this.companyServiceState});
  String? industry;
  String? size;
  String? modules;
  String? role;
  double companyService;
  ValueChanged<String?> induState;
  ValueChanged<String?> sizeState;
  ValueChanged<String?> roleState;
  ValueChanged<String?> moduState;
  ValueChanged<double> companyServiceState;

  @override
  State<CompanyServiceView> createState() => _CompanyServiceViewState();
}

class _CompanyServiceViewState extends State<CompanyServiceView> {
  MultiSelectController _controller = MultiSelectController();
  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CustomDropdownButton2(
            hint: "Company Industry",
            buttonHeight: 0.066.h,
            buttonWidth: double.infinity,
            dropdownWidth: isTablet ? (isPortrait ? 0.88.w : 0.63.w) : 0.92.w,
            // hasPrefix: true,
            // prefixUrl: "assets/images/lib.svg",
            borded: false,
            itemPadding: EdgeInsets.symmetric(horizontal:isPortrait? 0.03.w : 0.012.w),
           dropdownPadding: isTablet
                  ? null
                  : EdgeInsets.symmetric(horizontal: 0.0.w, vertical: 0.005.h),
            buttonPadding: isTablet
                ? EdgeInsets.symmetric(
                  horizontal:isPortrait? 0.02.w : 0.012.w
                   )
                : EdgeInsets.symmetric(horizontal: 0.02.w),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            value: widget.industry,
            dropdownItems: [
              "Entertainment".tr,
              "Food Services".tr,
              "Government".tr,
              "Utilities".tr,
              "Administration".tr,
              "Business".tr,
              "Transportation".tr,
              "Education".tr,
              "Real Estate".tr,
              "Construction".tr,
              "Healthcare".tr,
              "Manufacturing".tr,
              "Engineering".tr,
              "Financial Services".tr,
              "Online Retail".tr,
              "Hospitality".tr,
              "Other".tr,
            ],
            onChanged: (value) {
              setState(() {
                widget.industry = value;
                widget.induState(widget.industry);
                widget.companyService += 1 / 3;
                widget.companyServiceState(widget.companyService);
              });
            }),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 0.015.h),
          child: CustomDropdownButton2(
              hint: "Company Size",
              buttonHeight: 0.066.h,
              buttonWidth: double.infinity,
              dropdownWidth: isTablet ? (isPortrait ? 0.88.w : 0.63.w) : 0.92.w,
              borded: false,
              // hasPrefix: true,
              // prefixUrl: "assets/images/users.svg",
              itemPadding: EdgeInsets.symmetric(horizontal:isPortrait? 0.03.w : 0.012.w),
              dropdownPadding: isTablet
                  ? null
                  : EdgeInsets.symmetric(horizontal: 0.0.w, vertical: 0.005.h),
              buttonPadding: isTablet
                  ? EdgeInsets.symmetric(
                  horizontal:isPortrait? 0.02.w : 0.012.w
                   )
                  : EdgeInsets.symmetric(horizontal: 0.02.w),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              value: widget.size,
              dropdownItems: const ["2-10", "11-50", "51-200", "+200"],
              onChanged: (value) {
                setState(() {
                  widget.size = value;
                  widget.sizeState(widget.size);
                  widget.companyService += 1 / 3;
                  widget.companyServiceState(widget.companyService);
                });
              }),
        ),
    /*    Container(
          height: isTablet
              ? isPortrait
                  ? 0.066.h
                  : 0.07.h
              : 0.066.h,
          child: MultiSelectDropDown(
            showClearIcon: true,
            borderRadius: 8,
            dropdownBorderRadius: 8,
            selectedOptionIcon: SvgPicture.asset(
              'assets/icons/CheckListOn.svg',
              color: MyThemeData.lightPrimary,
              height: 0.025.h,
            ),
            clearIcon: SvgPicture.asset("assets/images/closefield.svg"),
            
            padding: EdgeInsets.only(
                right: Get.locale.toString().contains('en') ? (isTablet?   (isPortrait? 0.01.w : 0.00.w ): 0.02.w) : 0.001.w,
                left: Get.locale.toString().contains('en') ? (isTablet?   (isPortrait? 0.01.w : 0.003.w ): 0.001.w)  : (isTablet? (isPortrait? 0.015.w : 0.006.w) : 0.02.w)),
            borderColor: Theme.of(context).colorScheme.scrim.withOpacity(.7),
            borderWidth: 1.1,
            hint: "Requested Modules".tr,
            dropdownHeight: 0.18.h,
            suffixIcon: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: isTablet
                      ? Get.locale.toString().contains('en')
                          ? 0.013.w
                          : 0.007.w
                      : 0.02.w),
              child: SvgPicture.asset(
                'assets/images/arrowsquaredown.svg',
                height: isTablet
                    ? isPortrait
                        ? 0.02.h
                        : 0.03.h
                    : 0.02.h,
                width: 0.01.h,
                color:   Theme.of(context).colorScheme.onInverseSurface
                   ,
              ),
            ),
            hintColor: Theme.of(context).colorScheme.scrim,
            hintStyle: AppFontStyle.cairoRegularStyle.copyWith(
                color: isTablet
                    ? Theme.of(context).colorScheme.scrim
                    : Theme.of(context).colorScheme.scrim,
                height: 1.2,
                fontSize: isTablet
                    ? isPortrait
                        ? FontConstants.fontSize016.h
                        : FontConstants.fontSize022.h
                    : FontConstants.fontSize018.h),
            controller: _controller,
            onOptionSelected: (options) {
              print(_controller.toString());
              setState(() {
                widget.companyService += 1 / 3;
                widget.companyServiceState(widget.companyService);

                debugPrint('Selected Options: ${options.toString()}');
                widget
                    .moduState(options.map((e) => e.label).toList().join(", "));
              });
            },
            radiusGeometry: BorderRadius.circular(8),
            fieldBackgroundColor: Theme.of(context).colorScheme.inversePrimary,
            dropdownBackgroundColor:
                Theme.of(context).colorScheme.inversePrimary,
            selectedOptionBackgroundColor: Colors.transparent,

            options: <ValueItem>[
              ValueItem(label: "Asset Management".tr, value: '1'),
              ValueItem(label: 'Human Resources'.tr, value: '2'),
              ValueItem(
                  label: 'Attendance and Leave Management'.tr, value: '3'),
              ValueItem(label: 'Internal Communication'.tr, value: '4'),
              ValueItem(label: 'Task Management'.tr, value: '5'),
              ValueItem(
                  label: 'Strategy and Project Management'.tr, value: '6'),
            ],
            // disabledOptions: const [
            //   ValueItem(label: 'Sunday to Thursday', value: '1')
            // ],

            selectionType: SelectionType.multi,
            chipConfig: ChipConfig(
                deleteIcon: Icon(
                  Icons.cancel,
                  size: isPortrait ? 0.02.h : 0.03.h,
                  color: MyThemeData().contrastColor(),
                ),
                wrapType: WrapType.scroll,
                radius: 12),
            optionTextStyle: AppFontStyle.cairoRegularStyle.copyWith(
                color: MyThemeData.textdeactivecolor,
                height: 2.2,
                  fontSize: isTablet
                    ? isPortrait
                        ? FontConstants.fontSize016.h
                        : FontConstants.fontSize022.h
                    : FontConstants.fontSize018.h),
          ),
        ),*/
      ],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/network/get_base_url.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'custom_button_widget.dart';
import 'svg_custom.dart';
import 'text_field.dart';

class CustomDropdownFormField extends StatefulWidget {
  final String? selectedValue;
  final double? widthIcon;
  final Color? dropdownColor;
  final double? heightIcon;
  final List<Map<String, String>> items;
  final Function(String?) onChanged;
  final String Function(String?)? validator;
  final double? width;
  final double? height;
  final double? spaceHeight;
  final double? dropdownWidth;
  final Widget? hint;
  final String? label;
  final String? iconPath;
  final bool hasError;
  final bool isEditable;
  final String? firestoreCategory;

  /// ✅ Color support parameters
  final Map<String, Color>? itemColors;
  final bool showColorDots;

  const CustomDropdownFormField({
    Key? key,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    required this.widthIcon,
    required this.heightIcon,
    this.validator,
    this.width,
    this.height,
    this.spaceHeight,
    this.dropdownWidth,
    this.hint,
    this.dropdownColor,
    this.label,
    this.iconPath,
    this.isEditable = false,
    this.firestoreCategory,
    this.itemColors,
    this.showColorDots = false,
    required this.hasError,
  }) : super(key: key);

  @override
  State<CustomDropdownFormField> createState() =>
      _CustomDropdownFormFieldState();
}

class _CustomDropdownFormFieldState extends State<CustomDropdownFormField> {
  String? internalSelectedValue;
  final GlobalKey _dropdownKey = GlobalKey();
  double? _popupWidth;
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = false;
  List<Map<String, String>> _dynamicItems = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    internalSelectedValue = widget.selectedValue;
    _dynamicItems = List.from(widget.items);

    if (widget.selectedValue != null) {
      _textController.text = widget.items.firstWhere(
            (item) => item['key'] == widget.selectedValue,
        orElse: () => {'value': widget.selectedValue ?? ''},
      )['value'] ??
          '';
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _dropdownKey.currentContext;
      if (context != null && mounted) {
        final box = context.findRenderObject() as RenderBox;
        setState(() {
          _popupWidth = box.size.width;
        });
      }
    });

    if (widget.isEditable && widget.firestoreCategory != null) {
      _loadItemsFromFirestore();
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  /// Helper method to get color for an item
  Color? _getItemColor(Map<String, String> item) {
    if (widget.itemColors == null) return null;
    String key = item['key'] ?? '';
    String value = item['value'] ?? '';
    return widget.itemColors![key] ?? widget.itemColors![value];
  }

  /// ✅ Build dropdown item with hover color support + 14.sp font
  Widget _buildDropdownItem(
      Map<String, String> item,
      bool lightMode, {
        bool isHovered = false,
      }) {
    Color? itemColor = _getItemColor(item);

    final textColor = isHovered
        ? AppColors.textButton
        : itemColor ??
        (lightMode
            ? AppColors.blackButton
            : AppColors.white);

    if (widget.showColorDots && itemColor != null) {
      return Row(
        children: [
          Container(
            width: 8.sp,
            height: 8.sp,
            decoration: BoxDecoration(
              color: itemColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              item["value"] ?? '',
              style: AppTextStyles.font14BlackCairoRegular.copyWith(
                color: isHovered ? AppColors.textButton : textColor,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      );
    } else {
      return Text(
        item["value"] ?? '',
        style: AppTextStyles.font14BlackCairoRegular.copyWith(
          color: textColor,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
  }

  Future<void> _loadItemsFromFirestore() async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection(getBaseUrl('InventoryUser'))
          .doc('amrmesbah@gmail.com')
          .collection(widget.firestoreCategory!)
          .orderBy('createdAt', descending: false)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final List<Map<String, String>> firestoreItems =
        querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          final value = data?['value']?.toString() ?? '';
          return {'key': doc.id, 'value': value};
        }).where((item) => item['value']!.isNotEmpty).toList();

        setState(() {
          for (final newItem in firestoreItems) {
            if (!_dynamicItems.any(
                  (existingItem) =>
              existingItem['key'] == newItem['key'] ||
                  existingItem['value'] == newItem['value'],
            )) {
              _dynamicItems.add(newItem);
            }
          }
        });
      }
    } catch (e) {
      print('Error loading items from Firestore: $e');
    }
  }

  Future<void> _saveNewItemToFirestore(String newItem) async {
    if (widget.firestoreCategory == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final QuerySnapshot existingQuery = await _firestore
          .collection(getBaseUrl('InventoryUser'))
          .doc('amrmesbah@gmail.com')
          .collection(widget.firestoreCategory!)
          .where('value', isEqualTo: newItem)
          .limit(1)
          .get();

      if (existingQuery.docs.isNotEmpty) {
        final existingDoc = existingQuery.docs.first;
        final String existingKey = existingDoc.id;

        setState(() {
          if (!_dynamicItems.any((item) => item['key'] == existingKey)) {
            _dynamicItems.add({'key': existingKey, 'value': newItem});
          }
          internalSelectedValue = existingKey;
          _textController.text = newItem;
        });

        widget.onChanged(existingKey);

        _showSuccessDialog(
          context,
          "assets/lottie/warning.json",
          'S.of(context).alreadyExistsAndSelected',
        );

        return;
      }

      final DocumentReference docRef = _firestore
          .collection(getBaseUrl('InventoryUser'))
          .doc('amrmesbah@gmail.com')
          .collection(widget.firestoreCategory!)
          .doc();

      await docRef.set({
        'key': docRef.id,
        'value': newItem,
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': 'amrmesbah@gmail.com',
      });

      setState(() {
        _dynamicItems.add({'key': docRef.id, 'value': newItem});
        internalSelectedValue = docRef.id;
        _textController.text = newItem;
      });

      widget.onChanged(docRef.id);

      _showSuccessDialog(
        context,
        "assets/lottie/approved.json",
        'S.of(context).itemAddSuccessful',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving item: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showAddNewItemDialog() {
    final TextEditingController dialogController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        var isMobile = context.isPhone;
        var isTablet = context.isTablet;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final lightMode =
                Theme.of(context).brightness == Brightness.light;
            return SizedBox(
              width: isMobile ? 250.w : 411.w,
              height: isMobile ? 172.h : 200.h,
              child: AlertDialog(
                insetPadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                content: SizedBox(
                  width: isMobile ? 250.w : 411.w,
                  height: isMobile ? 172.h : 155.h,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 30.w,
                            height: 30.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                            ),
                            child: Center(
                              child: CustomSvg(
                                assetPath: "assets/images/plus.svg",
                                width: 15.w,
                                height: 15.h,
                                color: AppColors.textButton,
                              ),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            S.of(context).addNewItem,
                            style: AppTextStyles.font16BlackSemiBoldCairo,
                          ),
                        ],
                      ),
                      SizedBox(height: 0.h),
                      CustomValidatedTextField(
                        height: 36,
                        label: "",
                        hint: 'S.of(context).textHere',
                        controller: dialogController,
                      ),
                      SizedBox(height: 10.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'S.of(context).savedToHistory',
                          style: AppTextStyles.font12BlackCairoRegular.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customButton(
                            title: 'S.of(context).cancel',
                            function: () => Navigator.pop(context),
                            width: 100.w,
                            radius: 8.r,
                            height: 30.h,
                            color: Colors.grey[300],
                            textStyle:
                            AppTextStyles.font14BlackCairoMedium.copyWith(
                              color: Colors.black,
                            ),
                          ),
                          customButton(
                            title: 'S.of(context).submit',
                            function: () {
                              final String newItem =
                              dialogController.text.trim();
                              if (newItem.isNotEmpty) {
                                Navigator.of(context).pop();
                                _saveNewItemToFirestore(newItem);
                              }
                            },
                            width: 100.w,
                            radius: 8.r,
                            height: 30.h,
                            color: AppColors.primary,
                            textStyle:
                            AppTextStyles.font14BlackCairoMedium.copyWith(
                              color: AppColors.textButton,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool lightMode = Theme.of(context).brightness == Brightness.light;
    final double fieldHeight = widget.height ?? 36;

    if (!widget.isEditable) {
      return _buildOriginalDropdown(context, lightMode, fieldHeight);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Row(
            children: [
              Text(
                widget.label!,
                style: AppTextStyles.font14BlackCairoRegular.copyWith(
                  color: lightMode
                      ? AppColors.blackButton
                      : AppColors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: (widget.spaceHeight ?? 0.h)),
        ],
        SizedBox(height: 1.sp),
        Container(
          key: _dropdownKey,
          width: widget.width,
          height: fieldHeight.h,
          decoration: BoxDecoration(
            color: lightMode
                ? AppColors.white
                : AppColors.background,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: FormField<String>(
            initialValue: internalSelectedValue,
            validator: widget.validator,
            builder: (FormFieldState<String> field) {
              return Row(
                children: [
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: widget.hint,
                        value: _dynamicItems.any(
                              (e) => e['key'] == internalSelectedValue,
                        )
                            ? internalSelectedValue
                            : null,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              internalSelectedValue = value;
                              field.didChange(value);
                              _textController.text =
                                  _dynamicItems.firstWhere(
                                        (item) => item['key'] == value,
                                  )['value'] ??
                                      '';
                            });
                            widget.onChanged(value);
                          }
                        },
                        buttonStyleData: ButtonStyleData(
                          height: fieldHeight.h,
                          width: widget.width != null
                              ? widget.width! - 40.w
                              : null,
                          padding: EdgeInsets.only(
                            left: 8.w,
                            right: 8.w,
                            top: 0.h,
                            bottom: 0.h,
                          ),
                          decoration: BoxDecoration(
                            color: widget.dropdownColor ??
                                (lightMode
                                    ? AppColors.background
                                    : AppColors.background),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.r),
                              bottomLeft: Radius.circular(8.r),
                            ),
                          ),
                        ),
                        dropdownStyleData: DropdownStyleData(
                          width: widget.dropdownWidth ??
                              _popupWidth ??
                              widget.width ??
                              100.w,
                          maxHeight: 230.h,
                          offset: const Offset(0, 0),
                          decoration: BoxDecoration(
                            color: lightMode
                                ? AppColors.white
                                : AppColors.background,
                            borderRadius: BorderRadius.circular(8.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          scrollbarTheme: ScrollbarThemeData(
                            thumbVisibility:
                            MaterialStateProperty.all(true),
                            trackVisibility:
                            MaterialStateProperty.all(false),
                            thickness: MaterialStateProperty.all(4),
                            radius: Radius.circular(2.r),
                            thumbColor: MaterialStateProperty.all(
                              AppColors.primary.withOpacity(0.5),
                            ),
                          ),
                        ),
                        menuItemStyleData: MenuItemStyleData(
                          height: fieldHeight.h,
                          padding:
                          EdgeInsets.symmetric(horizontal: 8.sp),
                          overlayColor:
                          MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                              if (states
                                  .contains(MaterialState.hovered)) {
                                return AppColors.primary
                                    .withOpacity(0.1);
                              }
                              return null;
                            },
                          ),
                        ),
                        iconStyleData: IconStyleData(
                          icon: SvgPicture.asset(
                            widget.iconPath ??
                                'assets/images/arrow_down.svg',
                            width: widget.widthIcon?.w,
                            height: widget.heightIcon?.h,
                            fit: BoxFit.scaleDown,
                            color: AppColors.secondaryText,
                          ),
                        ),
                        style: AppTextStyles.font14BlackCairoRegular.copyWith(
                          color: lightMode
                              ? AppColors.blackButton
                              : AppColors.white,
                        ),
                        items: _dynamicItems.map((unit) {
                          return DropdownMenuItem<String>(
                            value: unit["key"],
                            child: _HoverableDropdownItem(
                              builder: (isHovered) =>
                                  _buildDropdownItem(
                                    unit,
                                    lightMode,
                                    isHovered: isHovered,
                                  ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  // Add new item button
                  Container(
                    width: 32.w,
                    height: fieldHeight.h,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8.r),
                        bottomRight: Radius.circular(8.r),
                      ),
                    ),
                    child: _isLoading
                        ? Center(
                      child: SizedBox(
                        width: 16.w,
                        height: 16.h,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                          AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    )
                        : Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: widget.firestoreCategory != null
                            ? _showAddNewItemDialog
                            : null,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8.r),
                          bottomRight: Radius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.add,
                          size: 18.sp,
                          color: AppColors.textButton,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOriginalDropdown(
      BuildContext context,
      bool lightMode,
      double fieldHeight,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.font14BlackCairoRegular.copyWith(
              color: lightMode
                  ? AppColors.blackButton
                  : AppColors.white,
            ),
          ),
          SizedBox(height: (widget.spaceHeight ?? 0.h)),
        ],
        Container(
          key: _dropdownKey,
          width: widget.width,
          height: fieldHeight.h,
          decoration: BoxDecoration(
            color: lightMode
                ? AppColors.white
                : AppColors.background,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: FormField<String>(
            initialValue: internalSelectedValue,
            validator: widget.validator,
            builder: (FormFieldState<String> field) {
              return DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  hint: widget.hint,
                  value: widget.items
                      .any((e) => e['key'] == internalSelectedValue)
                      ? internalSelectedValue
                      : null,
                  onChanged: (value) {
                    setState(() {
                      internalSelectedValue = value;
                      field.didChange(value);
                    });
                    widget.onChanged(value);
                  },
                  buttonStyleData: ButtonStyleData(
                    height: fieldHeight.h,
                    width: widget.width?.w,
                    padding: EdgeInsets.only(left: 8.w, right: 8.w),
                    decoration: BoxDecoration(
                      color: widget.dropdownColor ??
                          (lightMode
                              ? AppColors.background
                              : AppColors.background),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  dropdownStyleData: DropdownStyleData(
                    width: widget.dropdownWidth ??
                        _popupWidth ??
                        widget.width ??
                        100.w,
                    maxHeight: 225.h,
                    offset: const Offset(0, 0),
                    decoration: BoxDecoration(
                      color: lightMode
                          ? AppColors.white
                          : AppColors.background,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    scrollbarTheme: ScrollbarThemeData(
                      thumbVisibility:
                      MaterialStateProperty.all(false),
                      trackVisibility:
                      MaterialStateProperty.all(false),
                      thickness: MaterialStateProperty.all(0),
                      radius: Radius.zero,
                    ),
                  ),
                  menuItemStyleData: MenuItemStyleData(
                    height: fieldHeight.h,
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    overlayColor:
                    MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered)) {
                          return AppColors.primary.withOpacity(0.1);
                        }
                        return Colors.white;
                      },
                    ),
                  ),
                  iconStyleData: IconStyleData(
                    icon: SvgPicture.asset(
                      widget.iconPath ??
                          'assets/images/arrow_down.svg',
                      width: widget.widthIcon?.w,
                      height: widget.heightIcon?.h,
                      fit: BoxFit.scaleDown,
                      color: lightMode
                          ? AppColors.secondaryText
                          : AppColors.whiteShadow,
                    ),
                  ),
                  style: AppTextStyles.font14BlackCairoRegular.copyWith(
                    color: lightMode
                        ? AppColors.blackButton
                        : AppColors.white,
                  ),
                  items: widget.items.map((unit) {
                    return DropdownMenuItem<String>(
                      value: unit["key"],
                      child: _HoverableDropdownItem(
                        builder: (isHovered) => _buildDropdownItem(
                          unit,
                          lightMode,
                          isHovered: isHovered,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _showSuccessDialog(
      BuildContext context,
      String? lottie, [
        String? message,
      ]) async {
    final rootContext = context;
    await showDialog(
      context: rootContext,
      barrierDismissible: true,
      builder: (dialogContext) {
        var isMobile = dialogContext.isPhone;
        final screenSize = MediaQuery.of(dialogContext).size;
        final isPhone = screenSize.width < 600;
        final isTablet =
            screenSize.width >= 600 && screenSize.width < 1024;
        final isDesktop = screenSize.width >= 1024;
        final isLandscape = screenSize.width > screenSize.height;

        double dialogWidth;
        double lottieSize;
        double horizontalPadding;
        double verticalPadding;
        double textSize;
        double spacing;

        if (isPhone) {
          if (isLandscape) {
            dialogWidth = screenSize.width * 0.7;
            lottieSize = 80;
            horizontalPadding = 16;
            verticalPadding = 12;
            textSize = 16;
            spacing = 12;
          } else {
            dialogWidth = screenSize.width * 0.85;
            lottieSize = 100;
            horizontalPadding = 20;
            verticalPadding = 20;
            textSize = 18;
            spacing = 16;
          }
        } else if (isTablet) {
          if (isLandscape) {
            dialogWidth = screenSize.width * 0.5;
            lottieSize = 120;
            horizontalPadding = 24;
            verticalPadding = 20;
            textSize = 20;
            spacing = 20;
          } else {
            dialogWidth = screenSize.width * 0.7;
            lottieSize = 130;
            horizontalPadding = 28;
            verticalPadding = 24;
            textSize = 22;
            spacing = 24;
          }
        } else {
          dialogWidth = 450;
          lottieSize = 140;
          horizontalPadding = 32;
          verticalPadding = 28;
          textSize = 24;
          spacing = 28;
        }

        dialogWidth = dialogWidth.clamp(280.0, 600.0);

        return Dialog(
          backgroundColor:
          Theme.of(dialogContext).brightness == Brightness.light
              ? AppColors.white
              : AppColors.chatBackground,
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(isPhone ? 12.r : 16.r),
          ),
          insetPadding: EdgeInsets.symmetric(
            horizontal: isPhone ? 16.w : 40.w,
            vertical: isPhone ? 24.h : 40.h,
          ),
          child: Container(
            width: isMobile ? 250.w : 411.w,
            height: isMobile ? 150.h : 155.h,
            child: Padding(
              padding: EdgeInsets.all(15.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    lottie ?? 'assets/lottie/approved.json',
                    width: 70.w,
                    height: 70.h,
                    fit: BoxFit.scaleDown,
                    repeat: true,
                    animate: true,
                  ),
                  SizedBox(height: 10.h),
                  Flexible(
                    child: Text(
                      message ??
                          ' S.of(dialogContext).changingStatus',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.font20BlackCairoMedium.copyWith(
                        fontSize: textSize,
                        color: Theme.of(dialogContext).brightness ==
                            Brightness.light
                            ? AppColors.blackButton
                            : AppColors.white,
                        height: 1.3,
                      ),
                    ),
                  ),
                  if (isPhone && isLandscape) SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showResponsiveSuccessDialog(
      BuildContext context,
      String? lottie, [
        String? message,
      ]) async {
    final rootContext = context;
    await showDialog(
      context: rootContext,
      barrierDismissible: true,
      builder: (dialogContext) => LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          final maxHeight = constraints.maxHeight;
          final isCompact = maxWidth < 600 || maxHeight < 400;

          final dialogWidth = isCompact
              ? maxWidth * 0.9
              : (maxWidth * 0.6).clamp(320.0, 500.0);

          final lottieSize = isCompact ? 70.0 : 120.0;
          final padding = isCompact ? 16.0 : 24.0;
          final textSize = isCompact ? 16.0 : 20.0;
          final spacing = isCompact ? 12.0 : 20.0;

          return Dialog(
            backgroundColor:
            Theme.of(dialogContext).brightness == Brightness.light
                ? AppColors.white
                : AppColors.chatBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            insetPadding:
            EdgeInsets.all(isCompact ? 16.0 : 24.0),
            child: Container(
              width: dialogWidth,
              constraints: BoxConstraints(
                maxHeight: maxHeight * 0.8,
                maxWidth: dialogWidth,
              ),
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      lottie ?? 'assets/lottie/approved.json',
                      width: lottieSize,
                      height: lottieSize,
                      fit: BoxFit.scaleDown,
                      repeat: true,
                      animate: true,
                    ),
                    SizedBox(height: spacing),
                    Flexible(
                      child: Text(
                        message ??
                            'S.of(dialogContext).changingStatus',
                        textAlign: TextAlign.center,
                        style:
                        AppTextStyles.font20BlackCairoMedium.copyWith(
                          fontSize: textSize,
                          color: Theme.of(dialogContext).brightness ==
                              Brightness.light
                              ? AppColors.blackButton
                              : AppColors.white,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// ✅ Hover-detecting wrapper for dropdown items
class _HoverableDropdownItem extends StatefulWidget {
  final Widget Function(bool isHovered) builder;

  const _HoverableDropdownItem({required this.builder});

  @override
  State<_HoverableDropdownItem> createState() =>
      _HoverableDropdownItemState();
}

class _HoverableDropdownItemState extends State<_HoverableDropdownItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: widget.builder(_isHovered),
    );
  }
}

class CustomDropdownFormFieldCalender extends StatefulWidget {
  final String? selectedValue;
  final double? widthIcon;
  final Color? dropdownColor;
  final double? heightIcon;
  final Function(String?) onChanged;
  final String Function(String?)? validator;
  final double? width;
  final double? height;
  final double? spaceHeight;
  final Widget? hint;
  final String? label;
  final String? iconPath;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const CustomDropdownFormFieldCalender({
    Key? key,
    required this.selectedValue,
    required this.onChanged,
    required this.widthIcon,
    required this.heightIcon,
    this.validator,
    this.width,
    this.height,
    this.spaceHeight,
    this.hint,
    this.dropdownColor,
    this.label,
    this.iconPath,
    this.initialDate,
    this.firstDate,
    this.lastDate,
  }) : super(key: key);

  @override
  _CustomDropdownFormFieldCalenderState createState() =>
      _CustomDropdownFormFieldCalenderState();
}

class _CustomDropdownFormFieldCalenderState
    extends State<CustomDropdownFormFieldCalender> {
  String? internalSelectedValue;
  final GlobalKey _dropdownKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    internalSelectedValue = widget.selectedValue;
  }

  Future<void> _openDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.initialDate ?? DateTime.now(),
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime(2100),
      builder: (context, child) {
        final bool lightMode =
            Theme.of(context).brightness == Brightness.light;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: lightMode
                ? ColorScheme.light(primary: AppColors.primary)
                : ColorScheme.dark(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedDate =
          "${picked.day}/${picked.month}/${picked.year}";

      setState(() {
        internalSelectedValue = formattedDate;
      });

      widget.onChanged(formattedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool lightMode =
        Theme.of(context).brightness == Brightness.light;
    final double fieldHeight = widget.height ?? 36.sp;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.font14BlackCairoRegular.copyWith(
              color: lightMode
                  ? AppColors.blackButton
                  : AppColors.white,
            ),
          ),
          SizedBox(height: (widget.spaceHeight ?? 8.sp)),
        ],
        GestureDetector(
          onTap: _openDatePicker,
          child: Container(
            key: _dropdownKey,
            width: widget.width,
            height: fieldHeight.h,
            padding: EdgeInsets.symmetric(horizontal: 8.sp),
            decoration: BoxDecoration(
              color: widget.dropdownColor ??
                  (lightMode
                      ? AppColors.background
                      : AppColors.background),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    internalSelectedValue ??
                        (widget.hint is Text
                            ? (widget.hint as Text).data ??
                            'Select Date'
                            : 'Select Date'),
                    style: AppTextStyles.font12BlackCairoRegular.copyWith(
                      color: internalSelectedValue != null
                          ? (lightMode
                          ? AppColors.blackButton
                          : AppColors.white)
                          : (lightMode
                          ? AppColors.secondaryText
                          : AppColors.whiteShadow),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SvgPicture.asset(
                  'assets/images/calender.svg',
                  width: widget.widthIcon,
                  height: widget.heightIcon,
                  fit: BoxFit.scaleDown,
                  color: lightMode
                      ? AppColors.secondaryText
                      : AppColors.whiteShadow,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CustomDropdownFormFieldDateRange extends StatefulWidget {
  final DateTimeRange? selectedRange;
  final double? widthIcon;
  final Color? dropdownColor;
  final double? heightIcon;
  final Function(DateTimeRange?) onChanged;
  final String Function(DateTimeRange?)? validator;
  final double? width;
  final double? height;
  final double? spaceHeight;
  final Widget? hint;
  final String? label;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool showClearButton;

  const CustomDropdownFormFieldDateRange({
    Key? key,
    required this.selectedRange,
    required this.onChanged,
    required this.widthIcon,
    required this.heightIcon,
    this.validator,
    this.width,
    this.height,
    this.spaceHeight,
    this.hint,
    this.dropdownColor,
    this.label,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.showClearButton = true,
  }) : super(key: key);

  @override
  _CustomDropdownFormFieldDateRangeState createState() =>
      _CustomDropdownFormFieldDateRangeState();
}

class _CustomDropdownFormFieldDateRangeState
    extends State<CustomDropdownFormFieldDateRange> {
  DateTimeRange? internalSelectedRange;
  final GlobalKey _dropdownKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    internalSelectedRange = widget.selectedRange;
  }

  Future<void> _openDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: internalSelectedRange,
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime(2100),
      builder: (context, child) {
        final bool lightMode =
            Theme.of(context).brightness == Brightness.light;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: lightMode
                ? ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              secondary: AppColors.primary,
              onSecondary: Colors.white,
            )
                : ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              secondary: AppColors.primary,
              onSecondary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        internalSelectedRange = picked;
      });
      widget.onChanged(picked);
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  String _getDisplayText() {
    if (internalSelectedRange == null) {
      if (widget.hint is Text) {
        return (widget.hint as Text).data ?? 'Select date range';
      }
      return 'Select date range';
    }

    return '${_formatDate(internalSelectedRange!.start)} - ${_formatDate(internalSelectedRange!.end)}';
  }

  @override
  Widget build(BuildContext context) {
    final bool lightMode =
        Theme.of(context).brightness == Brightness.light;
    final double fieldHeight = widget.height ?? 40.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.font14BlackCairoRegular.copyWith(
              color: lightMode
                  ? AppColors.blackButton
                  : AppColors.white,
            ),
          ),
          SizedBox(height: (widget.spaceHeight ?? 8.sp)),
        ],
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _openDateRangePicker,
                child: Container(
                  key: _dropdownKey,
                  width: widget.width,
                  height: fieldHeight,
                  padding:
                  EdgeInsets.symmetric(horizontal: 8.sp),
                  decoration: BoxDecoration(
                    color: widget.dropdownColor ??
                        (lightMode
                            ? AppColors.background
                            : AppColors.background),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _getDisplayText(),
                          style: AppTextStyles.font12BlackCairoRegular
                              .copyWith(
                            color: internalSelectedRange != null
                                ? (lightMode
                                ? AppColors.blackButton
                                : AppColors.white)
                                : (lightMode
                                ? AppColors.secondaryText
                                : AppColors.whiteShadow),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      CustomSvg(
                        assetPath: "assets/images/calender.svg",
                        width: 14.w,
                        height: 14.h,
                        fit: BoxFit.scaleDown,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (widget.showClearButton &&
                internalSelectedRange != null) ...[
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: () {
                  setState(() {
                    internalSelectedRange = null;
                  });
                  widget.onChanged(null);
                },
                child: Container(
                  width: 32.w,
                  height: fieldHeight,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.clear,
                    color: lightMode
                        ? Colors.grey[600]
                        : Colors.grey[400],
                    size: 16.sp,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

extension StringCapitalization on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}
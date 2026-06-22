/// ******************* FILE INFO *******************
/// File Name: monthly_comparison_chart.dart
/// Description: Monthly comparison chart for canceled vs rejected services by department
/// Created by: Amr Mesbah
/// ✅ UPDATED: Bars centered under month labels using Row-based layout

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/network/get_base_url.dart';
import 'package:demo_app/features/department/presentation/controller/add_department_controller.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/core/constants/services_management/constant.dart';
import 'package:demo_app/features/home/presentation/ui/pages/dashboard_view_data/chart_orientation_enum.dart';
import 'package:demo_app/generated/l10n.dart';

import 'package:demo_app/core/helper/circle_progress.dart';

import 'package:demo_app/features/services_management_module/data/helper/services_dropdown.dart';
import 'package:demo_app/core/theme/app_colors.dart';import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';

class MonthlyComparisonChart extends StatefulWidget {
  final ChartOrientation orientation;
  final bool lightMode;

  const MonthlyComparisonChart({
    Key? key,
    this.orientation = ChartOrientation.vertical,
    required this.lightMode,
  }) : super(key: key);

  @override
  State<MonthlyComparisonChart> createState() => _MonthlyComparisonChartState();
}

class _MonthlyComparisonChartState extends State<MonthlyComparisonChart> {
  bool _isLoading = true;
  String? _selectedDepartmentId;
  Map<int, Map<String, int>> _monthlyData = {};
  ScrollController? _scrollController;

  final MainCoreDepartmentController _departmentController =
  Get.find<MainCoreDepartmentController>();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(getBaseUrl(FirestoreCollections.requestServices))
          .get();

      Map<int, Map<String, int>> data = {};
      for (int i = 1; i <= 12; i++) {
        data[i] = {'canceled': 0, 'rejected': 0};
      }

      final currentYear = DateTime.now().year;
      final employeeController = Get.find<MainCoreEmployeeController>();

      for (var doc in snapshot.docs) {
        try {
          final docData = doc.data();
          final model = ServicesHistoryModel.fromJson(docData, doc.id);

          String? documentDepartment;
          final emailRequester = docData['Email_Requester'];
          if (emailRequester is List && emailRequester.isNotEmpty) {
            final email = emailRequester[0];
            documentDepartment =
                employeeController.getEmployeeDepartmentName(email);
            if (documentDepartment == "no department") {
              documentDepartment = null;
            }
          }

          if (_selectedDepartmentId != null &&
              _selectedDepartmentId!.isNotEmpty) {
            if (documentDepartment == null) continue;
            final documentDepartmentId =
            _departmentController.getDepartmentIdFromDepartmentName(
              departmentName: documentDepartment.toLowerCase(),
            );
            if (documentDepartmentId != _selectedDepartmentId) continue;
          }

          String status = '';
          final stateArray = docData['state'];
          if (stateArray is List && stateArray.isNotEmpty) {
            status = stateArray.last?.toString().toLowerCase().trim() ?? '';
          }
          if (status.isEmpty) {
            status = _getFinalStateFromModel(model).toLowerCase();
          }

          if (status == 'cancel' ||
              status == 'canceled' ||
              status == 'rejected') {
            int? timestampValue;
            final timestampsArray = docData['timestamps'];
            if (timestampsArray is List && timestampsArray.isNotEmpty) {
              timestampValue = timestampsArray.last as int?;
            } else if (model.currentTimestamp != null) {
              timestampValue = model.currentTimestamp;
            }

            if (timestampValue != null) {
              final date = DateTime.fromMillisecondsSinceEpoch(timestampValue);
              if (date.year == currentYear) {
                final month = date.month;
                if (status == 'cancel' || status == 'canceled') {
                  data[month]!['canceled'] =
                      (data[month]!['canceled'] ?? 0) + 1;
                } else if (status == 'rejected') {
                  data[month]!['rejected'] =
                      (data[month]!['rejected'] ?? 0) + 1;
                }
              }
            }
          }
        } catch (e) {
          continue;
        }
      }

      setState(() {
        _monthlyData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  String _getFinalStateFromModel(ServicesHistoryModel service) {
    final outerState = service.currentState.toLowerCase().trim();
    final knownStates = [
      'done', 'inprogress', 'branchsla', 'breached sla', 'cancel',
      'canceled', 'pending', 'approved', 'rejected',
    ];
    if (knownStates.contains(outerState)) return outerState;

    final approvalList = service.currentApprovalCycle;
    if (approvalList.isEmpty) return 'pending';

    final states = <String>[];
    for (var approval in approvalList) {
      final state = (approval.state ?? '').toString().toLowerCase();
      if (state.isNotEmpty) states.add(state);
    }

    if (states.isEmpty) return 'pending';
    if (states.contains('cancel') || states.contains('canceled'))
      return 'cancel';
    if (states.contains('rejected')) return 'rejected';
    if (states.contains('pending')) return 'pending';
    if (states.contains('inprogress')) return 'inprogress';
    if (states.isNotEmpty && states.every((s) => s == 'approved'))
      return 'approved';
    return 'pending';
  }

  String _getMonthName(int month, bool isArabic) {
    final englishMonths = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final arabicMonths = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    if (month >= 1 && month <= 12) {
      return isArabic ? arabicMonths[month - 1] : englishMonths[month - 1];
    }
    return '';
  }

  String _formatNumber(num number, bool isArabic) {
    int intNumber = number.toInt();
    if (isArabic) {
      final westernDigits = [
        '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'
      ];
      final arabicDigits = [
        '٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'
      ];
      String numStr = intNumber.toString();
      for (int i = 0; i < westernDigits.length; i++) {
        numStr = numStr.replaceAll(westernDigits[i], arabicDigits[i]);
      }
      return numStr;
    }
    return intNumber.toString();
  }

  double _getMaxY() {
    if (_monthlyData.isEmpty) return 10.0;
    double maxValue = 0;
    for (var monthData in _monthlyData.values) {
      final canceled = monthData['canceled'] ?? 0;
      final rejected = monthData['rejected'] ?? 0;
      final total = canceled + rejected;
      if (total > maxValue) maxValue = total.toDouble();
    }
    if (maxValue == 0) return 10.0;
    int intMax = maxValue.ceil();
    int niceCeiling;
    if (intMax <= 5) {
      niceCeiling = 5;
    } else if (intMax <= 10) {
      niceCeiling = 10;
    } else if (intMax <= 20) {
      niceCeiling = 20;
    } else if (intMax <= 50) {
      niceCeiling = ((intMax / 10).ceil() * 10);
    } else if (intMax <= 100) {
      niceCeiling = ((intMax / 20).ceil() * 20);
    } else if (intMax <= 500) {
      niceCeiling = ((intMax / 50).ceil() * 50);
    } else {
      niceCeiling = ((intMax / 100).ceil() * 100);
    }
    return niceCeiling.toDouble();
  }

  double _getInterval(double maxY) {
    if (maxY <= 5) return 1.0;
    if (maxY <= 10) return 2.0;
    if (maxY <= 20) return 5.0;
    if (maxY <= 50) return 10.0;
    if (maxY <= 100) return 20.0;
    if (maxY <= 200) return 50.0;
    if (maxY <= 500) return 100.0;
    return (maxY / 5).ceilToDouble();
  }

  // ── Y-axis labels ──────────────────────────────────────────────────────────

  Widget _buildYAxisLabels(double maxY, double interval, bool isArabic) {
    final List<Widget> labels = [];
    double value = maxY;
    while (value >= 0) {
      labels.add(
        Expanded(
          child: Text(
            _formatNumber(value.toInt(), isArabic),
            style: TextStyle(fontSize: 9, color: AppColors.grey),
          ),
        ),
      );
      value -= interval;
    }
    return Column(children: labels);
  }

  // ── Single month bar (2 rods: canceled + rejected) ─────────────────────────

  Widget _buildSingleMonthBar({
    required double canceled,
    required double rejected,
    required double maxY,
    required double interval,
    required bool isArabic,
    required bool showGrid,
  }) {
    return BarChart(
      BarChartData(
        maxY: maxY,
        minY: 0,
        alignment: BarChartAlignment.center,
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: showGrid,
          drawVerticalLine: false,
          horizontalInterval: interval,
          getDrawingHorizontalLine: (v) => FlLine(
            color: widget.lightMode
                ? const Color(0xffEFF3F9)
                : AppColors.darkGrey,
            strokeWidth: 1,
          ),
        ),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipPadding: EdgeInsets.zero,
            tooltipMargin: 6.sp,
            getTooltipColor: (_) => Colors.transparent,
            tooltipBorder: BorderSide.none,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              if (rod.toY > 0) {
                return BarTooltipItem(
                  _formatNumber(rod.toY.toInt(), isArabic),
                  AppTextStyles.font10BlackCairoRegular.copyWith(color: AppColors.text),
                );
              }
              return null;
            },
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barsSpace: 4.sp,
            barRods: [
              BarChartRodData(
                toY: canceled,
                width: 12.sp,
                color: const Color(0xFFFF6B6B),
                borderRadius: BorderRadius.circular(4.r),
              ),
              BarChartRodData(
                toY: rejected,
                width: 12.sp,
                color: const Color(0xFF950E0E),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ],
            showingTooltipIndicators:
            (canceled > 0 || rejected > 0) ? [0, 1] : [],
          ),
        ],
      ),
    );
  }

  // ── Scrollable vertical chart with centered bars ───────────────────────────

  Widget _buildVerticalChart(BuildContext context, bool isArabic) {
    final maxY = _getMaxY();
    final interval = _getInterval(maxY);
    final double axisReservedSize = 28.0;
    final double itemWidth = 80.0;
    final double scrollContentWidth = 12 * itemWidth;

    final screenWidth = MediaQuery.of(context).size.width;
    final shouldScroll = (12 * 70.0) > (screenWidth - 30.sp);

    if (shouldScroll) {
      _scrollController ??= ScrollController();

      // Auto-scroll to first month with data
      int firstNonZeroIndex = -1;
      for (int m = 1; m <= 12; m++) {
        final monthData = _monthlyData[m] ?? {'canceled': 0, 'rejected': 0};
        if ((monthData['canceled'] ?? 0) > 0 ||
            (monthData['rejected'] ?? 0) > 0) {
          firstNonZeroIndex = m - 1;
          break;
        }
      }

      if (firstNonZeroIndex > 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController!.hasClients) {
            double targetOffset = (firstNonZeroIndex * itemWidth) -
                (screenWidth / 2) +
                (itemWidth / 2);
            targetOffset = targetOffset.clamp(
              0.0,
              _scrollController!.position.maxScrollExtent,
            );
            _scrollController!.animateTo(
              targetOffset,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }

      // ── Scrollable layout ──
      return Row(
        children: [
          if (!isArabic)
            SizedBox(
              width: axisReservedSize,
              child: _buildYAxisLabels(maxY, interval, isArabic),
            ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: SizedBox(
                width: scrollContentWidth,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: List.generate(12, (index) {
                          final month = index + 1;
                          final monthData = _monthlyData[month] ??
                              {'canceled': 0, 'rejected': 0};
                          return SizedBox(
                            width: itemWidth,
                            child: _buildSingleMonthBar(
                              canceled:
                              (monthData['canceled'] ?? 0).toDouble(),
                              rejected:
                              (monthData['rejected'] ?? 0).toDouble(),
                              maxY: maxY,
                              interval: interval,
                              isArabic: isArabic,
                              showGrid: index == 0,
                            ),
                          );
                        }),
                      ),
                    ),
                    SizedBox(
                      height: 28.sp,
                      child: Row(
                        children: List.generate(12, (index) {
                          return SizedBox(
                            width: itemWidth,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 2),
                                child: Text(
                                  _getMonthName(index + 1, isArabic),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: AppColors.text,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isArabic)
            SizedBox(
              width: axisReservedSize,
              child: _buildYAxisLabels(maxY, interval, isArabic),
            ),
        ],
      );
    }

    // ── Static layout (tablet/desktop) ──
    return Row(
      children: [
        if (!isArabic)
          SizedBox(
            width: 45.sp,
            child: _buildYAxisLabels(maxY, interval, isArabic),
          ),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: List.generate(12, (index) {
                    final month = index + 1;
                    final monthData =
                        _monthlyData[month] ?? {'canceled': 0, 'rejected': 0};
                    return Expanded(
                      child: _buildSingleMonthBar(
                        canceled: (monthData['canceled'] ?? 0).toDouble(),
                        rejected: (monthData['rejected'] ?? 0).toDouble(),
                        maxY: maxY,
                        interval: interval,
                        isArabic: isArabic,
                        showGrid: index == 0,
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(
                height: 28.sp,
                child: Row(
                  textDirection:
                  isArabic ? TextDirection.rtl : TextDirection.ltr,
                  children: List.generate(12, (index) {
                    return Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 2),
                          child: Text(
                            _getMonthName(index + 1, isArabic),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.text,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
        if (isArabic)
          SizedBox(
            width: 45.sp,
            child: _buildYAxisLabels(maxY, interval, isArabic),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final List<Map<String, String>> departmentItems = [
      {
        'key': '',
        'value': S.of(context).all_departments ?? 'All Departments'
      },
      ..._departmentController.departmentIds.map((id) {
        final name = isArabic
            ? _departmentController
            .getArabicDepartmentNameFromDepartmentId(departmentId: id)
            : _departmentController
            .getEnglishDepartmentNameFromDepartmentId(departmentId: id);
        return {'key': id, 'value': name ?? id};
      }).toList(),
    ];

    var isMobile = context.isPhone;

    return Container(
      height: isMobile ? 385.h : 330.h,
      padding: EdgeInsets.all(15.sp),
      decoration: BoxDecoration(
        color: widget.lightMode
            ? AppColors.white
            : AppColors.chatBackground,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 26.sp,
                        height: 26.sp,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            "assets/headphoneDashboard.svg",
                            width: 16.sp,
                            height: 16.sp,
                            color: AppColors.textButton,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.sp),
                      Text(
                        S.of(context).monthlyComparison ??
                            'Monthly Comparison',
                        style: AppTextStyles.font14BlackSemiBoldCairo.copyWith(
                          color: widget.lightMode
                              ? AppColors.blackButton
                              : AppColors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.sp),
                  // Legend
                  Row(
                    children: [
                      Container(
                        width: 12.sp,
                        height: 12.sp,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B6B),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        S.of(context).Canceled,
                        style: AppTextStyles.font12BlackCairoRegular.copyWith(
                          color: widget.lightMode
                              ? AppColors.blackButton
                              : AppColors.white,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Container(
                        width: 12.sp,
                        height: 12.sp,
                        decoration: BoxDecoration(
                          color: const Color(0xFF950E0E),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        S.of(context).Rejected,
                        style: AppTextStyles.font12BlackCairoRegular
                            .copyWith(color: AppColors.text),
                      ),
                    ],
                  ),
                ],
              ),
              // if (!isMobile)
              //   CustomDropdownFormFieldFinal(
              //     selectedValue: _selectedDepartmentId,
              //     items: departmentItems,
              //     onChanged: (value) {
              //       setState(() => _selectedDepartmentId = value);
              //       _loadData();
              //     },
              //     widthIcon: 13.w,
              //     paddingLeft: 8.sp,
              //     paddingRight: 8.sp,
              //     heightIcon: 6.h,
              //     width: MediaQuery.sizeOf(context).width * .3,
              //     height: 36,
              //     hint: Text(
              //       S.of(context).selectDepartment ?? 'Select Department',
              //       style: AppTextStyles.font12BlackCairoRegular
              //           .copyWith(color: AppColors.secondaryText),
              //     ),
              //     label: S.of(context).department,
              //     spaceHeight: 6.h,
              //   ),
            ],
          ),

          if (isMobile) ...[
            SizedBox(height: 15.sp),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomDropdownFormFieldFinal(
                  selectedValue: _selectedDepartmentId,
                  items: departmentItems,
                  onChanged: (value) {
                    setState(() => _selectedDepartmentId = value);
                    _loadData();
                  },
                  widthIcon: 13.w,
                  paddingLeft: 8.sp,
                  paddingRight: 8.sp,
                  heightIcon: 6.h,
                  width: MediaQuery.sizeOf(context).width * .45,
                  height: 36,
                  hint: Text(
                    S.of(context).selectDepartment ?? 'Select Department',
                    style: AppTextStyles.font12BlackCairoRegular
                        .copyWith(color: AppColors.secondaryText),
                  ),
                  label: S.of(context).department,
                  spaceHeight: 6.h,
                ),
              ],
            ),
          ],

          SizedBox(height: 20.sp),

          // ── Chart ──
          _isLoading
              ? SizedBox(
            height: 200.h,
            child: Center(child: CircleProgress()),
          )
              : Expanded(
            child: _buildVerticalChart(context, isArabic),
          ),
        ],
      ),
    );
  }
}

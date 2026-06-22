/// ******************* FILE INFO *******************
/// File Name: monthly_comparison_chart.dart
/// Description: Monthly comparison chart showing canceled vs rejected services across 12 months
/// Created by: Amr Mesbah
/// Last Update: 17/01/2026 - FIXED: Changed from collectionGroup to RequestServices collection

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/services_management_module/data/helper/services_dropdown.dart';
import 'package:demo_app/core/network/get_base_url.dart';
import 'package:demo_app/features/department/presentation/controller/add_department_controller.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/core/constants/services_management/constant.dart';
import 'package:demo_app/features/home/presentation/ui/pages/dashboard_view_data/chart_orientation_enum.dart';
import 'package:demo_app/generated/l10n.dart';

import 'package:demo_app/core/helper/circle_progress.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';

class MonthlyComparisonServicesChart extends StatefulWidget {
  final ChartOrientation orientation;
  final bool lightMode;

  const MonthlyComparisonServicesChart({
    Key? key,
    this.orientation = ChartOrientation.vertical,
    required this.lightMode,
  }) : super(key: key);

  @override
  State<MonthlyComparisonServicesChart> createState() => _MonthlyComparisonServicesChartState();
}

class _MonthlyComparisonServicesChartState extends State<MonthlyComparisonServicesChart> {
  bool _isLoading = true;
  String? _selectedServiceName;

  // Map to store monthly data: month (1-12) -> {canceled: count, rejected: count}
  Map<int, Map<String, int>> _monthlyData = {};

  // All services available (both English and Arabic)
  List<String> _allServicesEnglish = [];
  List<String> _allServicesArabic = [];

  final MainCoreDepartmentController _departmentController = Get.find<MainCoreDepartmentController>();

  @override
  void initState() {
    super.initState();
    // Don't load data here - wait for didChangeDependencies
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading) {
      // Only load once when first mounted
      _loadData();
    }
  }

  // ✅ FIXED: Query from RequestServices collection instead of collectionGroup
  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final employeeController = Get.find<MainCoreEmployeeController>();
      final userDepartmentId = employeeController.employeeEntity?.departmentId;

      String? userDepartmentName;
      if (userDepartmentId != null) {
        userDepartmentName = _departmentController.getDepartmentName(userDepartmentId, true);
      }

      // ✅ STEP 1: Fetch ALL services from CreateServices for the dropdown
      final createServicesSnapshot = await FirebaseFirestore.instance
          .collection(getBaseUrl(FirestoreCollections.createServices))
          .get();

      Set<String> allServicesSetEnglish = {};
      Set<String> allServicesSetArabic = {};

      for (var doc in createServicesSnapshot.docs) {
        final data = doc.data();
        final nameEN = _extractValue(data['Service_Name_English']);
        final nameAR = _extractValue(data['Service_Name_Arabic']);
        if (nameEN.isNotEmpty) allServicesSetEnglish.add(nameEN);
        if (nameAR.isNotEmpty) allServicesSetArabic.add(nameAR);
      }

      // ✅ STEP 2: Fetch RequestServices for chart data
      final snapshot = await FirebaseFirestore.instance
          .collection(getBaseUrl(FirestoreCollections.requestServices))
          .get();

      Map<int, Map<String, int>> monthlyData = {};
      for (int i = 1; i <= 12; i++) {
        monthlyData[i] = {'canceled': 0, 'rejected': 0};
      }

      // Cache to avoid duplicate Firestore calls for same Parent_Service_Id
      Map<String, Map<String, String>> serviceNameCache = {};

      for (var doc in snapshot.docs) {
        final docData = doc.data();
        final model = ServicesHistoryModel.fromJson(docData, doc.id);

        // Department filter
        String department = _normalizeDepartmentValue(docData['departmentRequester']);
        if (department.isEmpty) {
          final emailRequester = _extractValue(docData['Email_Requester']);
          if (emailRequester.isNotEmpty) {
            final employeeData = employeeController.mapOfEmployeesWithEmailKey[emailRequester];
            if (employeeData?.departmentId != null) {
              department = _departmentController.getEnglishDepartmentNameFromDepartmentId(
                departmentId: employeeData!.departmentId!,
              ) ?? '';
            }
          }
        }

        if (userDepartmentName != null && department != userDepartmentName) continue;

        // Get service name (with cache)
        String serviceNameEnglish = model.currentServiceNameEnglish;
        String serviceNameArabic = model.currentServiceNameArabic;

        if (serviceNameEnglish.isEmpty) {
          final parentId = _extractValue(docData['Parent_Service_Id']);
          if (parentId.isNotEmpty) {
            if (serviceNameCache.containsKey(parentId)) {
              serviceNameEnglish = serviceNameCache[parentId]!['en']!;
              serviceNameArabic = serviceNameCache[parentId]!['ar']!;
            } else {
              try {
                final createDoc = await FirebaseFirestore.instance
                    .doc('${getBaseUrl(FirestoreCollections.createServices)}/$parentId')
                    .get();
                if (createDoc.exists) {
                  serviceNameEnglish = _extractValue(createDoc.data()!['Service_Name_English']);
                  serviceNameArabic = _extractValue(createDoc.data()!['Service_Name_Arabic']);
                  serviceNameCache[parentId] = {'en': serviceNameEnglish, 'ar': serviceNameArabic};
                }
              } catch (e) {
              }
            }
          }
        }

        if (serviceNameEnglish.isEmpty) serviceNameEnglish = 'Unknown Service';
        if (serviceNameArabic.isEmpty) serviceNameArabic = 'خدمة غير معروفة';

        // Filter by selected service
        if (_selectedServiceName != null && _selectedServiceName!.isNotEmpty) {
          if (serviceNameEnglish != _selectedServiceName && serviceNameArabic != _selectedServiceName) {
            continue;
          }
        }

        final status = _getFinalStateFromModel(model).toLowerCase();
        if ((status == 'cancel' || status == 'canceled' || status == 'rejected') &&
            model.currentTimestamp != null) {
          final month = DateTime.fromMillisecondsSinceEpoch(model.currentTimestamp!).month;
          if (status == 'cancel' || status == 'canceled') {
            monthlyData[month]!['canceled'] = (monthlyData[month]!['canceled'] ?? 0) + 1;
          } else {
            monthlyData[month]!['rejected'] = (monthlyData[month]!['rejected'] ?? 0) + 1;
          }
        }
      }

      final sortedEN = allServicesSetEnglish.toList()..sort();
      final sortedAR = allServicesSetArabic.toList()..sort();

      setState(() {
        _monthlyData = monthlyData;
        _allServicesEnglish = sortedEN;
        _allServicesArabic = sortedAR;
        _isLoading = false;
      });

    } catch (e, s) {
      setState(() => _isLoading = false);
    }
  }

  String _normalizeDepartmentValue(dynamic departmentValue) {
    if (departmentValue == null) return '';
    String value = '';

    if (departmentValue is List && departmentValue.isNotEmpty) {
      value = departmentValue.last?.toString().trim() ?? '';
    } else {
      value = departmentValue.toString().trim();
    }

    if (value.isEmpty) return '';

    // Check if it's a department ID (numeric)
    if (int.tryParse(value) != null) {
      final departmentName = _departmentController.getEnglishDepartmentNameFromDepartmentId(
        departmentId: value,
      );

      if (departmentName != null && departmentName.isNotEmpty) {
        return departmentName;
      }
    }

    return value;
  }

  String _extractValue(dynamic value) {
    if (value == null) return '';
    if (value is List) {
      if (value.isEmpty) return '';
      return value[0]?.toString() ?? '';
    }
    return value.toString();
  }

  String _getFinalStateFromModel(ServicesHistoryModel service) {
    final outerState = service.currentState.toLowerCase().trim();
    final knownStates = [
      'done', 'inprogress', 'branchsla', 'breached sla', 'cancel',
      'canceled', 'pending', 'approved', 'rejected',
    ];

    if (knownStates.contains(outerState)) {
      return outerState;
    }

    final approvalList = service.currentApprovalCycle;
    if (approvalList.isEmpty) return 'pending';

    final states = <String>[];
    for (var approval in approvalList) {
      final state = (approval.state ?? '').toString().toLowerCase();
      if (state.isNotEmpty) states.add(state);
    }

    if (states.isEmpty) return 'pending';
    if (states.contains('cancel') || states.contains('canceled')) return 'cancel';
    if (states.contains('rejected')) return 'rejected';
    if (states.contains('pending')) return 'pending';
    if (states.contains('inprogress')) return 'inprogress';
    if (states.isNotEmpty && states.every((s) => s == 'approved')) return 'approved';

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
      final westernDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
      final arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

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

  List<BarChartGroupData> _buildBarGroups(bool isArabic) {
    List<BarChartGroupData> groups = [];

    for (int i = 0; i < 12; i++) {
      // ✅ FIXED: Reverse data order for Arabic
      int month;
      if (isArabic) {
        // Arabic: Display Dec (12) → Jan (1) from right to left
        month = 12 - i;
      } else {
        // English: Display Jan (1) → Dec (12) from left to right
        month = i + 1;
      }

      final monthData = _monthlyData[month] ?? {'canceled': 0, 'rejected': 0};
      final canceled = (monthData['canceled'] ?? 0).toDouble();
      final rejected = (monthData['rejected'] ?? 0).toDouble();

      groups.add(
        BarChartGroupData(
          x: i, // Keep x as 0-11 for positioning
          barsSpace: 4.sp,
          barRods: [
            BarChartRodData(
              toY: canceled,
              width: 12.sp,
              color: const Color(0xFFFF6B6B), // Red for canceled
              borderRadius: BorderRadius.circular(4.r),
            ),
            BarChartRodData(
              toY: rejected,
              width: 12.sp,
              color: const Color(0xFF950E0E), // Dark red for rejected
              borderRadius: BorderRadius.circular(4.r),
            ),
          ],
          showingTooltipIndicators: [0, 1],
        ),
      );
    }

    return groups;
  }

  Widget _buildVerticalChart(BuildContext context, bool isArabic) {
    final maxY = _getMaxY();
    final interval = _getInterval(maxY);

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    if (!isMobile) {
      // ✅ TABLET/DESKTOP: No scroll — everything fits on screen
      return BarChart(
        BarChartData(
          maxY: maxY,
          minY: 0,
          alignment: BarChartAlignment.spaceEvenly,
          groupsSpace: 8.sp,
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: interval,
            getDrawingHorizontalLine: (value) => FlLine(
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
              tooltipMargin: 8.sp,
              getTooltipColor: (_) => Colors.transparent,
              tooltipBorder: BorderSide.none,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                if (rod.toY > 0) {
                  return BarTooltipItem(
                    _formatNumber(rod.toY.toInt(), isArabic),
                    AppTextStyles.font10BlackCairoRegular.copyWith(
                      color: widget.lightMode
                          ? AppColors.blackButton
                          : AppColors.white,
                    ),
                  );
                }
                return null;
              },
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: !isArabic,
                reservedSize: 28,
                interval: interval,
                getTitlesWidget: (value, _) {
                  if (value % interval == 0) {
                    return Text(
                      _formatNumber(value.toInt(), isArabic),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: widget.lightMode ? AppColors.grey : AppColors.grey,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: isArabic,
                reservedSize: 28,
                interval: interval,
                getTitlesWidget: (value, _) {
                  if (value % interval == 0) {
                    return Text(
                      _formatNumber(value.toInt(), isArabic),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: widget.lightMode ? AppColors.grey : AppColors.grey,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                reservedSize: 28,
                showTitles: true,
                getTitlesWidget: (value, _) {
                  int month = isArabic ? 12 - value.toInt() : value.toInt() + 1;
                  if (month >= 1 && month <= 12) {
                    return FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: EdgeInsets.only(top: 3.sp),
                        child: Text(
                          _getMonthName(month, isArabic),
                          style: AppTextStyles.font12BlackMediumCairo.copyWith(
                            color: AppColors.text,
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          barGroups: _buildBarGroups(isArabic),
        ),
      );
    }

    // ✅ MOBILE: Fixed Y-axis + scrollable chart
    final double axisReservedSize = 28.0;
    final double itemWidth = 60.0;
    final double scrollContentWidth = 12 * itemWidth;

    return Row(
      children: [
        // ✅ Fixed Y-axis — does NOT scroll
        if (!isArabic)
          SizedBox(
            width: axisReservedSize,
            child: _buildYAxisLabels(maxY, interval, isArabic),
          ),

        // ✅ Scrollable chart area
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: isArabic,
            physics: const ClampingScrollPhysics(),
            child: SizedBox(
              width: scrollContentWidth,
              child: BarChart(
                BarChartData(
                  maxY: maxY,
                  minY: 0,
                  alignment: BarChartAlignment.spaceEvenly,
                  groupsSpace: 12.sp,
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: interval,
                    getDrawingHorizontalLine: (value) => FlLine(
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
                      tooltipMargin: 8.sp,
                      getTooltipColor: (_) => Colors.transparent,
                      tooltipBorder: BorderSide.none,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        if (rod.toY > 0) {
                          return BarTooltipItem(
                            _formatNumber(rod.toY.toInt(), isArabic),
                            AppTextStyles.font10BlackCairoRegular.copyWith(
                              color: widget.lightMode
                                  ? AppColors.blackButton
                                  : AppColors.white,
                            ),
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
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        reservedSize: 28,
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          int month = isArabic ? 12 - value.toInt() : value.toInt() + 1;
                          if (month >= 1 && month <= 12) {
                            return FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Padding(
                                padding: EdgeInsets.only(top: 3.sp),
                                child: Text(
                                  _getMonthName(month, isArabic),
                                  style: AppTextStyles.font12BlackMediumCairo.copyWith(
                                    color: AppColors.text,
                                  ),
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  barGroups: _buildBarGroups(isArabic),
                ),
              ),
            ),
          ),
        ),

        // ✅ Fixed Y-axis for Arabic (right side)
        if (isArabic)
          SizedBox(
            width: axisReservedSize,
            child: _buildYAxisLabels(maxY, interval, isArabic),
          ),
      ],
    );
  }

  Widget _buildYAxisLabels(double maxY, double interval, bool isArabic) {
    final List<double> values = [];
    double value = maxY;
    while (value >= 0) {
      values.add(value);
      value -= interval;
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 28), // match bottomTitles reservedSize
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment:
        isArabic ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: values.map((v) {
          return Text(
            _formatNumber(v.toInt(), isArabic),
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.grey,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHorizontalChart(BuildContext context, bool isArabic) {
    final maxY = _getMaxY();

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        height: 12 * 60.h,
        child: BarChart(
          BarChartData(
            maxY: maxY,
            minY: 0,
            alignment: BarChartAlignment.spaceEvenly,
            borderData: FlBorderData(show: false),
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: false,
              drawVerticalLine: true,
            ),
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                tooltipPadding: EdgeInsets.all(0.sp),
                tooltipMargin: 8.sp,
                getTooltipColor: (_) => Colors.transparent,
                tooltipBorder: BorderSide.none,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  if (rod.toY > 0) {
                    return BarTooltipItem(
                      _formatNumber(rod.toY.toInt(), isArabic),
                      AppTextStyles.font10BlackCairoRegular.copyWith(
                        color: widget.lightMode
                            ? AppColors.blackButton
                            : AppColors.white,
                      ),
                    );
                  }
                  return null;
                },
              ),
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 80.sp,
                  getTitlesWidget: (value, _) {
                    // ✅ FIXED: Reverse month order for Arabic
                    int month;
                    if (isArabic) {
                      month = 12 - value.toInt();
                    } else {
                      month = value.toInt() + 1;
                    }

                    if (month >= 1 && month <= 12) {
                      return Text(
                        _getMonthName(month, isArabic),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: widget.lightMode ? AppColors.black : AppColors.white,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30.sp,
                  getTitlesWidget: (value, _) {
                    return Text(
                      _formatNumber(value.toInt(), isArabic),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: widget.lightMode ? AppColors.grey : AppColors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
            barGroups: _buildBarGroups(isArabic), // ✅ Pass isArabic parameter
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    // Use appropriate language list
    final allServices = isArabic ? _allServicesArabic : _allServicesEnglish;

    // Prepare service dropdown items
    final List<Map<String, String>> serviceItems = [
      {'key': '', 'value': S.of(context).all_services ?? 'All Services'},
      ...allServices.map((serviceName) {
        return {'key': serviceName, 'value': serviceName};
      }).toList(),
    ];

    // Calculate totals for legend
    int totalCanceled = 0;
    int totalRejected = 0;
    for (var monthData in _monthlyData.values) {
      totalCanceled += monthData['canceled'] ?? 0;
      totalRejected += monthData['rejected'] ?? 0;
    }

    var isMobile = context.isPhone;

    return Container(
      padding: EdgeInsets.only(top: 15.sp, right: 15.w,left: 15.w,bottom: 10.h),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
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
                        Expanded(
                          child: Text(
                            S.of(context).monthlyComparison ?? 'Monthly Comparison',
                            style: AppTextStyles.font14BlackSemiBoldCairo.copyWith(
                              color: widget.lightMode
                                  ? AppColors.blackButton
                                  : AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.sp),
                    // Legend
                    Wrap(
                      spacing: 12.w,
                      runSpacing: 8.h,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
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
                              '${S.of(context).Canceled}: ${_formatNumber(totalCanceled, isArabic)}',
                              style: AppTextStyles.font12BlackCairoRegular.copyWith(
                                color: widget.lightMode
                                    ? AppColors.blackButton
                                    : AppColors.white,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                              '${S.of(context).Rejected}: ${_formatNumber(totalRejected, isArabic)}',
                              style: AppTextStyles.font12BlackCairoRegular.copyWith(
                                color: widget.lightMode
                                    ? AppColors.blackButton
                                    : AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
             isMobile ? SizedBox() : Spacer(),
              isMobile ? SizedBox() :   CustomDropdownFormFieldFinal(
                selectedValue: _selectedServiceName,
                items: serviceItems,
                onChanged: (value) {
                  setState(() {
                    _selectedServiceName = value;
                  });
                  _loadData();
                },
                widthIcon: 13.w,
                paddingLeft: 8.sp,
                paddingRight: 8.sp,
                heightIcon: 6.h,
                width: MediaQuery.sizeOf(context).width * .25,
                height: 36,
                hint: Text(
                  S.of(context).select_service ?? 'Select Service',
                  style: AppTextStyles.font12BlackCairoRegular.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                label: S.of(context).service ?? 'Service',
                spaceHeight: 6.h,
              ),
            ],
          ),
          isMobile ? SizedBox(height: 10.sp) : SizedBox(),
          isMobile ? CustomDropdownFormFieldFinal(
            selectedValue: _selectedServiceName,
            items: serviceItems,
            onChanged: (value) {
              setState(() {
                _selectedServiceName = value;
              });
              _loadData();
            },
            widthIcon: 13.w,
            paddingLeft: 8.sp,
            paddingRight: 8.sp,
            heightIcon: 6.h,
            width: MediaQuery.sizeOf(context).width * .45,
            height: 36,
            hint: Text(
              S.of(context).select_service ?? 'Select Service',
              style: AppTextStyles.font12BlackCairoRegular.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
            label: S.of(context).service ?? 'Service',
            spaceHeight: 6.h,
          ) : SizedBox(),

          SizedBox(height: 20.sp),

          // Chart
          _isLoading
              ? SizedBox(
            height: 300.h,
            child: Center(child: CircleProgress()),
          )
              : SizedBox(
            height: widget.orientation == ChartOrientation.vertical ? 200.h : 200.h,
            child: widget.orientation == ChartOrientation.vertical
                ? _buildVerticalChart(context, isArabic)
                : _buildHorizontalChart(context, isArabic),
          ),
        ],
      ),
    );
  }
}

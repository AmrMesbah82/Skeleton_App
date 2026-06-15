import 'package:demo_app/core/widgets/navigation.dart';
import 'package:demo_app/core/widgets/side_frame_master.dart';
import 'package:demo_app/core/theme/new_theme.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/core/widgets/custom_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/custom_validate_textfield.dart';
import 'package:demo_app/core/helper/circle_progress.dart';
import 'package:demo_app/core/helper/format_helper.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/inventory_module/core/navigate.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/services_mangment_module/Category/presentation/ui/service_department_manager/tablet/s2_details_service/details_service/widget/info_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/features/roles/presentation/ui/pages/user_management/user_mangement_details_request.dart';
import 'package:lottie/lottie.dart';

import '../../../../../../core/helper/cross_axis_count_helper.dart';
import '../../../../../../generated/l10n.dart';
import 'package:demo_app/core/network/get_base_url.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../employee/domain/entities/employee_entity.dart';
import '../../../../../employee/presentation/controller/main_core_employee_controller.dart';
// REMOVED_MODULE: import '../../../../../../external/services_mangment_module/Category/presentation/ui/services_admin/Widget/W3_Frame_Screen_tablet.dart';
// REMOVED_MODULE: import '../../../../../../external/services_mangment_module/core/new_theme.dart';
import '../../../../../settings/presentation/ui/pages/details_request.dart';
import '../../../../utils/role_log_service.dart';


class RequestPageApproval extends StatefulWidget {
  const RequestPageApproval({super.key});

  @override
  State<RequestPageApproval> createState() => _RequestPageApprovalState();
}

class _RequestPageApprovalState extends State<RequestPageApproval> {
  String selectStatus = "All";

  int totalRequests = 0;
  int pendingCount = 0;
  int approvedCount = 0;
  int rejectedCount = 0;

  List<Map<String, dynamic>> allRequests = [];
  List<Map<String, dynamic>> filteredRequests = [];

  TextEditingController searchController = TextEditingController();

  bool isLoading = true;

  // Track which cards are being actioned (to show loading per card)
  Set<String> _actioningIds = {};

  @override
  void initState() {
    super.initState();
    RoleLogService.log(RoleLogService.pageRequestApproval);
    _fetchRequestsFromFirebase();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterRequests();
  }

  Future<void> _fetchRequestsFromFirebase() async {
    setState(() {
      isLoading = true;
    });

    try {
      final MainCoreEmployeeController employeeController =
      Get.find<MainCoreEmployeeController>();
      final String? employeeId = employeeController.employeeEntity?.id;

      if (employeeId == null || employeeId.isEmpty) {
        throw Exception('Employee ID not found');
      }

      final String basePath = getBaseUrl('Modules');

      final querySnapshot = await FirebaseFirestore.instance
          .doc('$basePath/roles')
          .collection('Employees_Request')
          .where('employeeId', isEqualTo: employeeId)
          .orderBy('requestDate', descending: true)
          .get();

      List<Map<String, dynamic>> requests = [];

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        requests.add({
          'id': doc.id,
          'title': data['section'] ?? 'Personal Information',
          'dateRequested': data['requestDate']?.millisecondsSinceEpoch ?? 0,
          'status': data['status'] ?? 'pending',
          'requestNote': data['requestNote'] ?? '',
          'employeeId': data['employeeId'] ?? '',
          'employeeEmail': data['employeeEmail'] ?? '',
          'section': data['section'] ?? '',
          'whatChanged': data['whatChanged'] ?? '',
          'oldValue': data['oldValue'] ?? '',
          'newValue': data['newValue'] ?? '',
        });
      }

      setState(() {
        allRequests = requests;
        _updateCounts();
        _filterRequests();
        isLoading = false;
      });
    } catch (e) {
      print('❌ Error fetching requests: $e');
      setState(() {
        isLoading = false;
      });

      Get.snackbar(
        'Error'.tr,
        'Failed to load requests: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // ─── NEW: Update a single request status in Firestore ───────────────────────
  Future<void> _updateRequestStatus(String requestId, String newStatus) async {
    // Mark as loading
    setState(() => _actioningIds.add(requestId));

    try {
      final String basePath = getBaseUrl('Modules');

      await FirebaseFirestore.instance
          .doc('$basePath/roles')
          .collection('Employees_Request')
          .doc(requestId)
          .update({
        'status': newStatus,
        'actionDate': FieldValue.serverTimestamp(),
      });

      // Update local list so UI reflects immediately without full reload
      setState(() {
        final idx = allRequests.indexWhere((r) => r['id'] == requestId);
        if (idx != -1) {
          allRequests[idx]['status'] = newStatus;
        }
        _updateCounts();
        _filterRequests();
        _actioningIds.remove(requestId);
      });

      Get.snackbar(
        newStatus == 'approved' ? 'Approved ✓' : 'Rejected ✗',
        'Request has been ${newStatus} successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor:
        newStatus == 'approved' ? AppColors.green : Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      setState(() => _actioningIds.remove(requestId));
      Get.snackbar(
        'Error'.tr,
        'Failed to update request: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // ─── NEW: Confirmation dialog before approve / reject ───────────────────────
  Future<void> _showConfirmDialog({
    required String requestId,
    required String action, // 'approved' | 'rejected'
  }) async {
    final isApprove = action == 'approved';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        title: Row(
          children: [
            Icon(
              isApprove ? Icons.check_circle_outline : Icons.cancel_outlined,
              color: isApprove ? Colors.green : Colors.red,
              size: 24.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              isApprove ? 'Approve Request' : 'Reject Request',
              style: StyleText.fontSize16Weight500,
            ),
          ],
        ),
        content: Text(
          isApprove
              ? 'Are you sure you want to approve this request?'
              : 'Are you sure you want to reject this request?',
          style: StyleText.fontSize14Weight400,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cancel',
              style: StyleText.fontSize14Weight400.copyWith(
                  color: AppColors.secondaryText),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
              isApprove ? ColorAppLight.greenColor : Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r)),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              isApprove ? 'Approve' : 'Reject',
              style: StyleText.fontSize14Weight500
                  .copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      RoleLogService.log(action == 'approved'
          ? RoleLogService.actionApproveRequest
          : RoleLogService.actionRejectRequest);
      await _updateRequestStatus(requestId, action);
    }
  }

  void _updateCounts() {
    totalRequests = allRequests.length;
    pendingCount = allRequests.where((r) => r['status'] == 'pending').length;
    approvedCount = allRequests.where((r) => r['status'] == 'approved').length;
    rejectedCount = allRequests.where((r) => r['status'] == 'rejected').length;
  }

  void _filterRequests() {
    List<Map<String, dynamic>> filtered = List.from(allRequests);

    if (selectStatus != "All") {
      filtered = filtered.where((request) {
        if (selectStatus == S.of(context).Approved) {
          return request['status'] == 'approved';
        } else if (selectStatus == 'Pending') {
          return request['status'] == 'pending';
        } else if (selectStatus == 'Rejected') {
          return request['status'] == 'rejected';
        }
        return true;
      }).toList();
    }

    if (searchController.text.isNotEmpty) {
      final searchText = searchController.text.toLowerCase();
      filtered = filtered.where((request) {
        final title = request['title'].toString().toLowerCase();
        return title.contains(searchText);
      }).toList();
    }

    setState(() {
      filteredRequests = filtered;
    });
  }

  String _formatDate(int timestamp) {
    if (timestamp == 0) return '-';
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('dd MMM yyyy').format(date);
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return AppColors.green;
      case 'pending':
        return AppColors.yellow;
      case 'rejected':
        return Colors.red[500]!;
      default:
        return AppColors.secondaryText;
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return S.of(context).Approved;
      case 'pending':
        return 'Pending';
      case 'rejected':
        return 'Rejected';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    var isMobile = context.isPhone;
    var lightMode = Theme.of(context).brightness == Brightness.light;

    return isLoading
        ? Center(child: CircleProgress())
        : RefreshIndicator(
      onRefresh: _fetchRequestsFromFirebase,
      child: SideFrameMaster(
        titleText: "User Management",
        onFirstTap: () {
          Navigator.of(context).pop();
        },
        secondTitle: S.of(context).requests,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: filterSection()),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: CustomKnowticedTextField(
                      labelEn: '',
                      labelAr: '',
                      height: 36.h,
                      labelStyle: StyleText.fontSize16Weight400.copyWith(
                        color:   AppColors.text
                      ),
                      borderColor: Colors.transparent,
                      hintEn: 'Search',
                      hintAr: 'بحث',
                      contentPadding: EdgeInsets.symmetric(vertical: 5.h),
                      controller: searchController,
                      language: Localizations.localeOf(context).languageCode == 'ar'
                          ? AppLanguage.arabic
                          : AppLanguage.english,

                      keyboardType: TextInputType.text,
                      prefixIcon: Icons.search,

                      borderRadius: 8,
                      fillColor: AppColors.card,
                      // borderColor: lightMode
                      //     ? Colors.grey[300]
                      //     : ColorAppDark.titleKey,
                      focusedBorderColor: AppColors.primary,
                      onChanged: (val) {
                        _onSearchChanged();
                      },
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Container(
                    width: isMobile ? 38.w : 100.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: AppColors.card,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isMobile
                            ? Center(
                            child: CustomSvg(
                              assetPath:
                              "assets/images/Sort_services.svg",
                              width: 20.w,
                              height: 20.h,
                              fit: BoxFit.scaleDown,
                              color: AppColors.secondaryText,
                            ))
                            : Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Center(
                              child: CustomSvg(
                                assetPath:
                                "assets/images/Sort_services.svg",
                                width: 20.w,
                                height: 20.h,
                                fit: BoxFit.scaleDown,
                                color: AppColors.secondaryText,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              S.of(context).sort,
                              style: StyleText.fontSize16Weight500
                                  .copyWith(
                                  color: AppColors.secondaryText),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 20.h),
              filteredRequests.isEmpty
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 150.h),
                  Center(
                    child: Lottie.asset(
                      "assets/lottie/empty.json",
                      width: 300.w,
                      height: 300.h,
                      repeat: true,
                    ),
                  ),
                ],
              )
                  : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: CrossAxisCountHelper
                      .getCrossAxisCountForDefaultTablet2(context),
                  mainAxisSpacing: 15.sp,
                  crossAxisSpacing: 15.sp,
                  // ── slightly taller card to fit action buttons ──
                  mainAxisExtent: 200.sp,
                ),
                itemCount: filteredRequests.length,
                itemBuilder: (context, index) {
                  final request = filteredRequests[index];
                  final status = request['status'] ?? 'pending';
                  final statusColor = _getStatusColor(status);
                  final requestId = request['id'] as String;
                  final isPending = status == 'pending';
                  final isActioning =
                  _actioningIds.contains(requestId);

                  final employeeController =
                  Get.find<MainCoreEmployeeController>();
                  final employeeEmail =
                      request['employeeEmail'] ?? '';

                  final jobTitle = employeeEmail.isNotEmpty
                      ? employeeController
                      .getEmployeeJobTitle(employeeEmail)
                      : '-';
                  final department = employeeEmail.isNotEmpty
                      ? employeeController
                      .getEmployeeDepartmentName(employeeEmail)
                      : '-';

                  return GestureDetector(
                    onTap: () {
                      navigateTo(
                        context,
                        UserManagementDetailsRequestSettings(
                          requestId: requestId,
                          requestData: {
                            'employeeId': request['employeeId'],
                            'employeeEmail':
                            request['employeeEmail'],
                            'section': request['section'],
                            'whatChanged': request['whatChanged'],
                            'oldValue': request['oldValue'],
                            'newValue': request['newValue'],
                            'status': request['status'],
                            'requestDate': request['dateRequested'],
                            'requestNote': request['requestNote'],
                          },
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: AppColors.card,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(15.sp),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            // ── Header row ──────────────────────
                            Row(
                              children: [
                                Container(
                                  width: 50.w,
                                  height: 50.h,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(4.r),
                                    color: AppColors.background,
                                  ),
                                  child: Center(
                                    child: CustomSvg(
                                      assetPath: request["section"] ==
                                          "Personal Information"
                                          ? "assets/icons_settings_new/Personal Information.svg"
                                          : "assets/icons_settings_new/Health Insurance.svg",
                                      width: 30.w,
                                      height: 30.h,
                                      fit: BoxFit.fill,
                                      color: AppColors.text,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                Expanded(
                                  child: Text(
                                    request['title'] ?? 'Request',
                                    style: StyleText
                                        .fontSize14Weight500
                                        .copyWith(
                                        color: AppColors.text),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),

                            // ── Date ────────────────────────────
                            _infoRow(
                              icon: "assets/calender.svg",
                              label: "Request By: ",
                              value: _formatDate(
                                  request['dateRequested']),
                              lightMode: lightMode,
                            ),
                            SizedBox(height: 8.h),

                            // ── Job Title ───────────────────────
                            _infoRow(
                              icon: "assets/job_title.svg",
                              label:
                              "${S.of(context).jobTitle}: ",
                              value: FormatHelper.capitalize(
                                  jobTitle),
                              lightMode: lightMode,
                              ellipsis: true,
                            ),
                            SizedBox(height: 8.h),

                            // ── Department ──────────────────────
                            _infoRow(
                              icon: "assets/department.svg",
                              label:
                              "${S.of(context).department}: ",
                              value: FormatHelper.capitalize(
                                  department),
                              lightMode: lightMode,
                              ellipsis: true,
                            ),
                            SizedBox(height: 8.h),

                            // ── Status ──────────────────────────
                            Row(
                              children: [
                                CustomSvg(
                                  assetPath: "assets/status.svg",
                                  width: 14.w,
                                  height: 14.h,
                                  fit: BoxFit.scaleDown,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  "${S.of(context).status}: ",
                                  style: StyleText
                                      .fontSize12Weight400
                                      .copyWith(
                                      color: AppColors.text),
                                ),
                                Text(
                                  _getStatusLabel(status),
                                  style: StyleText
                                      .fontSize12Weight400
                                      .copyWith(
                                    color: statusColor,
                                    fontWeight: FontWeight.w600,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Reusable info row ───────────────────────────────────────────────────────
  Widget _infoRow({
    required String icon,
    required String label,
    required String value,
    required bool lightMode,
    bool ellipsis = false,
  }) {
    return Row(
      children: [
        CustomSvg(
          assetPath: icon,
          width: 14.w,
          height: 14.h,
          fit: BoxFit.scaleDown,
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: StyleText.fontSize12Weight400.copyWith(
              color:
              lightMode ? ColorAppLight.grayTextSla : ColorAppDark.titleKey),
        ),
        ellipsis
            ? Expanded(
          child: Text(
            value,
            style: StyleText.fontSize12Weight400.copyWith(
                color: lightMode
                    ? ColorAppLight.blackButton
                    : ColorAppDark.titleValue),
            overflow: TextOverflow.ellipsis,
          ),
        )
            : Text(
          value,
          style: StyleText.fontSize12Weight400.copyWith(
              color: lightMode
                  ? ColorAppLight.blackButton
                  : ColorAppDark.titleValue),
        ),
      ],
    );
  }

  Widget filterSection() {
    final s = S.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _statusChip("$totalRequests", s.all,
              isSelected: selectStatus == s.all,
              onTap: () {
                setState(() {
                  selectStatus = s.all;
                  _filterRequests();
                });
              },
              labelColor: Theme.of(context).brightness == Brightness.light
                  ? ColorAppLight.grayTextSla
                  : ColorAppDark.titleKey),
          _statusChip("$approvedCount", s.Approved,
              isSelected: selectStatus == s.Approved,
              onTap: () {
                setState(() {
                  selectStatus = s.Approved;
                  _filterRequests();
                });
              },
              labelColor: ColorAppLight.greenColor),
          _statusChip("$pendingCount", 'Pending',
              isSelected: selectStatus == 'Pending',
              onTap: () {
                setState(() {
                  selectStatus = 'Pending';
                  _filterRequests();
                });
              },
              labelColor: ColorAppLight.yellowColor),
          _statusChip("$rejectedCount", 'Rejected',
              isSelected: selectStatus == 'Rejected',
              onTap: () {
                setState(() {
                  selectStatus = 'Rejected';
                  _filterRequests();
                });
              },
              labelColor: Colors.red[500]!),
        ],
      ),
    );
  }

  Widget _statusChip(String count, String label,
      {required bool isSelected,
        required Color labelColor,
        required VoidCallback onTap}) {
    var light = Theme.of(context).brightness == Brightness.light;
    var isMobile = context.isPhone;

    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: isMobile ? 35.sp : 45.sp,
            height: isMobile ? 35.sp : 45.sp,
            decoration: BoxDecoration(
              color: light
                  ? isSelected
                  ? AppColors.primary
                  : ColorAppLight.whiteColor
                  : isSelected
                  ? AppColors.primary
                  : ColorAppDark.chatBackground,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Center(
              child: Text(
                count,
                style: isMobile
                    ? StyleText.fontSize14Weight400.copyWith(
                  color: light
                      ? isSelected
                      ? ColorAppLight.buttonTextColor
                      : ColorAppLight.grayTextSla
                      : isSelected
                      ? ColorAppLight.buttonTextColor
                      : ColorAppDark.titleKey,
                )
                    : StyleText.fontSize20Weight500.copyWith(
                  color: light
                      ? isSelected
                      ? ColorAppLight.buttonTextColor
                      : ColorAppLight.grayTextSla
                      : isSelected
                      ? ColorAppLight.buttonTextColor
                      : ColorAppDark.titleKey,
                ),
              ),
            ),
          ),
          SizedBox(width: 16.sp),
          SizedBox(
            child: Text(
              label,
              style: isMobile
                  ? StyleText.fontSize14Weight600.copyWith(color: labelColor)
                  : StyleText.fontSize16Weight600.copyWith(color: labelColor),
            ),
          ),
          SizedBox(width: 30.sp),
        ],
      ),
    );
  }
}
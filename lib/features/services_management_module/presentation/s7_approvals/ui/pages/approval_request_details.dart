/// ******************* FILE INFO *******************
/// File Name: approval_request_details.dart
/// Description: can see details of services before make approve or reject
/// Created by: Amr Mesbah
/// Last Update: 02/02/2026
/// ✅ UPDATED WITH CreateServicesHelper AND MainCore INTEGRATION
/// ✅ UPDATED WITH Comment Section Expand/Collapse Feature

import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/core/theme/new_theme.dart';
import 'package:demo_app/core/custom/32-custom_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import 'package:demo_app/core/custom/36-custom_comment_widget.dart';
import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/features/notification/data/models/notification_data_model.dart';
import 'package:demo_app/features/notification/data/repository/notification_services.dart';
import 'package:demo_app/features/notification/data/repository/notification_template_service.dart';
import 'package:demo_app/features/notification/notification_page_confg.dart';
import 'package:demo_app/core/network/get_base_url.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/features/department/presentation/controller/add_department_controller.dart';
import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
import 'package:demo_app/core/constants/services_management/constant.dart';
import 'package:demo_app/core/widgets/services_management/custom_botton.dart';
import 'package:demo_app/core/widgets/services_management/custom_dialog.dart';
import 'package:demo_app/core/helper/services_management/circle_progress.dart';
import 'package:demo_app/core/helper/services_management/format_helper.dart';
import 'package:demo_app/features/services_management_module/data/helper/services_helper_function.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/features/services_management_module/data/models/model_employee.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/features/services_management_module/presentation/controller/services_manager_cubit.dart';

import 'package:demo_app/core/custom/37-custom_navigate.dart';

import 'package:demo_app/core/widgets/services_management/W3_Frame_Screen_tablet.dart';
import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/ui/pages/dashboard_details_admin.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/ui/pages/select_services_provider_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/widgets/approvals.dart'
   ;
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/widgets/chat.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/widgets/provider_details.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/controller/create_services_helper.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/widgets/responsive_text.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/widgets/show_request_details_shimmer.dart';
import 'package:demo_app/features/services_management_module/presentation/s7_approvals/ui/pages/approval_request_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s7_approvals/ui/widgets/approval_details_shared_widgets.dart';

part 'approval_request_details.logic_a.dart';
part 'approval_request_details.logic_b.dart';
part 'approval_request_details.body_helpers.dart';
part 'approval_request_details.body_actions.dart';

class ApprovalDetailsScreen extends StatefulWidget {
  const ApprovalDetailsScreen({
    Key? key,
    required this.index,
    required this.approvalModel,
    this.fromTable = false,
    this.createServicesModel,
  }) : super(key: key);

  final ServicesHistoryModel approvalModel;
  final int index;
  final bool fromTable;
  final ServicesHistoryModel? createServicesModel;

  @override
  State<ApprovalDetailsScreen> createState() => _ApprovalDetailsScreenState();
}

class _ApprovalDetailsScreenState extends State<ApprovalDetailsScreen> {
  final TextEditingController rejectController = TextEditingController();
  final TextEditingController approveController = TextEditingController();
  late final MainCoreDepartmentController departmentController;
  late final MainCoreEmployeeController employeeController;
  final NotificationTemplateService _templateService = NotificationTemplateService();
  late ServicesHistoryModel _currentModel;

  // ✅ NEW: Track comment section expansion state
  bool isCommentSectionExpanded = false;

  // ✅ NEW: Service data from CreateServices
  String? serviceNameEnglish;
  String? serviceNameArabic;
  String? serviceDescriptionEnglish;
  String? serviceDescriptionArabic;
  String? serviceDuration;
  String? serviceDurationUnit;
  String? owningDepartment;


  final TextEditingController _controller = TextEditingController();
  bool isVisible = false;








  String saveIdUser = "";
  String stateLabel = 'Pending';
  String? cancelReason;



  String? currentState;
  bool isLoadingCommentReson = true;
  String rejectCommentText = '';
  String approveCommentText = '';

  @override
  void initState() {
    super.initState();
    _initialize();
    this.loadRequesterData();
    _currentModel = widget.approvalModel;
    this.fetchRequesterInfoFromFirestore();
    departmentController = Get.find<MainCoreDepartmentController>();
    employeeController = Get.find<MainCoreEmployeeController>();
    _loadServiceDataFromCreateServices();

    // ✅ ADD THIS: Refresh model from Firestore on load
    _refreshModelFromFirestore();
  }

  // ✅ NEW: Load service data from CreateServices collection
  // Find this section in the _loadServiceDataFromCreateServices() method:




  String? globalEmailRequester;
  String? globalFirstNameRequester;
  String? globalLastNameRequester;
  String? globalGenderRequester;
  String? globalPhoneRequester;
  String? globalJobTitleRequester;
  String? globalDepartmentRequester;


  String? requesterFirstNameEn;
  String? requesterLastNameEn;
  String? requesterJobTitleEn;
  String? requesterDepartment;
  String? requesterFirstNameAr;
  String? requesterLastNameAr;
  String? requesterJobTitleAr;






  TextEditingController searchController = TextEditingController();
  String? selectedStatus;
  List<String> selectedDepartmentKeys = [];
  bool showFilter = false;
  String selectStatus = "All";
  List<ServicesHistoryModel> filteredModel = [];
  List<ServicesHistoryModel> unsortedCurrent = [];
  List<ServicesHistoryModel> visibleApprovals = [];



  var employeeEntity = Get.find<MainCoreEmployeeController>().employeeEntity!;




  @override
  Widget build(BuildContext context) {
    var isTablet = context.isTablet;
    var lightMode = Theme.of(context).brightness == Brightness.light;

    final isDocStateFinalized =
    (currentState?.toLowerCase().trim().isNotEmpty ?? false);

    final hasPendingInApprovalCycle =
    widget.approvalModel.currentApprovalCycle.any(
          (e) => e.state?.toLowerCase() == 'pending',
    );

    if (isLoadingCommentReson) {
      return Container(
        color: AppColors.background,
        child: Center(
          child: CircleProgress(),
        ),
      );
    }

    final approvalCycle = widget.approvalModel.currentApprovalCycle;
    List<EmployeeEntityModell> displayCycle = _adjustCycleStates(approvalCycle);

    final docState = this.getOverallStatus();
    stateLabel = _getLabel(docState);
    Color borderColor = _getBorderColor(docState);
    String iconAsset = _getIconAsset(docState);

    final bool hasRejection = displayCycle.any(
          (e) =>
      e.state != null &&
          (e.state!.toLowerCase() == 'rejected' ||
              e.state!.toLowerCase() == 'cancel'),
    );

    if (docState == 'cancel') {
      stateLabel = _getLabel('cancel');
      borderColor = _getBorderColor('cancel');
      iconAsset = _getIconAsset('cancel');
    } else if (hasRejection) {
      final rejected = displayCycle.firstWhere(
            (e) =>
        e.state!.toLowerCase() == 'rejected' ||
            e.state!.toLowerCase() == 'cancel',
      );
      final s = rejected.state!.toLowerCase();
      stateLabel = _getLabel(s);
      borderColor = _getBorderColor(s);
      iconAsset = _getIconAsset(s);
    } else if (docState != 'inprogress' &&
        docState != 'done' &&
        docState != 'breached sla' &&
        displayCycle.every((e) => e.state?.toLowerCase() == 'approved')) {
      stateLabel = 'Approved';
      borderColor = AppColors.lightGreen;
      iconAsset = "assets/state/approved.svg";
    } else {
      final currentPending = displayCycle.indexWhere(
            (e) => e.state?.toLowerCase() == 'pending',
      );
      if (currentPending != -1) {
        stateLabel = 'Pending';
        borderColor = _getBorderColor('pending');
        iconAsset = _getIconAsset('pending');
      }
    }

    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final userEmail = employeeFunctionHelper.email?.toLowerCase();

    final myState = widget.approvalModel.currentApprovalCycle
        .firstWhere(
          (e) => e.email?.toLowerCase() == userEmail,
      orElse: () => EmployeeEntityModell(),
    )
        .state
        ?.toLowerCase();

    final isMobile = context.isPhone;
    final isLandscape = context.isLandscape;

    // ✅ Get display values (CreateServices data takes priority)
    final displayServiceNameEn = serviceNameEnglish ?? widget.approvalModel.currentServiceNameEnglish ?? '';
    final displayServiceNameAr = serviceNameArabic ?? widget.approvalModel.currentServiceNameArabic ?? '';
    final displayServiceDescEn = serviceDescriptionEnglish ?? widget.approvalModel.currentServiceDescriptionEnglish ?? '';
    final displayServiceDescAr = serviceDescriptionArabic ?? widget.approvalModel.currentServiceDescriptionArabic ?? '';

    final displayServiceName = isArabic ? displayServiceNameAr : displayServiceNameEn;
    final displayServiceDesc = isArabic ? displayServiceDescAr : displayServiceDescEn;

    // ✅ Get requester data from MainCore
    final requesterEmail = widget.approvalModel.currentEmailRequester ?? '';
    String requesterFullName = '-';
    String requesterJobTitle = '-';
    String requesterDepartmentName = '-';

    if (requesterEmail.isNotEmpty) {
      requesterFullName = employeeController.getEmployeeNameEnglishArabic(requesterEmail, !isArabic);

      final employee = employeeController.getLocaleEmployee(requesterEmail);
      if (employee != null) {
        requesterJobTitle = isArabic
            ? (employee.titleInArabic ?? employee.title ?? '-')
            : (employee.title ?? '-');

        if (employee.departmentId != null && employee.departmentId!.isNotEmpty) {
          requesterDepartmentName = isArabic
              ? (departmentController.getArabicDepartmentNameFromDepartmentId(departmentId: employee.departmentId!) ?? '-')
              : (departmentController.getEnglishDepartmentNameFromDepartmentId(departmentId: employee.departmentId!) ?? '-');
        }
      }
    }

    // ✅ Duration from CreateServices or fallback
    final displayDuration = serviceDuration ?? widget.approvalModel.currentDurationOfServices ?? '';
    final displayUnit = serviceDurationUnit ?? widget.approvalModel.currentSelectedDurationUnit ?? '';
    final localizedUnit = this.getLocalizedDurationUnit(displayUnit, isArabic, quantity: int.tryParse(displayDuration));
    final formattedDuration = '$displayDuration $localizedUnit';

    return Scaffold(
      body: SafeArea(
        child: SideFrameMasterServices(
          titleText: S.of(context).services,
          onFirstTap: () {
            Navigator.pop(context);
          },
          secondTitle: widget.fromTable
              ? FormatHelper.capitalize(displayServiceName)
              : S.of(context).approvals,
          onSecondTap: () {
            navigateTo(context, ApprovalToggle());
          },
          thirdTitle: widget.fromTable
              ? S.of(context).RequestedServicesDetails
              : FormatHelper.capitalize(displayServiceName),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                // ✅ CONDITIONAL: Show this section ONLY when comment section is NOT expanded
                if (!isCommentSectionExpanded) ...[
                  Row(
                    children: [
                      SizedBox(width: 3.sp),
                      Text(
                        S.of(context).approval_request_details,
                        style: AppTextStyles.font16BlackSemiBoldCairo
                            .copyWith(color: AppColors.text),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.sp),

                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: AppColors.card),
                        child: Column(
                          children: [
                            // First section photo & details
                            _buildServiceHeaderRow(
                              context,
                              isMobile: isMobile,
                              isArabic: isArabic,
                              displayServiceNameAr: displayServiceNameAr,
                              displayServiceNameEn: displayServiceNameEn,
                              displayServiceDesc: displayServiceDesc,
                            ),

                            SizedBox(height: 20.h),

                            isMobile ? this.descriptionWidget(displayServiceDesc) : SizedBox(),
                            isMobile ? SizedBox(height: 20.sp) : SizedBox(),

                            // Provider Section
                            _buildProviderSection(context),

                            SizedBox(height: 29.sp),

                            // Requester Details title
                            Row(
                              children: [
                                Text(
                                  S.of(context).RequesterDetails,
                                  style: AppTextStyles.font16BlackMediumCairo.copyWith(
                                    color: AppColors.text,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 10.sp),

                            // Requester services info
                            this.buildRequesterDetailsSection(
                              context,
                              firstName: requesterFullName.split(' ').first,
                              lastName: requesterFullName.split(' ').skip(1).join(' '),
                              jobTitle: requesterJobTitle,
                              department: requesterDepartmentName,
                            ),

                            SizedBox(height: 20.h),

                            // Approval Cycle Title
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "${S.of(context).approvalCycle}: ",
                                  style: AppTextStyles.font14BlackCairoRegular.copyWith(
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                              ],
                            ),

                            isMobile ? SizedBox() : SizedBox(height: 15.h),

                            // Approval Cycle item
                            widget.approvalModel.currentApprovalCycle.isEmpty
                                ? SizedBox()
                                : isMobile
                                ? buildApprovalCycleMyRequest(
                              context,
                              false,
                              [],
                              _adjustCycleStates(widget
                                  .approvalModel.currentApprovalCycle),
                            )
                                : Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                approvalCycleViewLogic(
                                  context,
                                  _adjustCycleStates(widget
                                      .approvalModel.currentApprovalCycle),
                                ),
                              ],
                            ),

                            ..._buildCommentReasons(context),

                            SizedBox(height: 20.h),

                            _buildApprovalActions(context, myState, displayServiceName),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.sp),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "${S.of(context).requestDate}: ",
                              style: isMobile
                                  ? AppTextStyles.font10BlackCairoRegular.copyWith(
                                color: AppColors.secondaryText,
                              )
                                  : AppTextStyles.font12BlackCairoRegular.copyWith(
                                color: AppColors.secondaryText,
                              ),
                            ),
                            Text(
                              DateFormat('dd MMM yyyy').format(
                                DateTime.now(),
                              ),
                              style: isMobile
                                  ? AppTextStyles.font10BlackCairoRegular.copyWith(
                                color: AppColors.text,
                              )
                                  : AppTextStyles.font12BlackCairoRegular.copyWith(
                                color: AppColors.text,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: 20.sp),
                ],

                // ✅ COMMENT SECTION - Always visible
                UniversalCommentSection(
                  isExpandable: true,
                  collectionPath: 'Demo/75440689/Comments',
                  filterFields: {
                    'Request_Id': widget.approvalModel.currentId,
                  },
                  currentUserId: Get.find<MainCoreEmployeeController>()
                      .employeeEntity!
                      .email!,
                  fixedHeight: isCommentSectionExpanded ? null : 400.h,
                  onExpandChanged: (bool expanded) {
                    // ✅ Update state when expansion changes
                    setState(() {
                      isCommentSectionExpanded = expanded;
                    });
                  },
                  style: CommentSectionStyle(
                    hintStyle: AppTextStyles.font16BlackRegularCairo.copyWith(
                        color: AppColors.secondaryText.withOpacity(.5)),
                    commentTextStyle: AppTextStyles.font18BlackMediumCairo
                        .copyWith(color: AppColors.text),
                    fileChipDecoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    fileIconColor: AppColors.text,
                    fileNameStyle: AppTextStyles.font12BlackCairoRegular
                        .copyWith(color: AppColors.text),
                    avatarColor: AppColors.background,
                    inputFillColor: AppColors.card,
                    containerDecoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    commentItemDecoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8.r)),
                    userNameStyle: AppTextStyles.font16BlackRegularCairo.copyWith(
                      color: AppColors.text,
                    ),
                    sendButtonDecoration: BoxDecoration(
                      color: AppColors.secondaryPrimary,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    sendIconColor: AppColors.secondaryPrimaryText,
                  ),
                ),

                SizedBox(height: 20.sp),
              ],
            ),
          ),
        ),
      ),
    );
  }




}

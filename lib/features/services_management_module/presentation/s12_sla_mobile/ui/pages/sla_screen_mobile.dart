/// ******************* FILE INFO *******************
/// File Name: sla_notification_data.dart
/// Description: can select all info which need to handle notification
/// Created by: Amr Mesbah
/// Last Update: 30/8/2025

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/core/custom/2-custom_textfield.dart';
import 'package:demo_app/features/services_management_module/presentation/s1_home_page_services/ui/pages/home_page_services_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s1_home_page_services/ui/widgets/shared_prefs.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:demo_app/core/widgets/custom_check_box.dart';
import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/utils/shared.dart';
import 'package:demo_app/features/services_management_module/data/helper/services_prefs_employee.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/widgets/services_management/custom_textformfield.dart';
import 'package:demo_app/core/helper/services_management/format_helper.dart';
import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/features/services_management_module/data/models/model_employee.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/features/services_management_module/presentation/controller/services_manager_cubit.dart';
import 'package:demo_app/core/custom/37-custom_navigate.dart';

class SlaScreenMobile extends StatefulWidget {
  const SlaScreenMobile({super.key, this.editingModel});

  final ServicesHistoryModel? editingModel;

  @override
  State<SlaScreenMobile> createState() => _SlaScreenMobileState();
}

class _SlaScreenMobileState extends State<SlaScreenMobile> {
  final TextEditingController _providerPercentageController =
      TextEditingController();
  final TextEditingController _managerPercentageController =
      TextEditingController();

  bool _showProviderPercentageError = false;
  bool _showManagerPercentageError = false;

  Map<String, bool> _providerSwitches = {
    'When Service Requested And Approved': false,
    'When Service Status Changes': false,
  };

  Map<String, bool> _sectionCheckboxes = {
    'Notify Service Requester': true,
    'Notify Service Provider': true,
    'Notify Provider Manager': true,
  };

  String? formatDate;

  @override
  void initState() {
    super.initState();

    final rawJson = ServicesManagerCubit.get(context).docServiceRawJson;

    if (rawJson != null) {
      SharedPrefsHelper.setBool('sla_switch', rawJson['branchSLA'] ?? false);
      SharedPrefsHelper.setBool(
          'inquiry_switch', rawJson['allowInquiries'] ?? false);
      SharedPrefsHelper.setBool(
          'comments_switch', rawJson['allowComments'] ?? false);
      SharedPrefsHelper.setString('percentage', rawJson['percentage'] ?? '');
      SharedPrefsHelper.setStringList(
        'notifications',
        (rawJson['notifications'] as List?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
      );
    }

    final dateTime = Timestamp.now().toDate();
    formatDate = DateFormat("MMMdd_yyyy").format(dateTime);

    _loadFromModel();
  }

  bool _isInteger(String value) {
    return int.tryParse(value) != null;
  }

  @override
  void dispose() {
    _providerPercentageController.dispose();
    _managerPercentageController.dispose();
    super.dispose();
  }

  Future<void> _loadFromModel() async {
    final model = ServicesManagerCubit.get(context).docService;
    setState(() {
      // ✅ UPDATED: Access .current from FieldHistory
      _providerPercentageController.text =
          model?.currentSlaOneControllerEnglish ?? '';
      _managerPercentageController.text =
          model?.currentSlaTwoControllerEnglish ?? '';
      _sectionCheckboxes['Notify Service Requester'] =
          model?.currentNotifyRequesterChecked ?? true;
      _sectionCheckboxes['Notify Service Provider'] =
          model?.currentNotifyProviderChecked ?? true;
      _sectionCheckboxes['Notify Provider Manager'] =
          model?.currentNotifyManagerChecked ?? true;
      _providerSwitches['When Service Requested And Approved'] =
          model?.currentNotifyRequesterSwitch0 ?? false;
      _providerSwitches['When Service Status Changes'] =
          model?.currentNotifyManagerSwitch1 ?? false;
    });
  }

  Future<ServicesHistoryModel> createModelFromSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final isActive = prefs.getBool('service_status') ?? true;
    // ✅ UPDATED: Use ServicesModel.createNew()
    return ServicesHistoryModel.createNew(
      id: '',
      state: 'draft',
      status: isActive ? 'active' : 'inactive',  // ✅ FIX
      //      serviceNameEnglish: prefs.getString('service_name_en') ?? '',
      serviceNameArabic: prefs.getString('service_name_ar') ?? '',
      serviceDescriptionEnglish:
          prefs.getString('service_description_en') ?? '',
      serviceDescriptionArabic: prefs.getString('service_description_ar') ?? '',
      durationOfServices: prefs.getString('duration_value') ?? '',
      selectedDurationUnit: prefs.getString('duration_unit') ?? '',
      providerServices: await SharedPrefsEmployeeHelper.getSelectedEmployees(),
    );
  }

  Future<void> _submitAllToSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('sla_one', _providerPercentageController.text);
    await prefs.setString('sla_two', _managerPercentageController.text);

    await prefs.setBool('Notify Service Requester_checked',
        _sectionCheckboxes['Notify Service Requester'] ?? true);
    await prefs.setBool('Notify Service Provider_checked',
        _sectionCheckboxes['Notify Service Provider'] ?? true);
    await prefs.setBool('Notify Provider Manager_checked',
        _sectionCheckboxes['Notify Provider Manager'] ?? true);

    await prefs.setBool('Notify Service Requester_switch_0',
        _providerSwitches['When Service Requested And Approved'] ?? false);
    await prefs.setBool('Notify Provider Manager_switch_1',
        _providerSwitches['When Service Status Changes'] ?? false);

    final modelServicesModel = await createModelFromSharedPrefs();

    // ✅ UPDATED: Access .current from FieldHistory
    final docId = widget.editingModel?.currentId ??
        "User${Random().nextInt(100)}${DateFormat("MMMdd_yyyy").format(Timestamp.now().toDate())}";

    final isEdit = widget.editingModel != null;

    if (isEdit) {
      await ServicesManagerCubit.get(context)
          .updateService(docId, modelServicesModel);
    } else {
      await ServicesManagerCubit.get(context)
          .saveService(docId, modelServicesModel);
    }
  }

  Future<void> _createService() async {
    final prefs = await SharedPreferences.getInstance();
    final isEdit = widget.editingModel != null;

    // ✅ UPDATED: Access .current from FieldHistory
    final oldDocId = widget.editingModel?.currentId ?? '';
    final formattedDate =
        DateFormat("MMMdd_yyyy").format(Timestamp.now().toDate());
    final randomId = Random().nextInt(100);
    final hasUserPrefix = oldDocId.startsWith('User');
    final docId =
        isEdit && hasUserPrefix ? oldDocId : "User${randomId}${formattedDate}";
    final isActive = prefs.getBool('service_status') ?? true;
    // ✅ UPDATED: Use ServicesModel.createNew()
    final model = ServicesHistoryModel.createNew(
      id: docId,
      state: isActive ? 'active' : 'inactive',    // ✅ FIX
      status: isActive ? 'active' : 'inactive',   // ✅ FIX
      serviceNameEnglish:
          await SharedPrefsHelper.getString("service_name_en") ?? '',
      serviceNameArabic:
          await SharedPrefsHelper.getString("service_name_ar") ?? '',
      serviceDescriptionEnglish:
          await SharedPrefsHelper.getString("service_description_en") ?? '',
      serviceDescriptionArabic:
          await SharedPrefsHelper.getString("service_description_ar") ?? '',
      durationOfServices:
          await SharedPrefsHelper.getString("duration_value") ?? '',
      selectedDurationUnit:
          await SharedPrefsHelper.getString("duration_unit") ?? '',
      selectDepartment: await SharedPrefsDepartmentsHelper.getDepartments(),
      limitAvailability:
          await SharedPrefsHelper.getBool("limit_availability") ?? false,
      requireApproval:
          await SharedPrefsHelper.getBool("require_approval") ?? false,
      providerServices: await SharedPrefsEmployeeHelper.getSelectedEmployees(),
      approvalCycle: await SharedPrefsApprovalHelper.getApprovalCycle(),
      notifyManagerChecked:
          prefs.getBool('Notify Provider Manager_checked') ?? true,
      notifyProviderChecked:
          prefs.getBool('Notify Service Provider_checked') ?? true,
      notifyRequesterChecked:
          prefs.getBool('Notify Service Requester_checked') ?? true,
      notifyRequesterSwitch0:
          prefs.getBool('Notify Service Requester_switch_0') ?? false,
      notifyManagerSwitch1:
          prefs.getBool('Notify Provider Manager_switch_1') ?? false,
      slaOneControllerEnglish: prefs.getString('sla_one') ?? '',
      imageUrl: await SharedPrefsHelper.getString("service_image_url") ?? '',
      slaTwoControllerEnglish: prefs.getString('sla_two') ?? '',
      departmentRequester: prefs.getString("departmentRequester") ?? '',
      emailRequester: prefs.getString("emailRequester") ?? '',
      firstNameRequester: prefs.getString("firstNameRequester") ?? '',
      lastNameRequester: prefs.getString("lastNameRequester") ?? '',
      genderRequester: prefs.getString("genderRequester") ?? '',
      phoneRequester: prefs.getString("phoneRequester") ?? '',
      jobTitleRequester: prefs.getString("jobTitleRequester") ?? '',
      firstNameRequesterArabic:
          prefs.getString("firstNameRequesterArabic") ?? '',
      lastNameRequesterArabic: prefs.getString("lastNameRequesterArabic") ?? '',
      jobTitleRequesterArabic: prefs.getString("jobTitleRequesterArabic") ?? '',
    );

    // ✅ UPDATED: Access .current from FieldHistory
    final serviceCall =
        isEdit && widget.editingModel!.currentState == "submitted"
            ? ServicesManagerCubit.get(context).updateService(docId, model)
            : ServicesManagerCubit.get(context).saveService(docId, model);

    await serviceCall;

    // ✅ UPDATED: Access .current from FieldHistory
    if (widget.editingModel?.currentId != null) {
      await SharedPrefsServiceMaster.removeDraftById(
          widget.editingModel!.currentId);
    }

    ServicesManagerCubit.get(context).getAllServices();
    _showSuccessDialog(context);
  }

  void _handleSubmit() async {
    final navCtxStable = context;

    await _createService();

    await _showSuccessDialog(navCtxStable);
  }

  Future<void> _showSuccessDialog(BuildContext context) async {
    final navCtxStable = context;
    bool closed = false;
    final isEditMode = widget.editingModel != null;

    await showDialog(
      context: navCtxStable,
      barrierDismissible: true,
      builder: (successDialogContext) {
        Future.delayed(const Duration(seconds: 2), () {
          if (!closed) {
            closed = true;
            Navigator.of(navCtxStable, rootNavigator: true).pop();
            navigateAndFinish(navCtxStable, LayoutScreenServices());
          }
        });

        return Dialog(
          backgroundColor: AppColors.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.r),
            child: SizedBox(
              width: 410.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    'assets/lottie/approved.json',
                    width: 70.w,
                    height: 70.h,
                    fit: BoxFit.scaleDown,
                    repeat: true,
                    animate: true,
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    isEditMode
                        ? S.of(successDialogContext).editSuccess
                        : S.of(successDialogContext).createSuccess,

                    style: AppTextStyles.font20BlackCairoMedium.copyWith(
                      color: AppColors.text,
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    isEditMode
                        ? S.of(successDialogContext).YouSuccessfullyEditedThisService
                        : S.of(successDialogContext).YouSuccessfullyCreatedThisService,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.font14BlackCairoMedium.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showConfirmDialog() {
    final navCtxStable = context;
    final isEditMode = widget.editingModel != null;

    showDialog(
      context: navCtxStable,
      barrierDismissible: false,
      builder: (confirmDialogContext) => Dialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: Container(
          width: 300.sp,
          padding: EdgeInsets.all(20.sp),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                isEditMode
                    ? 'assets/lottie/createServices.json'  // Use different animation for edit mode if available
                    : 'assets/lottie/createServices.json',
                width: 70.w,
                height: 70.h,
                fit: BoxFit.scaleDown,
                repeat: true,
                animate: true,
              ),
              SizedBox(height: 20.sp),
              Text(
                isEditMode
                    ? S.of(confirmDialogContext).editingService  // You'll need to add this to your localization
                    : S.of(confirmDialogContext).creatingService,
                style: AppTextStyles.font20BlackCairoMedium.copyWith(
                  color: AppColors.text,
                ),
              ),
              SizedBox(height: 18.sp),
              Text(
                isEditMode
                    ? S.of(confirmDialogContext).areYouSureEditService  // You'll need to add this to your localization
                    : S.of(confirmDialogContext).areYouSureCreateService,
                textAlign: TextAlign.center,
                style: AppTextStyles.font14BlackCairoMedium.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
              SizedBox(height: 15.sp),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          Navigator.of(navCtxStable, rootNavigator: true).pop(),
                      child: Container(
                        height: 38.sp,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.grey,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          S.of(confirmDialogContext).no,
                          style: AppTextStyles.font16BlackMediumCairo
                              .copyWith(color: AppColors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 28.sp),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        try {
                          ServicesManagerCubit.get(navCtxStable)
                              .getAllServices();

                          Navigator.of(navCtxStable, rootNavigator: true).pop();

                          _handleSubmit();
                        } catch (e, st) {
                          if (Navigator.of(navCtxStable, rootNavigator: true)
                              .canPop()) {
                            Navigator.of(navCtxStable, rootNavigator: true)
                                .pop();
                          }
                        }
                      },
                      child: Container(
                        height: 38.sp,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          S.of(confirmDialogContext).yes,
                          style: AppTextStyles.font16BlackMediumCairo.copyWith(
                            color: AppColors.textButton,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextEditingController controller1 = TextEditingController();

  final Map<int, bool> _providerSwitchStates = {};
  bool _hasTyped = false;

  bool isNumericOnly(String text) {
    final numericRegex = RegExp(r'^\d+$');
    return numericRegex.hasMatch(text);
  }

  Map<int, bool> switchStates = {};

  List<TextEditingController> notifyProviderControllers = [];
  List<TextEditingController> notifyManagerControllers = [];
  final Map<String, List<TextEditingController>> notificationControllers = {};

  List<TextEditingController> dynamicSlaControllers = [TextEditingController()];
  List<TextEditingController> dynamicSlaTwoControllers = [
    TextEditingController()
  ];

  @override
  Widget build(BuildContext context) {
    var lightMode = Theme.of(context).brightness == Brightness.light;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor:
        AppColors.background,
        statusBarIconBrightness: lightMode ? Brightness.dark : Brightness.light,
        statusBarBrightness: lightMode ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor:AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 15.sp),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Transform(
                          alignment: Alignment.center,
                          transform:
                              Localizations.localeOf(context).languageCode ==
                                      'ar'
                                  ? Matrix4.rotationY(3.1416)
                                  : Matrix4.identity(),
                          child: SvgPicture.asset(
                            "assets/arrowleft.svg",
                            width: 18.sp,
                            height: 18.sp,
                            fit: BoxFit.cover,
                            color: AppColors.text,
                            semanticsLabel: 'Back Arrow',
                          ),
                        ),
                      ),
                      SizedBox(width: 16.sp),
                      Text(
                        // ✅ UPDATED: Access .current from FieldHistory
                        widget.editingModel != null
                            ? "${S.of(context).Editing} ${Localizations.localeOf(context).languageCode == 'ar' ? widget.editingModel!.currentServiceNameArabic : widget.editingModel!.currentServiceNameEnglish}"
                            : S.of(context).creatingNewService,
                        style: AppTextStyles.font20BlackSemiBoldCairo.copyWith(
                          color: AppColors.text,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.sp),
                  Container(
                    padding: EdgeInsets.only(left: 15.sp, right: 15.sp),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.sp),
                        Text(
                          FormatHelper.capitalize(
                              S.of(context).ServiceFulfillment),
                          style: AppTextStyles.font18BlackMediumCairo.copyWith(
                            color: AppColors.text,
                          ),
                        ),
                        SizedBox(height: 20.sp),
                        Text(
                          FormatHelper.capitalize(
                              S.of(context).SendNotifications),
                          style: AppTextStyles.font14BlackCairoMedium.copyWith(
                            color: AppColors.text,
                          ),
                        ),
                        SizedBox(height: 29.sp),
                        _buildSection(
                          title: S.of(context).notifyServiceRequester,
                          items: [
                            S.of(context).WhenTheirManagerApprovesTheService,
                            S.of(context).whenServiceStatusChanges,
                            S
                                .of(context)
                                .whenTheyReceiveCommentFromServiceProvider,
                            S.of(context).whenSlaIsBreached,
                          ],
                        ),
                        _buildSection(
                          title: S.of(context).notifyServiceProvider,
                          items: [
                            S
                                .of(context)
                                .WhenServiceIsRequestedAndApprovedByTheRequester,
                            S.of(context).whenTheyReceiveCommentFromRequester,
                            S.of(context).whenSlaIsBreached,
                          ],
                          showSLA: true,
                          controller: _providerPercentageController,
                          showError: _showProviderPercentageError,
                          onChanged: (value) {
                            setState(() {
                              _showProviderPercentageError = !_isInteger(value);
                            });
                          },
                        ),
                        _buildSectionTwo(
                          title: S.of(context).notifyProviderManager,
                          items: [S.of(context).whenProviderBreachedSla],
                          showSLA: true,
                          switchStates: _providerSwitchStates,
                          onToggleIndexSwitch: (index, value) {
                            setState(() {
                              _providerSwitchStates[index] = value;
                            });
                          },
                          switches: _providerSwitches,
                          onToggleSwitch: (key, value) {
                            setState(() {
                              _providerSwitches[key] = value;
                            });
                          },
                          controller: _managerPercentageController,
                          showError: _showManagerPercentageError,
                          onChanged: (value) {
                            setState(() {
                              _showManagerPercentageError = !_isInteger(value);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.sp),

                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (widget.editingModel != null) {
                              // ✅ Edit mode: Discard = just go back
                              Navigator.pop(context);
                            } else {
                              // ✅ Create mode: Save for later
                              saveDraft();
                            }
                          },
                          child: Container(
                            height: 38.sp,
                            decoration: BoxDecoration(
                              color: AppColors.secondaryButton,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              widget.editingModel != null
                                  ? S.of(context).discard
                                  : S.of(context).saveForLater,
                              style: AppTextStyles.font16BlackMediumCairo
                                  .copyWith(color: AppColors.black),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 75.sp),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _showConfirmDialog(),
                          child: Container(
                            height: 38.sp,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              widget.editingModel != null
                                  ? S.of(context).update
                                  : S.of(context).submit,
                              style: AppTextStyles.font16BlackMediumCairo.copyWith(
                                color: AppColors.textButton,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveDraft() async {
    await _submitAllToSharedPrefs();

    final nameEn = await SharedPrefsHelper.getString('service_name_en');
    final nameAr = await SharedPrefsHelper.getString('service_name_ar');
    final descEn = await SharedPrefsHelper.getString('service_description_en');
    final descAr = await SharedPrefsHelper.getString('service_description_ar');
    final durationVal = await SharedPrefsHelper.getString('duration_value');
    final durationUnit = await SharedPrefsHelper.getString('duration_unit');
    final slaOne = await SharedPrefsHelper.getString('sla_one');
    final slaTwo = await SharedPrefsHelper.getString('sla_two');
    final selectedProviders =
        await SharedPrefsEmployeeHelper.getSelectedEmployees();
    final selectedDepartments =
        await SharedPrefsDepartmentsHelper.getDepartments();
    final selectedEmployees =
        await SharedPrefsApprovalHelper.getApprovalCycle();

    // ✅ UPDATED: Use ServicesModel.createNew()
    final model = ServicesHistoryModel.createNew(
      id: '',
      state: "draft",
      status: "draft",
      serviceNameEnglish: nameEn ?? '',
      serviceNameArabic: nameAr ?? '',
      serviceDescriptionEnglish: descEn ?? '',
      serviceDescriptionArabic: descAr ?? '',
      durationOfServices: durationVal ?? '',
      selectedDurationUnit: durationUnit ?? '',
      providerServices: selectedProviders,
      selectDepartment: selectedDepartments,
      approvalCycle: selectedEmployees
          .cast<EmployeeEntityModell>()
          .map((e) => EmployeeEntityModell(
                id: e.id ?? '',
                state: "pending",
                firstName: e.firstName,
                middleName: e.middleName,
                lastName: e.lastName,
                email: e.email,
                gender: e.gender,
                title: e.title,
              ))
          .toList(),
      slaOneControllerEnglish: slaOne ?? '',
      slaTwoControllerEnglish: slaTwo ?? '',
      notifyRequesterChecked:
          _sectionCheckboxes['Notify Service Requester'] ?? true,
      notifyProviderChecked:
          _sectionCheckboxes['Notify Service Provider'] ?? true,
      notifyManagerChecked:
          _sectionCheckboxes['Notify Provider Manager'] ?? true,
      notifyRequesterSwitch0:
          _providerSwitches['When Service Requested And Approved'] ?? false,
      notifyManagerSwitch1:
          _providerSwitches['When Service Status Changes'] ?? false,
    );

    // ✅ UPDATED: Access .current from FieldHistory
    if (widget.editingModel != null && widget.editingModel!.currentId != null) {
      final updatedDraft = model.copyWith(id: widget.editingModel!.currentId);
      await SharedPrefsServiceMaster.updateDraft(updatedDraft, updatedDraft);
    } else {
      await SharedPrefsServiceMaster.saveDraft(model);
    }

    await _showSuccessDialog(context);
  }

  Widget _buildSectionTwo({
    required String title,
    required List<String> items,
    bool showSLA = false,
    bool showSwitch = false,
    TextEditingController? controller,
    bool showError = false,
    void Function(String)? onChanged,
    Map<String, bool>? switches,
    required Map<int, bool> switchStates,
    void Function(String, bool)? onToggleSwitch,
    required void Function(int, bool) onToggleIndexSwitch,
  }) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isChecked = _sectionCheckboxes[title] ?? true;
    final lightMode = Theme.of(context).brightness == Brightness.light;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => _sectionCheckboxes[title] = !isChecked),
          child: Row(
            children: [
              SvgPicture.asset(
                isChecked
                    ? 'assets/checkbox_fill.svg'
                    : "assets/state/unselectedSvg.svg",
                width: 20.sp,
                height: 20.sp,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 8.sp),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.font14BlackCairoMedium.copyWith(
                    color: AppColors.text,
                  ),
                ),
              ),
            ],
          ),
        ),
        ...items.map((item) {
          final itemChecked = switches?[item] ?? false;
          return Padding(
            padding: EdgeInsets.only(left: 30.sp, top: 6.sp, right: 30.sp),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• $item',
                  style: AppTextStyles.font10BlackCairoRegular.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                const Spacer(),
                if (switches != null && switches.containsKey(item))
                  GestureDetector(
                    onTap: () => onToggleSwitch?.call(item, !itemChecked),
                    child: SvgPicture.asset(
                      itemChecked
                          ? 'assets/checkbox_fill.svg'
                          : 'assets/checkbox.svg',
                      width: 22.sp,
                      height: 22.sp,
                      fit: BoxFit.contain,
                    ),
                  ),
              ],
            ),
          );
        }),
        if (showSLA) ...[
          Padding(
            padding: EdgeInsets.only(
                left: isArabic ? 0 : 26.sp,
                top: 15.sp,
                right: isArabic ? 26.sp : 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  FormatHelper.capitalize(
                      S.of(context).WhenServiceRequestedAndApproved),
                  style: AppTextStyles.font10BlackCairoRegular.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Text(
                      S.of(context).ManagerIfItRequiresApproval,
                      style: AppTextStyles.font10BlackCairoRegular.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                    SizedBox(width: 10.sp),
                    GestureDetector(
                      onTap: () => onToggleSwitch?.call(
                        S.of(context).WhenServiceRequestedAndApproved,
                        !(switches?[S
                                .of(context)
                                .WhenServiceRequestedAndApproved] ??
                            false),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 0.sp),
                        child: FlutterSwitch(
                          activeColor: AppColors.primary,
                          height: 22.sp,
                          padding: 3.sp,
                          width: 38.sp,
                          borderRadius: 20.sp,
                          toggleSize: 16.sp,
                          inactiveColor: Color(0xFF787880).withOpacity(0.16),
                          value: switchStates[0] ?? false,
                          onToggle: (val) {
                            setState(() {
                              switchStates[0] = val;
                            });
                            onToggleIndexSwitch(0, val);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.only(left: 26.sp, right: 29.sp),
            child: Row(
              children: [
                Text(
                  FormatHelper.capitalize(
                      S.of(context).whenServiceStatusChanges),
                  style: AppTextStyles.font10BlackCairoRegular.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                SizedBox(width: 10.sp),
                GestureDetector(
                  onTap: () => onToggleSwitch?.call(
                    FormatHelper.capitalize(
                        "When Service SLA Is About To Be Breached"),
                    !(switches?[FormatHelper.capitalize(
                            "When Service SLA Is About To Be Breached")] ??
                        false),
                  ),
                  child: FlutterSwitch(
                    activeColor: AppColors.secondaryPrimary,
                    height: 22.sp,
                    padding: 3.sp,
                    width: 38.sp,
                    borderRadius: 20.sp,
                    toggleSize: 16.sp,
                    inactiveColor: Color(0xFF787880).withOpacity(0.16),
                    value: switchStates[1] ?? false,
                    onToggle: (val) {
                      setState(() {
                        switchStates[1] = val;
                      });
                      onToggleIndexSwitch(1, val);
                    },
                  ),
                ),
              ],
            ),
          ),
          for (int i = 0; i < dynamicSlaControllers.length; i++)
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                if (i != 0)
                  Padding(
                    padding: EdgeInsets.only(bottom: 6.5.sp),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          dynamicSlaControllers.removeAt(i);
                        });
                      },
                      child: Container(
                        width: 16.sp,
                        height: 16.sp,
                        decoration: BoxDecoration(
                          color: AppColors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                            child: Icon(Icons.remove,
                                size: 14.sp, color: AppColors.white)),
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.only(
                      left: isArabic ? 0 : 24.sp,
                      top: 8.h,
                      right: isArabic ? 24.sp : 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${S.of(context).whenServiceSlaIsAboutToBeBreached}",
                        style: TextStyle(
                          fontSize: isArabic ? 10.sp : 8.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                      ),
                      SizedBox(width: 8.sp),
                      CustomTextField(
                        onlyDigits: true,
                        width: 100.w,
                        hint: S.of(context).EnterPercentage,

                        fillColor:AppColors.background,
                        controller: dynamicSlaControllers[i],
                        onChanged: (_) => setState(() {}),
                        height: 28.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text('%',
                          style: AppTextStyles.font12BlackCairoRegular.copyWith(
                            color: AppColors.text,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          SizedBox(height: 10.sp),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.sp),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  dynamicSlaControllers.add(TextEditingController());
                });
              },
              child: Container(
                width: 104.sp,
                height: 28.sp,
                padding:
                    EdgeInsets.symmetric(vertical: 6.sp, horizontal: 7.5.sp),
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      child: SvgPicture.asset(
                        "assets/plus.svg",
                        width: 12.sp,
                        height: 12.sp,
                        fit: BoxFit.scaleDown,
                        semanticsLabel: 'Dart Logo',
                      ),
                    ),
                    SizedBox(width: 8.sp),
                    Text(
                      FormatHelper.capitalize(S.of(context).notifications),
                      style: AppTextStyles.font12BlackMediumCairo
                          .copyWith(color: AppColors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        SizedBox(height: 20.sp),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<String> items,
    bool showSLA = false,
    TextEditingController? controller,
    bool showError = false,
    void Function(String)? onChanged,
    Map<String, bool>? switches,
    void Function(String, bool)? onToggleSwitch,
  }) {
    final isChecked = _sectionCheckboxes[title] ?? true;
    final lightMode = Theme.of(context).brightness == Brightness.light;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => _sectionCheckboxes[title] = !isChecked),
          child: Row(
            children: [
              CustomCheckBox(
                isSelected: isChecked,
                size: 20.sp,
              ),
              SizedBox(width: 6.sp),
              Expanded(
                child: Text(
                  FormatHelper.capitalize(title),
                  style: AppTextStyles.font14BlackCairoMedium.copyWith(
                    color: AppColors.text,
                  ),
                ),
              ),
            ],
          ),
        ),
        ...items.map((item) {
          final isItemChecked = switches?[item] ?? false;
          return Padding(
            padding: EdgeInsets.only(
                left: isArabic ? 0 : 30.sp,
                top: 0.sp,
                bottom: 7.sp,
                right: isArabic ? 30.sp : 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• $item',
                  style: AppTextStyles.font10BlackCairoRegular.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                const Spacer(),
                if (switches != null && switches.containsKey(item))
                  GestureDetector(
                    onTap: () => onToggleSwitch?.call(item, !isItemChecked),
                    child: SvgPicture.asset(
                      isItemChecked
                          ? 'assets/checkbox_fill.svg'
                          : 'assets/checkbox.svg',
                      width: 22.w,
                      height: 22.h,
                      fit: BoxFit.contain,
                    ),
                  ),
              ],
            ),
          );
        }),
        if (showSLA) ...[
          for (int i = 0; i < dynamicSlaTwoControllers.length; i++)
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                if (i != 0)
                  Padding(
                    padding: EdgeInsets.only(bottom: 6.5.sp),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          dynamicSlaTwoControllers.removeAt(i);
                        });
                      },
                      child: Container(
                        width: 16.sp,
                        height: 16.sp,
                        decoration: BoxDecoration(
                          color: AppColors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.remove,
                            size: 14.sp, color: AppColors.white),
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.only(
                      left: isArabic ? 0 : 25.sp,
                      top: 8.h,
                      right: isArabic ? 25.sp : 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${S.of(context).whenServiceSlaIsAboutToBeBreached}",
                        style: TextStyle(
                          fontSize: isArabic ? 10.sp : 8.sp,
                          fontWeight: FontWeight.w600,
                          color:AppColors.text,
                        ),
                      ),
                      SizedBox(width: 4.sp),
                      CustomTextField(
                        onlyDigits: true,
                        hint: S.of(context).EnterPercentage,
                        width: 102.w,
                        valueStyle: AppTextStyles.font14BlackCairoMedium.copyWith(
                          fontSize: 12.sp
                        ),
                        fillColor: AppColors.background,
                        controller: dynamicSlaTwoControllers[i],
                        onChanged: (_) => setState(() {}),
                        height: 28.sp,
                      ),
                      SizedBox(width: 4.sp),
                      Text(
                        '%',
                        style: AppTextStyles.font12BlackCairoRegular.copyWith(
                          color: AppColors.text,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          SizedBox(height: 10.sp),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.sp),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  dynamicSlaTwoControllers.add(TextEditingController());
                });
              },
              child: Container(
                width: 104.sp,
                height: 28.sp,
                padding:
                    EdgeInsets.symmetric(vertical: 6.sp, horizontal: 7.5.sp),
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      child: SvgPicture.asset(
                        "assets/plus.svg",
                        width: 12.sp,
                        height: 12.sp,
                        fit: BoxFit.scaleDown,
                        semanticsLabel: 'Dart Logo',
                      ),
                    ),
                    SizedBox(width: 8.sp),
                    Text(
                      FormatHelper.capitalize(S.of(context).notifications),
                      style: AppTextStyles.font12BlackMediumCairo.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        SizedBox(height: 20.h),
      ],
    );
  }
}

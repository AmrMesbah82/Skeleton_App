/// ******************* FILE INFO *******************
/// File Name: sla_screen_page_tablet.dart
/// Description: Main screen for SLA notification tablet view
/// Created by: Amr Mesbah
/// Last Update: 30/8/2025

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/services_management_module/presentation/s1_home_page_services/ui/pages/home_page_services_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s1_home_page_services/ui/widgets/shared_prefs.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/controller/sla_notification_state.dart';

import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/ui/widgets/dialogs.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/ui/widgets/notification_section.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/ui/widgets/sla_notification_widgets.dart';

import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/utils/shared.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/custom/2-custom_textfield.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';

import 'package:demo_app/core/widgets/services_management/custom_botton.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/features/services_management_module/presentation/controller/services_manager_cubit.dart';
import 'package:demo_app/core/custom/37-custom_navigate.dart';
import 'package:demo_app/core/widgets/services_management/W3_Frame_Screen_tablet.dart';

import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/ui/pages/details_switch_screen_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/controller/sla_notification_cubit.dart';

class SlaScreenPageTablet extends StatefulWidget {
  const SlaScreenPageTablet({super.key, this.editingModel});

  final ServicesHistoryModel? editingModel;

  @override
  State<SlaScreenPageTablet> createState() => _SlaScreenPageTabletState();
}

class _SlaScreenPageTabletState extends State<SlaScreenPageTablet> {
  late SlaNotificationCubit cubit;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();

    final rawJson = ServicesManagerCubit.get(context).docServiceRawJson;
    if (rawJson != null) {
      SharedPrefsHelper.setBool('sla_switch', rawJson['branchSLA'] ?? false);
      SharedPrefsHelper.setBool('inquiry_switch', rawJson['allowInquiries'] ?? false);
      SharedPrefsHelper.setBool('comments_switch', rawJson['allowComments'] ?? false);
      SharedPrefsHelper.setString('percentage', rawJson['percentage'] ?? '');
      SharedPrefsHelper.setStringList(
        'notifications',
        (rawJson['notifications'] as List?)?.map((e) => e.toString()).toList() ?? [],
      );
    }

    cubit = SlaNotificationCubit(
      submitSlaData: ServicesManagerCubit.get(context).submitSlaData,
      saveDraft: (model) async {
        // Implement save draft logic or call your existing method
        await SharedPrefsServiceMaster.saveDraft(model);
      },
    );

    cubit.initialize(widget.editingModel);
    _setupControllerListeners();
  }

  void _setupControllerListeners() {
    cubit.model.slaOneController.addListener(() {
      final v = cubit.model.slaOneController.text.trim();

      _debounceTimer?.cancel();
      _debounceTimer = Timer(Duration(milliseconds: 500), () {
        cubit.updateAndSaveModel();
        SharedPrefsHelper.setString('sla_one', v);
        setState(() {});
      });
    });

    cubit.model.slaTwoController.addListener(() {
      final v = cubit.model.slaTwoController.text.trim();

      _debounceTimer?.cancel();
      _debounceTimer = Timer(Duration(milliseconds: 500), () {
        cubit.updateAndSaveModel();
        SharedPrefsHelper.setString('sla_two', v);
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isMobile = context.isPhone;
    var lightMode = Theme.of(context).brightness == Brightness.light;

    final isDraft = widget.editingModel != null &&
        (widget.editingModel!.currentState == "draft" ||
            widget.editingModel!.currentDurationOfServices.isEmpty ||
            widget.editingModel!.currentDurationOfServices == "-");

    final isEditingSubmittedService = widget.editingModel != null &&
        widget.editingModel!.currentState != "submitted";
    final shouldShowSaveForLaterButton = !isEditingSubmittedService || isDraft;

    return BlocProvider.value(
      value: cubit,
      child: BlocListener<SlaNotificationCubit, SlaNotificationState>(
        listener: (context, state) {
          if (state is SlaNotificationValidationError) {
            SlaNotificationWidgets.showValidationError(context, state.message);
          } else if (state is SlaNotificationDraftSaved) {
            // ✅ Only shows for Save For Later
            showDraftSavedSuccessDialog(context);
          } else if (state is SlaNotificationSaved) {
            // ✅ Only shows for Submit
            showCreateServiceDialog(
              context,
              cubit.currentModel,
              cubit.model.notificationSwitches,
              cubit.model.notifyRequesterSwitch0,
              cubit.model.notifyManagerSwitch1,
            );
          }
        },
        child: BlocBuilder<SlaNotificationCubit, SlaNotificationState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: AppColors.background,
              body: SafeArea(
                child: SideFrameMasterServices(
                  titleText: S.of(context).service,
                  onFirstTap: () {
                    navigateTo(context, LayoutScreenServices());
                  },
                  secondTitle: widget.editingModel != null
                      ? isDraft
                      ? "${S.of(context).draft} ${Localizations.localeOf(context).languageCode == 'ar' ? widget.editingModel!.currentServiceNameArabic : widget.editingModel!.currentServiceNameEnglish}"
                      : "${S.of(context).Editing} ${Localizations.localeOf(context).languageCode == 'ar' ? widget.editingModel!.currentServiceNameArabic : widget.editingModel!.currentServiceNameEnglish}"
                      : S.of(context).creatingNewService,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              S.of(context).ServiceFulfillment,
                              style: AppTextStyles.font18BlackMediumCairo.copyWith(
                                color: lightMode
                                    ? AppColors.blackButton
                                    : AppColors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.sp),
                        SingleChildScrollView(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.sp),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10.sp),
                                  Text(
                                    S.of(context).SendNotifications,
                                    style: AppTextStyles.font14BlackCairoMedium.copyWith(
                                      color: lightMode
                                          ? AppColors.blackButton
                                          : AppColors.white,
                                    ),
                                  ),
                                  SizedBox(height: 28.sp),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      NotificationTile(
                                        title: S.of(context).notifyServiceRequester,
                                        isChecked: cubit.model.notifyRequesterChecked,
                                        onCheckboxChanged: (value) {
                                          setState(() {
                                            cubit.updateCheckbox('requester', value);
                                          });
                                          cubit.updateAndSaveModel();
                                          SharedPrefsHelper.setBool('Notify Service Requester_checked', value);
                                        },
                                        children: [
                                          S.of(context).whenManagerApprovesServiceIfRequired,
                                          S.of(context).whenServiceStattusChanges,
                                          S.of(context).whenTheyReceiveCommentFromServiceProvider,
                                          S.of(context).whenSlaIsBreached,
                                        ],
                                        onSwitchChanged: (map) {
                                          setState(() {
                                            cubit.updateNotificationSwitches(S.of(context).notifyServiceRequester, map);
                                          });
                                        },
                                        onSingleSwitchChanged: ({required index, required value, required title}) {
                                          final key = cubit.slug('${title}_switch_$index');
                                          cubit.updateAndSaveModel();
                                        },
                                      ),

                                      SizedBox(height: 15.h),
                                      NotificationTile(
                                        title: S.of(context).notifyServiceProvider,
                                        isChecked: cubit.model.notifyProviderChecked,
                                        onCheckboxChanged: (value) {
                                          setState(() {
                                            cubit.updateCheckbox('provider', value);
                                          });
                                          cubit.updateAndSaveModel();
                                          SharedPrefsHelper.setBool('Notify Service Provider_checked', value);
                                        },
                                        onCheckSlaData: () {
                                          if (cubit.hasProviderSlaData()) {
                                            SlaNotificationWidgets.showSlaValidationError(context, S.of(context).notifyServiceProvider);
                                          } else {
                                            setState(() {
                                              cubit.updateCheckbox('provider', false);
                                            });
                                            cubit.updateAndSaveModel();
                                            SharedPrefsHelper.setBool('Notify Service Provider_checked', false);
                                          }
                                        },
                                        children: [
                                          S.of(context).whenServicesRequestedAndApprovedIfRequired,
                                          S.of(context).whenTheyReceiveCommentFromRequester,
                                          S.of(context).whenServiceSlaIsBreached,
                                        ],
                                        onSwitchChanged: (map) {
                                          setState(() {
                                            cubit.updateNotificationSwitches(S.of(context).notifyServiceProvider, map);
                                          });
                                        },
                                        onSingleSwitchChanged: ({required index, required value, required title}) {
                                          final key = cubit.slug('${title}_switch_$index');
                                          cubit.updateAndSaveModel();
                                        },
                                      ),

                                      SizedBox(height: 15.sp),
                                      Padding(
                                        padding: EdgeInsets.only(left: isArabic ? 0 : 30.w, right: isArabic ? 30.w : 0),
                                        child: Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(top: 8.sp),
                                                      child: Text(
                                                        S.of(context).whenServiceSlaIsAboutToBeBreached,
                                                        style: AppTextStyles.font12BlackMediumCairo.copyWith(
                                                          color: lightMode ? AppColors.blackButton :
                                                          AppColors.white,
                                                          letterSpacing: .34,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10.sp),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SlaNotificationWidgets.slaRow(
                                                          context: context,
                                                          controller: cubit.model.slaOneController,
                                                          isInvalid: cubit.model.isInvalidNumber,
                                                          onChanged: (val) {
                                                            setState(() {
                                                              cubit.updateSlaOne(val);
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ...cubit.model.extraSlaControllers.asMap().entries.map((entry) {
                                            final index = entry.key;
                                            final controller = entry.value;

                                            final invalid = controller.text.trim().isNotEmpty &&
                                                (controller.text.contains('.') || controller.text.contains(',') ||
                                                    !RegExp(r'^\d+$').hasMatch(controller.text.trim()));

                                            return Padding(
                                              padding: EdgeInsets.only(left: isArabic ? 0 : 27.sp, bottom: 10.sp, right: isArabic ? 27.sp : 0),
                                              child: Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.only(top: 4.sp),
                                                            child: Text(
                                                              S.of(context).whenServiceSlaIsAboutToBeBreached,
                                                              style: AppTextStyles.font12BlackMediumCairo.copyWith(
                                                                color: lightMode ? AppColors.blackButton :
                                                                AppColors.white,
                                                                letterSpacing: .34,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 10.sp),
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              SizedBox(
                                                                width: 150.sp,
                                                                height: 28.sp,
                                                                child: CustomTextField(
                                                                  controller: controller,
                                                                  keyboardType: TextInputType.number,
                                                                  hint: S.of(context).EnterPercentage,
                                                                  fillColor: AppColors.background,
                                                                  borderRadius: BorderRadius.circular(4),
                                                                  contentPadding: EdgeInsets.symmetric(
                                                                    horizontal: 8.sp,
                                                                    vertical: 7.sp,
                                                                  ),
                                                                  valueStyle: TextStyle(fontSize: 10.sp, color: AppColors.text),
                                                                  hintStyle: AppTextStyles.font10BlackCairoRegular.copyWith(
                                                                    color: AppColors.secondaryText.withOpacity(.5),
                                                                  ),
                                                                  onChanged: (_) {
                                                                    setState(() {});
                                                                    final idxKey = cubit.slug('extraSlaList_$index');
                                                                    final val = controller.text.trim();

                                                                    Timer? debounceTimer;
                                                                    debounceTimer?.cancel();
                                                                    debounceTimer = Timer(Duration(milliseconds: 500), () {
                                                                      cubit.updateAndSaveModel();
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                              SizedBox(height: 3.sp),
                                                              AnimatedOpacity(
                                                                opacity: invalid ? 1.0 : 0.0,
                                                                duration: const Duration(milliseconds: 200),
                                                                child: Text(
                                                                  controller.text.contains('.') || controller.text.contains(',')
                                                                      ? (Localizations.localeOf(context).languageCode == 'ar'
                                                                      ? "الأرقام العشرية غير مسموحة"
                                                                      : "Decimals are not allowed")
                                                                      : S.of(context).Onlynumbersareallowed,
                                                                  style: TextStyle(fontSize: 10.sp, color: AppColors.red, fontWeight: FontWeight.w600),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: 5.sp),
                                                  Padding(
                                                    padding: EdgeInsets.only(bottom: 10.sp),
                                                    child: Text("%", style: TextStyle(fontSize: 15.sp)),
                                                  ),
                                                  SizedBox(width: 10.w),
                                                  Padding(
                                                    padding: EdgeInsets.only(bottom: 10.sp),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          cubit.removeExtraSlaController(index);
                                                        });
                                                      },
                                                      child: Icon(Icons.remove_circle, color: AppColors.red, size: 18.sp),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),

                                          SlaNotificationWidgets.addSlaButton(
                                            context: context,
                                            onTap: () {
                                              setState(() {
                                                cubit.addExtraSlaController();
                                              });
                                            },
                                            onSave: () {
                                              cubit.updateAndSaveModel();
                                            },
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: 20.sp),
                                    ],
                                  ),

                                  NotificationTile(
                                    title: S.of(context).notifyProviderManager,
                                    isChecked: cubit.model.notifyManagerChecked,
                                    onCheckboxChanged: (value) {
                                      setState(() {
                                        cubit.updateCheckbox('manager', value);
                                      });
                                      cubit.updateAndSaveModel();
                                      SharedPrefsHelper.setBool('Notify Provider Manager_checked', value);
                                    },
                                    onCheckSlaData: () {
                                      if (cubit.hasManagerSlaData()) {
                                        SlaNotificationWidgets.showSlaValidationError(context, S.of(context).notifyProviderManager);
                                      } else {
                                        setState(() {
                                          cubit.updateCheckbox('manager', false);
                                        });
                                        cubit.updateAndSaveModel();
                                        SharedPrefsHelper.setBool('Notify Provider Manager_checked', false);
                                      }
                                    },
                                    children: [
                                      S.of(context).whenProviderBreachedSla,
                                      S.of(context).whenServiceRequestedAndApprovedIfRequired,
                                      S.of(context).whenServiceStatusChanges,
                                    ],
                                    onSwitchChanged: (map) {
                                      setState(() {
                                        cubit.updateNotificationSwitches(S.of(context).notifyProviderManager, map);
                                      });
                                    },
                                    onSingleSwitchChanged: ({required index, required value, required title}) {
                                      final key = cubit.slug('${title}_switch_$index');
                                      cubit.updateAndSaveModel();
                                      _saveNotificationSwitchesToSharedPrefs();
                                    },
                                  ),

                                  SizedBox(height: 15.sp),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: isArabic ? 0 : 30.w, bottom: 0.sp, right: isArabic ? 30.w : 0),
                                        child: Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(top: 8.sp),
                                                      child: Text(
                                                        S.of(context).whenServiceSlaIsAboutToBeBreached,
                                                        style: AppTextStyles.font12BlackMediumCairo.copyWith(
                                                          color: lightMode ? AppColors.blackButton :
                                                          AppColors.white,
                                                          letterSpacing: .34,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10.sp),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SlaNotificationWidgets.slaRow(
                                                          context: context,
                                                          controller: cubit.model.slaTwoController,
                                                          isInvalid: cubit.model.isInvalidNumberTwo,
                                                          onChanged: (val) {
                                                            setState(() {
                                                              cubit.updateSlaTwo(val);
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      ...cubit.model.extraSlaTwoControllers.asMap().entries.map((entry) {
                                        final index = entry.key;
                                        final controller = entry.value;

                                        final invalid = controller.text.trim().isNotEmpty &&
                                            (controller.text.contains('.') || controller.text.contains(',') ||
                                                !RegExp(r'^\d+$').hasMatch(controller.text.trim()));

                                        return Padding(
                                          padding: EdgeInsets.only(left: isArabic ? 0 : 30.w, bottom: 0.sp, right: isArabic ? 30.w : 0),
                                          child: Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.only(top: 4.sp),
                                                        child: Text(
                                                          S.of(context).whenServiceSlaIsAboutToBeBreached,
                                                          style: AppTextStyles.font12BlackMediumCairo.copyWith(
                                                            color: lightMode ? AppColors.blackButton :
                                                            AppColors.white,
                                                            letterSpacing: .34,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10.sp),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(
                                                            width: 150.sp,
                                                            height: 28.sp,
                                                            child: CustomTextField(
                                                              controller: controller,
                                                              keyboardType: TextInputType.number,
                                                              hint: S.of(context).EnterPercentage,
                                                              fillColor: AppColors.background,
                                                              borderRadius: BorderRadius.circular(4),
                                                              contentPadding: EdgeInsets.symmetric(
                                                                horizontal: 8.sp,
                                                                vertical: 7.sp,
                                                              ),
                                                              valueStyle: TextStyle(fontSize: 10.sp),
                                                              onChanged: (_) {
                                                                setState(() {});
                                                                final idxKey = cubit.slug('extraSlaTwoList_$index');
                                                                final val = controller.text.trim();

                                                                Timer? debounceTimer;
                                                                debounceTimer?.cancel();
                                                                debounceTimer = Timer(Duration(milliseconds: 500), () {
                                                                  cubit.updateAndSaveModel();
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          SizedBox(height: 3.sp),
                                                          AnimatedOpacity(
                                                            opacity: invalid ? 1.0 : 0.0,
                                                            duration: const Duration(milliseconds: 200),
                                                            child: Text(
                                                              controller.text.contains('.') || controller.text.contains(',')
                                                                  ? (Localizations.localeOf(context).languageCode == 'ar'
                                                                  ? "الأرقام العشرية غير مسموحة"
                                                                  : "Decimals are not allowed")
                                                                  : S.of(context).Onlynumbersareallowed,
                                                              style: TextStyle(fontSize: 10.sp, color: AppColors.red, fontWeight: FontWeight.w600),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 5.sp),
                                              Padding(
                                                padding: EdgeInsets.only(bottom: 10.sp),
                                                child: Text("%", style: TextStyle(fontSize: 15.sp)),
                                              ),
                                              SizedBox(width: 10.w),
                                              Padding(
                                                padding: EdgeInsets.only(bottom: 10.sp),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      cubit.removeExtraSlaTwoController(index);
                                                    });
                                                  },
                                                  child: Icon(Icons.remove_circle, color: AppColors.red, size: 18.sp),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),

                                      SlaNotificationWidgets.addSlaButtonAlt(
                                        context: context,
                                        onTap: () {
                                          setState(() {
                                            cubit.addExtraSlaTwoController();
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15.sp),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.sp),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customButtonAnimation(
                                title: S.of(context).back,
                                function: () {
                                  Navigator.pop(context);
                                },
                                textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
                                    color: Color(0xff2D2D2D)
                                ),
                                width: 150.sp,
                                height: 38.sp,
                                radius: 8.r,
                                color: Color(0xffCCCCCCCC).withOpacity(.8)
                            ),

                            Spacer(),

                            customButtonAnimation(
                              title: cubit.getSaveForLaterText(context, widget.editingModel, S.of(context).submit, S.of(context).Save),
                              function: () {
                                cubit.handleSubmit(
                                  context,
                                  S.of(context).notifyServiceRequester,
                                  S.of(context).notifyServiceProvider,
                                  S.of(context).notifyProviderManager,
                                );
                              },
                              textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
                                  color: AppColors.textButton
                              ),
                              width: 150.sp,
                              height: 38.sp,
                              radius: 8.r,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                        SizedBox(height: 10.sp),

                        if (shouldShowSaveForLaterButton)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              customButtonAnimation(
                                  title: isEditingSubmittedService ? S.of(context).discardChange : S.of(context).saveForLater,
                                  function: () {
                                    cubit.handleSaveForLater(
                                      context,
                                      widget.editingModel,
                                          () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => DetailsToggleScreen(
                                              editingModel: widget.editingModel!,
                                              docId: widget.editingModel!.currentId ?? '',
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
                                      color: Color(0xff2D2D2D)
                                  ),
                                  width: 150.sp,
                                  height: 38.sp,
                                  radius: 8.r,
                                  color: Color(0xffCCCCCCCC).withOpacity(.8)
                              )
                            ],
                          ),
                        SizedBox(height: 20.sp),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _saveNotificationSwitchesToSharedPrefs() async {
    final reqMap = cubit.model.notificationSwitches[S.of(context).notifyServiceRequester] ?? {};
    final mgrMap = cubit.model.notificationSwitches[S.of(context).notifyProviderManager] ?? {};
    cubit.model.notifyRequesterSwitch0 = reqMap[0] ?? false;
    cubit.model.notifyManagerSwitch1 = mgrMap[0] ?? false;

    await SharedPrefsHelper.setBool('notifyRequesterSwitch0', cubit.model.notifyRequesterSwitch0);
    await SharedPrefsHelper.setBool('notifyManagerSwitch1', cubit.model.notifyManagerSwitch1);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    cubit.close();
    super.dispose();
  }
}

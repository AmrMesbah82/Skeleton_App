import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/custom/35-custom_search_widget_custom.dart';
import 'package:demo_app/core/helper/circle_progress.dart';
import 'package:demo_app/features/services_management_module/presentation/controller/services_manager_cubit.dart' hide RequestServicesLoading, RequestServicesError, RequestServicesLoaded;
import 'package:demo_app/features/services_management_module/presentation/s1_home_page_services/ui/pages/home_page_services_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/controller/request_services_state.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/widgets/department_filter_chips_widget.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/widgets/empty_state_widget.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/widgets/services_grid_widget.dart';

import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/widgets/circle_progress.dart';
import 'package:demo_app/core/custom/37-custom_navigate.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/widgets/services_management/custom_botton.dart';
import 'package:demo_app/core/helper/services_management/format_helper.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/core/widgets/services_management/W3_Frame_Screen_tablet.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/pages/my_request_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/controller/request_services_cubit.dart';

class RequestServicesPage extends StatelessWidget {
  const RequestServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RequestServicesCubit()..initialize(context),
      child: RequestServicesView(),
    );
  }
}

class RequestServicesView extends StatefulWidget {
  const RequestServicesView({super.key});

  @override
  State<RequestServicesView> createState() => _RequestServicesViewState();
}

class _RequestServicesViewState extends State<RequestServicesView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = RequestServicesCubit.get(context);
    final lightMode = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      body: SafeArea(
        child: SideFrameMasterServices(
          titleText: FormatHelper.capitalize(S.of(context).services),
          onFirstTap: () {
            navigateTo(context, LayoutScreenServices());
          },
          secondTitle: FormatHelper.capitalize(S.of(context).serviceRequests),
          child: BlocConsumer<RequestServicesCubit, RequestServicesState>(
            listener: (context, state) {
              // Handle state changes if needed
            },
            builder: (context, state) {
              return BlocListener<ServicesManagerCubit, ServicesManagerState>(
                listener: (context, servicesState) {
                  if (servicesState is GetServiceLoaded) {
                    final services = ServicesManagerCubit.get(context).servicesRequest;
                    cubit.loadServices(services);
                  }
                },
                child: SingleChildScrollView(
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Action Bar
                      Row(
                        children: [
                          const Spacer(),
                          SizedBox(width: 15.w),
                          customButtonAnimation(
                            title: FormatHelper.capitalize(S.of(context).myRequests),
                            function: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => MyRequestServicesToggle(),
                                ),
                              );
                            },
                            textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
                              color: AppColors.textButton,
                            ),
                            width: 135.sp,
                            height: 36.sp,
                            radius: 8.r,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                      SizedBox(height: 15.sp),

                      // Department Filter Chips
                      if (state is RequestServicesLoaded)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DepartmentFilterChipsWidget(
                              selectedDepartment: cubit.filterModel.selectedDepartment,
                              departmentCounts: cubit.departmentCounts,
                              onDepartmentChanged: (dept) => cubit.changeDepartmentFilter(dept),
                            ),
                          ],
                        ),

                      SizedBox(height: 15.h),

                      // Search Bar
                      Row(
                        children: [
                          AppSearchTextField(
                            controller: _searchController,
                            onChanged: (val) => cubit.searchServices(val),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),

                      // Content
                      if (state is RequestServicesLoading)
                        Padding(
                          padding: EdgeInsets.only(top: 100.sp),
                          child: CircleProgressMaster(),
                        )
                      else if (state is RequestServicesError)
                        Center(
                          child: Text('Error: ${state.message}'),
                        )
                      else if (state is RequestServicesLoaded)
                          state.filteredServices.isEmpty
                              ? EmptyStateWidget()
                              : ServicesGridWidget(
                            services: state.filteredServices,
                            providerCache: cubit.providerCache,
                          ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: unrelated_type_equality_checks
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/external/main_core/core/theme/app_colors.dart';
import 'package:demo_app/features/external/todo_module/core/widgets/reusable_icon_container.dart';
import 'package:demo_app/features/external/todo_module/features/todo_create_and_edit/presentation/UI/screens/mobile/create_todo_mobile.dart';
import 'package:demo_app/features/external/todo_module/features/todo_list/presentation/ui/pages/mobile/todo_item_mobile.dart';
import 'package:demo_app/features/external/todo_module/features/todo_list/presentation/ui/widgets/home_sorting_dropdown.dart';
import 'package:lottie/lottie.dart';

import '../../../../../../../../../nav_bar_package.dart/functions.dart';
import '../../../../../../../../../nav_bar_package.dart/model.dart';
import '../../../../../../core/constants/app_constanst.dart';
import '../../../../../../core/widgets/custom_appbar_mobile.dart';
import '../../../../../../core/widgets/custom_search.dart';
import '../../../../../../core/widgets/custom_upper_filter.dart';
import '../../../../../../core/widgets/priority_filter.dart';
import '../../../controllers/todo_controller.dart';

// ---------------------------------------------------------------------------
/// Module name:       Todo Module
/// Description:       This file contains the TodoHomeScreenMobile widget,
///                    this file represents the todo list flow, this flow will show the todo for each user according to his schedule
///                    It displays the list of to-dos based on the user's schedule and selected filters.
///
/// Author:            Bassem Mohamed,
/// Date:              21/April/2025
///
/// Revision history:
///   - Ahmed Mahmoud     | 26/April/2025| ui and logic refinements
/// ---------------------------------------------------------------------------

class TodoHomeScreenMobile extends StatefulWidget {
  const TodoHomeScreenMobile({super.key});

  @override
  State<TodoHomeScreenMobile> createState() => _TodoHomeScreenMobileState();
}

class _TodoHomeScreenMobileState extends State<TodoHomeScreenMobile> {
  String searchText = '';

  /// This is the build method for the TodoScreenMobile class.
  /// It builds a TodoScreenMobile widget based on the given parameters.
  /// It will show the todo list for each user according to his schedule.
  /// The todo list will be shown in a column.
  /// The column contains a title, a row of buttons to control the todo list,
  /// and a section of todo containers.

  @override
  void initState() {
    Get.find<TodoController>().searchAndFilter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GetBuilder<TodoController>(
        builder: (controller) {
          // calculate the number of Items in each filter type

          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBarMobile(
                    title: AppConstants.todoListName, showIcon: false),
                SizedBox(height: 26),
                Expanded(
                  child: Container(
                    color: AppColors.background,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // filter section
                          UpperFilters(
                            numberOfFilter: controller.numberOfFilter,
                            filterTitles: [
                              AppConstants.all.capitalize!.tr,
                              AppConstants.todo.capitalize!.tr,
                              AppConstants.done.capitalize!.tr,
                              AppConstants.deleted.capitalize!.tr,
                              AppConstants.scheduled.capitalize!.tr,
                            ],
                            selectedIndex: controller.selectedFilterIndex,
                            selectedIndexState: (value) {
                              controller.selectedFilterIndex = value;
                              controller.filterList();
                            },
                            selectedDepartmentState: (value) {},
                          ),

                          // (Search - Sorting - Create) row
                          Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 15),
                            child: Row(
                              spacing: 10,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // search section
                                Expanded(
                                  child: CustomSearchFiled2(
                                    hint: AppConstants.search.tr,
                                    keyBoardType: TextInputType.text,
                                    onChanged: (value) {
                                      searchText = value;
                                      controller.searchName = value;
                                      controller.searchAndFilter();
                                    },
                                  ),
                                ),
                                // Sorting section
                                HomeSortingDropDown(),
                                // Create section
                                ReusableIconContainer(
                                  filterColor: true,
                                  imagePath: "assets/icons/g5545.svg",
                                  onPressed: () {
                                    PersistentNavBarNavigator.pushNewScreen(
                                      context,
                                      pageTransitionAnimation:
                                          PageTransitionAnimation.fade,
                                      screen: const CreateTodoMobile(),
                                      withNavBar: false,
                                    );
                                  },
                                )
                              ],
                            ),
                          ),

                          // priority filter
                          PriorityFilter(
                            onFilterSelected: (selectedPriority) {
                              controller.filterByPriority(selectedPriority);
                            },
                          ),
                          SizedBox(height: 15),
                          controller.filteredTodoList.isNotEmpty
                              ? Expanded(
                                  child: ListView.separated(
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return const SizedBox(height: 15);
                                    },
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount:
                                        controller.filteredTodoList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ToDoItemMobile(index: index);
                                    },
                                  ),
                                )
                              : Expanded(
                                  child: Lottie.asset(
                                      'assets/images/Animation - 1715582755834.json'),
                                ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:demo_app/core/nav_bar_package.dart/functions.dart';
import 'package:demo_app/core/nav_bar_package.dart/model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/features/todo_module/core/components/other_components/custom_appbar.dart';
import 'package:demo_app/features/todo_module/core/components/other_components/custom_drawer.dart';
import 'package:demo_app/features/todo_module/core/components/other_components/custom_icon_button.dart';
import 'package:demo_app/features/todo_module/core/widgets/custom_search.dart';
import 'package:demo_app/features/todo_module/core/widgets/custom_upper_filter.dart';
import 'package:demo_app/features/todo_module/core/widgets/priority_filter.dart';
import 'package:demo_app/features/todo_module/features/todo_create_and_edit/presentation/UI/screens/tablet/create_todo_tablet.dart';
import 'package:demo_app/features/todo_module/features/todo_list/presentation/controllers/todo_controller.dart';
import 'package:demo_app/features/todo_module/features/todo_list/presentation/ui/pages/tablet/todo_item_tablet.dart';
import 'package:demo_app/features/todo_module/features/todo_list/presentation/ui/widgets/home_sorting_dropdown.dart';
import 'package:lottie/lottie.dart';


import '../../../../../../core/constants/app_constanst.dart';

// ---------------------------------------------------------------------------
/// Module name:       Todo Module
/// Description:       This file contains the TodoHomeScreenTablet widget,
///                    this file represents the todo list flow, this flow will show the todo for each user according to his schedule
///                    It displays the list of to-dos based on the user's schedule and selected filters.
///
/// Author:            Bassem Mohamed,
/// Date:              21/April/2025
///
/// Revision history:
///   - Ahmed Mahmoud     | 26/April/2025| ui and logic refinements
/// ---------------------------------------------------------------------------
class TodoHomeScreenTablet extends StatefulWidget {
  const TodoHomeScreenTablet({super.key});

  @override
  State<TodoHomeScreenTablet> createState() => _TodoHomeScreenTabletState();
}

class _TodoHomeScreenTabletState extends State<TodoHomeScreenTablet> {
  String searchText = '';

  /// This is the build method for the Todo Tablet class.
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
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GetBuilder<TodoController>(
        builder: (controller) {
          return SafeArea(
              child: Row(
            children: [
              CustomDrawer(selectedIndex: 12),
              Expanded(
                child: Column(
                  children: [
                    CustomAppBar(),
                    Expanded(
                      child: Container(
                        color: AppColors.background,
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Home Title
                                Text(
                                  AppConstants.todoListName.tr,
                                  style: AppTextStyles.font10BlueCairo.copyWith(
                                    fontSize: 34,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.text,
                                  ),
                                ),
                                SizedBox(height: 30),
                                Column(
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
                                      selectedIndex:
                                          controller.selectedFilterIndex,
                                      selectedIndexState: (value) {
                                        controller.selectedFilterIndex = value;
                                        controller.filterList();
                                      },
                                      selectedDepartmentState: (value) {},
                                    ),
                                    SizedBox(height: 20),
                                    // (Search - Sorting - Create) row
                                    Row(
                                      spacing: 15,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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

                                        // Create Todo Button
                                        CustomIconButton(
                                          height: 38,
                                          width: 150,
                                          buttonText: 'Create To Do'.tr,
                                          imagePath: "assets/icons/g5545.svg",
                                          onPressed: () {
                                            PersistentNavBarNavigator
                                                .pushNewScreen(
                                              context,
                                              pageTransitionAnimation:
                                                  PageTransitionAnimation.fade,
                                              screen: const CreateTodoTablet(),
                                              withNavBar: false,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 15),
                                    // Priority Filter
                                    PriorityFilter(
                                      onFilterSelected: (selectedPriority) {
                                        controller
                                            .filterByPriority(selectedPriority);
                                      },
                                    ),
                                    SizedBox(height: 15),
                                    controller.filteredTodoList.isNotEmpty
                                        ? ListView.separated(
                                            separatorBuilder:
                                                (context, index) =>
                                                    const SizedBox(height: 15),
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: isPortrait
                                                ? controller
                                                    .filteredTodoList.length
                                                : (controller.filteredTodoList
                                                            .length /
                                                        (2))
                                                    .ceil(),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              int itemsPerRow;

                                              // Determine items per row based on screen orientation and size
                                              if (MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  2400) {
                                                itemsPerRow = 6;
                                              } else if (MediaQuery.of(context)
                                                          .size
                                                          .width >=
                                                      2000 &&
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width <
                                                      2400) {
                                                itemsPerRow = 5;
                                              } else if (MediaQuery.of(context)
                                                          .size
                                                          .width >=
                                                      1500 &&
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width <
                                                      2000) {
                                                itemsPerRow = 4;
                                              } else if (MediaQuery.of(context)
                                                          .size
                                                          .width >=
                                                      1100 &&
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width <
                                                      1500) {
                                                itemsPerRow = 3;
                                              } else if (MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      720 &&
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width <
                                                      1100) {
                                                itemsPerRow = 2;
                                              } else {
                                                itemsPerRow = 1;
                                              }

                                              // Calculate the base index for each row
                                              int baseIndex =
                                                  index * itemsPerRow;
                                              return Row(
                                                spacing: 15,
                                                children: List.generate(
                                                  itemsPerRow,
                                                  (i) {
                                                    int currentIndex =
                                                        baseIndex + i;
                                                    // Only display if the current index is within the todo list
                                                    if (currentIndex <
                                                        controller
                                                            .filteredTodoList
                                                            .length) {
                                                      return Expanded(
                                                        child: TodoItemTablet(
                                                          index: currentIndex,
                                                        ),
                                                      );
                                                    } else {
                                                      return const Expanded(
                                                          child: SizedBox());
                                                    }
                                                  },
                                                ),
                                              );
                                            },
                                          )
                                        : Lottie.asset(
                                            'assets/images/Animation - 1715582755834.json',
                                          ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ));
        },
      ),
    );
  }
}

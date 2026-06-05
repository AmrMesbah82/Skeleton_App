// //App Version : Version 2
// // Date of Last Edit :4/March/2024
// // Objectives: this is a widget to customize the fikter if the messages
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:demo_app/core/theme/font_manager.dart';
// import 'package:demo_app/features/external/main_core/core/theme/my_theme.dart';
//
// // ignore: must_be_immutable
// class UpperFiltersWithUnderLine extends StatefulWidget {
//   UpperFiltersWithUnderLine({
//     super.key,
//     required this.selectedIndex,
//     required this.selectedDepartmentState,
//     required this.selectedIndexState,
//     required this.filterTitles,
//     this.isSettingsPage = false,
//   });
//   int selectedIndex;
//   ValueChanged<String> selectedDepartmentState;
//   ValueChanged<int> selectedIndexState;
//   List<String> filterTitles;
//   bool? isSettingsPage;
//
//   @override
//   State<UpperFiltersWithUnderLine> createState() => _UpperFiltersState();
// }
//
// class _UpperFiltersState extends State<UpperFiltersWithUnderLine> {
//   final TextStyle unselectedStyle = AppFontStyle.cairoRegularStyle.copyWith(
//     fontSize: FontConstants.fontSize032.h,
//     color: MyThemeData.colorGrey,
//     fontWeight: FontWeight.w400,
//   );
//   final TextStyle selectedStyle = AppFontStyle.cairoRegularStyle.copyWith(
//     color: MyThemeData.lightPrimary,
//     /*Theme.of(context).colorScheme.onInverseSurface,*/
//     fontWeight: FontWeight.w800,
//     fontSize: FontConstants.fontSize032.h,
//   );
//
//   final KnowledgeHapticController hapticController = Get.put(KnowledgeHapticController());
//   //AddDepartmentController addDepartmentController = Get.find();
//   Widget filterItems(String title, int index) {
//     bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
//     bool orientation =
//         MediaQuery.of(context).orientation == Orientation.portrait;
//     return GestureDetector(
//       onTap: () {
//         hapticController.triggerHapticFeedback(
//             vibration: VibrateType.lightImpact,
//             hapticFeedback: HapticFeedback.lightImpact);
//         setState(() {
//           widget.selectedIndex = index;
//           widget.selectedDepartmentState(title);
//           widget.selectedIndexState(index);
//         });
//       },
//       child: Text(
//         title.tr,
//         // textAlign: TextAlign.start,
//         style: widget.selectedIndex == index
//             ? isTablet
//                 ? selectedStyle.copyWith(
//                     fontSize: widget.isSettingsPage == true
//                         ? (orientation
//                             ? FontConstants.fontSize019.h
//                             : FontConstants.fontSize022.h)
//                         : orientation
//                             ? FontConstants.fontSize020.h
//                             : FontConstants.fontSize030.h,
//                     height: 1.6,
//                     shadows: [
//                       Shadow(
//                           color: MyThemeData.lightPrimary,
//                           offset: Offset(0, -5))
//                     ],
//                     color: Colors.transparent,
//                     decoration: TextDecoration.underline,
//                     decorationColor: MyThemeData.lightPrimary,
//                     decorationThickness: 2.5)
//                 : selectedStyle.copyWith(
//                     fontSize: FontConstants.fontSize021.h,
//                     height: 1.8,
//                     shadows: [
//                       Shadow(
//                           color: MyThemeData.lightPrimary,
//                           offset: Offset(0, -5))
//                     ],
//                     color: Colors.transparent,
//                     decoration: TextDecoration.underline,
//                     decorationColor: MyThemeData.lightPrimary,
//                     decorationThickness: 2.5)
//             : isTablet
//                 ? unselectedStyle.copyWith(
//                     fontSize: widget.isSettingsPage == true
//                         ? (orientation
//                             ? FontConstants.fontSize019.h
//                             : FontConstants.fontSize022.h)
//                         : orientation
//                             ? FontConstants.fontSize020.h
//                             : FontConstants.fontSize030.h,
//                   )
//                 : unselectedStyle.copyWith(
//                     fontSize: FontConstants.fontSize021.h),
//       ),
//     );
//   }
//
//   Widget selectedContainer(int index, double width) {
//     return Container(
//       width: width,
//       color: widget.selectedIndex == index
//           ? MyThemeData.lightPrimary
//           : Colors.transparent,
//     );
//   }
//
//   Widget upSpacer() {
//     bool orientation =
//         MediaQuery.of(context).orientation == Orientation.portrait;
//     bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
//     return SizedBox(
//       width: isTablet ? (orientation ? 0.04.w : 0.06.h) : 0.06.w,
//     );
//   }
//
//   Widget belowSpacer() {
//     return Container(
//       width: 0.041.w,
//       color: Colors.transparent,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 0.05.h,
//       width: double.infinity,
//       child: ListView.builder(
//         shrinkWrap: true,
//         scrollDirection: Axis.horizontal,
//         itemBuilder: (context, index) {
//           return Row(
//             children: [
//               filterItems(widget.filterTitles[index], index),
//               upSpacer(),
//             ],
//           );
//         },
//         itemCount: widget.filterTitles.length,
//       ),
//     );
//   }
// }

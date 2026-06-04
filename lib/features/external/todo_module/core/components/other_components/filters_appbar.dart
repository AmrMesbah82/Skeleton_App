// // Date Created :14/November/2023
// // Developer Name : Mazen shabaan
// //App Version : Version 2
// // Date of Last Edit :14/November/2023
// // Objectives: this is a widget to customize the filters of the appbar
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:demo_app/features/external/main_core/core/theme/font_manager.dart';
// import 'package:demo_app/features/external/todo_module/core/constants/screen_size.dart';
// import 'package:demo_app/features/external/main_core/core/theme/my_theme.dart';

// class FiltersAppBar extends StatelessWidget {
//   const FiltersAppBar(
//       {super.key,
//       required this.imageUrl,
//       required this.title,
//       this.hideIcon,
//       this.iconColor});
//   final String imageUrl;
//   final String title;
//   final bool? hideIcon;
//   final Color? iconColor;

//   @override
//   Widget build(BuildContext context) {
//     bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
//     bool isPortrait =
//         MediaQuery.of(context).orientation == Orientation.portrait;
//     return Column(
//       children: [
//         Row(
//           children: [
//             isPortrait
//                 ? SizedBox(
//                     width: 0.006.w,
//                   )
//                 : const SizedBox.shrink(),
//             hideIcon == true
//                 ? const SizedBox.shrink()
//                 : CircleAvatar(
//                     radius: isPortrait ? 0.018.h : 0.025.h,
//                     backgroundColor: MyThemeData.signOut,
//                     child: Transform.scale(
//                         scale: isTablet
//                             ? isPortrait
//                                 ? 1.5
//                                 : 1.1
//                             : 0.9,
//                         child: SvgPicture.asset(
//                           imageUrl,
//                           color: MyThemeData.colorBlack,
//                         )),
//                   ),
//             Padding(
//               padding: EdgeInsets.only(
//                   left: hideIcon == true
//                       ? 0
//                       : Get.locale.toString().contains('en')
//                           ? isPortrait
//                               ? 0.015.w
//                               : 0.01.w
//                           : 0,
//                   right: hideIcon == true
//                       ? 0
//                       : Get.locale.toString().contains('en')
//                           ? 0
//                           : isPortrait
//                               ? 0.015.w
//                               : 0.01.w),
//               child: Text(
//                 title.tr,
//                 style: AppFontStyle.cairoRegularStyle.copyWith(
//                     fontSize: isTablet
//                         ? isPortrait
//                             ? FontConstants.fontSize021.h
//                             : FontConstants.fontSize028.h
//                         : FontConstants.fontSize020.h,
//                     fontWeight: Get.locale.toString().contains('en')
//                         ? FontWeight.w600
//                         : FontWeight.w500,
//                     height: isTablet ? (isPortrait ? 1.8 : 1.8) : 0.002.h,
//                     color: Theme.of(context).colorScheme.inverseSurface),
//               ),
//             ),
//           ],
//         ),
//         if (isTablet)
//           isPortrait
//               ? SizedBox(height: 0.015.h)
//               : SizedBox(
//                   height: 0.03.h,
//                 ),
//         // if(isTablet)
//         // Padding(
//         //   padding: EdgeInsets.symmetric(vertical:isTablet? 0.005.h:0),
//         //   child: Divider(
//         //     color: MyThemeData.divider,
//         //     thickness: 1.5,
//         //   ),
//         // ),
//         if (!isTablet)
//           SizedBox(
//             height: 0.01.h,
//           )
//       ],
//     );
//   }
// }

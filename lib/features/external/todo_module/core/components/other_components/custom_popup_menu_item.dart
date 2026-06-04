// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:demo_app/constant/screen_size.dart';

// import '../main_core/old_theme/my_theme.dart';
// import 'sort_option_widget.dart';
// import 'success_dialog.dart';
// import '../todo_module/features/todo_list/data/models/todo_model.dart';
// import '../todo_module/core/widgets/dialogs/delete_dialog.dart';

// class CustomPopupMenuItem<T> extends PopupMenuItem<T> {
//   final Color color;
//   final bool first;
//   final bool last;

//   const CustomPopupMenuItem({
//     Key? key,
//     required T value,
//     bool enabled = true,
//     required Widget child,
//     required this.color,
//     this.first = false,
//     this.last = false,
//   }) : super(key: key, value: value, enabled: enabled, child: child);

//   @override
//   // ignore: library_private_types_in_public_api
//   _CustomPopupMenuItemState<T> createState() => _CustomPopupMenuItemState<T>();
// }

// class _CustomPopupMenuItemState<T>
//     extends PopupMenuItemState<T, CustomPopupMenuItem<T>> {
//   late BorderRadius borderRadius;
//   double radius = 10;
//   @override
//   Widget build(BuildContext context) {
//     if (widget.first) {
//       borderRadius = BorderRadius.only(
//           topLeft: Radius.circular(radius), topRight: Radius.circular(radius));
//     } else if (widget.last) {
//       borderRadius = BorderRadius.only(
//           bottomLeft: Radius.circular(radius),
//           bottomRight: Radius.circular(radius));
//     } else {
//       borderRadius = BorderRadius.zero;
//     }
//     return ClipRRect(
//       borderRadius: borderRadius,
//       child: Container(
//         color: widget.color,
//         child: super.build(context),
//       ),
//     );
//   }
// }

// enum Status {
//   // ignore: constant_identifier_names
//   Edit,
//   // ignore: constant_identifier_names
//   Delete,
// }

// void showSortMenu(
//     BuildContext context,
//     Offset iconPosition,
//     void Function() deleteCallback,
//     TodoModel todoModel,
//     String searchText) async {
//   final List<Status> sortOptions = [
//     Status.Edit,
//     Status.Delete,
//   ];
//   bool isVertical = MediaQuery.of(context).orientation == Orientation.portrait;
//   bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
//   final RenderBox overlay =
//       Overlay.of(context).context.findRenderObject() as RenderBox;
//   final double menuOffsetX = iconPosition.dx - (-12);
//   final double menuOffsetY = iconPosition.dy - (-12.0);

//   final RelativeRect position = RelativeRect.fromLTRB(
//     menuOffsetX,
//     menuOffsetY,
//     overlay.size.width - menuOffsetX,
//     overlay.size.height,
//   );

//   selectedOption = await showMenu(
//     elevation: 0,
//     shadowColor: Colors.transparent,
//     color: Theme.of(context).colorScheme.inversePrimary,
//     context: context,
//     constraints: BoxConstraints(
//       maxWidth: isTablet ? 0.18.w : 0.3.w,
//       minHeight: 0.04.h,
//     ),
//     position: position,
//     shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//         side: BorderSide(
//           color: MyThemeData.lightPrimary,
//         )),
//     items: sortOptions.map((option) {
//       return CustomPopupMenuItem<Status>(
//           first: option.index == 0,
//           last: option.index == sortOptions.length - 1,
//           color: Colors.transparent,
//           value: option,
//           child: _getSortOptionLabel(option, context));
//     }).toList(),
//   );

//   if (selectedOption != null) {
//     switch (selectedOption!) {
//       case Status.Edit:
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return isTablet
//                 ? CreateTodoScreen()
//                 : CreateEditTodoMobile(
//                     isEdit: true,
//                     todoModelEdit: todoModel,
//                     searchText: searchText,
//                   );
//           },
//         );
//         break;
//       case Status.Delete:
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return DeleteDialog(
//               deleteTitleText: "Delete List",
//               deleteText: "Are You Sure You Want To Delete This List?".tr,
//               yesOnPressed: () {
//                 deleteCallback();
//                 Get.back();
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return const SuccessDialog(
//                       title: "Successful",
//                       subtitle: "Your List Has Been Deleted Successfully",
//                       lottieAsset: "assets/images/correct.json",
//                     );
//                   },
//                 );
//               },
//             );
//           },
//         );
//         break;
//     }
//   }
// }

// Status? selectedOption;
// Widget _getSortOptionLabel(Status option, BuildContext context) {
//   switch (option) {
//     case Status.Edit:
//       return const SortOptionWidget(
//         iconAddress: 'assets/icons/smallEdit.svg',
//         text: "Edit",
//       );
//     case Status.Delete:
//       return const SortOptionWidget(
//         iconAddress: 'assets/icons/smallTrash.svg',
//         text: "Delete",
//       );
//   }
// }

/*
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/core/widgets/attachemnet_pdf_container.dart';
import 'package:demo_app/core/widgets/column_request_data.dart';
import 'package:demo_app/core/widgets/dialogs/delete_dialog.dart';
import 'package:demo_app/core/widgets/filters_appbar.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_button.dart';
import 'package:demo_app/features/external/knowledge_hub/feature/create_document/presentation/controller/comments_controller.dart';
import 'package:demo_app/features/external/knowledge_hub/feature/create_document/presentation/controller/create_document_controller.dart';
import 'package:demo_app/features/external/knowledge_hub/feature/document_details/data/model/comments_model.dart';
import 'package:demo_app/features/external/knowledge_hub/feature/home/presentation/controller/knowledge_hub_controller.dart';

import 'package:demo_app/core/widgets/sort_option_widget.dart';
import 'package:demo_app/features/external/main_core/core/theme/font_manager.dart';
import 'package:demo_app/features/external/main_core/core/theme/my_theme.dart';
import 'package:demo_app/features/external/knowledge_hub/core/constant/screen_size.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'package:demo_app/features/external/main_core/features/employee/presentation/controller/main_core_employee_controller.dart';

import '../../features/external/knowledge_hub/feature/create_document/data/models/document_model.dart';
import '../../features/skeleton/onboarding/presentation/ui/pages/onboarding.dart';

/// Date Created :21/November/2023
/// Developer Name : Bassem Mohamed
/// App Version : Version 2
/// Date of Last Edit :23/November/2023 By Bassem
/// Objectives:  this file represents the custom container for the comments section to view the sender name, time , and the message it self

class CustomCommentsContainer extends StatefulWidget {
  final String imagPath;
  final DocumentModel? document;

  final int index;
  CustomCommentsContainer({
    required this.imagPath,
    this.document,
    required this.index,
  });

  @override
  State<CustomCommentsContainer> createState() =>
      _CustomCommentsContainerState();
}

class _CustomCommentsContainerState extends State<CustomCommentsContainer> {
  @override
  initState() {
    super.initState();
  }

  int currentDocument = 0;
  KnowledgeHubCreateDocumentController createDocumentController =
      Get.find<KnowledgeHubCreateDocumentController>();
  KnowledgeHubController knowledgeHubController =
      Get.put(KnowledgeHubController());

  String formatTimestampArabicToString(String date) {
    DateTime dateTime = DateTime.parse(date);
    DateFormat dateFormat = DateFormat("dd MMM yyyy ${'at'.tr}  mm : hh  a",
        Get.locale.toString().contains("en") ? 'en' : 'ar');
    String formattedDate = dateFormat.format(dateTime);
    return formattedDate;
  }

  String getFileNameFromUrl(String url) {
    Uri uri = Uri.parse(url);
    return uri.pathSegments.isNotEmpty
        ? uri.pathSegments.last.split('/').last
        : 'unknown';
  }

  @override
  Widget build(BuildContext context) {
    currentDocument =
        knowledgeHubController.documents.indexOf(widget.document!);
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return GetBuilder<KnowledgeHubController>(builder: (controller) {
      return Padding(
        padding: EdgeInsets.only(
            top: isTablet ? (isPortrait ? 0.015.h : 0.03.h) : 0.015.h),
        child: Container(
            width: isTablet ? null : null,
            padding: isTablet
                ? EdgeInsets.symmetric(vertical: isPortrait ? 0.01.h : 0.02.h)
                : EdgeInsets.symmetric(vertical: 0.01.h),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  //  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: widget.imagPath.isURL
                          ? Image.network(
                              widget.imagPath,
                              width: isTablet
                                  ? (isPortrait ? 0.065.w : 0.03.w)
                                  : 0.11.w,
                              height: isTablet
                                  ? (isPortrait ? 0.065.w : 0.03.w)
                                  : 0.11.w,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              widget.imagPath,
                              width: isTablet
                                  ? (isPortrait ? 0.065.w : 0.03.w)
                                  : 0.11.w,
                              height: isTablet
                                  ? (isPortrait ? 0.065.w : 0.03.w)
                                  : 0.11.w,
                              fit: BoxFit.cover,
                            ),
                    ),
                    SizedBox(
                      width: 0.01.w,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Get.find<MainCoreEmployeeController>()
                                .getEmployeeName(controller
                                    .documents[currentDocument]
                                    .comments![widget.index]
                                    .email)
                                .capitalize!,
                            style: AppFontStyle.cairoRegularStyle.copyWith(
                              fontSize: !isPortrait
                                  ? FontConstants.fontSize015.w
                                  : isTablet
                                      ? FontConstants.fontSize015.h
                                      : FontConstants.fontSize015.h,
                              color: mainCoreThemeController.currentTheme ==
                                      MyThemeData.lightTheme
                                  ? MyThemeData.colorBlack
                                  : MyThemeData.colorWhiteDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 0.005.h,
                          ),
                          Text(
                            Get.find<MainCoreEmployeeController>()
                                .getEmployeeJobTitle(controller
                                    .documents[currentDocument]
                                    .comments![widget.index]
                                    .email)
                                .capitalize!,
                            style: AppFontStyle.cairoRegularStyle.copyWith(
                              fontSize: !isPortrait
                                  ? FontConstants.fontSize014.w
                                  : isTablet
                                      ? FontConstants.fontSize014.h
                                      : FontConstants.fontSize014.h,
                              color: MyThemeData.textdeactivecolor,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                    Text(
                      formatTimestampArabicToString(controller
                          .documents[currentDocument]
                          .comments![widget.index]
                          .date),
                      style: AppFontStyle.cairoRegularStyle.copyWith(
                        fontSize: isPortrait
                            ? FontConstants.fontSize012.h
                            : FontConstants.fontSize011.w,
                        color: MyThemeData.textdeactivecolor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      width: 0.013.w,
                    ),
                    InkWell(
                        onTapUp: (details) {
                          final iconPosition = details.globalPosition;
                          _showSortMenu(
                            context,
                            iconPosition,
                            controller.documents[currentDocument],
                            widget.index,
                  */
/**/ /*
          controller.documents[currentDocument]
                                .comments![widget.index],
                            () async {
                              await createDocumentController
                                  .editComment(
                                controller.documents[currentDocument],
                                controller.documents[currentDocument]
                                    .comments![widget.index],
                                widget.index,
                              )
                                  .then((value) {
                                if (value != null) {
                                  controller.documents[currentDocument]
                                      .comments![widget.index] = value;
                                  controller.update();
                                }
                              });
                              createDocumentController.update();
                              Navigator.pop(context);
                            },
                            () async {
                              await createDocumentController
                                  .deleteComment(
                                controller.documents[currentDocument],
                                widget.index,
                              )
                                  .then((value) {
                                if (value) {
                                  controller
                                      .documents[currentDocument].comments!
                                      .removeAt(widget.index);
                                  controller.update();
                                }
                              });
                              createDocumentController.update();
                              Navigator.pop(context);
                            },
                          );
                        },
                        child: Container(
                          //    color: Colors.amber,
                          width: isTablet
                              ? (isPortrait ? 0.04.w : 0.025.w)
                              : 0.07.w,
                          height: isTablet
                              ? isPortrait
                                  ? 0.015.h
                                  : 0.022.h
                              : 0.015.h,
                          color: Theme.of(context).colorScheme.inversePrimary,
                          child: SvgPicture.asset(
                            "assets/icons/three_dots.svg",
                            height: isTablet
                                ? isPortrait
                                    ? 0.01.h
                                    : 0.015.h
                                : null,
                            alignment: Alignment.topCenter,
                            color: Theme.of(context).colorScheme.inverseSurface,
                          ),
                        )),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.015.h),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: (mainCoreThemeController.currentTheme ==
                              MyThemeData.lightTheme
                          ? MyThemeData.colorLightGrey
                          : MyThemeData.darkBackGround),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 0.01.h, horizontal: 0.02.w),
                      child: controller.documents[currentDocument]
                              .comments![widget.index].isPdf
                          ? InkWell(
                              onTap: () async {
                                await launchUrl(Uri.parse(controller
                                    .documents[currentDocument]
                                    .comments![widget.index]
                                    .description));
                              },
                              child: Row(
                                children: [
                                  AttachmentPdfContainer(
                                    fileName: getFileNameFromUrl(controller
                                        .documents[currentDocument]
                                        .comments![widget.index]
                                        .description),
                                    fileSize: double.parse(controller
                                            .documents[currentDocument]
                                            .comments![widget.index]
                                            .fileSize)
                                        .toStringAsFixed(3),
                                    onTapDelete: () {},
                                    onTapDownload: () {},
                                  ),
                                  Spacer(),
                                ],
                              ),
                            )
                          : Text(
                              controller.documents[currentDocument]
                                  .comments![widget.index].description,
                              maxLines: 46,
                              overflow: TextOverflow.ellipsis,
                              style: AppFontStyle.cairoRegularStyle.copyWith(
                                fontSize: !isPortrait
                                    ? FontConstants.fontSize025.h
                                    : FontConstants.fontSize016.h,
                                color: mainCoreThemeController.currentTheme ==
                                        MyThemeData.lightTheme
                                    ? MyThemeData.colorDarkGrey
                                    : MyThemeData.colorGreydark,
                                fontWeight: FontWeight.w600,
                                height: isTablet
                                    ? (isPortrait ? 1.6 : 0.0018.h)
                                    : 0.0018.h,
                              ),
                            ),
                    ),
                  ),
                )
              ],
            )),
      );
    });
  }
}

enum StatusWant {
  // ignore: constant_identifier_names
  Edit,
  // ignore: constant_identifier_names
  Delete,
  // ignore: constant_identifier_names
}

void _showSortMenu(
  BuildContext context,
  Offset iconPosition,
  DocumentModel document,
  int commentIndex,
  CommentsModel comment,
  void Function() onPressEdit,
  void Function() onPressDelete,
) async {
  final List<StatusWant> sortOptions = [
    StatusWant.Edit,
    StatusWant.Delete,
  ];
  final List<StatusWant> sortOptions2 = [
    StatusWant.Delete,
  ];

  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;
  final double menuOffsetX = iconPosition.dx - (-9.0);
  final double menuOffsetY = iconPosition.dy - (-7.0);

  final RelativeRect position = RelativeRect.fromLTRB(
    menuOffsetX,
    menuOffsetY,
    overlay.size.width - menuOffsetX,
    overlay.size.height,
  );

  selectedOption = await showMenu(
    elevation: 0,
    shadowColor: Colors.transparent,
    color: Theme.of(context).colorScheme.onPrimary,
    context: context,
    constraints: BoxConstraints(
      maxWidth: 0.35.w,
      minHeight: 0.0.h,
    ),
    position: position,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: MyThemeData.signOut,
        )),
    items: comment.isPdf
        ? sortOptions2.map((option) {
            return CustomPopupMenuItem<StatusWant>(
                first: option.index == 0,
                last: option.index == sortOptions.length - 1,
                color: Theme.of(context).colorScheme.onPrimary,
                value: option,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _getSortOptionLabel(option, context),
                  ],
                ));
          }).toList()
        : sortOptions.map((option) {
            return CustomPopupMenuItem<StatusWant>(
                first: option.index == 0,
                last: option.index == sortOptions.length - 1,
                color: Theme.of(context).colorScheme.onPrimary,
                value: option,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _getSortOptionLabel(option, context),
                  ],
                ));
          }).toList(),
  );

  if (selectedOption != null) {
    // Call the appropriate dialog function based on the selected option
    switch (selectedOption!) {
      case StatusWant.Edit:
        showDialog(
            context: context,
            builder: (context) {
              return EditCommentDialog(
                commentText: comment.description,
                index: commentIndex,
                comment: comment,
                document: document,
                onPressEdit: onPressEdit,
              );
            });
        break;
      case StatusWant.Delete:
        showDialog(
            context: context,
            builder: (context) {
              return DeleteDialog(
                  yesOnPressed: onPressDelete,
                  deleteTitleText: "Delete Comment",
                  deleteText: "Are You Sure You Want To Delete This Comment ?");
            });

        break;
    }
  }
}

StatusWant? selectedOption;
Widget _getSortOptionLabel(StatusWant option, BuildContext context) {
  switch (option) {
    case StatusWant.Edit:
      return const SortOptionWidget(
        iconAddress: 'assets/icons/move_mobile.svg',
        text: "Edit Comment",
        hasImage: false,
      );
    case StatusWant.Delete:
      return const SortOptionWidget(
        iconAddress: 'assets/icons/delete_mob.svg',
        iconColor: Color(0xFF797979),
        text: "Delete Comment",
        hasImage: false,
      );
  }
}

class CustomPopupMenuItem<T> extends PopupMenuItem<T> {
  final Color color;
  final bool first;
  final bool last;

  const CustomPopupMenuItem({
    Key? key,
    required T value,
    bool enabled = true,
    required Widget child,
    required this.color,
    this.first = false,
    this.last = false,
  }) : super(key: key, value: value, enabled: enabled, child: child);

  @override
  // ignore: library_private_types_in_public_api
  _CustomPopupMenuItemState<T> createState() => _CustomPopupMenuItemState<T>();
}

class _CustomPopupMenuItemState<T>
    extends PopupMenuItemState<T, CustomPopupMenuItem<T>> {
  late BorderRadius borderRadius;
  double radius = 10;
  @override
  Widget build(BuildContext context) {
    if (widget.first) {
      borderRadius = BorderRadius.only(
          topLeft: Radius.circular(radius), topRight: Radius.circular(radius));
    } else if (widget.last) {
      borderRadius = BorderRadius.only(
          bottomLeft: Radius.circular(radius),
          bottomRight: Radius.circular(radius));
    } else {
      borderRadius = BorderRadius.zero;
    }
    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        color: widget.color,
        child: super.build(context),
      ),
    );
  }
}

class EditCommentDialog extends StatefulWidget {
  EditCommentDialog({
    super.key,
    required this.commentText,
    required this.comment,
    required this.document,
    required this.index,
    required this.onPressEdit,
  });
  String commentText;
  DocumentModel document;
  CommentsModel comment;
  int index;
  void Function() onPressEdit;
  @override
  State<EditCommentDialog> createState() => _EditCommentDialogState();
}

class _EditCommentDialogState extends State<EditCommentDialog> {
  KnowledgeHubCreateDocumentController controller = Get.find();

  @override
  void initState() {
    controller.commentController =
        TextEditingController(text: widget.commentText);
    super.initState();
  }

  @override
  void dispose() {
    controller.commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: isTablet ? (isPortrait ? 0.15.w : 0.3.w) : 0.05.w,
      ),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.inversePrimary),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.02.w, vertical: 0.015.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FiltersAppBar(
                    imageUrl: 'assets/images/pen_service.svg',
                    iconColor: MyThemeData().contrastColor(),
                    title: "Edit Comment"),
                ColumnRequestData(
                  title: "Comment",
                  isTextField: true,
                  hint: "Edit Here",
                  textController: controller.commentController,
                  isOptional: false,
                  isExpanded: true,
                  controllerState: (value) {},
                ),
                SizedBox(height: 0.02.h),
                Padding(
                  padding: EdgeInsets.only(top: 0.02.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width:
                            isTablet ? (isPortrait ? 0.15.w : 0.1.w) : 0.25.w,
                        child: MainCustomButton(
                          buttonText: 'Submit',
                          onPressed: widget.onPressEdit,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/

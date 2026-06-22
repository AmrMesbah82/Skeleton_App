import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/network/get_base_url.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/constants/services_management/constant.dart';
import 'package:demo_app/features/services_management_module/data/helper/services_helper_function.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';



class MessageModel {
  final String senderName;
  final String senderTitle;
  final String avatarPath;
  final String? text;
  final String? imagePath; // NEW
  final DateTime timestamp;
  final String? docId;

  MessageModel({
    required this.senderName,
    required this.senderTitle,
    required this.avatarPath,
    this.text,
    this.imagePath,
    required this.timestamp,
    this.docId,
  });
}

class EmployeeChatCommentSection extends StatefulWidget {
  const EmployeeChatCommentSection({
    super.key,

    required this.modelId,
  });


  final String modelId;

  @override
  State<EmployeeChatCommentSection> createState() => _EmployeeChatCommentSectionState();
}

class _EmployeeChatCommentSectionState extends State<EmployeeChatCommentSection> {
  bool isExpanded = false;
  final List<MessageModel> messages = [];
  final TextEditingController _controller = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  String _getMonth(int month) {
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return monthNames[month - 1];
  }

  Future<void> _loadComments() async {
    // First, get the request document
    final requestQuerySnapshot = await FirebaseFirestore.instance
        .collection(getBaseUrl(FirestoreCollections.requestServices))
        .where("emailRequester", arrayContains: employeeFunctionHelper.email)
        .get();

    final requestDoc = requestQuerySnapshot.docs.firstWhere(
          (doc) => doc.id == widget.modelId,
      orElse: () => throw Exception("Request document not found"),
    );

    // Now get comments from the subcollection
    final querySnapshot = await requestDoc.reference
        .collection('comments')
        .orderBy('timestamp')
        .get();

    final loadedMessages = querySnapshot.docs.map((doc) {
      final data = doc.data();
      return MessageModel(
        senderName: data['senderName'] ?? '',
        senderTitle: data['senderTitle'] ?? '',
        avatarPath: 'assets/images/avatar1.png',
        text: data['text'],
        imagePath: data['imagePath'],
        timestamp: (data['timestamp'] as Timestamp).toDate(),
        docId: doc.id,
      );
    }).toList();

    setState(() {
      messages.addAll(loadedMessages);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final String firstName = prefs.getString("firstNameRequester") ?? '';
    final String lastName = prefs.getString("lastNameRequester") ?? '';
    final String jobTitle = prefs.getString("jobTitleRequester") ?? '';
    final String fullName = '$firstName $lastName'.trim();

    final DateTime now = DateTime.now();

    final comment = MessageModel(
      senderName: fullName,
      senderTitle: jobTitle,
      avatarPath: 'assets/images/avatar1.png',
      text: text,
      imagePath: null,
      timestamp: now,
    );

    setState(() {
      messages.add(comment);
      _controller.clear();
    });

    // Get the request document
    final requestQuerySnapshot = await FirebaseFirestore.instance
        .collection(getBaseUrl(FirestoreCollections.requestServices))
        .where("emailRequester", arrayContains: employeeFunctionHelper.email)
        .get();

    final requestDoc = requestQuerySnapshot.docs.firstWhere(
          (doc) => doc.id == widget.modelId,
      orElse: () => throw Exception("Request document not found"),
    );

    // Save to Firestore
    await requestDoc.reference
        .collection('comments')
        .add({
      'senderName': comment.senderName,
      'senderTitle': comment.senderTitle,
      'text': comment.text,
      'timestamp': now,
    });
  }

  ///edit message function
  void _editMessage(int index) {
    final MessageModel message = messages[index];
    if (message.text == null || message.docId == null) return;

    final TextEditingController editController = TextEditingController(
      text: message.text,
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
        title: Text(S.of(context).EditMessage),
        content: TextField(
          controller: editController,
          decoration: InputDecoration(
            hintText: S.of(context).Edityourmessage,
          ),
          maxLines: null,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.of(context).Cancel),
          ),
          TextButton(
            onPressed: () async {
              final newText = editController.text.trim();
              if (newText.isNotEmpty) {
                // Update local state
                setState(() {
                  messages[index] = MessageModel(
                    senderName: message.senderName,
                    senderTitle: message.senderTitle,
                    avatarPath: message.avatarPath,
                    text: newText,
                    imagePath: null,
                    timestamp: message.timestamp,
                    docId: message.docId,
                  );
                });

                // Get the request document
                final requestQuerySnapshot = await FirebaseFirestore.instance
                    .collection(getBaseUrl(FirestoreCollections.requestServices))
                    .where("emailRequester", arrayContains: employeeFunctionHelper.email)
                    .get();

                final requestDoc = requestQuerySnapshot.docs.firstWhere(
                      (doc) => doc.id == widget.modelId,
                  orElse: () => throw Exception("Request document not found"),
                );

                // Update Firestore
                await requestDoc.reference
                    .collection('comments')
                    .doc(message.docId)
                    .update({'text': newText});

                Navigator.pop(context);
              }
            },
            child: Text(S.of(context).Save),
          )
        ],
      ),
    );
  }

  ///delete message function
  void _deleteMessage(int index) async {
    final MessageModel message = messages[index];
    if (message.docId == null) return;

    // Get the request document
    final requestQuerySnapshot = await FirebaseFirestore.instance
        .collection(getBaseUrl(FirestoreCollections.requestServices))
        .where("emailRequester", arrayContains: employeeFunctionHelper.email)
        .get();

    final requestDoc = requestQuerySnapshot.docs.firstWhere(
          (doc) => doc.id == widget.modelId,
      orElse: () => throw Exception("Request document not found"),
    );

    // Delete from Firestore
    await requestDoc.reference
        .collection('comments')
        .doc(message.docId)
        .delete();

    // Delete locally
    setState(() {
      messages.removeAt(index);
    });
  }

  Future<void> _launchExternal(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  Widget _buildMediaPreview(MessageModel msg) {
    final imageUrl = msg.imagePath!;
    final isImage = [
      '.jpg',
      '.jpeg',
      '.png',
      '.gif',
    ].any((ext) => imageUrl.toLowerCase().contains(ext));
    final isPDF = imageUrl.toLowerCase().contains('.pdf');

    if (isImage) {
      return GestureDetector(
        onTap: () => _launchExternal(imageUrl),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/image_big.svg',
              width: 35.sp,
              height: 35.sp,
              fit: BoxFit.scaleDown,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                msg.text ?? 'Image',
                style: TextStyle(
                  color: AppColors.blue,
                  decoration: TextDecoration.underline,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    } else if (isPDF) {
      return GestureDetector(
        onTap: () => launchUrl(Uri.parse(imageUrl)),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/pdf.svg',
              width: 35.sp,
              height: 35.sp,
              fit: BoxFit.scaleDown,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                msg.text ?? 'PDF Document',
                style: TextStyle(
                  color: AppColors.blue,
                  decoration: TextDecoration.underline,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    } else {
      return GestureDetector(
        onTap: () => launchUrl(Uri.parse(imageUrl)),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/pdf.svg', // fallback icon
              width: 24,
              height: 24,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                msg.text ?? 'Document',
                style: TextStyle(
                  color: AppColors.blue,
                  decoration: TextDecoration.underline,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }
  }

  // delete or Edit
  void _showCustomMenu(BuildContext context, Offset position, int index) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        String? selectedItem; // to track selection

        return StatefulBuilder(
          builder: (context, setState) {
            return Stack(
              children: [
                Positioned(
                  left: position.dx,
                  top: position.dy,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: 150.w,
                      padding: EdgeInsets.symmetric(vertical: 8.sp),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light ?
                        AppColors.white : AppColors.chatBackground,
                        borderRadius: BorderRadius.circular(8.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.12),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildOptionItem(
                            label: 'Edit',
                            iconPath: "assets/reply.svg",
                            isSelected: selectedItem == 'edit',
                            onTap: () {
                              setState(() => selectedItem = 'edit');
                              Future.delayed(Duration(milliseconds: 150), () {
                                Navigator.pop(context);
                                _editMessage(index);
                              });
                            },
                            selectedColor: AppColors.red,
                            // 🔴
                            selectedBackground: AppColors.primary, // 🟡
                          ),
                          _buildOptionItem(
                            label: 'Delete',
                            iconPath: "assets/icon _trash.svg",
                            isSelected: selectedItem == 'delete',
                            onTap: () {
                              setState(() => selectedItem = 'delete');
                              Future.delayed(Duration(milliseconds: 150), () {
                                Navigator.pop(context);
                                _deleteMessage(index);
                              });
                            },
                            selectedColor: AppColors.red,
                            selectedBackground: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildOptionItem({
    required String label,
    required String iconPath,
    required bool isSelected,
    required VoidCallback onTap,
    required Color selectedColor,
    Color? selectedBackground,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280.sp,
        padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 8.sp),
        decoration: BoxDecoration(
          color:
          isSelected
              ? (selectedBackground ?? AppColors.lightGrey)
              : Colors.transparent,

          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              fit: BoxFit.scaleDown,
              color: isSelected ? selectedColor : AppColors.secondaryText,
              width: 14.sp,
              height: 14.sp,
            ),
            SizedBox(width: 10.sp),
            Text(
              label,
              style: AppTextStyles.font13SecondaryBlackCairo.copyWith(
                color:
                Theme.of(context).brightness == Brightness.light
                    ? AppColors.secondaryText
                    : AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Data Allow To Pick
  Future<void> _pickMedia() async {
    final prefs = await SharedPreferences.getInstance();
    final String firstName = prefs.getString("firstNameRequester") ?? '';
    final String lastName = prefs.getString("lastNameRequester") ?? '';
    final String jobTitle = prefs.getString("jobTitleRequester") ?? '';
    final String fullName = '$firstName $lastName'.trim();

    final choice = await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => SimpleDialog(
        title: Text(S.of(context).selectFileSource),
        children: [
          _buildMediaOption(S.of(context).camera, 'camera'),
          _buildMediaOption(S.of(context).gallery, 'gallery'),
          _buildMediaOption(S.of(context).document, 'document'),
          _buildMediaOption(S.of(context).cancel, null),
        ],
      ),
    );

    if (choice == null) return;

    String? filePath;
    String? fileName;

    if (choice == 'camera' || choice == 'gallery') {
      final source =
      choice == 'camera' ? ImageSource.camera : ImageSource.gallery;
      final XFile? imageFile = await _picker.pickImage(
        source: source,
        imageQuality: 70,
      );
      if (imageFile == null) return;
      filePath = imageFile.path;
      fileName = imageFile.name;
    } else if (choice == 'document') {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );
      if (result == null || result.files.single.path == null) return;
      filePath = result.files.single.path!;
      fileName = result.files.single.name;
    }

    if (filePath == null || fileName == null) return;

    try {
      // Upload to Firebase Storage
      final ref = FirebaseStorage.instance.ref(
        'comments_attachments/${DateTime.now().millisecondsSinceEpoch}_$fileName',
      );
      await ref.putFile(File(filePath));
      final downloadUrl = await ref.getDownloadURL();

      final DateTime now = DateTime.now();

      final message = MessageModel(
        senderName: fullName,
        senderTitle: jobTitle,
        avatarPath: 'assets/pdf.svg',
        text: fileName,
        imagePath: downloadUrl,
        timestamp: now,
      );

      setState(() {
        messages.add(message);
      });

      final requestQuerySnapshot = await FirebaseFirestore.instance
          .collection(getBaseUrl(FirestoreCollections.requestServices))
          .where("emailRequester", arrayContains: employeeFunctionHelper.email)
          .get();

      final requestDoc = requestQuerySnapshot.docs.firstWhere(
            (doc) => doc.id == widget.modelId,
        orElse: () => throw Exception("Request document not found"),
      );

      await requestDoc.reference
          .collection('comments')
          .add({
        'senderName': fullName,
        'senderTitle': jobTitle,
        'text': fileName,
        'imagePath': downloadUrl,
        'timestamp': now,
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(S.of(context).uploadSuccess)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${S.of(context).uploadFailed}: $e')),
      );
    }
  }

  Widget _buildMediaOption(String title, String? returnVal) {
    return Padding(
      padding: EdgeInsets.all(8.sp),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: SimpleDialogOption(
            onPressed: () => Navigator.pop(context, returnVal),
            child: Text(
              title,
              style: AppTextStyles.font14BlackCairoRegular.copyWith(
                color: AppColors.textButton,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // InquiriesAndComments & Expand & Hide
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // InquiriesAndComments
              Text(
                S.of(context).InquiriesAndComments,
                style: AppTextStyles.font22BlackCairoSemiBold.copyWith(
                  color:
                  Theme.of(context).brightness == Brightness.light
                      ? AppColors.blackButton
                      : AppColors.white,
                ),
              ),
              Spacer(),
              // Expand & Hide
              GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Text.rich(
                  TextSpan(
                    text:
                    isExpanded ? S.of(context).Hide : S.of(context).Expand,
                    style: AppTextStyles.font14BlackCairoMedium.copyWith(
                      color: const Color(0xFF1877F2),
                      decoration: TextDecoration.underline,
                      decorationThickness: 1.2,
                      // Optional: controls thickness
                      decorationColor: const Color(0xFF1877F2),
                    ),
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),

          // space
          SizedBox(height: 8.sp),

          if (isExpanded)
            Container(
              decoration: BoxDecoration(
                color:
                Theme.of(context).brightness == Brightness.light
                    ? AppColors.white
                    : AppColors.chatBackground,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                children: [
                  /// Message List
                  if (messages.isNotEmpty)
                  // Comment List View
                    ListView.builder(
                      itemCount: messages.length,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: 15.sp,
                            left: 15.sp,
                            right: 15.sp,
                            top: 15.sp,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              /// Avatar + Name/Title
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipOval(
                                    child: SvgPicture.asset(
                                      "assets/male.svg",
                                      width: 35.sp,
                                      height: 35.sp,
                                      fit: BoxFit.scaleDown,
                                      semanticsLabel: 'Dart Logo',
                                    ),
                                  ),
                                  SizedBox(width: 10.sp),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        msg.senderName,
                                        style: AppTextStyles.font14BlackCairoMedium
                                            .copyWith(
                                          color:AppColors.text
                                        ),
                                      ),
                                      Text(
                                        msg.senderTitle,
                                        style: AppTextStyles.font12BlackMediumCairo
                                            .copyWith(
                                          color:AppColors.secondaryText
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              /// Message or Image Bubble
                              GestureDetector(
                                onLongPressStart: (details) {
                                  _showCustomMenu(
                                    context,
                                    details.globalPosition,
                                    index,
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10.sp),
                                  child: Container(
                                    padding:
                                    msg.text != null
                                        ? EdgeInsets.symmetric(
                                      horizontal: 14.sp,
                                      vertical: 12.sp,
                                    )
                                        : EdgeInsets.all(8.sp),
                                    decoration: BoxDecoration(
                                      color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                          ? AppColors.background
                                          : AppColors.background,
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child:
                                    msg.imagePath != null
                                        ? _buildMediaPreview(msg)
                                        : Text(msg.text ?? ''),
                                  ),
                                ),
                              ),

                              /// Timestamp
                              Padding(
                                padding: EdgeInsets.only(top: 8.sp),
                                child: Text(
                                  "${msg.timestamp.day} ${_getMonth(msg.timestamp.month)} ${msg.timestamp.year} At ${msg.timestamp.hour}:${msg.timestamp.minute.toString().padLeft(2, '0')} PM",
                                  style: AppTextStyles.font10BlackCairoRegular.copyWith(
                                    color:
                                    Theme.of(context).brightness ==
                                        Brightness.light
                                        ? AppColors.secondaryText
                                        : AppColors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                  /// Input Comment Box
                  Padding(
                    padding: EdgeInsets.only(top: 15.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 15.sp),
                        Expanded(
                          child: Container(
                            height: 38.sp,
                            decoration: BoxDecoration(
                              color:
                              Theme.of(context).brightness == Brightness.light
                                  ? AppColors.background
                                  : AppColors.chatBackground,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 38.sp,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                          ? AppColors.white
                                          : AppColors.chatBackground,
                                    ),
                                    child: TextField(
                                      controller: _controller,
                                      decoration: InputDecoration(
                                        prefixIcon: Padding(
                                          padding: EdgeInsets.all(10.sp),
                                          child: GestureDetector(
                                            onTap: _pickMedia,
                                            child: SvgPicture.asset(
                                              "assets/uploadcamera.svg",
                                              width: 16.sp,
                                              height: 16.sp,
                                              color:
                                              Theme.of(context).brightness ==
                                                  Brightness.light
                                                  ? AppColors.secondaryText
                                                  : AppColors.whiteShadow,
                                              fit: BoxFit.scaleDown,
                                            ),
                                          ),
                                        ),
                                        hintText: S.of(context).WriteaComment,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                          borderSide:
                                          BorderSide
                                              .none, // No border line at all
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                        filled: true,
                                        fillColor:
                                        Theme.of(context).brightness ==
                                            Brightness.light
                                            ? AppColors.background
                                            : AppColors.background,
                                        hoverColor: Colors.transparent,
                                        hintStyle: AppTextStyles.font14BlackCairoMedium
                                            .copyWith(
                                          color:
                                          Theme.of(context).brightness ==
                                              Brightness.light
                                              ? AppColors.secondaryText
                                              : AppColors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 15.sp),
                        GestureDetector(
                          onTap: () async => await _sendMessage(),
                          child: Container(
                            width: 35.sp,
                            height: 35.sp,
                            decoration: BoxDecoration(
                              color: AppColors.secondaryPrimary,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: SvgPicture.asset(
                              "assets/save.svg",
                              width: 20.sp,
                              height: 20.sp,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),

                        SizedBox(width: 15.sp),
                      ],
                    ),
                  ),

                  SizedBox(height: 15.sp),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/network/get_base_url.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/custom/2-custom_textfield.dart';
import 'package:demo_app/core/custom/5-custom_button.dart';
import 'package:demo_app/core/constants/services_management/constant.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';


class MessageModel {
  final String senderName;
  final String senderTitle;
  final String avatarPath;
  final String? text;
  final String? imagePath;
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

class ChatCommentSectionRequest extends StatefulWidget {
  const ChatCommentSectionRequest({
    super.key,
    required this.modelId,
  });

  final String modelId;

  @override
  State<ChatCommentSectionRequest> createState() => _ChatCommentSectionRequestState();
}

class _ChatCommentSectionRequestState extends State<ChatCommentSectionRequest> {
  bool isExpanded = false;
  final List<MessageModel> messages = [];
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final GlobalKey _commentSectionKey = GlobalKey();

  String _getMonth(int month) {
    const monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return monthNames[month - 1];
  }

  Future<void> _loadComments() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection(getBaseUrl(FirestoreCollections.requestServices))
        .doc(widget.modelId)
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

  void _scrollToCommentSection() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox? renderBox = _commentSectionKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final position = renderBox.localToGlobal(Offset.zero);
        final scrollController = Scrollable.of(context);

        scrollController.position.ensureVisible(
          renderBox,
          alignment: 0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
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

    await FirebaseFirestore.instance
        .collection(getBaseUrl(FirestoreCollections.requestServices))
        .doc(widget.modelId)
        .collection('comments')
        .add({
      'senderName': comment.senderName,
      'senderTitle': comment.senderTitle,
      'text': comment.text,
      'timestamp': now,
    });
  }

  void _editMessage(int index) {
    final MessageModel message = messages[index];
    if (message.text == null || message.docId == null) return;

    final TextEditingController editController = TextEditingController(text: message.text);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).EditMessage),
        content: CustomTextField(
          controller: editController,
          hint: S.of(context).Edityourmessage,
          maxLines: null,
        ),
        actions: [
          customButton(
            title: S.of(context).Cancel,
            function: () => Navigator.pop(context),
            width: 90.sp,
            height: 36.sp,

            color: AppColors.card,
            textColor: AppColors.text,
          ),
          customButton(
            title: S.of(context).Save,
            width: 90.sp,
            height: 36.sp,
            color: AppColors.primary,
            textColor: AppColors.textButton,
            function: () async {
              final newText = editController.text.trim();
              if (newText.isNotEmpty) {
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

                await FirebaseFirestore.instance
                    .collection(getBaseUrl(FirestoreCollections.requestServices))
                    .doc(widget.modelId)
                    .collection('comments')
                    .doc(message.docId)
                    .update({'text': newText});

                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  void _deleteMessage(int index) async {
    final MessageModel message = messages[index];
    if (message.docId == null) return;

    await FirebaseFirestore.instance
        .collection(getBaseUrl(FirestoreCollections.requestServices))
        .doc(widget.modelId)
        .collection('comments')
        .doc(message.docId)
        .delete();

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
    final isImage = ['.jpg', '.jpeg', '.png', '.gif']
        .any((ext) => imageUrl.toLowerCase().contains(ext));
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
              'assets/pdf.svg',
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

  void _showCustomMenu(BuildContext context, Offset position, int index) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        String? selectedItem;

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
                        color: Theme.of(context).brightness == Brightness.light
                            ? AppColors.white
                            : AppColors.chatBackground,
                        borderRadius: BorderRadius.circular(8.r),
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
                            selectedBackground: AppColors.primary,
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
          color: isSelected
              ? selectedBackground
              : Theme.of(context).brightness == Brightness.light
              ? AppColors.white
              : AppColors.chatBackground,
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
                color: Theme.of(context).brightness == Brightness.light
                    ? AppColors.secondaryText
                    : AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickMedia() async {
    final isDesktop = !kIsWeb && (Platform.isMacOS || Platform.isLinux || Platform.isWindows);

    final prefs = await SharedPreferences.getInstance();
    final String firstName = prefs.getString("firstNameRequester") ?? '';
    final String lastName = prefs.getString("lastNameRequester") ?? '';
    final String jobTitle = prefs.getString("jobTitleRequester") ?? '';
    final String fullName = '$firstName $lastName'.trim();

    final choice = await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (context) => SimpleDialog(
        title: Text(S.of(context).selectFileSource),
        children: [
          if (!isDesktop) _buildMediaOption(S.of(context).camera, 'camera'),
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
      final source = choice == 'camera' ? ImageSource.camera : ImageSource.gallery;
      final XFile? imageFile = await _picker.pickImage(source: source, imageQuality: 70);
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
      final ref = FirebaseStorage.instance
          .ref('comments_attachments/${DateTime.now().millisecondsSinceEpoch}_$fileName');
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

      await FirebaseFirestore.instance
          .collection(getBaseUrl(FirestoreCollections.requestServices))
          .doc(widget.modelId)
          .collection('comments')
          .add({
        'senderName': fullName,
        'senderTitle': jobTitle,
        'text': fileName,
        'imagePath': downloadUrl,
        'timestamp': now,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).uploadSuccess)),
      );
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
    var isMobile = context.isPhone;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.sp),
      child: Column(
        key: _commentSectionKey,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // InquiriesAndComments & Expand & Hide
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // InquiriesAndComments
              Text(
                S.of(context).InquiriesAndComments,
                style: isMobile
                    ? AppTextStyles.font16BlackMediumCairo.copyWith(
                    color: Theme.of(context).brightness == Brightness.light
                        ? AppColors.blackButton
                        : AppColors.white)
                    : AppTextStyles.font22BlackCairoSemiBold.copyWith(
                    color: Theme.of(context).brightness == Brightness.light
                        ? AppColors.blackButton
                        : AppColors.white),
              ),
              Spacer(),
              // Expand & Hide with Animated Icon
              GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });

                  // Auto scroll to comment section when expanding
                  if (isExpanded) {
                    Future.delayed(const Duration(milliseconds: 100), () {
                      _scrollToCommentSection();
                    });
                  }
                },
                child: Row(
                  children: [
                    Text(
                      isExpanded ? S.of(context).Hide : S.of(context).Expand,
                      style: AppTextStyles.font14BlackCairoMedium.copyWith(
                        color: const Color(0xFF1877F2),
                        decoration: TextDecoration.underline,
                        decorationThickness: 1.2,
                        decorationColor: const Color(0xFF1877F2),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // space
          SizedBox(height: 8.sp),

          // Animated Container with Size and Opacity
          AnimatedSize(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutCubic,
            child: isExpanded
                ? AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeIn,
              child: Container(
                padding: EdgeInsets.only(bottom: 15.sp),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light
                      ? AppColors.white
                      : AppColors.chatBackground,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  children: [
                    /// Message List
                    if (messages.isNotEmpty)
                      ListView.builder(
                        itemCount: messages.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final msg = messages[index];
                          return TweenAnimationBuilder<double>(
                            duration: Duration(milliseconds: 300 + (index * 50)),
                            curve: Curves.easeOutCubic,
                            tween: Tween(begin: 0.0, end: 1.0),
                            builder: (context, value, child) {
                              return Transform.translate(
                                offset: Offset(0, 20 * (1 - value)),
                                child: Opacity(
                                  opacity: value,
                                  child: child,
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom: 15.sp,
                                left: 15.sp,
                                right: 15.sp,
                                top: index == 0 ? 15.sp : 0,
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            msg.senderName,
                                            style: AppTextStyles.font14BlackCairoMedium.copyWith(
                                              color: Theme.of(context).brightness == Brightness.light
                                                  ? AppColors.blackButton
                                                  : AppColors.white,
                                            ),
                                          ),
                                          Text(
                                            msg.senderTitle,
                                            style: AppTextStyles.font12BlackMediumCairo.copyWith(
                                              color: Theme.of(context).brightness == Brightness.light
                                                  ? AppColors.secondaryText
                                                  : AppColors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  /// Message or Image Bubble
                                  GestureDetector(
                                    onLongPressStart: (details) {
                                      _showCustomMenu(context, details.globalPosition, index);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 10.sp),
                                      child: Container(
                                        padding: msg.text != null
                                            ? EdgeInsets.symmetric(horizontal: 14.sp, vertical: 12.sp)
                                            : EdgeInsets.all(8.sp),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).brightness == Brightness.light
                                              ? AppColors.background
                                              : AppColors.background,
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                        child: msg.imagePath != null
                                            ? _buildMediaPreview(msg)
                                            : Text(
                                          msg.text ?? '',
                                          style: AppTextStyles.font12BlackCairoRegular,
                                        ),
                                      ),
                                    ),
                                  ),

                                  /// Timestamp
                                  Padding(
                                    padding: EdgeInsets.only(top: 8.sp),
                                    child: Text(
                                      "${msg.timestamp.day} ${_getMonth(msg.timestamp.month)} ${msg.timestamp.year} At ${msg.timestamp.hour}:${msg.timestamp.minute.toString().padLeft(2, '0')} PM",
                                      style: AppTextStyles.font10BlackCairoRegular.copyWith(
                                        color: Theme.of(context).brightness == Brightness.light
                                            ? AppColors.secondaryText
                                            : AppColors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                    // space
                    SizedBox(height: 15.sp),

                    /// Input Comment Box
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 15.sp),
                        Expanded(
                          child: Container(
                            height: 38.sp,
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.light
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
                                      color: Theme.of(context).brightness == Brightness.light
                                          ? AppColors.white
                                          : AppColors.chatBackground,
                                    ),
                                    child: CustomTextField(
                                      controller: _controller,
                                      hint: S.of(context).WriteaComment,
                                      fillColor: AppColors.background,
                                      borderRadius: BorderRadius.circular(8.r),
                                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8.w),
                                      valueStyle: AppTextStyles.font14BlackCairoMedium.copyWith(
                                        height: 1.4,
                                      ),
                                      hintStyle: AppTextStyles.font14BlackCairoMedium.copyWith(
                                        color: Theme.of(context).brightness == Brightness.light
                                            ? AppColors.secondaryText
                                            : AppColors.grey,
                                      ),
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.all(10.sp),
                                        child: GestureDetector(
                                          onTap: _pickMedia,
                                          child: SvgPicture.asset(
                                            "assets/uploadcamera.svg",
                                            width: 16.sp,
                                            height: 16.sp,
                                            color: Theme.of(context).brightness == Brightness.light
                                                ? AppColors.secondaryText
                                                : AppColors.whiteShadow,
                                            fit: BoxFit.scaleDown,
                                          ),
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
                  ],
                ),
              ),
            )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

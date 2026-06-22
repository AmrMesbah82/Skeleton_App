import 'package:flutter/material.dart';
import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/theme/app_colors.dart';

class InquiriesAndCommentsWidget extends StatefulWidget {
  const InquiriesAndCommentsWidget({super.key});

  @override
  State<InquiriesAndCommentsWidget> createState() =>
      _InquiriesAndCommentsWidgetState();
}

class _InquiriesAndCommentsWidgetState extends State<InquiriesAndCommentsWidget> {
  bool isVisible = true;
  final TextEditingController _controller = TextEditingController();

  final List<_ChatItem> _chatItems = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with Hide toggle
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                "Inquiries And Comments",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
                child: Text(
                  isVisible ? "Hide" : "Expand",
                  style: TextStyle(
                    color: AppColors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Chat content
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: isVisible ? null : 0,
          child: Visibility(
            visible: isVisible,
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _chatItems.length,
                  itemBuilder: (_, index) {
                    final item = _chatItems[index];
                    return item.isAttachment
                        ? _attachmentBubble(index)
                        : _textComment(item.text!);
                  },
                ),
              ],
            ),
          ),
        ),

        // Input Section
        if (isVisible)
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.alternate_email, color: AppColors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Write a Comment",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty) {
                      setState(() {
                        _chatItems.add(
                          _ChatItem(
                            text: _controller.text.trim(),
                            isAttachment: false,
                          ),
                        );
                        _controller.clear();
                      });
                    }
                  },
                  icon: const Icon(Icons.send, color: Color(0xFFFFD73E)),
                ),
                IconButton(
                  onPressed: () {
                    // Simulate attachment
                    setState(() {
                      _chatItems.add(
                        _ChatItem(isAttachment: true, fileName: "Resume.pdf"),
                      );
                    });
                  },
                  icon: Icon(Icons.attach_file, color: AppColors.grey),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _textComment(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage("assets/images/person.png"),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Ahmed Ali",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                 Text(
                  "Marketing lead",
                  style: TextStyle(color: AppColors.grey, fontSize: 12),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(text),
                ),
                const SizedBox(height: 4),
                 Text(
                  "24 Jan 2024 At 12:00 PM",
                  style: TextStyle(fontSize: 11, color: AppColors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _attachmentBubble(int index) {
    final item = _chatItems[index];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const SizedBox(width: 10),
                  const CircleAvatar(
                    radius: 16,
                    backgroundImage: AssetImage("assets/images/person.png"),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                "Ahmed Ali",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
               Text(
                "Marketing lead",
                style: TextStyle(fontSize: 12, color: AppColors.grey),
              ),

              const SizedBox(height: 6),
              Container(
                width: 240,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.lightGrey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                     Icon(Icons.picture_as_pdf, color: AppColors.red),
                    const SizedBox(width: 8),
                    Expanded(child: Text(item.fileName ?? '')),
                    const Text("KB", style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                   Text(
                    "24 Jan 2024 At 12:00 PM",
                    style: TextStyle(fontSize: 11, color: AppColors.grey),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _actionButton("Edit", Icons.edit, () {
                    _editAttachment(index);
                  }),
                  const SizedBox(width: 8),
                  _actionButton("Delete", Icons.delete, () {
                    setState(() {
                      _chatItems.removeAt(index);
                    });
                  }, bgColor: AppColors.yellow),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _editAttachment(int index) {
    showDialog(
      context: context,
      builder: (context) {
        final editController = TextEditingController(
          text: _chatItems[index].fileName ?? '',
        );
        return AlertDialog(
          title: Text(S.of(context).editFileName),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(hintText: "Enter file name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _chatItems[index].fileName = editController.text.trim();
                });
                Navigator.pop(context);
              },
              child: Text(S.of(context).Save),
            ),
          ],
        );
      },
    );
  }

  Widget _actionButton(
    String label,
    IconData icon,
    VoidCallback onTap, {
    Color bgColor = const Color(0xFFF5F5F5),
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 4),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class _ChatItem {
  final String? text;
  String? fileName;
  final bool isAttachment;

  _ChatItem({this.text, this.fileName, required this.isAttachment});
}

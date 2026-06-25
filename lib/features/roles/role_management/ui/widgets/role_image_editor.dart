import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:demo_app/core/constants/skeleton_assets.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/features/roles/role_management/controller/role_cubit.dart';

class RoleImageEditor extends StatefulWidget {
  RoleImageEditor({super.key});

  @override
  State<RoleImageEditor> createState() => _RoleImageEditorState();
}

class _RoleImageEditorState extends State<RoleImageEditor> {
  late RoleCubit controller;

  @override
  Widget build(BuildContext context) {
    controller = context.read<RoleCubit>();

    return BlocListener<RoleCubit, RoleState>(
      listener: (context, state) {
        if (state is RoleError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        } else if (state is RoleImagePicked) {
          setState(() {});
        }
      },
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          CircleAvatar(
            radius: 32.r,
            backgroundColor: AppColors.grey,
            child: controller.roleImage != null
                ? CircleAvatar(
              radius: 32.r,
              backgroundImage:
              FileImage(controller.roleImage!.absolute),
            )
                : controller.selectedRole?.currentRoleImage != null &&
                controller
                    .selectedRole!.currentRoleImage.isNotEmpty
                ? CircleAvatar(
              radius: 32.r,
              backgroundImage: NetworkImage(
                controller.selectedRole!.currentRoleImage,
              ),
              onBackgroundImageError: (_, __) {},
            )
                : Container(
              padding: EdgeInsets.all(8.sp),
              child: SvgPicture.asset(
                SkeletonAssets.roleIcon,
                width: 26.sp,
                height: 26.sp,
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              await controller.pickRoleImage(camera: false);
            },
            child: CircleAvatar(
              radius: 12.r,
              backgroundColor: AppColors.primary,
              child: SvgPicture.asset(
                SkeletonAssets.cameraIcon,
                width: 16.w,
                height: 16.h,
                color: AppColors.textButton,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
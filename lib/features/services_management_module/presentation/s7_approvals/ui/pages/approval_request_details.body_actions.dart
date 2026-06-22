part of 'approval_request_details.dart';

// Auto-extracted to keep files under 600 lines.
extension _ApprovalBodyActions on _ApprovalDetailsScreenState {
  Widget _buildApprovalActions(BuildContext context, String? myState, String displayServiceName) {
    return widget.fromTable
                                ? SizedBox()
                                : ApprovalButtons(
                              myState: myState,
                              documentState: currentState,
                              onApprove: () {
                                CustomDialogManager.showDialogFlow(
                                  context: context,
                                  customReasonTitle:
                                  S.of(context).reasonOfApproval,
                                  confirmLottie:
                                  'assets/lottie/approved.json',
                                  confirmTitle:
                                  S.of(context).ApproveRequest,
                                  confirmSubtitle: S
                                      .of(context)
                                      .AreYouSureYouWantToApproveThisRequest,
                                  confirmYesText: S.of(context).yes,
                                  confirmNoText: S.of(context).no,
                                  onConfirm: () {},
                                  comment: true,
                                  commentRequired: false,
                                  commentController: approveController,
                                  commentSubmitText: S.of(context).submit,
                                  commentDiscardText: S.of(context).discard,
                                  onCommentSubmit: () async {
                                    final email = employeeFunctionHelper.email;
                                    final serviceId = widget.approvalModel.currentId;
                                    final requesterEmail = widget.approvalModel.currentEmailRequester;

                                    if (email == null || email.isEmpty) {
                                      return;
                                    }

                                    try {
                                      final cubit = ServicesManagerCubit.get(context);
                                      final firestoreDocId = cubit.serviceIdToFirestoreDocId[serviceId] ?? serviceId;

                                      final tenantRoot = getBaseUrl(FirestoreCollections.requestServices);
                                      final docPath = '$tenantRoot/$firestoreDocId';

                                      final docSnapshot = await FirebaseFirestore.instance.doc(docPath).get();

                                      if (!docSnapshot.exists) {
                                        return;
                                      }

                                      final docData = docSnapshot.data() as Map<String, dynamic>;

                                      final approvalCycleField = docData['Approval_Cycle'] ?? docData['approvalCycle'];

                                      if (approvalCycleField == null) {
                                        return;
                                      }

                                      final approvalCycleArray = approvalCycleField is List
                                          ? approvalCycleField
                                          : [approvalCycleField];

                                      bool updated = false;
                                      int itemIndex = -1;

                                      for (int i = 0; i < approvalCycleArray.length; i++) {
                                        final item = approvalCycleArray[i];

                                        if (item is String) {
                                          try {
                                            final decoded = jsonDecode(item);

                                            if (decoded is List) {

                                              for (int j = 0; j < decoded.length; j++) {
                                                final emp = decoded[j];
                                                final empEmail = emp['email']?.toString().toLowerCase() ?? '';
                                                final empState = emp['state']?.toString().toLowerCase() ?? '';

                                                if (empEmail == email.toLowerCase()) {
                                                  emp['state'] = 'approved';

                                                  final updatedJsonString = jsonEncode(decoded);
                                                  approvalCycleArray[i] = updatedJsonString;

                                                  updated = true;
                                                  itemIndex = i;
                                                  break;
                                                }
                                              }
                                            }
                                          } catch (e) {
                                          }
                                        }

                                        if (updated) break;
                                      }

                                      if (!updated) {
                                        return;
                                      }

                                      final myIndex = widget.approvalModel.currentApprovalCycle.indexWhere(
                                              (e) => (e.email ?? '').toLowerCase() == email.toLowerCase()
                                      );

                                      final isLastApprover = (myIndex == widget.approvalModel.currentApprovalCycle.length - 1);

                                      Map<String, dynamic> updateData = {
                                        'Approval_Cycle': approvalCycleArray,
                                        'approveComment': approveController.text,
                                        'timestamps': FieldValue.arrayUnion([DateTime.now().millisecondsSinceEpoch]),
                                      };

                                      if (isLastApprover) {
                                        updateData['state'] = ['approved'];
                                      }

                                      await FirebaseFirestore.instance.doc(docPath).update(updateData);

                                      if (requesterEmail != null && requesterEmail.isNotEmpty) {
                                        await _sendNotificationToRequester(
                                          action: 'approved',
                                          requesterEmail: requesterEmail,
                                          serviceName: displayServiceName,
                                        );
                                      }

                                      cubit.getAllServices();
                                      cubit.getMyRequestServices();
                                      cubit.loadProviderPerDocument();
                                      await cubit.getMyApprovalServices(email);

                                      setState(() {});
                                    } catch (e, st) {
                                    }
                                  },
                                  successLottie:
                                  'assets/lottie/approved.json',
                                  successTitle: S.of(context).Successful,
                                  successSubtitle: S
                                      .of(context)
                                      .YouSuccessfullyApprovedThisRequest,
                                  onSuccessDismissed: () {
                                    Future.delayed(
                                        const Duration(seconds: 1), () {
                                      navigateTo(context, ApprovalToggle());
                                    });
                                  },
                                );
                              },
                              onReject: () {
                                CustomDialogManager.showDialogFlow(
                                  context: context,
                                  customReasonTitle:
                                  S.of(context).reasonOfRejection,
                                  confirmLottie:
                                  'assets/lottie/rejected.json',
                                  confirmTitle: S.of(context).RejectRequest,
                                  confirmSubtitle: S
                                      .of(context)
                                      .AreYouSureYouWantToRejectThisRequest,
                                  confirmYesText: S.of(context).yes,
                                  confirmNoText: S.of(context).no,
                                  onConfirm: () {},
                                  comment: true,
                                  commentRequired: true,
                                  commentController: rejectController,
                                  commentSubmitText: S.of(context).submit,
                                  commentDiscardText: S.of(context).discard,
                                  onCommentSubmit: () async {
                                    final email =
                                        employeeFunctionHelper.email;
                                    final serviceId =
                                        widget.approvalModel.currentId;
                                    final requesterEmail = widget
                                        .approvalModel
                                        .currentEmailRequester;

                                    if (email == null || email.isEmpty) {
                                      return;
                                    }

                                    try {
                                      final cubit =
                                      ServicesManagerCubit.get(context);
                                      final firestoreDocId =
                                      cubit.serviceIdToFirestoreDocId[
                                      serviceId];

                                      if (firestoreDocId == null ||
                                          firestoreDocId.isEmpty) {
                                        return;
                                      }

                                      final tenantRoot = getBaseUrl(
                                          FirestoreCollections
                                              .requestServices);
                                      final docPath =
                                          '$tenantRoot/$firestoreDocId';

                                      final docSnapshot =
                                      await FirebaseFirestore.instance
                                          .doc(docPath)
                                          .get();

                                      if (!docSnapshot.exists) {
                                        return;
                                      }

                                      final docData = docSnapshot.data()
                                      as Map<String, dynamic>;
                                      final approvalCycleArray =
                                          docData['approvalCycle']
                                          as List<dynamic>? ??
                                              [];

                                      bool updated = false;
                                      for (int i = 0;
                                      i < approvalCycleArray.length;
                                      i++) {
                                        final item = approvalCycleArray[i];

                                        if (item is String) {
                                          try {
                                            final decoded =
                                            jsonDecode(item);

                                            if (decoded is List) {
                                              for (var emp in decoded) {
                                                if (emp is Map &&
                                                    (emp['email']
                                                        ?.toString()
                                                        .toLowerCase() ==
                                                        email
                                                            .toLowerCase())) {
                                                  emp['state'] = 'rejected';

                                                  final updatedJsonString =
                                                  jsonEncode(decoded);
                                                  approvalCycleArray[i] =
                                                      updatedJsonString;

                                                  updated = true;
                                                  break;
                                                }
                                              }
                                            }
                                          } catch (e) {}
                                        }

                                        if (updated) break;
                                      }

                                      if (!updated) {
                                        return;
                                      }

                                      Map<String, dynamic> updateData = {
                                        'approvalCycle': approvalCycleArray,
                                        'rejectComment':
                                        rejectController.text,
                                        'timestamps':
                                        FieldValue.arrayUnion([
                                          DateTime.now()
                                              .millisecondsSinceEpoch
                                        ]),
                                        'state': FieldValue.arrayUnion([
                                          'rejected'
                                        ]),
                                      };

                                      await FirebaseFirestore.instance
                                          .doc(docPath)
                                          .update(updateData);

                                      if (requesterEmail != null &&
                                          requesterEmail.isNotEmpty) {
                                        await _sendNotificationToRequester(
                                          action: 'rejected',
                                          requesterEmail: requesterEmail,
                                          serviceName: displayServiceName,
                                        );
                                      }

                                      cubit.getAllServices();
                                      cubit.getMyRequestServices();
                                      cubit.loadProviderPerDocument();
                                      cubit.getMyApprovalServices(email);

                                      setState(() {});
                                    } catch (e, st) {
                                    }
                                  },
                                  successLottie:
                                  'assets/lottie/rejected.json',
                                  successTitle: S.of(context).RejectRequest,
                                  successSubtitle: S
                                      .of(context)
                                      .YouSuccessfullyRejectedThisRequest,
                                  onSuccessDismissed: () {
                                    Future.delayed(
                                        const Duration(seconds: 1), () {
                                      navigateTo(context, ApprovalToggle());
                                    });
                                  },
                                );
                              },
                            );
  }

  List<Widget> _buildCommentReasons(BuildContext context) {
    final isMobile = context.isPhone;
    return [
                            if (cancelReason != null && cancelReason!.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(top: 12.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 0.sp),
                                      child: SvgPicture.asset(
                                        "assets/status.svg",
                                        width: 16.sp,
                                        height: 16.sp,
                                        fit: BoxFit.cover,
                                        color: AppColors.red,
                                      ),
                                    ),
                                    SizedBox(width: 6.sp),
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          style: AppTextStyles.font14BlackCairoMedium
                                              .copyWith(
                                            color: Theme.of(context).brightness ==
                                                Brightness.light
                                                ? AppColors.red
                                                : AppColors.secondaryText,
                                          ),
                                          children: [
                                            TextSpan(
                                              text:
                                              "${S.of(context).ReasonOfCancelation}: ",
                                              style: AppTextStyles.font14BlackCairoMedium
                                                  .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.red,
                                              ),
                                            ),
                                            TextSpan(
                                              text: FormatHelper.capitalize(
                                                  cancelReason!),
                                              style: AppTextStyles.font14BlackCairoMedium
                                                  .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.text,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            if (rejectCommentText.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(top: 12.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/status.svg",
                                      width: isMobile ? 12.sp : 16.sp,
                                      height: isMobile ? 12.sp : 16.sp,
                                      color: AppColors.red,
                                    ),
                                    SizedBox(width: 6.sp),
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          style: AppTextStyles.font14BlackCairoMedium
                                              .copyWith(
                                            color: AppColors.red,
                                          ),
                                          children: [
                                            TextSpan(
                                              text:
                                              "${S.of(context).ReasonOfRejection} ",
                                              style: isMobile
                                                  ? AppTextStyles.font12BlackMediumCairo
                                                  .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.red,
                                              )
                                                  : AppTextStyles.font14BlackCairoMedium
                                                  .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.red,
                                              ),
                                            ),
                                            TextSpan(
                                              text: FormatHelper.capitalize(
                                                  rejectCommentText),
                                              style: isMobile
                                                  ? AppTextStyles.font12BlackMediumCairo
                                                  .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.text,
                                              )
                                                  : AppTextStyles.font14BlackCairoMedium
                                                  .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.text,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            if (approveCommentText.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(top: 12.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/status.svg",
                                      width: isMobile ? 12.sp : 16.sp,
                                      height: isMobile ? 12.sp : 16.sp,
                                      color: AppColors.lightGreen,
                                    ),
                                    SizedBox(width: 6.sp),
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          style: AppTextStyles.font14BlackCairoMedium
                                              .copyWith(
                                            color: AppColors.lightGreen,
                                          ),
                                          children: [
                                            TextSpan(
                                              text:
                                              "${S.of(context).ReasonOfApprove} ",
                                              style: isMobile
                                                  ? AppTextStyles.font12BlackMediumCairo
                                                  .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.red,
                                              )
                                                  : AppTextStyles.font14BlackCairoMedium
                                                  .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.lightGreen,
                                              ),
                                            ),
                                            TextSpan(
                                              text: FormatHelper.capitalize(
                                                  approveCommentText),
                                              style: isMobile
                                                  ? AppTextStyles.font12BlackMediumCairo
                                                  .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.text,
                                              )
                                                  : AppTextStyles.font14BlackCairoMedium
                                                  .copyWith(
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  color: AppColors.text),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
    ];
  }

}

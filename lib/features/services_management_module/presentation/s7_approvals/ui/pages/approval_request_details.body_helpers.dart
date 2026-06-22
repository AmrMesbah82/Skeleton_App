part of 'approval_request_details.dart';

// Auto-extracted to keep files under 600 lines.
extension _ApprovalBodyHelpers on _ApprovalDetailsScreenState {
  Widget buildRequesterDetailsSection(
      BuildContext context, {
        required String? firstName,
        required String? lastName,
        required String? jobTitle,
        required String? department,
      })
  {
    final requesterName =
        "${FormatHelper.capitalize(firstName ?? '-')} ${FormatHelper.capitalize(lastName ?? '-')}";
    final isMobile = context.isPhone;
    final isTabletCheck = MediaQuery.sizeOf(context).width >= 600 &&
        MediaQuery.sizeOf(context).width < 900;

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomRowDetailsMaster(
            data: requesterName,
            image: "assets/images/details/User Plus.svg",
            title: "${S.of(context).Requestedby}: ",
          ),
          SizedBox(height: 5.sp),
          CustomRowDetailsMaster(
            data: department ?? '-',
            image: "assets/images/details/Case.svg",
            title: "${S.of(context).Department}: ",
          ),
          SizedBox(height: 10.sp),
          CustomRowDetailsMaster(
            data: FormatHelper.capitalize(jobTitle ?? '-'),
            image: "assets/images/details/Case.svg",
            title: "${S.of(context).jobTitle}: ",
          ),
        ],
      );
    }

    if (isTabletCheck) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomRowDetailsMaster(
                data: requesterName,
                image: "assets/images/details/User Plus.svg",
                title: "${S.of(context).Requestedby}: ",
              ),
              SizedBox(height: 5.sp),
              CustomRowDetailsMaster(
                data: department ?? '-',
                image: "assets/images/details/Case.svg",
                title: "${S.of(context).Department}: ",
              ),
            ],
          ),
          SizedBox(width: MediaQuery.sizeOf(context).width * .15),
          Column(
            children: [
              CustomRowDetailsMaster(
                data: FormatHelper.capitalize(jobTitle ?? '-'),
                image: "assets/images/details/Case.svg",
                title: "${S.of(context).jobTitle}: ",
              ),
            ],
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: CustomRowDetailsMaster(
            data: requesterName,
            image: "assets/images/details/User Plus.svg",
            title: "${S.of(context).Requestedby}: ",
          ),
        ),
        SizedBox(height: 5.sp),
        Expanded(
          child: CustomRowDetailsMaster(
            data: department ?? '-',
            image: "assets/images/details/Case.svg",
            title: "${S.of(context).Department}: ",
          ),
        ),
        Expanded(
          child: CustomRowDetailsMaster(
            data: FormatHelper.capitalize(jobTitle ?? '-'),
            image: "assets/images/details/Case.svg",
            title: "${S.of(context).jobTitle}: ",
          ),
        ),
      ],
    );
  }

  Widget descriptionWidget(String description) {
    var isMobile = context.isPhone;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              child: SvgPicture.asset(
                "assets/des.svg",
                width: 16.w,
                height: 16.h,
                color: AppColors.secondaryText.withOpacity(.5),
                fit: BoxFit.scaleDown,
                semanticsLabel: 'Description Icon',
              ),
            ),
            SizedBox(width: 3.w),
            Text(
              "${S.of(context).serviceDescription} : ",
              style: isMobile
                  ? AppTextStyles.font12BlackCairoRegular.copyWith(
                color: AppColors.secondaryText,
              )
                  : AppTextStyles.font14BlackCairoRegular.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
        SizedBox(height: 5.sp),
        Text(
          FormatHelper.capitalize(description),
          style: isMobile
              ? AppTextStyles.font10BlackCairoRegular.copyWith(
            wordSpacing: -1.sp,
            color: AppColors.text,
          )
              : AppTextStyles.font13SecondaryBlackCairo.copyWith(
            color: AppColors.text,
          ),
          textAlign: TextAlign.start,
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
      ],
    );
  }

  Widget _buildProviderSection(BuildContext context) {
    return Builder(
                              builder: (context) {
                                List<EmployeeEntityModell> providersList;

                                try {
                                  providersList = _currentModel.currentProviderServices;
                                } catch (e) {
                                  providersList = [];
                                }

                                if (providersList.isEmpty) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20.h),
                                    child: Container(
                                      padding: EdgeInsets.all(16.sp),
                                      decoration: BoxDecoration(
                                        color: AppColors.card,
                                        borderRadius: BorderRadius.circular(8.r),
                                        border: Border.all(
                                          color: AppColors.secondaryText
                                              .withOpacity(0.2),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.info_outline,
                                                color: AppColors.secondaryText,
                                                size: 20.sp,
                                              ),
                                              SizedBox(width: 8.sp),
                                              Expanded(
                                                child: Text(
                                                  'No service provider assigned to this request',
                                                  style: StyleText
                                                      .fontSize14Weight400
                                                      .copyWith(
                                                    color:
                                                    AppColors.secondaryText,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (widget.fromTable) ...[
                                            SizedBox(height: 12.sp),
                                            GestureDetector(
                                              onTap: () async {
                                                navigateTo(
                                                  context,
                                                  ServicesProviderLayout(
                                                    editingModel: _currentModel,
                                                    docId: _currentModel.currentId,
                                                    editProvider: _currentModel,
                                                  ),
                                                );
                                                if (mounted) {
                                                  await _refreshModelFromFirestore();
                                                }
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 12.sp,
                                                  vertical: 8.sp,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(4.r),
                                                  border: Border.all(color: AppColors.primary),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(Icons.add, color: AppColors.primary, size: 16.sp),
                                                    SizedBox(width: 4.sp),
                                                    Text(
                                                      'Assign Provider',
                                                      style: AppTextStyles.font14BlackCairoMedium.copyWith(
                                                        color: AppColors.primary,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  );
                                }

                                final assignedEmail = _currentModel
                                    .currentAssignedProviderEmail
                                    ?.toLowerCase()
                                    .trim() ?? '';

                                EmployeeEntityModell? assignedProvider;

                                if (assignedEmail.isNotEmpty) {
                                  for (int i = 0; i < providersList.length; i++) {
                                    final provider = providersList[i];
                                    final providerEmail =
                                        provider.email?.toLowerCase().trim() ??
                                            '';

                                    if (providerEmail == assignedEmail) {
                                      assignedProvider = provider;
                                      break;
                                    }
                                  }
                                }

                                if (assignedProvider == null) {
                                  assignedProvider = providersList.first;
                                }

                                return buildProviderDetailsSectionMaster(
                                  onTap: () {
                                    navigateTo(
                                      context,
                                      ServicesProviderLayout(
                                        editingModel: widget.approvalModel,
                                        docId: widget.approvalModel.currentId,
                                        editProvider: widget.approvalModel,
                                      ),
                                    );
                                  },
                                  table: widget.fromTable,
                                  context: context,
                                  duration: serviceDuration ?? widget.approvalModel.currentDurationOfServices ?? '',
                                  durationUnit: serviceDurationUnit ?? widget.approvalModel.currentSelectedDurationUnit ?? '',
                                  durationTimeStamp: widget.approvalModel.currentDurationOfServicesTimestamp,
                                  approvalCycle: widget.approvalModel.currentApprovalCycle,
                                  model: assignedProvider,
                                  state: currentState ?? 'pending',
                                );
                              },
                            );
  }

  Widget _buildServiceHeaderRow(BuildContext context, {required bool isMobile, required bool isArabic, required String displayServiceNameAr, required String displayServiceNameEn, required String displayServiceDesc}) {
    return Row(
                              crossAxisAlignment: isMobile
                                  ? CrossAxisAlignment.center
                                  : CrossAxisAlignment.start,
                              children: [
                                // image column
                                Column(
                                  children: [
                                    Container(
                                      width: isMobile ? 40.sp : !this.isTabletLandscape(context) ? 80.sp : 100.sp,
                                      height: isMobile ? 40.sp : !this.isTabletLandscape(context) ? 80.sp : 100.sp,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.r),
                                        color: AppColors.background,
                                      ),
                                      child: Center(
                                        child: (widget.approvalModel.currentImageUrl != null &&
                                            widget.approvalModel.currentImageUrl.isNotEmpty)
                                            ? ClipRRect(
                                          borderRadius: BorderRadius.circular(4.r),
                                          child: FractionallySizedBox(
                                            widthFactor: 0.6,
                                            heightFactor: 0.6,
                                            child: CachedNetworkImage(
                                              imageUrl: widget.approvalModel.currentImageUrl,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) => Center(
                                                child: CircularProgressIndicator(),
                                              ),
                                              errorWidget: (context, url, error) => Icon(Icons.error),
                                            ),
                                          ),
                                        )
                                            : FractionallySizedBox(
                                          widthFactor: 0.6,
                                          heightFactor: 0.6,
                                          child: SvgPicture.asset(
                                            "assets/services_module/new_head_phone.svg",
                                            color: AppColors.secondaryText,
                                            fit: BoxFit.scaleDown,
                                            semanticsLabel: 'Service Icon',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(width: 10.w),

                                isMobile ? Text(isArabic ? displayServiceNameAr : displayServiceNameEn, style: AppTextStyles.font14BlackCairoMedium.copyWith(
                                    color: AppColors.text
                                ),) : SizedBox(),

                                // details text
                                isMobile ? SizedBox() : Flexible(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          CustomSvg(assetPath: "assets/services_module/descrption_icons.svg", width: 20.w, height: 20.h, fit: BoxFit.fill,),
                                          SizedBox(width: 8.w),
                                          Text(S.of(context).serviceDescription, style: AppTextStyles.font14BlackCairoMedium.copyWith(
                                            color: AppColors.secondaryText,
                                          ),),
                                        ],
                                      ),
                                      isMobile ? SizedBox() : SizedBox(height: 10.h),
                                      isMobile ? SizedBox() : Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              displayServiceDesc,
                                              style: AppTextStyles.font13SecondaryBlackCairo
                                                  .copyWith(color: AppColors.text),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
  }
}

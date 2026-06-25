import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/helper/todo_new_module/external/tasks_module/category/presentation/screens/to_do_list/details_screen/hr_module/services_tab_content.dart';
import 'package:demo_app/core/helper/todo_new_module/external/tasks_module/category/presentation/screens/to_do_list/details_screen/hr_module/tasks_tab_content.dart';
import '../../../../../../../../../knowledge_hub_module/core/custom_buttons.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import '../../../../../../core/custom_widgets/SideFrameMaster.dart';
import 'assets_tab_content.dart';
import 'attendance_tab_content.dart';

class ResponsiveHelper {
  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 1000;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width <= mobileMaxWidth;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width > mobileMaxWidth &&
      MediaQuery.of(context).size.width <= tabletMaxWidth;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width > tabletMaxWidth;
}

class EmployeeDetailsScreen extends StatefulWidget {
  const EmployeeDetailsScreen({super.key});

  @override
  State<EmployeeDetailsScreen> createState() => _EmployeeDetailsScreenState();
}

class _EmployeeDetailsScreenState extends State<EmployeeDetailsScreen> {
  String _selectedTab = 'personal_information';

  // Expansion states
  bool _isPersonalInfoExpanded = true;
  bool _isContactDetailsExpanded = true;
  bool _isAddressDetailsExpanded = true;
  bool _isIdentificationDetailsExpanded = true;
  bool _isPositionDetailsExpanded = true;
  bool _isCertificationDetailsExpanded = true;
  bool _isHealthInsuranceExpanded = true;
  bool _isEmergencyContactsExpanded = true;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Scaffold(
      body: SideFrameMaster(
        titleText: "HR",
        secondTitle: "Employees",
        thirdTitle: "Employee Name Details",
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // EMPLOYEE HEADER CARD
              _buildEmployeeHeader(isMobile, isTablet),
              SizedBox(height: 20.h),

              // TABS ROW
              _buildTabsRow(isMobile, isTablet),
              SizedBox(height: 20.h),

              // TAB CONTENT
              if (_selectedTab == 'personal_information')
                _buildPersonalInformationTab(isMobile, isTablet)
              else if (_selectedTab == 'services')
                ServicesTabContent()
              else if (_selectedTab == 'tasks')
                TasksTabContent()
              else if (_selectedTab == 'attendance')
                AttendanceTabContent()
              else if (_selectedTab == 'assets')
                AssetsTabContent()
            ],
          ),
        ),
      ),
    );
  }

  // EMPLOYEE HEADER - RESPONSIVE
  Widget _buildEmployeeHeader(bool isMobile, bool isTablet) {
    if (isMobile) {
      return Container(
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          children: [
            // Profile Image and Name
            Row(
              children: [
                Container(
                  width: 50.sp,
                  height: 50.sp,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.background,
                  ),
                  child: ClipOval(
                    child: SvgPicture.asset(
                      "assets/hrAsset/Ellipse.svg",
                      width: 20.sp,
                      height: 20.sp,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Salma Mohamed',
                        style: AppTextStyles.font16BlackMediumCairo.copyWith(
                          color: AppColors.text,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Marketing',
                        style: AppTextStyles.font12BlackCairoRegular.copyWith(
                          color: AppColors.secondaryText,
                        ),
                      ),
                      Text(
                        'Marketing Manager',
                        style: AppTextStyles.font12BlackCairoRegular.copyWith(
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            // Contact Info
            _buildMobileContactRow(
                'assets/hrAsset/hrPhone.svg', 'Phone Number: 2010258963'),
            SizedBox(height: 6.h),
            _buildMobileContactRow('assets/hrAsset/hrEmail.svg',
                'Email: Mona.Mohamed@GulfDev.com'),
            SizedBox(height: 12.h),
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: customButtonWithImage(
                    title: '',
                    function: () {},
                    textStyle: AppTextStyles.font14BlackCairoMedium.copyWith(
                      color: AppColors.textButton,
                    ),
                    width: double.infinity,
                    height: 35.h,
                    space: 0.w,
                    radius: 8.r,
                    color: AppColors.primary,
                    image: 'assets/hrAsset/hrChatDots.svg',
                    widthImage: 20.sp,
                    heightImage: 20.sp,
                    colorBorder: Colors.transparent,
                    svgColor: AppColors.textButton,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: customButtonWithImage(
                    title: 'Edit',
                    function: () {},
                    textStyle: AppTextStyles.font14BlackCairoMedium.copyWith(
                      color: AppColors.textButton,
                    ),
                    width: double.infinity,
                    height: 35.h,
                    space: 6.w,
                    radius: 8.r,
                    color: AppColors.primary,
                    image: 'assets/hrAsset/hrEdit.svg',
                    widthImage: 18.sp,
                    heightImage: 18.sp,
                    colorBorder: Colors.transparent,
                    svgColor: AppColors.textButton,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // Tablet and Desktop Layout
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: isTablet
          ? Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 60.sp,
                      height: 60.sp,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.background,
                      ),
                      child: ClipOval(
                        child: SvgPicture.asset(
                          "assets/hrAsset/Ellipse.svg",
                          width: 20.sp,
                          height: 20.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 15.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mona Mohammed',
                            style: AppTextStyles.font18BlackMediumCairo.copyWith(
                              color: AppColors.text,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              SvgPicture.asset('assets/hrAsset/hrCase.svg',
                                  width: 14.sp, height: 14.sp),
                              SizedBox(width: 4.w),
                              Text(
                                'Title: Technician',
                                style: AppTextStyles.font12BlackMediumCairo.copyWith(
                                  color: AppColors.secondaryText,
                                ),
                              ),
                              SizedBox(width: 20.w),
                              SvgPicture.asset(
                                  'assets/hrAsset/hrdepartment.svg',
                                  width: 14.sp,
                                  height: 14.sp),
                              SizedBox(width: 4.w),
                              Text(
                                'Department: IT',
                                style: AppTextStyles.font12BlackMediumCairo.copyWith(
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    SvgPicture.asset('assets/hrAsset/hrEmail.svg',
                        width: 14.sp, height: 14.sp),
                    SizedBox(width: 4.w),
                    Text(
                      'Email: Mona.Mohammed@Exellier.com',
                      style: AppTextStyles.font12BlackMediumCairo.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    SvgPicture.asset('assets/hrAsset/hrPhone.svg',
                        width: 14.sp, height: 14.sp),
                    SizedBox(width: 4.w),
                    Text(
                      'Phone Number: +201012108963',
                      style: AppTextStyles.font12BlackMediumCairo.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: customButtonWithImage(
                        title: 'Message',
                        function: () {},
                        textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
                          color: AppColors.textButton,
                        ),
                        width: double.infinity,
                        height: 35.h,
                        space: 6.w,
                        radius: 8.r,
                        color: AppColors.primary,
                        image: 'assets/hrAsset/hrChatDots.svg',
                        widthImage: 18.sp,
                        heightImage: 18.sp,
                        colorBorder: Colors.transparent,
                        svgColor: AppColors.textButton,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: customButtonWithImage(
                        title: 'Edit',
                        function: () {},
                        textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
                          color: AppColors.textButton,
                        ),
                        width: double.infinity,
                        height: 35.h,
                        space: 6.w,
                        radius: 8.r,
                        color: AppColors.primary,
                        image: 'assets/hrAsset/hrEdit.svg',
                        widthImage: 18.sp,
                        heightImage: 18.sp,
                        colorBorder: Colors.transparent,
                        svgColor: AppColors.textButton,
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Row(
              children: [
                Container(
                  width: 60.sp,
                  height: 60.sp,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.background,
                  ),
                  child: ClipOval(
                    child: SvgPicture.asset(
                      "assets/hrAsset/Ellipse.svg",
                      width: 20.sp,
                      height: 20.sp,
                    ),
                  ),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mona Mohammed',
                        style: AppTextStyles.font20BlackCairoMedium.copyWith(
                          color: AppColors.text,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          SvgPicture.asset('assets/hrAsset/hrCase.svg',
                              width: 14.sp, height: 14.sp),
                          SizedBox(width: 4.w),
                          Text(
                            'Title: Technician',
                            style: AppTextStyles.font14BlackCairoMedium.copyWith(
                              color: AppColors.secondaryText,
                            ),
                          ),
                          SizedBox(width: 130.w),
                          SvgPicture.asset('assets/hrAsset/hrdepartment.svg',
                              width: 14.sp, height: 14.sp),
                          SizedBox(width: 4.w),
                          Text(
                            'Department: IT',
                            style: AppTextStyles.font14BlackCairoMedium.copyWith(
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          SvgPicture.asset('assets/hrAsset/hrEmail.svg',
                              width: 14.sp, height: 14.sp),
                          SizedBox(width: 4.w),
                          Text(
                            'Email: Mona.Mohammed@Exellier.com',
                            style: AppTextStyles.font14BlackCairoMedium.copyWith(
                              color: AppColors.secondaryText,
                            ),
                          ),
                          SizedBox(width: 20.w),
                          SvgPicture.asset('assets/hrAsset/hrPhone.svg',
                              width: 14.sp, height: 14.sp),
                          SizedBox(width: 4.w),
                          Text(
                            'Phone Number: +201012108963',
                            style: AppTextStyles.font14BlackCairoMedium.copyWith(
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                customButtonWithImage(
                  title: 'Message',
                  function: () {},
                  textStyle: AppTextStyles.font18BlackMediumCairo.copyWith(
                    color: AppColors.textButton,
                  ),
                  width: 100.w,
                  height: 35.h,
                  space: 6.w,
                  radius: 8.r,
                  color: AppColors.primary,
                  image: 'assets/hrAsset/hrChatDots.svg',
                  widthImage: 18.sp,
                  heightImage: 18.sp,
                  colorBorder: Colors.transparent,
                  svgColor: AppColors.textButton,
                ),
                SizedBox(width: 10.w),
                Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: customButtonWithImage(
                    title: 'Edit',
                    function: () {},
                    textStyle: AppTextStyles.font18BlackMediumCairo.copyWith(
                      color: AppColors.textButton,
                    ),
                    width: 80.w,
                    height: 35.h,
                    space: 6.w,
                    radius: 8.r,
                    color: AppColors.primary,
                    image: 'assets/hrAsset/hrEdit.svg',
                    widthImage: 18.sp,
                    heightImage: 18.sp,
                    colorBorder: Colors.transparent,
                    svgColor: AppColors.textButton,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildMobileContactRow(String iconPath, String text) {
    return Row(
      children: [
        SvgPicture.asset(
          iconPath,
          width: 14.sp,
          height: 14.sp,
          colorFilter:
              ColorFilter.mode(AppColors.secondaryText, BlendMode.srcIn),
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.font12BlackCairoRegular.copyWith(
              color: AppColors.secondaryText,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // TABS ROW - RESPONSIVE
  Widget _buildTabsRow(bool isMobile, bool isTablet) {
    if (isMobile) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildTab('Personal Information', 'personal_information', isMobile),
            SizedBox(width: 15.w),
            _buildTab('Services', 'services', isMobile),
            SizedBox(width: 15.w),
            _buildTab('Tasks', 'tasks', isMobile),
            SizedBox(width: 15.w),
            _buildTab('Attendance', 'attendance', isMobile),
            SizedBox(width: 15.w),
            _buildTab('Assets', 'assets', isMobile),
          ],
        ),
      );
    }

    return Wrap(
      spacing: 20.w,
      runSpacing: 10.h,
      children: [
        _buildTab('Personal Information', 'personal_information', isMobile),
        _buildTab('Services', 'services', isMobile),
        _buildTab('Tasks', 'tasks', isMobile),
        _buildTab('Attendance', 'attendance', isMobile),
        _buildTab('Assets', 'assets', isMobile),
      ],
    );
  }

  Widget _buildTab(String title, String value, bool isMobile) {
    final isSelected = _selectedTab == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = value;
        });
      },
      child: Text(
        title,
        style: (isMobile
                ? AppTextStyles.font14BlackCairoMedium
                : AppTextStyles.font18BlackMediumCairo)
            .copyWith(
          color:
              isSelected ? AppColors.secondaryPrimary : AppColors.secondaryText,
          decoration: isSelected ? TextDecoration.underline : null,
          decorationColor: AppColors.secondaryPrimary,
          decorationThickness: 2.h,
        ),
      ),
    );
  }

  // PERSONAL INFORMATION TAB - RESPONSIVE
  Widget _buildPersonalInformationTab(bool isMobile, bool isTablet) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          // Personal Information
          _buildSectionHeader('Personal Information', _isPersonalInfoExpanded,
              () {
            setState(() {
              _isPersonalInfoExpanded = !_isPersonalInfoExpanded;
            });
          }, isMobile),
          if (_isPersonalInfoExpanded)
            _buildPersonalInformationContent(isMobile, isTablet),

          // Contact Details
          _buildSectionHeader('Contact Details', _isContactDetailsExpanded, () {
            setState(() {
              _isContactDetailsExpanded = !_isContactDetailsExpanded;
            });
          }, isMobile),
          if (_isContactDetailsExpanded)
            _buildContactDetailsContent(isMobile, isTablet),

          // Address Details
          _buildSectionHeader('Address Details', _isAddressDetailsExpanded, () {
            setState(() {
              _isAddressDetailsExpanded = !_isAddressDetailsExpanded;
            });
          }, isMobile),
          if (_isAddressDetailsExpanded)
            _buildAddressDetailsContent(isMobile, isTablet),

          // Identification Details
          _buildSectionHeader(
              'Identification Details', _isIdentificationDetailsExpanded, () {
            setState(() {
              _isIdentificationDetailsExpanded =
                  !_isIdentificationDetailsExpanded;
            });
          }, isMobile),
          if (_isIdentificationDetailsExpanded)
            _buildIdentificationDetailsContent(isMobile, isTablet),

          // Position Details
          _buildSectionHeader('Position Details', _isPositionDetailsExpanded,
              () {
            setState(() {
              _isPositionDetailsExpanded = !_isPositionDetailsExpanded;
            });
          }, isMobile),
          if (_isPositionDetailsExpanded)
            _buildPositionDetailsContent(isMobile, isTablet),

          // Certification Details
          _buildSectionHeader(
              'Certification Details', _isCertificationDetailsExpanded, () {
            setState(() {
              _isCertificationDetailsExpanded =
                  !_isCertificationDetailsExpanded;
            });
          }, isMobile),
          if (_isCertificationDetailsExpanded)
            _buildCertificationDetailsContent(isMobile, isTablet),

          // Health Insurance
          _buildSectionHeader('Health Insurance', _isHealthInsuranceExpanded,
              () {
            setState(() {
              _isHealthInsuranceExpanded = !_isHealthInsuranceExpanded;
            });
          }, isMobile),
          if (_isHealthInsuranceExpanded)
            _buildHealthInsuranceContent(isMobile, isTablet),

          // Emergency Contacts
          _buildSectionHeader(
              'Emergency Contacts', _isEmergencyContactsExpanded, () {
            setState(() {
              _isEmergencyContactsExpanded = !_isEmergencyContactsExpanded;
            });
          }, isMobile),
          if (_isEmergencyContactsExpanded)
            _buildEmergencyContactsContent(isMobile, isTablet),
        ],
      ),
    );
  }

  // EXPANDABLE SECTION HEADER
  Widget _buildSectionHeader(
      String title, bool isExpanded, VoidCallback onTap, bool isMobile) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 10.w : 15.w,
            vertical: isMobile ? 10.h : 15.h),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12.w : 16.w,
              vertical: isMobile ? 10.h : 12.h),
          decoration: BoxDecoration(
            color: AppColors.secondaryText.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: (isMobile
                          ? AppTextStyles.font14BlackCairoMedium
                          : AppTextStyles.font16BlackMediumCairo)
                      .copyWith(
                    color: AppColors.text,
                  ),
                ),
              ),
              SvgPicture.asset(
                isExpanded
                    ? 'assets/hrAsset/arrow_up.svg'
                    : 'assets/hrAsset/arrow_down.svg',
                width: isMobile ? 16.sp : 20.sp,
                height: isMobile ? 16.sp : 20.sp,
                colorFilter: ColorFilter.mode(AppColors.text, BlendMode.srcIn),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // INFO ROW WIDGET - RESPONSIVE
  Widget _buildInfoRow(
      String iconPath, String label, String value, bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 6.h : 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            iconPath,
            width: isMobile ? 14.sp : 16.sp,
            height: isMobile ? 14.sp : 16.sp,
            colorFilter:
                ColorFilter.mode(AppColors.secondaryText, BlendMode.srcIn),
          ),
          SizedBox(width: isMobile ? 6.w : 8.w),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: (isMobile
                            ? AppTextStyles.font12BlackCairoRegular
                            : AppTextStyles.font14BlackCairoRegular)
                        .copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: (isMobile
                            ? AppTextStyles.font12BlackCairoRegular
                            : AppTextStyles.font14BlackCairoRegular)
                        .copyWith(
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // PERSONAL INFORMATION CONTENT - RESPONSIVE
  Widget _buildPersonalInformationContent(bool isMobile, bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 10.w : 15.w, vertical: isMobile ? 12.h : 16.h),
      child: Column(
        children: [
          if (isMobile) ...[
            _buildInfoRow(
                'assets/hrAsset/person.svg', 'First Name', 'Moataz', isMobile),
            _buildInfoRow(
                'assets/hrAsset/person.svg', 'Middle Name', 'hamed', isMobile),
            _buildInfoRow(
                'assets/hrAsset/person.svg', 'Last Name', 'Hendoaa', isMobile),
            _buildInfoRow(
                'assets/hrAsset/gender.svg', 'Gender', 'Male', isMobile),
            _buildInfoRow('assets/hrAsset/calendar.svg', 'Birthday',
                '28 Nov 2024', isMobile),
            _buildInfoRow(
                'assets/hrAsset/flag.svg', 'Nationality', 'Egyptian', isMobile),
            _buildInfoRow('assets/hrAsset/marital.svg', 'Marital Status',
                'Married', isMobile),
            _buildInfoRow(
                'assets/hrAsset/language.svg', 'Language', 'Arabic', isMobile),
          ] else ...[
            Row(
              children: [
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/person.svg',
                        'First Name', 'Moataz', isMobile)),
                SizedBox(width: 20.w),
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/person.svg',
                        'Middle Name', 'hamed', isMobile)),
                SizedBox(width: 20.w),
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/person.svg',
                        'Last Name', 'Hendoaa', isMobile)),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/gender.svg', 'Gender',
                        'Male', isMobile)),
                SizedBox(width: 20.w),
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/calendar.svg',
                        'Birthday', '28/Nov 2026', isMobile)),
                SizedBox(width: 20.w),
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/flag.svg',
                        'Nationality', 'Egyptian', isMobile)),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/marital.svg',
                        'Marital Status', 'Married', isMobile)),
                SizedBox(width: 20.w),
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/language.svg',
                        'Language', 'Arabic', isMobile)),
                SizedBox(width: 20.w),
                Expanded(child: SizedBox()),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // CONTACT DETAILS CONTENT - RESPONSIVE
  Widget _buildContactDetailsContent(bool isMobile, bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 10.w : 15.w, vertical: isMobile ? 12.h : 16.h),
      child: Column(
        children: [
          if (isMobile) ...[
            _buildInfoRow('assets/hrAsset/phone.svg', 'Mobile Phone',
                '01243546456', isMobile),
            _buildInfoRow('assets/hrAsset/email.svg', 'Personal Email',
                'John.smith@example.com', isMobile),
            _buildInfoRow('assets/hrAsset/businessemail.svg', 'Business Email',
                'John.smith@example.com', isMobile),
            _buildInfoRow('assets/hrAsset/officephone.svg', 'Office Number',
                '01243546456', isMobile),
            _buildInfoRow('assets/hrAsset/extensionphone.svg', 'Extension',
                '023', isMobile),
            _buildInfoRow('assets/hrAsset/Homephone.svg', 'Home Number',
                '01243546456', isMobile),
          ] else ...[
            Row(
              children: [
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/phone.svg',
                        'Mobile Phone', '01245154656', isMobile)),
                SizedBox(width: 20.w),
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/email.svg',
                        'Personal Email', 'ahdamfd@exampla.com', isMobile)),
                SizedBox(width: 20.w),
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/officephone.svg',
                        'Office Number', '01245154658', isMobile)),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/Homephone.svg',
                        'Home Number', '01245154658', isMobile)),
                SizedBox(width: 20.w),
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/businessemail.svg',
                        'Business Email', 'beh-omhs@Exampl.com', isMobile)),
                SizedBox(width: 20.w),
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/extensionphone.svg',
                        'Extension', '023', isMobile)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ADDRESS DETAILS CONTENT - RESPONSIVE
  Widget _buildAddressDetailsContent(bool isMobile, bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 10.w : 15.w, vertical: isMobile ? 12.h : 16.h),
      child: Column(
        children: [
          if (isMobile) ...[
            _buildInfoRow(
                'assets/hrAsset/country.svg', 'Country', 'Egypt', isMobile),
            _buildInfoRow(
                'assets/hrAsset/location.svg', 'Province', 'Cairo', isMobile),
            _buildInfoRow('assets/hrAsset/city.svg', 'City', 'Cairo', isMobile),
            _buildInfoRow(
                'assets/hrAsset/street.svg', 'Street', 'Sayed', isMobile),
            _buildInfoRow('assets/hrAsset/postal.svg', 'Postal Code', '1113555',
                isMobile),
          ] else ...[
            Row(
              children: [
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/country.svg',
                        'Country', 'Egypt', isMobile)),
                SizedBox(width: 20.w),
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/location.svg',
                        'Province', 'Cairo', isMobile)),
                SizedBox(width: 20.w),
                Expanded(
                    child: _buildInfoRow(
                        'assets/hrAsset/city.svg', 'City', 'Cairo', isMobile)),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/street.svg', 'Street',
                        'Saeed', isMobile)),
                SizedBox(width: 20.w),
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/postal.svg',
                        'Postal Code', '1119595', isMobile)),
                SizedBox(width: 20.w),
                Expanded(child: SizedBox()),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // IDENTIFICATION DETAILS CONTENT - RESPONSIVE
  Widget _buildIdentificationDetailsContent(bool isMobile, bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 10.w : 15.w, vertical: isMobile ? 12.h : 16.h),
      child: Column(
        children: [
          if (isMobile) ...[
            _buildInfoRow('assets/hrAsset/id.svg', 'National ID',
                '11111111111111', isMobile),
            _buildInfoRow('assets/hrAsset/nationalExpiration.svg',
                'National ID Expiration', '11111111111', isMobile),
            _buildInfoRow('assets/hrAsset/passport.svg', 'Passport',
                '11111111111', isMobile),
            _buildInfoRow('assets/hrAsset/passportExpiration.svg',
                'Passport Expiration', 'Egyptian', isMobile),
            _buildInfoRow('assets/hrAsset/license.svg', 'Driving License ID',
                '11111111111', isMobile),
            _buildInfoRow(
                'assets/hrAsset/car.svg', 'Car Plate', '11111111111', isMobile),
          ] else ...[
            Row(
              children: [
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/id.svg', 'National ID',
                        '11111111111111', isMobile)),
                SizedBox(width: 20.w),
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/passport.svg',
                        'Passport', '11111111111', isMobile)),
                SizedBox(width: 20.w),
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/license.svg',
                        'Driving License ID', '11111111111', isMobile)),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: _buildInfoRow(
                        'assets/hrAsset/nationalExpiration.svg',
                        'National ID Expiration:',
                        '11111111111',
                        isMobile)),
                SizedBox(width: 20.w),
                Expanded(
                    child: _buildInfoRow(
                        'assets/hrAsset/passportExpiration.svg',
                        'Passport Expiration',
                        'Egyptian',
                        isMobile)),
                SizedBox(width: 20.w),
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/car.svg', 'Car Plate',
                        '11111111111', isMobile)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // POSITION DETAILS CONTENT - RESPONSIVE
  Widget _buildPositionDetailsContent(bool isMobile, bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 10.w : 15.w, vertical: isMobile ? 12.h : 16.h),
      child: Column(
        children: [
          if (isMobile) ...[
            _buildInfoRow('assets/hrAsset/assets/hrAsset/hrCase.svg',
                'Job Title', 'Marketing Leader', isMobile),
            _buildInfoRow('assets/hrAsset/business.svg', 'Department',
                'Marketing', isMobile),
            _buildInfoRow('assets/hrAsset/Manager.svg', 'Manager',
                'Philip Schiller', isMobile),
            _buildInfoRow(
                'assets/hrAsset/work.svg', 'Job Type', 'Full Time', isMobile),
            _buildInfoRow('assets/hrAsset/WorkArrangement.svg',
                'Work Arrangement', 'Hybrid', isMobile),
            _buildInfoRow('assets/hrAsset/RemoteStatus.svg', 'Remote Status',
                'Yes', isMobile),
            _buildInfoRow('assets/hrAsset/WorkingHours.svg', 'Working Hours',
                '10 AM - 6 PM', isMobile),
            _buildInfoRow('assets/hrAsset/StartDate.svg', 'Start Date',
                '28 Nov 2004', isMobile),
            _buildInfoRow('assets/hrAsset/DaysOff.svg', 'Days Off',
                'Friday-Saturday', isMobile),
            _buildInfoRow(
                'assets/hrAsset/money.svg', 'Salary', '10,000 EGP', isMobile),
            _buildInfoRow('assets/hrAsset/JobLocation.svg', 'Job Location',
                'Main Office - Office - 1', isMobile),
          ] else ...[
            Row(
              children: [
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/hrCase.svg',
                        'Job Title', 'Marketing Leader', isMobile)),
                SizedBox(width: 20.w),
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/business.svg',
                        'Department', 'Marketing', isMobile)),
                SizedBox(width: 20.w),
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/Manager.svg',
                        'Manager', 'Philip Snider', isMobile)),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/work.svg', 'Job Type',
                        'Full Time', isMobile)),
                SizedBox(width: 20.w),
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/WorkArrangement.svg',
                        'Work Arrangement', 'Hybrid', isMobile)),
                SizedBox(width: 20.w),
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/seniority.svg',
                        'Seniority', 'Leader', isMobile)),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/WorkingHours.svg',
                        'Working Hours', '10 AM - 6 PM', isMobile)),
                SizedBox(width: 20.w),
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/StartDate.svg',
                        'Start Date', '28/Nov 2026', isMobile)),
                SizedBox(width: 20.w),
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/money.svg', 'Salary',
                        '10,000 EGP', isMobile)),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: _buildInfoRow(
                        'assets/hrAsset/calendar.svg',
                        'Date Of Probation End (Seniority)',
                        'Main Office - Office - 3',
                        isMobile)),
                Expanded(child: SizedBox()),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // CERTIFICATION DETAILS CONTENT - RESPONSIVE
  Widget _buildCertificationDetailsContent(bool isMobile, bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 10.w : 15.w, vertical: isMobile ? 12.h : 16.h),
      child: Column(
        children: [
          if (isMobile) ...[
            _buildInfoRow('assets/hrAsset/InstitutionName.svg',
                'Institution Name', 'Marketing Leader', isMobile),
            _buildInfoRow('assets/hrAsset/degree.svg',
                'Degree Of Certification', 'Marketing', isMobile),
            _buildInfoRow('assets/hrAsset/field.svg', 'Field of Study',
                'Philip Schiller', isMobile),
            _buildInfoRow('assets/hrAsset/grade.svg', 'Grade Or Score:',
                'Full Time', isMobile),
            _buildInfoRow('assets/hrAsset/StartDate.svg', 'Start Date',
                'Hybrid', isMobile),
            _buildInfoRow(
                'assets/hrAsset/EndDate.svg', 'End Date', 'Hybrid', isMobile),
            _buildInfoRow('assets/hrAsset/CertificateID.svg', 'Certificate ID',
                'Full Time', isMobile),
            _buildInfoRow('assets/hrAsset/authority.svg', 'Issuing Authority',
                'Hybrid', isMobile),
            _buildInfoRow(
                'assets/hrAsset/link.svg', 'Document URL', 'Yes', isMobile),
            _buildInfoRow(
                'assets/hrAsset/Notes.svg',
                'Notes',
                'Time Time Time Time Time Time Time Time Time Time Time Time',
                isMobile),
          ] else ...[
            Row(
              children: [
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/InstitutionName.svg',
                        'Institution Name', 'Marketing Leader', isMobile)),
                SizedBox(width: 20.w),
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/degree.svg',
                        'Degree Of Certification', 'Marketing', isMobile)),
                SizedBox(width: 20.w),
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/field.svg',
                        'Field of Study', 'Philip Snider', isMobile)),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/location.svg',
                        'Location Of Study', 'Full Time', isMobile)),
                SizedBox(width: 20.w),
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/end.svg', 'End Date',
                        'Time Time Time Time Time', isMobile)),
                SizedBox(width: 20.w),
                Expanded(
                    child: _buildInfoRow(
                        'assets/hrAsset/grade.svg',
                        'Grade Of Study',
                        'Time Time Time Time Time',
                        isMobile)),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/CertificateID.svg',
                        'Certificate ID', 'Full Time', isMobile)),
                SizedBox(width: 20.w),
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/authority.svg',
                        'Issuing Authority', 'Hybrid', isMobile)),
                SizedBox(width: 20.w),
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/link.svg',
                        'Document URL', 'Yes', isMobile)),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/calendar.svg',
                        'Issue Date', 'Time Time Time Time Time', isMobile)),
                SizedBox(width: 20.w),
                Expanded(child: SizedBox()),
                SizedBox(width: 20.w),
                Expanded(child: SizedBox()),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // HEALTH INSURANCE CONTENT - RESPONSIVE
  Widget _buildHealthInsuranceContent(bool isMobile, bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 10.w : 15.w, vertical: isMobile ? 12.h : 16.h),
      child: Column(
        children: [
          if (isMobile) ...[
            _buildInfoRow('assets/hrAsset/insurance.svg', 'Insurance Name',
                'Marketing Leader', isMobile),
            _buildInfoRow('assets/hrAsset/policy.svg',
                'Insurance Policy Number', 'Marketing', isMobile),
            _buildInfoRow('assets/hrAsset/Provider.svg', 'Provider Contact',
                'Philip Schiller', isMobile),
          ] else ...[
            Row(
              children: [
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/insurance.svg',
                        'Insurance Name', 'Marketing Leader', isMobile)),
                SizedBox(width: 20.w),
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/policy.svg',
                        'Insurance Policy Number', 'Marketing', isMobile)),
                SizedBox(width: 20.w),
                Expanded(
                    child: _buildInfoRow('assets/hrAsset/Provider.svg',
                        'Provider Contact', 'Philip Snider', isMobile)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // EMERGENCY CONTACTS CONTENT - RESPONSIVE
  Widget _buildEmergencyContactsContent(bool isMobile, bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 10.w : 15.w, vertical: isMobile ? 12.h : 16.h),
      child: isMobile
          ? Column(
              children: [
                _buildEmergencyContactCard(isMobile),
                SizedBox(height: 12.h),
                _buildEmergencyContactCard(isMobile),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildEmergencyContactCard(isMobile)),
                SizedBox(width: 20.w),
                Expanded(child: _buildEmergencyContactCard(isMobile)),
              ],
            ),
    );
  }

  Widget _buildEmergencyContactCard(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 10.w : 12.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          _buildInfoRow(
              'assets/hrAsset/person.svg', 'Name', 'Ahmed Wael', isMobile),
          _buildInfoRow('assets/hrAsset/relationship.svg', 'Relationship',
              'Brother', isMobile),
          _buildInfoRow('assets/hrAsset/email.svg', 'Email',
              'mohammed@outlook.com', isMobile),
          _buildInfoRow('assets/hrAsset/phone.svg', 'Mobile Number',
              'mohammed@outlook.com', isMobile),
          _buildInfoRow('assets/hrAsset/country.svg', 'Country',
              'Marketing Manager', isMobile),
          _buildInfoRow('assets/hrAsset/location.svg', 'Province',
              'UI/UX Design', isMobile),
          _buildInfoRow('assets/hrAsset/city.svg', 'City', 'Cairo', isMobile),
          _buildInfoRow(
              'assets/hrAsset/street.svg', 'Street', 'Sayed', isMobile),
          _buildInfoRow('assets/hrAsset/language.svg', 'Language',
              'UI/UX Design', isMobile),
        ],
      ),
    );
  }
}

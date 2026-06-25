import 'package:flutter/material.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:demo_app/core/custom/35-custom_search_widget_custom.dart';
import '../../../../../../../../../knowledge_hub_module/core/custom_buttons.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import '../../../../../../core/custom_widgets/SideFrameMaster.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'add_new_employee_screen.dart';

class HrEmployeeScreen extends StatefulWidget {
  const HrEmployeeScreen({super.key});

  @override
  State<HrEmployeeScreen> createState() => _HrEmployeeScreenState();
}

class _HrEmployeeScreenState extends State<HrEmployeeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedTopTab = 'employees';
  String _selectedFilterTab = 'all';
  bool _isGridView = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _employees = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final snapshot = await _firestore
          .collection('Demo')
          .doc('75440689')
          .collection('Employees_Info')
          .get();

      _employees = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          ...data,
        };
      }).toList();

      print('✅ Loaded ${_employees.length} employees');
    } catch (e) {
      print('❌ Error loading employees: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SideFrameMaster(
        titleText: "HR",
        onFirstTap: (){
          Navigator.pop(context);
        },
        secondTitle: "Employee",
        onSecondTap:  (){
          Navigator.pop(context);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopTabsRow(),
            SizedBox(height: 20.h),
            if (_selectedTopTab == 'employees') ...[
              _buildFilterTabsRow(),
              SizedBox(height: 20.h),
            ],
            _buildSearchAndActionsRow(),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isGridView = false;
                    });
                  },
                  child: Container(
                    width: 38.w,
                    height: 38.h,
                    decoration: BoxDecoration(
                      color: !_isGridView ? AppColors.primary : AppColors.card,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: SvgPicture.asset(
                      "assets/hrAsset/hrList.svg",
                      width: 20.sp,
                      height: 20.sp,
                      colorFilter: ColorFilter.mode(
                        !_isGridView ? AppColors.textButton : AppColors.text,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15.w),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isGridView = true;
                    });
                  },
                  child: Container(
                    width: 38.w,
                    height: 38.h,
                    decoration: BoxDecoration(
                      color: _isGridView ? AppColors.primary : AppColors.card,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/hrAsset/hrGrid.svg",
                        width: 20.sp,
                        height: 20.sp,
                        colorFilter: ColorFilter.mode(
                          _isGridView ? AppColors.textButton : AppColors.text,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _isGridView
                  ? _buildGridView()
                  : _buildTableView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopTabsRow() {
    return Row(
      children: [
        _buildTopTab('Employees', 'employees'),
        SizedBox(width: 24.w),
        _buildTopTab('Health Insurance', 'health_insurance'),
        SizedBox(width: 20.w),
        _buildTopTab('Emergency Contacts', 'emergency_contacts'),
        SizedBox(width: 20.w),
        _buildTopTab('Salaries', 'salaries'),
        SizedBox(width: 20.w),
        _buildTopTab('Certifications', 'certifications'),
      ],
    );
  }

  Widget _buildTopTab(String title, String value) {
    final isSelected = _selectedTopTab == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTopTab = value;
          if (value != 'employees') {
            _selectedFilterTab = 'all';
          }
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: AppTextStyles.font16BlackMediumCairo.copyWith(
              color: isSelected
                  ? AppColors.secondaryPrimary
                  : AppColors.secondaryText,
              decoration: isSelected ? TextDecoration.underline : null,
              decorationColor: AppColors.secondaryPrimary,
              decorationThickness: 2.h,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabsRow() {
    return Row(
      children: [
        _buildFilterTab('All', 'all', hasFixedWidth: true),
        SizedBox(width: 15.w),
        _buildFilterTab('Personal Informations', 'personal_info'),
        SizedBox(width: 15.w),
        _buildFilterTab('Contact Details', 'contact_details'),
        SizedBox(width: 15.w),
        _buildFilterTab('Address Details', 'address_details'),
        SizedBox(width: 15.w),
        _buildFilterTab('Identification Details', 'identification_details'),
        SizedBox(width: 15.w),
        _buildFilterTab('Position Details', 'position_details'),
      ],
    );
  }

  Widget _buildFilterTab(String title, String value,
      {bool hasFixedWidth = false}) {
    final isSelected = _selectedFilterTab == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilterTab = value;
        });
      },
      child: Container(
        width: hasFixedWidth ? 35.w : null,
        height: 28.h,
        padding: hasFixedWidth ? null : EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.card,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Center(
          child: Text(
            title,
            style: AppTextStyles.font14BlackCairoRegular.copyWith(
              color: isSelected ? AppColors.textButton : AppColors.text,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndActionsRow() {
    return Row(
      children: [
        AppSearchTextField(
          controller: _searchController,
          onChanged: (value) {},
          fillColor: AppColors.card,
        ),
        SizedBox(width: 15.w),
        customButtonWithImage(
          title: 'Filter',
          function: () {},
          textStyle: AppTextStyles.font14BlackCairoRegular.copyWith(
            color: AppColors.secondaryText,
          ),
          width: 90.w,
          height: 38.h,
          space: 8.w,
          radius: 4.r,
          color: AppColors.card,
          image: 'assets/hrAsset/filter.svg',
          widthImage: 20.sp,
          heightImage: 20.sp,
          colorBorder: Colors.transparent,
          svgColor: AppColors.secondaryText,
        ),
        SizedBox(width: 15.w),
        customButtonWithImage(
          title: 'Export',
          function: () {},
          textStyle: AppTextStyles.font14BlackCairoMedium.copyWith(
            color: AppColors.textButton,
          ),
          width: 100.w,
          height: 38.h,
          space: 8.w,
          radius: 4.r,
          color: AppColors.primary,
          image: 'assets/hrAsset/hrExport.svg',
          widthImage: 20.sp,
          heightImage: 20.sp,
          colorBorder: Colors.transparent,
          svgColor: AppColors.textButton,
        ),
        SizedBox(width: 15.w),
        customButtonWithImage(
          title: 'Employee',
          function: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return HRAddNewEmployeeScreen();
            }));
          },
          textStyle: AppTextStyles.font14BlackCairoMedium.copyWith(
            color: AppColors.textButton,
          ),
          width: 150.w,
          height: 38.h,
          space: 8.w,
          radius: 4.r,
          color: AppColors.primary,
          image: 'assets/hrAsset/hrEmployeeButton.svg',
          widthImage: 20.sp,
          heightImage: 20.sp,
          colorBorder: Colors.transparent,
          svgColor: AppColors.textButton,
        ),
        SizedBox(width: 15.w),
      ],
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 4,
        crossAxisSpacing: 15.w,
        mainAxisSpacing: 15.h,
      ),
      itemCount: _employees.length,
      itemBuilder: (context, index) {
        final employee = _employees[index];
        return _buildEmployeeCard(employee);
      },
    );
  }

  Widget _buildEmployeeCard(Map<String, dynamic> employee) {
    // ⚠️ UPDATED: Use correct Firebase field names
    final firstName = _getLatestValue(employee['First_Name']);
    final lastName = _getLatestValue(employee['Last_Name']);
    final title = _getLatestValue(employee['Title']);
    final department = _getLatestValue(employee['Department_Id']);

    return Container(
      height: 65.h,
      padding: EdgeInsets.all(15.sp),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Container(
            width: 35.sp,
            height: 35.sp,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.background,
            ),
            child: Icon(Icons.person, color: AppColors.text, size: 20.sp),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  firstName.isEmpty && lastName.isEmpty
                      ? 'No Name'
                      : '$firstName $lastName'.trim(),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.text,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  title.isEmpty ? 'No Title' : title,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  department.isEmpty ? 'No Department' : department,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 85.w,
              height: 25.h,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 14.sp,
                    color: AppColors.textButton,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Message',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textButton,
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

  Widget _buildTableView() {
    if (_selectedTopTab == 'employees') {
      return _buildEmployeesTable();
    } else {
      return _buildOtherTabsTable();
    }
  }

  Widget _buildEmployeesTable() {
    switch (_selectedFilterTab) {
      case 'all':
        return _buildAllDataTable();
      case 'personal_info':
        return _buildPersonalInfoTable();
      case 'contact_details':
        return _buildContactDetailsTable();
      case 'address_details':
        return _buildAddressDetailsTable();
      case 'identification_details':
        return _buildIdentificationDetailsTable();
      case 'position_details':
        return _buildPositionDetailsTable();
      default:
        return _buildAllDataTable();
    }
  }

  Widget _buildPersonalInfoTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: 2200.w,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(color: Colors.black),
              child: Row(
                children: [
                  _buildTableHeaderCell('NO', 60.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Employee ID', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('First Name', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Middle Name', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Last Name', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('الاسم الأول', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('الاسم الأوسط', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('الاسم الأخير', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Nationality', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Birth Date', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Gender', 100.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Marital Status', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Language', 100.w),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _employees.length,
                itemBuilder: (context, index) {
                  final employee = _employees[index];
                  return _buildPersonalInfoRow(employee, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoRow(Map<String, dynamic> employee, int index) {
    final backgroundColor =
    index % 2 == 0 ? AppColors.background : AppColors.card;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(color: backgroundColor),
      child: Row(
        children: [
          _buildTableCell((index + 1).toString(), 60.w),
          SizedBox(width: 50.w),
          _buildTableCell(employee['Id'] ?? '', 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['First_Name']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['Middle_Name']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['Last_Name']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(
              _getLatestValue(employee['First_Name_In_Arabic']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(
              _getLatestValue(employee['Middle_Name_In_Arabic']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(
              _getLatestValue(employee['Last_Name_In_Arabic']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['Nationality']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['Birth_Day']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['Gender']), 100.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['Marital_Status']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['Language']), 100.w),
        ],
      ),
    );
  }

  Widget _buildContactDetailsTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: 2300.w,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(color: Colors.black),
              child: Row(
                children: [
                  _buildTableHeaderCell('NO', 60.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Employee ID', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('First Name', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Middle Name', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Last Name', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('الاسم الأول', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('الاسم الأوسط', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('الاسم الأخير', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Email', 150.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Mobile Phone', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Home Number', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Office Number', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Extension', 100.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Language', 100.w),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _employees.length,
                itemBuilder: (context, index) {
                  final employee = _employees[index];
                  return _buildContactDetailsRow(employee, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactDetailsRow(Map<String, dynamic> employee, int index) {
    final backgroundColor =
    index % 2 == 0 ? AppColors.background : AppColors.card;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(color: backgroundColor),
      child: Row(
        children: [
          _buildTableCell((index + 1).toString(), 60.w),
          SizedBox(width: 50.w),
          _buildTableCell(employee['Id'] ?? '', 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['First_Name']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['Middle_Name']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['Last_Name']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(
              _getLatestValue(employee['First_Name_In_Arabic']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(
              _getLatestValue(employee['Middle_Name_In_Arabic']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(
              _getLatestValue(employee['Last_Name_In_Arabic']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['Email']), 150.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getMobilePhone(employee['Mobile_Phone']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['Home_Phone']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['Office_Phone']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['Extension']), 100.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['Language']), 100.w),
        ],
      ),
    );
  }

  Widget _buildAddressDetailsTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: 2370.w,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(color: Colors.black),
              child: Row(
                children: [
                  _buildTableHeaderCell('NO', 60.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Employee ID', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('First Name', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Middle Name', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Last Name', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('الاسم الأول', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('الاسم الأوسط', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('الاسم الأخير', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('National ID', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Country', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Province', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('City', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Postal Code', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Street', 150.w),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _employees.length,
                itemBuilder: (context, index) {
                  final employee = _employees[index];
                  return _buildAddressDetailsRow(employee, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressDetailsRow(Map<String, dynamic> employee, int index) {
    final backgroundColor =
    index % 2 == 0 ? AppColors.background : AppColors.card;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(color: backgroundColor),
      child: Row(
        children: [
          _buildTableCell((index + 1).toString(), 60.w),
          SizedBox(width: 50.w),
          _buildTableCell(employee['Id'] ?? '', 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['First_Name']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['Middle_Name']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['Last_Name']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(
              _getLatestValue(employee['First_Name_In_Arabic']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(
              _getLatestValue(employee['Middle_Name_In_Arabic']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(
              _getLatestValue(employee['Last_Name_In_Arabic']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['National_Id']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['Country']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['Province']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['City']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['Postal_Code']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['Street']), 150.w),
        ],
      ),
    );
  }

  Widget _buildIdentificationDetailsTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: 2400.w,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(color: Colors.black),
              child: Row(
                children: [
                  _buildTableHeaderCell('NO', 60.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Employee ID', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('First Name', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Middle Name', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Last Name', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('الاسم الأول', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('الاسم الأوسط', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('الاسم الأخير', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('National ID', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('National ID Expiration', 150.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Passport', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Passport Expiration', 150.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Driving License ID', 150.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Car Plates', 120.w),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _employees.length,
                itemBuilder: (context, index) {
                  final employee = _employees[index];
                  return _buildIdentificationDetailsRow(employee, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIdentificationDetailsRow(
      Map<String, dynamic> employee, int index) {
    final backgroundColor =
    index % 2 == 0 ? AppColors.background : AppColors.card;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(color: backgroundColor),
      child: Row(
        children: [
          _buildTableCell((index + 1).toString(), 60.w),
          SizedBox(width: 50.w),
          _buildTableCell(employee['Id'] ?? '', 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['First_Name']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['Middle_Name']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['Last_Name']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(
              _getLatestValue(employee['First_Name_In_Arabic']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(
              _getLatestValue(employee['Middle_Name_In_Arabic']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(
              _getLatestValue(employee['Last_Name_In_Arabic']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['National_Id']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(
              _getLatestValue(employee['National_Id_Expiration_Date']),
              150.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['Passport']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(
              _getLatestValue(employee['Passport_Expiration_Date']), 150.w),
          SizedBox(width: 50.w),
          _buildTableCell(
              _getLatestValue(employee['Driving_License_Id']), 150.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getCarPlates(employee['Car_Plates']), 120.w),
        ],
      ),
    );
  }

  Widget _buildPositionDetailsTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: 2600.w,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(color: Colors.black),
              child: Row(
                children: [
                  _buildTableHeaderCell('NO', 60.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Employee ID', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('First Name', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Middle Name', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Last Name', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('الاسم الأول', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('الاسم الأوسط', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('الاسم الأخير', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Department ID', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Department Name', 150.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('الاسم_الوظيفي', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Supervisor', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Role', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Title', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Work Location', 150.w),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _employees.length,
                itemBuilder: (context, index) {
                  final employee = _employees[index];
                  return _buildPositionDetailsRow(employee, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPositionDetailsRow(Map<String, dynamic> employee, int index) {
    final backgroundColor =
    index % 2 == 0 ? AppColors.background : AppColors.card;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(color: backgroundColor),
      child: Row(
        children: [
          _buildTableCell((index + 1).toString(), 60.w),
          SizedBox(width: 50.w),
          _buildTableCell(employee['Id'] ?? '', 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['First_Name']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['Middle_Name']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['Last_Name']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(
              _getLatestValue(employee['First_Name_In_Arabic']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(
              _getLatestValue(employee['Middle_Name_In_Arabic']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(
              _getLatestValue(employee['Last_Name_In_Arabic']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['Department_Id']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell('N/A', 150.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['Title_In_Arabic']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['Supervisor']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['Role']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['Title']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['Work_Location']), 150.w),
        ],
      ),
    );
  }

  Widget _buildAllDataTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: 4600.w,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(color: Colors.black),
              child: Row(
                children: [
                  _buildTableHeaderCell('NO', 60.w),
                  SizedBox(width: 30.w),
                  _buildTableHeaderCell('Employee ID', 120.w),
                  SizedBox(width: 30.w),
                  _buildTableHeaderCell('First Name', 120.w),
                  SizedBox(width: 30.w),
                  _buildTableHeaderCell('Middle Name', 120.w),
                  SizedBox(width: 30.w),
                  _buildTableHeaderCell('Last Name', 120.w),
                  SizedBox(width: 30.w),
                  _buildTableHeaderCell('Gender', 100.w),
                  SizedBox(width: 30.w),
                  _buildTableHeaderCell('Birth Date', 120.w),
                  SizedBox(width: 30.w),
                  _buildTableHeaderCell('Marital Status', 120.w),
                  SizedBox(width: 30.w),
                  _buildTableHeaderCell('Nationality', 120.w),
                  SizedBox(width: 30.w),
                  _buildTableHeaderCell('Language', 100.w),
                  SizedBox(width: 30.w),
                  _buildTableHeaderCell('Email', 150.w),
                  SizedBox(width: 30.w),
                  _buildTableHeaderCell('Mobile Phone', 120.w),
                  SizedBox(width: 30.w),
                  _buildTableHeaderCell('Home Number', 120.w),
                  SizedBox(width: 30.w),
                  _buildTableHeaderCell('Office Number', 120.w),
                  SizedBox(width: 30.w),
                  _buildTableHeaderCell('Extension', 100.w),
                  SizedBox(width: 30.w),
                  _buildTableHeaderCell('Country', 120.w),
                  SizedBox(width: 30.w),
                  _buildTableHeaderCell('Province', 120.w),
                  SizedBox(width: 30.w),
                  _buildTableHeaderCell('City', 120.w),
                  SizedBox(width: 30.w),
                  _buildTableHeaderCell('Street', 150.w),
                  SizedBox(width: 30.w),
                  _buildTableHeaderCell('Postal Code', 120.w),
                  SizedBox(width: 30.w),
                  _buildTableHeaderCell('National ID', 120.w),
                  SizedBox(width: 30.w),
                  _buildTableHeaderCell('National ID Exp', 150.w),
                  SizedBox(width: 30.w),
                  _buildTableHeaderCell('Passport', 120.w),
                  SizedBox(width: 30.w),
                  _buildTableHeaderCell('Passport Exp', 150.w),
                  SizedBox(width: 30.w),
                  _buildTableHeaderCell('Driving License', 150.w),
                  SizedBox(width: 30.w),
                  _buildTableHeaderCell('Car Plates', 120.w),
                  SizedBox(width: 30.w),
                  _buildTableHeaderCell('Title', 120.w),
                  SizedBox(width: 30.w),
                  _buildTableHeaderCell('Department ID', 120.w),
                  SizedBox(width: 30.w),
                  _buildTableHeaderCell('Role', 120.w),
                  SizedBox(width: 30.w),
                  _buildTableHeaderCell('Work Location', 150.w),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _employees.length,
                itemBuilder: (context, index) {
                  final employee = _employees[index];
                  return _buildAllDataRow(employee, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllDataRow(Map<String, dynamic> employee, int index) {
    final backgroundColor =
    index % 2 == 0 ? AppColors.background : AppColors.card;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(color: backgroundColor),
      child: Row(
        children: [
          _buildTableCell((index + 1).toString(), 60.w),
          SizedBox(width: 30.w),
          _buildTableCell(employee['Id'] ?? '', 120.w),
          SizedBox(width: 30.w),
          _buildTableCell(_getLatestValue(employee['First_Name']), 120.w),
          SizedBox(width: 30.w),
          _buildTableCell(_getLatestValue(employee['Middle_Name']), 120.w),
          SizedBox(width: 30.w),
          _buildTableCell(_getLatestValue(employee['Last_Name']), 120.w),
          SizedBox(width: 30.w),
          _buildTableCell(_getLatestValue(employee['Gender']), 100.w),
          SizedBox(width: 30.w),
          _buildTableCell(_getLatestValue(employee['Birth_Day']), 120.w),
          SizedBox(width: 30.w),
          _buildTableCell(_getLatestValue(employee['Marital_Status']), 120.w),
          SizedBox(width: 30.w),
          _buildTableCell(_getLatestValue(employee['Nationality']), 120.w),
          SizedBox(width: 30.w),
          _buildTableCell(_getLatestValue(employee['Language']), 100.w),
          SizedBox(width: 30.w),
          _buildTableCell(_getLatestValue(employee['Email']), 150.w),
          SizedBox(width: 30.w),
          _buildTableCell(_getMobilePhone(employee['Mobile_Phone']), 120.w),
          SizedBox(width: 30.w),
          _buildTableCell(_getLatestValue(employee['Home_Phone']), 120.w),
          SizedBox(width: 30.w),
          _buildTableCell(_getLatestValue(employee['Office_Phone']), 120.w),
          SizedBox(width: 30.w),
          _buildTableCell(_getLatestValue(employee['Extension']), 100.w),
          SizedBox(width: 30.w),
          _buildTableCell(_getLatestValue(employee['Country']), 120.w),
          SizedBox(width: 30.w),
          _buildTableCell(_getLatestValue(employee['Province']), 120.w),
          SizedBox(width: 30.w),
          _buildTableCell(_getLatestValue(employee['City']), 120.w),
          SizedBox(width: 30.w),
          _buildTableCell(_getLatestValue(employee['Street']), 150.w),
          SizedBox(width: 30.w),
          _buildTableCell(_getLatestValue(employee['Postal_Code']), 120.w),
          SizedBox(width: 30.w),
          _buildTableCell(_getLatestValue(employee['National_Id']), 120.w),
          SizedBox(width: 30.w),
          _buildTableCell(
              _getLatestValue(employee['National_Id_Expiration_Date']),
              150.w),
          SizedBox(width: 30.w),
          _buildTableCell(_getLatestValue(employee['Passport']), 120.w),
          SizedBox(width: 30.w),
          _buildTableCell(
              _getLatestValue(employee['Passport_Expiration_Date']), 150.w),
          SizedBox(width: 30.w),
          _buildTableCell(
              _getLatestValue(employee['Driving_License_Id']), 150.w),
          SizedBox(width: 30.w),
          _buildTableCell(_getCarPlates(employee['Car_Plates']), 120.w),
          SizedBox(width: 30.w),
          _buildTableCell(_getLatestValue(employee['Title']), 120.w),
          SizedBox(width: 30.w),
          _buildTableCell(_getLatestValue(employee['Department_Id']), 120.w),
          SizedBox(width: 30.w),
          _buildTableCell(_getLatestValue(employee['Role']), 120.w),
          SizedBox(width: 30.w),
          _buildTableCell(_getLatestValue(employee['Work_Location']), 150.w),
        ],
      ),
    );
  }

  Widget _buildOtherTabsTable() {
    String columnName = '';
    switch (_selectedTopTab) {
      case 'health_insurance':
        columnName = 'Health Insurance';
        break;
      case 'emergency_contacts':
        columnName = 'Emergency Contact';
        break;
      case 'salaries':
        columnName = 'Salary';
        break;
      case 'certifications':
        columnName = 'Certification';
        break;
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: 1500.w,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(color: Colors.black),
              child: Row(
                children: [
                  _buildTableHeaderCell('NO', 60.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('First Name', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Middle Name', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('Last Name', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('الاسم الأول', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('الاسم الأوسط', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell('الاسم الأخير', 120.w),
                  SizedBox(width: 50.w),
                  _buildTableHeaderCell(columnName, 150.w),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _employees.length,
                itemBuilder: (context, index) {
                  final employee = _employees[index];
                  return _buildOtherTabsRow(employee, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtherTabsRow(Map<String, dynamic> employee, int index) {
    final backgroundColor =
    index % 2 == 0 ? AppColors.background : AppColors.card;

    String specificData = '';
    switch (_selectedTopTab) {
      case 'health_insurance':
        specificData = _getLatestValue(employee['Insurance_Name']);
        break;
      case 'emergency_contacts':
        specificData =
            _getLatestValue(employee['First_Contact_First_Name']) +
                ' ' +
                _getLatestValue(employee['First_Contact_Last_Name']);
        break;
      case 'salaries':
        specificData = 'N/A';
        break;
      case 'certifications':
        specificData = _getAcademicHistory(employee['Academic_History']);
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(color: backgroundColor),
      child: Row(
        children: [
          _buildTableCell((index + 1).toString(), 60.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['First_Name']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['Middle_Name']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(_getLatestValue(employee['Last_Name']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(
              _getLatestValue(employee['First_Name_In_Arabic']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(
              _getLatestValue(employee['Middle_Name_In_Arabic']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(
              _getLatestValue(employee['Last_Name_In_Arabic']), 120.w),
          SizedBox(width: 50.w),
          _buildTableCell(specificData, 150.w),
        ],
      ),
    );
  }

  Widget _buildTableHeaderCell(String text, double width) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: AppTextStyles.font14BlackSemiBoldCairo.copyWith(
          color: AppColors.text,
        ),
      ),
    );
  }

  Widget _buildTableCell(String text, double width) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: AppTextStyles.font13SecondaryBlackCairo.copyWith(
          color: AppColors.text,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  String _getLatestValue(dynamic field) {
    if (field == null) return '';
    if (field is List && field.isNotEmpty) {
      final lastValue = field.last;
      if (lastValue is Map && lastValue.containsKey('value')) {
        return lastValue['value']?.toString() ?? '';
      }
      return lastValue?.toString() ?? '';
    }
    if (field is String) return field;
    return field.toString();
  }

  String _getMobilePhone(dynamic mobilePhoneField) {
    if (mobilePhoneField == null) return '';
    if (mobilePhoneField is List && mobilePhoneField.isNotEmpty) {
      final mobilePhone = mobilePhoneField.last;
      if (mobilePhone is Map && mobilePhone['Phone'] != null) {
        final phones = mobilePhone['Phone'];
        if (phones is List && phones.isNotEmpty) {
          return phones.last?.toString() ?? '';
        }
      }
    }
    return '';
  }

  String _getCarPlates(dynamic carPlatesField) {
    if (carPlatesField == null) return '';
    if (carPlatesField is List && carPlatesField.isNotEmpty) {
      final plates = carPlatesField.last;
      if (plates is Map && plates['items'] != null) {
        final items = plates['items'];
        if (items is List && items.isNotEmpty) {
          return items.join(', ');
        }
      }
    }
    return '';
  }

  String _getAcademicHistory(dynamic academicHistoryField) {
    if (academicHistoryField == null) return '';
    if (academicHistoryField is List && academicHistoryField.isNotEmpty) {
      final history = academicHistoryField.last;
      if (history is Map) {
        return history['institutionName']?.toString() ?? '';
      }
    }
    return '';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
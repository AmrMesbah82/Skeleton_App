import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/employees/employees_views/employees_hr_view/employees_profile/custom_personal_Info_Container.dart';
import 'package:demo_app/core/theme/app_font_size.dart';


/// Date Created :3/Dec/2023
/// Developer Name : Bassem Mohamed
/// App Version : Version 2
/// Date of Last Edit :14/Dec/2023
/// Objectives: this screen is responsible for showing the 5 things about each employee, the first thing is to show his personal info, 
/// Position details, additional info, and the assets he got, and also the health, which is bothe the emergency contacts, and the health insurance details
///  
/// 


class PersonalInfoScreen extends StatefulWidget {
  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.78.h,
     
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //Personal Info
            CustomPersonalInfoContainer(
              isPersonalInformation: true,
              primaryText: 'Personal Information',
              customIcons: [
                'assets/icons/PhoneRounded.svg',
                'assets/icons/LetterOpened.svg',
                'assets/icons/MapPoint.svg',
                'assets/icons/Flag.svg',
                'assets/icons/Global.svg',
                'assets/icons/Book.svg',
                'assets/icons/UsersRoundedPersonal.svg',
              ],
              personalInfoTexts: [
                'Second Phone :',
                'Email :',
                'Address :',
                'Nationality :',
                'Language :',
                'Education :',
                'Marital Status :',
              ],
              secondaryTexts: [
                '01243546456',
                'bassem@gmail.com ',
                '15 Nasr City , Cairo ',
                'Egyptian'.tr,
                'Arabic and English',
                'Master Degree at Education  Master Degree at Education Master Degree at Education Master Degree at Education',
                'Married'.tr,
              ],
            ),
            //Position Details
            CustomPersonalInfoContainer(
              primaryText: 'Position Details',
              isPersonalInformation: true,
              isPositionDetailes: true,
              customIcons: [
                'assets/icons/FolderWithFiles.svg',
                'assets/icons/Case.svg',
                'assets/icons/Case.svg',
                'assets/icons/Banknote.svg',
                'assets/icons/MapPoint.svg',
                'assets/icons/Banknote.svg',
              ],
              personalInfoTexts: [
                'Department :',
                'Job Compensation :',
                'Job Type :',
                'Salary :',
                'Job Location :',
                '${'Bounces'.tr} :',
              ],
              secondaryTexts: [
                'Marketing'.tr,
                'Part Time'.tr,
                'Fixed'.tr,
                '20.000 ${'EGP'.tr}',
                'OnSite'.tr,
                '20.000 ${'EGP'.tr}',
              ],
            ),
            CustomPersonalInfoContainer(
              primaryText: 'Additional Information',
              isAdditionalInfo: true,
            ),
            CustomPersonalInfoContainer(
              primaryText: 'Assets',
              isAssets: true,
             
            ),
            CustomPersonalInfoContainer(
              primaryText: 'Health',
              isHealth: true,
            ),
          ],
        ),
      ),
    );
  }
}

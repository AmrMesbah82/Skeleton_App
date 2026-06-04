import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/custom_appbar.dart';
import 'package:demo_app/features/skeleton/app_drawer/presentation/ui/pages/custom_drawer.dart';
import 'package:demo_app/core/widgets/circle_progress.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/no_internet_screen.dart';
import 'package:demo_app/org_chart_card.dart';

class OrgChartTest extends StatefulWidget {
  const OrgChartTest({super.key});

  @override
  State<OrgChartTest> createState() => _OrgChartTestState();
}

class _OrgChartTestState extends State<OrgChartTest> {
  List<EmployeeOrg> gms = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Row(
        children: [
          // Align(
          //   alignment: Alignment.topCenter,
          //   child: CustomDrawer(
          //     selectedIndex: 3,
          //   ),
          // ),
          Container(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomAppBar(),
                        Expanded(
                            child: Container(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 0.025.h,
                              horizontal: 0.02.h, //0.03.w
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "Employees".tr,
                                  style: AppFontStyle.cairoRegularStyle
                                      .copyWith(
                                          fontSize: FontConstants.fontSize038.h,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.1,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inverseSurface),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 0.02.h),
                                  child: Container(
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        OrgChartCard(
                                            department: "Marketing",
                                            role: empOrgList[0].title,
                                            name: empOrgList[0].name),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 0.015.h),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: IntrinsicHeight(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  ...empOrgList
                                                      .where((emp) =>
                                                          emp.supervisorID ==
                                                          empOrgList[0].id)
                                                      .map((child) => Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              OrgChartCard(
                                                                  department:
                                                                      "GM Row",
                                                                  role: child
                                                                      .title,
                                                                  name: child
                                                                      .name),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            0.015.h),
                                                                child: Expanded(
                                                                  // width: 0.5.w,
                                                                  child:
                                                                      SingleChildScrollView(
                                                                    scrollDirection:
                                                                        Axis.horizontal,
                                                                    child:
                                                                        IntrinsicHeight(
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          ...empOrgList
                                                                              .where((emp1) => emp1.supervisorID == child.id)
                                                                              .map((child2) => Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: EdgeInsets.symmetric(horizontal: 0.02.w),
                                                                                        child: OrgChartCard(department: "Manager Row", role: child2.title, name: child2.name),
                                                                                      ),
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          ...empOrgList
                                                                                              .where((emp2) => emp2.supervisorID == child2.id)
                                                                                              .map((child3) => SingleChildScrollView(
                                                                                                    child: Padding(
                                                                                                      padding: EdgeInsets.symmetric(vertical: 0.015.h),
                                                                                                      child: IntrinsicHeight(
                                                                                                        child: Row(
                                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                          children: [
                                                                                                            Column(
                                                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                              children: [
                                                                                                                OrgChartCard(department: "Team Leader Row", role: child3.title, name: child3.name),
                                                                                                                Padding(
                                                                                                                  padding: EdgeInsets.symmetric(vertical: 0.015.h),
                                                                                                                  child: Row(
                                                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                                    children: [
                                                                                                                      ...empOrgList.where((emp3) => emp3.supervisorID == child3.id).map((child4) => Row(
                                                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                                            children: [
                                                                                                                              Padding(
                                                                                                                                padding: EdgeInsets.symmetric(horizontal: 0.01.w),
                                                                                                                                child: OrgChartCard(department: "Member Row", role: child4.title, name: child4.name),
                                                                                                                              ),
                                                                                                                            ],
                                                                                                                          ))
                                                                                                                    ],
                                                                                                                  ),
                                                                                                                )
                                                                                                              ],
                                                                                                            )
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ))
                                                                                              .toList()
                                                                                        ],
                                                                                      )
                                                                                    ],
                                                                                  ))
                                                                              .toList()
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ))
                                                      .toList()
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ))
                      ],
                    ),
                  ),
        ],
      )),
    );
  }
}

class EmployeeOrg {
  final String id;
  final String name;
  final String title;
  final String supervisorID;

  EmployeeOrg(
      {required this.id,
      required this.name,
      required this.supervisorID,
      required this.title});
}

List<EmployeeOrg> empOrgList = [
  EmployeeOrg(
      id: "amro@gmail.com", name: "A.handousa", supervisorID: "", title: "CEO"),
  EmployeeOrg(
      id: "mazen@gmail.com",
      name: "M.shabaan",
      supervisorID: "amro@gmail.com",
      title: "GM"),
  EmployeeOrg(
      id: "bassem@gmail.com",
      name: "B.mohamed",
      supervisorID: "amro@gmail.com",
      title: "GM"),
  EmployeeOrg(
      id: "fouad@gmail.com",
      name: "M.fouad",
      supervisorID: "mazen@gmail.com",
      title: "M1"),
  EmployeeOrg(
      id: "dalal@gmail.com",
      name: "d.elsayed",
      supervisorID: "mazen@gmail.com",
      title: "M2"),
  EmployeeOrg(
      id: "ali@gmail.com",
      name: "A.gamal",
      supervisorID: "bassem@gmail.com",
      title: "M3"),
  EmployeeOrg(
      id: "ibrahem@gmail.com",
      name: "I.slem",
      supervisorID: "bassem@gmail.com",
      title: "M4"),
  EmployeeOrg(
      id: "sara@gmail.com",
      name: "S.ahmed",
      supervisorID: "fouad@gmail.com",
      title: "TM1"),
  EmployeeOrg(
      id: "ahmed@gmail.com",
      name: "A.khaled",
      supervisorID: "fouad@gmail.com",
      title: "TM2"),
  EmployeeOrg(
      id: "mo@gmail.com",
      name: "M.salah",
      supervisorID: "dalal@gmail.com",
      title: "TM3"),
  EmployeeOrg(
      id: "salma@gmail.com",
      name: "s.handousa",
      supervisorID: "ahmed@gmail.com",
      title: "Emp"),
  EmployeeOrg(
      id: "khaled@gmail.com",
      name: "K.handousa",
      supervisorID: "ahmed@gmail.com",
      title: "Emp"),
  EmployeeOrg(
      id: "fatma@gmail.com",
      name: "f.handousa",
      supervisorID: "ahmed@gmail.com",
      title: "Emp"),
];

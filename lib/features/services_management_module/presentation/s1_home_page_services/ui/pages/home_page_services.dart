import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:demo_app/core/custom/7_custom_button_with_icon.dart';
import 'package:demo_app/features/services_management_module/presentation/s1_home_page_services/ui/widgets/management_widget.dart';
import 'package:demo_app/features/services_management_module/presentation/s1_home_page_services/ui/widgets/request_services_button.dart';
import 'package:demo_app/features/services_management_module/presentation/s1_home_page_services/ui/widgets/request_services_widget.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/services/services_permissions_sections.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:demo_app/generated/l10n.dart';

import 'package:demo_app/core/utils/shared.dart';
import 'package:demo_app/features/services_management_module/data/helper/services_prefs_employee.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/modules_enum.dart';
import 'package:demo_app/features/department/presentation/controller/add_department_controller.dart';
import 'package:demo_app/features/employee/domain/entities/employee_entity.dart';
import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
import 'package:demo_app/core/widgets/services_management/custom_filter.dart';
import 'package:demo_app/core/helper/services_management/circle_progress.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/features/services_management_module/data/repository/service_repository_impl.dart';
import 'package:demo_app/features/services_management_module/presentation/controller/services_manager_cubit.dart';
import 'package:demo_app/core/widgets/services_management/W3_Frame_Screen_tablet.dart';
import 'package:demo_app/features/services_management_module/presentation/s1_home_page_services/ui/widgets/shared_prefs.dart' show SharedPrefsServiceMaster;

import '../../../../data/helper/csv_helper.dart';

class ServicesScreenTablet extends StatefulWidget {
  const ServicesScreenTablet({super.key});

  @override
  State<ServicesScreenTablet> createState() => _ServicesScreenTabletState();
}

class _ServicesScreenTabletState extends State<ServicesScreenTablet> with TickerProviderStateMixin {

  late AnimationController _gridAnimationController;
  final List<Animation<Offset>> _slideAnimations = [];

  bool _isInitializing = true;
  bool _dataFullyLoaded = false;
  bool _hasInitialized = false; // ✅ NEW: Track if we've already initialized

  // ✅ NEW: Track if we're currently processing an update
  bool _isProcessingUpdate = false;

  // ✅ NEW: Track the last service count to detect actual changes
  int _lastServicesCount = 0;
  bool isGridViewChoose = true;
  int selectedStatusIndex = 0;

  EmployeeEntityPro? _employeeEntity;

  EmployeeEntityPro get employeeEntity {
    if (_employeeEntity == null) {
      final controller = Get.find<MainCoreEmployeeController>();
      if (controller.employeeEntity != null) {
        _employeeEntity = controller.employeeEntity;
      } else {
        // // //print'⚠️ WARNING: EmployeeEntity is null in getter');
        throw Exception('EmployeeEntity is not initialized yet');
      }
    }
    return _employeeEntity!;
  }

  final TextEditingController _searchController = TextEditingController();
  Map<String, Map<String, dynamic>> selectedProviders = {};
  Map<String, int> doneServicesCount = {};

  void _initializeGridAnimations(int itemCount) {
    _slideAnimations.clear();

    for (int i = 0; i < itemCount; i++) {
      final Animation<Offset> slideAnimation = Tween<Offset>(
        begin: const Offset(-1.0, 0.0), // Slide from left (horizontal)
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _gridAnimationController,
          curve: Interval(
            (i * 0.15).clamp(0.0, 1.0),
            ((i * 0.15) + 0.4).clamp(0.0, 1.0),
            curve: Curves.easeOutCubic,
          ),
        ),
      );
      _slideAnimations.add(slideAnimation);
    }

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _gridAnimationController.forward();
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _gridAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    formatDate = DateFormat("MMMdd_yyyy").format(Timestamp.now().toDate());
    searchController.addListener(() => _applyFilters());

    // ✅ FIX: Ensure filter starts at "All" (index 0)
    selectedStatusIndex = 0;

    // ✅ Only initialize once
    if (!_hasInitialized) {
      _initializeAllData();
    }
  }

  // ✅ NEW: Master initialization method
  // ✅ UPDATED: Master initialization method with flag
  Future<void> _initializeAllData() async {
    // ✅ Prevent duplicate initialization
    if (_hasInitialized) {
      //print"⚠️ Already initialized, skipping...");
      return;
    }

    try {
      //print"╔════════════════════════════════════════════════════════════════╗");
      //print"║         🚀 INITIALIZING ALL DATA - PLEASE WAIT                ║");
      //print"╚════════════════════════════════════════════════════════════════╝");

      setState(() {
        _isInitializing = true;
        _dataFullyLoaded = false;
      });

      // Step 1: Initialize employee
      //print"✅ [1/4] Initializing employee...");
      await _initializeEmployeeAndData();

      // Step 2: Load user department
      //print"✅ [2/4] Loading department...");
      await loadUserDepartmentSafely();
      //print"   - userEmail: '$userEmail'");
      //print"   - userDepartment: '$userDepartment'");

      // Step 3: Fetch services from Firestore
      //print"✅ [3/4] Fetching services...");
      if (mounted) {
        await ServicesManagerCubit.get(context).getAllRequestServices();
      }

      // Step 4: Apply filters
      //print"✅ [4/4] Applying filters...");
      if (mounted && userDepartment.isNotEmpty) {
        _applyFilters();
      } else {
        //print"⚠️ userDepartment still empty after load");
      }

      // ✅ Small delay to ensure everything is rendered
      await Future.delayed(const Duration(milliseconds: 500));

      // ✅ Mark as fully loaded AND initialized
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _dataFullyLoaded = true;
          _hasInitialized = true; // ✅ Set the flag
        });
      }

      //print"╔════════════════════════════════════════════════════════════════╗");
      //print"║         ✅ ALL DATA LOADED SUCCESSFULLY                        ║");
      //print"╚════════════════════════════════════════════════════════════════╝");
    } catch (e, stackTrace) {
      //print"❌ ERROR during initialization: $e");
      //print"🧱 Stack trace: $stackTrace");

      if (mounted) {
        setState(() {
          _isInitializing = false;
          _dataFullyLoaded = false;
          _hasInitialized =
          true; // ✅ Still mark as initialized to prevent retry loop
        });
      }
    }
  }

  /////////////////////////////////// Admin /////////////////////////////

  List<ServicesHistoryModel> filteredServices = [];
  TextEditingController searchController = TextEditingController();
  String userEmail = '';
  String userDepartment = '';

  List<String> allowedDepartmentsCache = [];
  String? selectedDurationUnit;

  Future<void> loadAndPrepareData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userEmail = employeeEntity.email ?? '';
    userDepartment = Get.find<MainCoreEmployeeController>()
        .getEmployeeDepartmentName(userEmail);

    final model = ServicesManagerCubit
        .get(context)
        .servicesRequest;

    setState(() {
      filteredServices = _filterServicesForUser(model);
    });

    final myDeptCanonical = _normDept(userDepartment);
//    _recountDepartments(model, myDeptCanonical);
  }

  List<ServicesHistoryModel> _filterServicesForUser(
      List<ServicesHistoryModel> services) {
    return services.where((service) => canUserSeeService(service)).toList();
  }

  void fetchLocalDepartmentCounts() {
    final model = ServicesManagerCubit
        .get(context)
        .servicesRequest;

    final List<String> departments = [
      "Executive",
      "Customer Support",
      "Operations",
      "Finance",
      "Information Technology",
      "Human Resources",
      "Marketing",
      "Sales",
      "Data Management",
      "Compliance & Legal",
      "Software",
    ];

    final Map<String, int> departmentCounts = {
      for (var dept in departments) dept: 0,
    };

    int localTotal = 0;

    for (var service in model) {
      final isLimited = service.currentLimitAvailability;
      final sameDepartment =
          service.currentDepartmentRequester.toLowerCase().trim() ==
              userDepartment.toLowerCase().trim();

      if (!isLimited || sameDepartment) {
        final dept = service.currentDepartmentRequester;
        if (departmentCounts.containsKey(dept)) {
          departmentCounts[dept] = departmentCounts[dept]! + 1;
          localTotal++;
        }
      }
    }

    setState(() {
      executiveCount = departmentCounts["Executive"] ?? 0;
      customerSupportCount = departmentCounts["Customer Support"] ?? 0;
      operationsCount = departmentCounts["Operations"] ?? 0;
      financeCount = departmentCounts["Finance"] ?? 0;
      informationTechnologyCount =
          departmentCounts["Information Technology"] ?? 0;
      humanResourcesCount = departmentCounts["Human Resources"] ?? 0;
      marketingCount = departmentCounts["Marketing"] ?? 0;
      salesCount = departmentCounts["Sales"] ?? 0;
      dataManagementCount = departmentCounts["Data Management"] ?? 0;
      complianceLegalCount = departmentCounts["Compliance & Legal"] ?? 0;
      softwareCount = departmentCounts["Software"] ?? 0;

      totalServices = localTotal;
    });
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userEmail = prefs.getString("emailRequester") ?? '';
    userDepartment = Get.find<MainCoreEmployeeController>()
        .getEmployeeDepartmentName(userEmail);

    var model = ServicesManagerCubit
        .get(context)
        .servicesRequest;

    setState(() {
      filteredServices = _filterServicesByDepartmentAccess(model);
    });
  }

  List<ServicesHistoryModel> _filterServicesByDepartmentAccess(
      List<ServicesHistoryModel> services) {
    List<ServicesHistoryModel> filteredList = [];

    for (var service in services) {
      final isLimited = service.currentLimitAvailability;
      final sameDepartment =
          service.currentDepartmentRequester.toLowerCase().trim() ==
              userDepartment.toLowerCase().trim();

      if (isLimited ? sameDepartment : true) {
        filteredList.add(service);
      }
    }

    return filteredList;
  }

  String? formatDate;

  List<String> _processAllowedDepartments(ServicesHistoryModel service) {
    List<String> allowedDepts = [];

    final selectDepartment = service.currentSelectDepartment;
    if (selectDepartment.isNotEmpty) {
      for (var dept in selectDepartment) {
        final normalizedDept = _normDept(dept.toString());
        if (normalizedDept.isNotEmpty) {
          allowedDepts.add(normalizedDept);
        }
      }
    }

    return allowedDepts;
  }

  void _onSearchChangedRequest() {
    var model = ServicesManagerCubit
        .get(context)
        .servicesRequest;
    String query = searchController.text.toLowerCase().trim();

    setState(() {
      filteredServices = _filterServicesBySearchAndDepartment(model, query);
    });
  }

  List<ServicesHistoryModel> _filterServicesBySearchAndDepartment(
      List<ServicesHistoryModel> services, String query) {
    List<ServicesHistoryModel> filteredList = [];

    for (var service in services) {
      final nameEn = service.currentServiceNameEnglish.toLowerCase();
      final nameAr = service.currentServiceNameArabic.toLowerCase();

      final nameMatch = nameEn.contains(query) || nameAr.contains(query);

      final isLimited = service.currentLimitAvailability;
      final sameDepartment =
          service.currentDepartmentRequester.toLowerCase().trim() ==
              userDepartment.toLowerCase().trim();

      final departmentCheck = isLimited ? sameDepartment : true;

      if (nameMatch && departmentCheck) {
        filteredList.add(service);
      }
    }

    return filteredList;
  }

  Future<void> loadUserDepartmentSafely() async {
    try {
      //print"\n╔════════════════════════════════════════════════════════════════╗");
      //print"║              🔒 loadUserDepartmentSafely START                 ║");
      //print"╚════════════════════════════════════════════════════════════════╝");

      if (_employeeEntity == null) {
        //print"⚠️ Employee entity is null, initializing...");
        await _initializeEmployeeAndData();
      }

      userEmail = _employeeEntity?.email ?? '';
      //print"📧 Loaded Email: '$userEmail'");

      if (userEmail.isNotEmpty) {
        userDepartment = Get.find<MainCoreEmployeeController>()
            .getEmployeeDepartmentName(userEmail);

        //print"🏢 Loaded Department: '$userDepartment'");

        if (userDepartment.isEmpty) {
          //print"⚠️ WARNING: Department is EMPTY even though email exists!");
          //print"   Attempting to get department from employee entity...");

          if (_employeeEntity?.departmentId != null) {
            try {
              final deptController = Get.find<MainCoreDepartmentController>();
              userDepartment = deptController.getDepartmentName(
                  _employeeEntity!.departmentId!,
                  true // English
              );
              //print"✅ Got department from entity: '$userDepartment'");
            } catch (e) {
              //print"❌ Failed to get department from entity: $e");
            }
          }
        }
      } else {
        //print"❌ ERROR: No email found!");
        //print"╚════════════════════════════════════════════════════════════════╝\n");
        return;
      }

      // ✅ REMOVED: Don't call _applyFilters here, it will be called in initState
      //print"✅ Department loaded successfully, _applyFilters will be called in initState");
      //print"╚════════════════════════════════════════════════════════════════╝\n");
    } catch (e, stackTrace) {
      //print"❌ ERROR loading user data: $e");
      //print"🧱 Stack trace: $stackTrace");
    }
  }

  int totalServices = 0;
  int executiveCount = 0;
  int customerSupportCount = 0;
  int operationsCount = 0;
  int financeCount = 0;
  int informationTechnologyCount = 0;
  int humanResourcesCount = 0;
  int marketingCount = 0;
  int salesCount = 0;
  int dataManagementCount = 0;
  int complianceLegalCount = 0;
  int softwareCount = 0;
  String selectStatus = "All";
  List<Map<String, dynamic>> allServices = [];
  bool isServiceListLoading = true;

  Map<String, String> departmentTranslations = {
    "Marketing": "التسويق",
    "Sales": "المبيعات",
    "HR": "شؤون الموظفين",
    "Executive": "الإدارة التنفيذية",
    "Customer Support": "دعم العملاء",
    "Operations": "العمليات",
    "Finance": "المالية",
    "Information Technology": "تقنية المعلومات",
    "Human Resources": "الموارد البشرية",
    "Data Management": "إدارة البيانات",
    "Compliance & Legal": "الامتثال والقانون",
    "Software": "البرمجيات",
  };

  String getLocalizedDepartment(String key, bool isArabic) {
    return isArabic ? (departmentTranslations[key] ?? key) : key;
  }

  String _normDept(String? raw) {
    if (raw == null || raw
        .trim()
        .isEmpty) {
      //print"      ⚠️ _normDept: Input is null or empty");
      return '';
    }

    final k = raw.trim().toLowerCase();
    //print"      🔄 _normDept: '$raw' → lowercase: '$k'");

    // Executive
    if (k == 'executive' || k.contains('executive') || k == 'exec') {
      //print"      ✅ Matched: Executive");
      return 'Executive';
    }

    // Customer Support
    if (k == 'customer support' ||
        (k.contains('customer') && k.contains('support')) ||
        k == 'support' ||
        k == 'customer service') {
      //print"      ✅ Matched: Customer Support");
      return 'Customer Support';
    }

    // Operations
    if (k == 'operations' || k.contains('operation') || k == 'ops') {
      //print"      ✅ Matched: Operations");
      return 'Operations';
    }

    // Finance
    if (k == 'finance' ||
        k.contains('financ') ||
        k == 'accounting' ||
        k.contains('account')) {
      //print"      ✅ Matched: Finance");
      return 'Finance';
    }

    // Information Technology
    if (k == 'information technology' ||
        k == 'it' ||
        k.contains('information') ||
        k.contains('technology') ||
        k == 'tech' ||
        k.contains('it ') ||
        k.startsWith('it')) {
      //print"      ✅ Matched: Information Technology");
      return 'Information Technology';
    }

    // Human Resources
    if (k == 'human resources' ||
        k == 'hr' ||
        k.contains('human') ||
        k.contains('resource') ||
        k == 'personnel') {
      //print"      ✅ Matched: Human Resources");
      return 'Human Resources';
    }

    // Marketing
    if (k == 'marketing' ||
        k.contains('marketing') ||
        k.startsWith('market') ||
        k.startsWith('mark') ||
        k == 'mkt') {
      //print"      ✅ Matched: Marketing");
      return 'Marketing';
    }

    // Sales
    if (k == 'sales' ||
        k.contains('sales') ||
        k == 'salse' ||
        k.startsWith('sale') ||
        k == 'business development') {
      //print"      ✅ Matched: Sales");
      return 'Sales';
    }

    // Data Management
    if (k == 'data management' ||
        (k.contains('data') && k.contains('management')) ||
        k == 'data' ||
        k == 'data analytics') {
      //print"      ✅ Matched: Data Management");
      return 'Data Management';
    }

    // Compliance & Legal
    if (k == 'compliance & legal' ||
        k.contains('compliance') ||
        k.contains('legal') ||
        k == 'compliance' ||
        k == 'legal') {
      //print"      ✅ Matched: Compliance & Legal");
      return 'Compliance & Legal';
    }

    // Software
    if (k == 'software' ||
        k.contains('software') ||
        k == 'development' ||
        k.contains('dev') ||
        k == 'engineering') {
      //print"      ✅ Matched: Software");
      return 'Software';
    }

    // Arabic translations
    if (k.contains('التنفيذي')) return 'Executive';
    if (k.contains('دعم العملاء')) return 'Customer Support';
    if (k.contains('العمليات')) return 'Operations';
    if (k.contains('المالية')) return 'Finance';
    if (k.contains('تقنية المعلومات') || k == 'it')
      return 'Information Technology';
    if (k.contains('الموارد البشرية')) return 'Human Resources';
    if (k.contains('التسويق')) return 'Marketing';
    if (k.contains('المبيعات')) return 'Sales';
    if (k.contains('إدارة البيانات')) return 'Data Management';
    if (k.contains('الامتثال') || k.contains('القانون'))
      return 'Compliance & Legal';
    if (k.contains('البرمجيات')) return 'Software';

    // No match found
    //print"      ❌ NO MATCH - Returning trimmed original: '${raw.trim()}'");
    return raw.trim();
  }

  void _applyFilters() {
    //print"\n╔════════════════════════════════════════════════════════════════╗");
    //print"║                 🔍 _applyFilters START                         ║");
    //print"╚════════════════════════════════════════════════════════════════╝");

    final model = ServicesManagerCubit.get(context).servicesRequest;
    //print"📊 Services from cubit: ${model.length}");
    //print"📊 Current userDepartment: '$userDepartment'");
    //print"📊 Current userEmail: '$userEmail'");

    // ✅ FIX: Get localized strings properly
    final l = S.of(context);
    final selectedKey = _getSelectedKeyByIndex(selectedStatusIndex, l);

    //print"📊 Current selectStatus: '$selectStatus' (Index: $selectedStatusIndex, Key: '$selectedKey')";

    if (userDepartment.isEmpty) {
      //print"⚠️⚠️⚠️ WARNING: userDepartment is EMPTY!");
      //print"   Trying to reload user department...";

      try {
        userEmail = _employeeEntity?.email ?? '';
        if (userEmail.isNotEmpty) {
          userDepartment = Get.find<MainCoreEmployeeController>()
              .getEmployeeDepartmentName(userEmail);
          //print"   ✅ Reloaded userDepartment: '$userDepartment'";
        }
      } catch (e) {
        //print"   ❌ Failed to reload userDepartment: $e";
      }
    }

    final query = searchController.text.toLowerCase().trim();

    // ✅ CRITICAL FIX: Use l.all instead of "All"
    final selectedKeyCanonical = l.all;

    final myDeptCanonical = _normDept(userDepartment);

    //print"🔍 Filter Parameters:";
    //print"   - Search Query: '${query.isEmpty ? 'EMPTY' : query}'";
    //print"   - Selected Key Canonical: '$selectedKeyCanonical' (Localized: '$selectedKey')";
    //print"   - My Dept Canonical: '${myDeptCanonical.isEmpty ? 'EMPTY ⚠️' : myDeptCanonical}'";

    final list = _applyAllFilters(model, query, selectedKeyCanonical);
    //print"✅ Filtered: ${list.length} services";

    // Calculate department counts
    //print"\n🔢 Calculating department counts from ${list.length} filtered services...";

    final keys = [
      "Executive",
      "Customer Support",
      "Operations",
      "Finance",
      "Information Technology",
      "Human Resources",
      "Marketing",
      "Sales",
      "Data Management",
      "Compliance & Legal",
      "Software",
    ];

    final Map<String, int> counts = { for (final k in keys) k: 0};
    var total = 0;

    int draftCount = 0;
    int visibleDraftCount = 0;

    for (int i = 0; i < list.length; i++) {
      final service = list[i];

      final state = service.currentState?.toLowerCase().trim() ?? '';
      final isDraft = state == 'draft';

      if (isDraft) {
        draftCount++;
        continue;
      }

      final rawDept = service.currentDepartmentRequester;
      final sDept = _normDept(rawDept);

      if (sDept.isEmpty) {
        continue;
      }

      if (counts.containsKey(sDept)) {
        counts[sDept] = (counts[sDept] ?? 0) + 1;
        total++;
      }
    }

    //print"\n📊 Final Counts:";
    //print"   - Total Active/Published: $total";
    //print"   - Draft Services Found: $draftCount (Visible to you: $visibleDraftCount)";

    if (mounted) {
      setState(() {
        filteredServices = list;

        executiveCount = counts["Executive"] ?? 0;
        customerSupportCount = counts["Customer Support"] ?? 0;
        operationsCount = counts["Operations"] ?? 0;
        financeCount = counts["Finance"] ?? 0;
        informationTechnologyCount = counts["Information Technology"] ?? 0;
        humanResourcesCount = counts["Human Resources"] ?? 0;
        marketingCount = counts["Marketing"] ?? 0;
        salesCount = counts["Sales"] ?? 0;
        dataManagementCount = counts["Data Management"] ?? 0;
        complianceLegalCount = counts["Compliance & Legal"] ?? 0;
        softwareCount = counts["Software"] ?? 0;
        totalServices = total;

        isServiceListLoading = false;
      });
      //print"✅ State updated";
    } else {
      //print"⚠️ Widget not mounted, skipping setState";
    }

    //print"╚════════════════════════════════════════════════════════════════╝\n";
  }

  List<ServicesHistoryModel> _applyAllFilters(
      List<ServicesHistoryModel> services,
      String query,
      String selectedKeyCanonical) {
    List<ServicesHistoryModel> filteredList = [];

    for (int i = 0; i < services.length; i++) {
      final service = services[i];
      final nameEn = service.currentServiceNameEnglish.toLowerCase();
      final nameAr = service.currentServiceNameArabic.toLowerCase();
      final matchesName = query.isEmpty || nameEn.contains(query) ||
          nameAr.contains(query);

      // ✅ Use canUserSeeService which now properly handles drafts
      bool passesVisibility = canUserSeeService(service, i);

      final serviceDeptCanonical = _normDept(
          service.currentDepartmentRequester);

      // ✅ For "All", show all visible services (including user's drafts)
      // For specific departments, exclude drafts since they're personal
      bool matchesDeptChip;
      if (selectedKeyCanonical == "All") {
        matchesDeptChip = true; // Show all visible including user's drafts
      } else {
        // When filtering by department, exclude drafts (they're not departmental)
        final isDraft = service.currentState?.toLowerCase().trim() == 'draft';
        matchesDeptChip =
            !isDraft && (serviceDeptCanonical == selectedKeyCanonical);
      }

      if (matchesName && passesVisibility && matchesDeptChip) {
        filteredList.add(service);
      }
    }

    return filteredList;
  }

  bool canUserSeeService(ServicesHistoryModel service, [int? index]) {
    final indexStr = index != null ? " [Service #$index]" : "";
    final shouldPrintDetails = index == null || index < 3;

    if (_employeeEntity == null) {
      return false;
    }

    final currentUserEmail = (_employeeEntity?.email ?? '')
        .toLowerCase()
        .trim();
    final serviceEmail = (service.currentEmailRequester ?? '')
        .toLowerCase()
        .trim();
    final isAdmin = _employeeEntity?.role?.toLowerCase().contains("admin") ==
        true;

    // ✅ FIX: Handle null state safely
    final state = service.currentState?.toLowerCase().trim() ?? '';
    final isDraft = state == 'draft';
    final isCreator = serviceEmail == currentUserEmail;

    // ✅ FIX: Draft services - only creator can see their own drafts
    if (isDraft) {
      if (isCreator) {
        return true;
      } else {
        return false;
      }
    }

    // ✅ Admin can see all non-draft services
    if (isAdmin) {
      return true;
    }

    // ✅ Non-draft services: check visibility rules
    if (!service.currentLimitAvailability) {
      return true;
    }

    final userDept = _normDept(userDepartment);
    if (userDept.isEmpty) {
      return false;
    }

    final selectDepartment = service.currentSelectDepartment;
    if (selectDepartment.isNotEmpty) {
      List<String> allowedDepartments = _processAllowedDepartments(service);
      final canSee = allowedDepartments.contains(userDept);

      return canSee;
    }

    return false;
  }

  Map<String, int> _createSortedDepartmentMap() {
    final unsortedMap = {
      "Marketing": marketingCount,
      "Software": softwareCount,
      "Finance": financeCount,
      "Human Resources": humanResourcesCount,
      "Operations": operationsCount,
      "Executive": executiveCount,
      "Customer Support": customerSupportCount,
      "Information Technology": informationTechnologyCount,
      "Sales": salesCount,
      "Data Management": dataManagementCount,
      "Compliance & Legal": complianceLegalCount,
    };

    final sortedEntries = unsortedMap.entries.toList();
    sortedEntries.sort((a, b) => b.value.compareTo(a.value));

    final Map<String, int> sortedMap = {};
    for (final entry in sortedEntries) {
      sortedMap[entry.key] = entry.value;
    }

    return sortedMap;
  }

  /////////////////////////////////// Admin /////////////////////////////

  Future<void> _initializeEmployeeAndData() async {
    try {
      // // //print"🔄 ========== _initializeEmployeeAndData START ==========");
      final controller = Get.find<MainCoreEmployeeController>();

      int attempts = 0;
      while (controller.employeeEntity == null && attempts < 100) {
        await Future.delayed(Duration(milliseconds: 100));
        attempts++;
        if (attempts % 10 == 0) {
          // // //print"⏳ Waiting for employee... attempt $attempts");
        }
      }

      if (controller.employeeEntity == null) {
        // // //print'❌ Failed to load employee data after $attempts attempts');
        return;
      }

      _employeeEntity = controller.employeeEntity;

      // // //print"✅ Employee loaded successfully:");
      // // //print"   - Email: ${_employeeEntity?.email}");
      // // //print"   - Role: ${_employeeEntity?.role}");
      // // //print"   - Department ID: ${_employeeEntity?.departmentId}");
      // // //print"   - Is Admin: ${_employeeEntity?.role?.toLowerCase()?.contains('admin')}");

      await SharedPrefsServiceMaster.fixExistingDrafts();
      await SharedPrefsEmployeeHelper.clearSelectedEmployees();

      try {
        final cubit = ServicesManagerCubit.get(context);
        if (cubit.docService != null) {
          cubit.docService = cubit.docService!.copyWith(providerServices: []);
        }
      } catch (e) {
        // // //print'❌ Error clearing cubit provider selections: $e');
      }

      // // //print'✅ Provider selections cleared');

      _searchController.addListener(_onSearchChanged);

      final servicesCubit = ServicesManagerCubit.get(context);
      servicesCubit.loadServices();
      loadSelectedProviders();

      await startApp();

      // // //print"🔄 ========== _initializeEmployeeAndData END ==========");
    } catch (e, stackTrace) {
      // // //print'❌ Error in initialization: $e');
      // // //print'❌ Stack trace: $stackTrace');
    }
  }

  Future<void> startApp() async {
    try {
      // // //print"🚀 ========== startApp START ==========");

      await Future.delayed(Duration(seconds: 2));

      final prefs = await SharedPreferences.getInstance();
      var department = Get.find<MainCoreDepartmentController>()
          .getEnglishDepartmentNameFromDepartmentId(
        departmentId: employeeEntity.departmentId!,
      );

      await prefs.setString("emailRequester", employeeEntity.email ?? '');
      await prefs.setString(
        "firstNameRequester",
        employeeEntity.firstName ?? '',
      );
      await prefs.setString("lastNameRequester", employeeEntity.lastName ?? '');
      await prefs.setString("genderRequester", employeeEntity.gender ?? '');
      await prefs.setString(
        "phoneRequester",
        employeeEntity.mobilePhone?.phone ?? '',
      );
      await prefs.setString(
        "firstNameRequesterArabic",
        employeeEntity.firstNameInArabic ?? '',
      );
      await prefs.setString(
        "lastNameRequesterArabic",
        employeeEntity.lastNameInArabic ?? '',
      );
      await prefs.setString(
        "jobTitleRequesterArabic",
        employeeEntity.titleInArabic ?? '',
      );
      await prefs.setString("jobTitleRequester", employeeEntity.title ?? '');
      await prefs.setString("departmentRequester", department ?? '');

      // // //print"✅ SharedPreferences saved");
      // // //print"   - Email: ${employeeEntity.email}");
      // // //print"   - Department: $department");

      if (mounted) {
        ServicesManagerCubit.get(context).getMyApprovalServices(
            employeeEntity.email!);
      }

      // // //print"🚀 ========== startApp END ==========");
    } catch (e) {
      // // //print'❌ Error in startApp: $e');
    }
  }

  String formatStartDate(dynamic timestampOrDateTime) {
    if (timestampOrDateTime == null) return '-';

    DateTime date;

    if (timestampOrDateTime is Timestamp) {
      date = timestampOrDateTime.toDate();
    } else if (timestampOrDateTime is DateTime) {
      date = timestampOrDateTime;
    } else {
      return '-';
    }

    final formatted = DateFormat('dd MMM yyyy').format(date);
    return formatted;
  }

  Future<List<ServicesHistoryModel>> _getAllServicesIncludingDrafts() async {
    final servicesCubit = ServicesManagerCubit.get(context);

    // ✅ Use servicesRequest which now has repaired drafts
    final firestoreServices = servicesCubit.servicesRequest;

    // Separate drafts from regular services
    final regularServices = firestoreServices.where((s) {
      final state = s.currentState?.toLowerCase().trim() ?? '';
      return state != 'draft';
    }).toList();

    final draftsInFirestore = firestoreServices.where((s) {
      final state = s.currentState?.toLowerCase().trim() ?? '';
      return state == 'draft';
    }).toList();

    // Get additional Firebase drafts (if any not already included)
    List<ServicesHistoryModel> additionalDrafts = [];
    try {
      additionalDrafts = await servicesCubit.getFirebaseDrafts();
    } catch (e) {
    }

    // Combine all (avoiding duplicates)
    final combinedServices = <ServicesHistoryModel>[];
    final Set<String> addedIds = {};

    for (final service in [...regularServices, ...draftsInFirestore, ...additionalDrafts]) {
      if (!addedIds.contains(service.currentId)) {
        combinedServices.add(service);
        addedIds.add(service.currentId);
      }
    }

    return combinedServices;
  }
  void loadSelectedProviders() async {
    for (var service in ServicesManagerCubit
        .get(context)
        .services) {
      final serviceId = service.currentId;
      if (serviceId.isNotEmpty) {
        final selected = await selectServiceProvider(serviceId);
        if (selected != null) {
          if (mounted) {
            setState(() {
              selectedProviders[serviceId] = selected;
            });
          }
        }
      }
    }
  }

  void _onSearchChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _gridAnimationController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    searchController.removeListener(_onSearchChangedRequest);
    searchController.dispose();
    super.dispose();
  }

  String getLocalizedDurationUnit(BuildContext context,
      String? rawUnit, {
        num? quantity,
      }) {
    final localizer = S.of(context);
    if (rawUnit == null) return '';

    final k = rawUnit.trim().toLowerCase();

    String canonical;
    switch (k) {
      case 'h':
      case 'hr':
      case 'hrs':
      case 'hour':
      case 'hours':
        canonical = 'hours';
        break;
      case 'm':
      case 'min':
      case 'mins':
      case 'minute':
      case 'minutes':
        canonical = 'minutes';
        break;
      case 's':
      case 'sec':
      case 'secs':
      case 'second':
      case 'seconds':
        canonical = 'seconds';
        break;
      case 'w':
      case 'wk':
      case 'wks':
      case 'week':
      case 'weeks':
        canonical = 'week';
        break;
      case 'd':
      case 'day':
      case 'days':
        canonical = 'day';
        break;
      case 'mo':
      case 'month':
      case 'months':
        canonical = 'month';
        break;
      case 'y':
      case 'yr':
      case 'yrs':
      case 'year':
      case 'years':
        canonical = 'year';
        break;
      default:
        return rawUnit;
    }

    switch (canonical) {
      case 'hours':
        return localizer.hours;
      case 'minutes':
        return localizer.minutes;
      case 'seconds':
        return localizer.seconds;
      case 'week':
        return localizer.week;
      case 'day':
        return localizer.day;
      case 'month':
        return localizer.month;
      case 'year':
        return localizer.year;
      default:
        return rawUnit;
    }
  }

  String _getSelectedKeyByIndex(int index, S l) {
    // ✅ Return English keys internally
    switch (index) {
      case 0:
        return "All";
      case 1:
        return "Active";
      case 2:
        return "Inactive";
      case 3:
        return "Draft";
      default:
        return "All";
    }
  }

  int _getIndexByKey(String key, S l) {
    // ✅ Work with English keys
    if (key == "All") return 0;
    if (key == "Active") return 1;
    if (key == "Inactive") return 2;
    if (key == "Draft") return 3;
    return 0;
  }

  @override
  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    //print"\n╔════════════════════════════════════════════════════════════════╗");
    //print"║              🎨 SERVICES SCREEN TABLET BUILD                   ║");
    //print"║  _hasInitialized: $_hasInitialized                              ║");
    //print"║  _isInitializing: $_isInitializing                              ║");
    //print"║  _dataFullyLoaded: $_dataFullyLoaded                            ║");
    //print"╚════════════════════════════════════════════════════════════════╝");
    final cubit = ServicesManagerCubit.get(context);
    // ✅ UPDATED: Only show loading on FIRST load, not on navigation back
    if (!_hasInitialized && (_isInitializing || !_dataFullyLoaded)) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleProgress(),
              const SizedBox(height: 20),
              Text(
                S
                    .of(context)
                    .loading ?? 'Loading...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme
                      .of(context)
                      .brightness == Brightness.light
                      ? AppColors.black.withOpacity(0.54)
                      : AppColors.white.withOpacity(0.70),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isArabic ?  "يرجى الانتظار ريثما يتم تحميل خدماتك..." : "Please wait while we load your services..." ,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme
                      .of(context)
                      .brightness == Brightness.light
                      ? AppColors.black.withOpacity(0.38)
                      : AppColors.white.withOpacity(0.54),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ✅ MAIN CONTENT - Show immediately on subsequent visits
    return BlocConsumer<ServicesManagerCubit, ServicesManagerState>(
      listener: (context, state) {
        //print"\n🔔 BlocConsumer Listener - State: ${state.runtimeType}");

        if (state is GetServiceLoaded) {
          //print"✅ Services loaded in BlocListener");
          //print"   - Services count: ${ServicesManagerCubit.get(context).servicesRequest.length}");
          //print"   - Current userDepartment: '$userDepartment'");

          // ✅ CRITICAL FIX: Only process if fully initialized AND not already processing
          if (mounted && _hasInitialized && !_isProcessingUpdate) {
            //print"   - Checking if data actually changed...");

            final newServicesCount = ServicesManagerCubit
                .get(context)
                .servicesRequest
                .length;

            // ✅ Only apply filters if service count changed
            if (newServicesCount != _lastServicesCount) {
              //print"   - Service count changed: $_lastServicesCount → $newServicesCount");
              //print"   - Applying filters...");

              setState(() {
                _isProcessingUpdate = true;
              });

              // If userDepartment is empty, try to load it first
              if (userDepartment.isEmpty && _employeeEntity != null) {
                //print"   ⚠️ userDepartment empty, loading it first...");
                userEmail = _employeeEntity?.email ?? '';
                if (userEmail.isNotEmpty) {
                  try {
                    userDepartment = Get.find<MainCoreEmployeeController>()
                        .getEmployeeDepartmentName(userEmail);
                    //print"   ✅ Loaded userDepartment: '$userDepartment'");
                  } catch (e) {
                    //print"   ❌ Failed to load userDepartment: $e");
                  }
                }
              }

              // Apply filters
              _applyFilters();

              // Update last count and reset processing flag
              setState(() {
                _lastServicesCount = newServicesCount;
                _isProcessingUpdate = false;
              });
            } else {
              //print"   - Service count unchanged ($newServicesCount), skipping filters");
            }
          } else {
            if (!_hasInitialized) {
              //print"   ⏭️ Skipping: Not yet initialized");
            } else if (_isProcessingUpdate) {
              //print"   ⏭️ Skipping: Already processing update");
            }
          }
        } else if (state is GetServiceError) {
          //print"❌ Error loading services: ${state.toString()}");

          // Show error message to user
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S.of(context).errorLoadingServices),
                backgroundColor: AppColors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      },
      builder: (context, state) {
        final servicesCubit = ServicesManagerCubit.get(context);

        //print"\n🏗️ BlocConsumer Builder - State: ${state.runtimeType}");
        //print"   - Services from cubit: ${servicesCubit.servicesRequest.length}");
        //print"   - Filtered services: ${filteredServices.length}");
        //print"   - _hasInitialized: $_hasInitialized");

        // ✅ Show loading only for initial load (not for navigation back)
        if (state is GetServiceLoading && !_hasInitialized) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleProgress(),
                  const SizedBox(height: 20),
                  Text(
                    S
                        .of(context)
                        .loading ?? 'Loading...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme
                          .of(context)
                          .brightness == Brightness.light
                          ? AppColors.black.withOpacity(0.54)
                          : AppColors.white.withOpacity(0.70),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // ✅ Show error state
        if (state is GetServiceError && !_hasInitialized) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading services',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme
                          .of(context)
                          .brightness == Brightness.light
                          ? AppColors.black.withOpacity(0.87)
                          : AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please try again later',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme
                          .of(context)
                          .brightness == Brightness.light
                          ? AppColors.black.withOpacity(0.54)
                          : AppColors.white.withOpacity(0.70),
                    ),
                  ),
                  const SizedBox(height: 24),
                  customButtonWithIcon(
                    title: S.of(context).retry ?? 'Retry',
                    function: () async {
                      setState(() {
                        _isInitializing = true;
                        _dataFullyLoaded = false;
                        _hasInitialized = false; // ✅ Reset flag to allow retry
                      });
                      await _initializeAllData();
                    },
                    textStyle: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textButton,
                    ),
                    width: 160.sp,
                    height: 44.sp,
                    space: 8.sp,
                    radius: 8.r,
                    color: AppColors.primary,
                    icon: Icons.refresh,
                    iconColor: AppColors.textButton,
                    iconSize: 20.sp,
                  ),
                ],
              ),
            ),
          );
        }

        // ✅ MAIN CONTENT with FutureBuilder
        return FutureBuilder<List<ServicesHistoryModel>>(
          future: _getAllServicesIncludingDrafts(), // ✅ This must be called
          builder: (context, snapshot) {
            // ✅ Don't show loading for FutureBuilder if already initialized
            if (snapshot.connectionState == ConnectionState.waiting &&
                !_hasInitialized) {
              return Scaffold(
                backgroundColor: AppColors.background,
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleProgress(),
                      const SizedBox(height: 20),
                      Text(
                        'Loading draft services...',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme
                              .of(context)
                              .brightness == Brightness.light
                              ? AppColors.black.withOpacity(0.54)
                              : AppColors.white.withOpacity(0.70),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Handle FutureBuilder error
            if (snapshot.hasError) {
              //print"❌ FutureBuilder Error: ${snapshot.error}");
            }

            final allServices = snapshot.data ?? servicesCubit.services;

            // ✅ CRITICAL: Don't use servicesCubit.services if snapshot has data
            // The snapshot.data already includes drafts!

            final filteredModel = _getFilteredServices(allServices);

            //print"📊 Final Data:");
            //print"   - All Services: ${allServices.length}");
            //print"   - Filtered Model: ${filteredModel.length}");

            // Process provider data
            final providerSelector = servicesCubit.providerSelector;
            List<ProviderData> providerList = [];

            if (providerSelector != null) {
              providerSelector.forEach((id, data) {
                final firstName = data['firstName'] ?? 'Unknown';
                final lastName = data['lastName'] ?? 'Unknown';
                final email = data['email'] ?? 'Unknown';
                final gender = data['gender'] ?? 'Unknown';
                final role = data['role'] ?? 'Unknown';
                final state = data['state'] ?? 'Unknown';
                final lastNameInArabic = data['lastNameInArabic'] ?? 'Unknown';
                final firstNameInArabic = data['firstNameInArabic'] ??
                    'Unknown';
                final title = data['title'] ?? 'Unknown';
                final phone = data['mobilePhone']?["phone"] ?? 'Unknown';

                providerList.add(
                  ProviderData(
                    id: id,
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    phone: phone,
                    gender: gender,
                    title: title,
                    role: role,
                    state: state,
                    firstNameInArabic: firstNameInArabic,
                    lastNameInArabic: lastNameInArabic,
                  ),
                );
              });
            }

            // ✅ FINAL UI - Render immediately on subsequent visits
            return Scaffold(
              backgroundColor: AppColors.background,
              body: SafeArea(
                child: SideFrameMasterServices(
                  titleText: S
                      .of(context)
                      .service,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: ClampingScrollPhysics(),
                    child: Column(
                      children: [
                        _buildServiceWidget(allServices, filteredModel),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildServiceWidget(List<ServicesHistoryModel> allServices, dynamic filteredModel) {
    final controller = Get.find<MainCoreEmployeeController>();

    final hasServicesPermission = controller.isHasPermission(
      module: Modules.services,
      section: ServicePermissionsSections.servicesPermissions,
      permission: null,
    );

    // ✅ DEBUG: Check what we're passing

    // Check for drafts in allServices
    final draftsInAll = allServices.where((s) =>
    (s.currentState ?? '').toLowerCase().trim() == 'draft'
    ).length;

    return hasServicesPermission
        ? managementWidget(
      allServices: allServices,
      filteredModel: filteredModel,
    )
        : requestServicesWidget();
  }

  // In services_screen_tablet.dart

  Widget managementWidget({
    required List<ServicesHistoryModel> allServices,
    required List<ServicesHistoryModel> filteredModel,
  }) {
    // Initialize animations when filtered model changes
    if (_slideAnimations.isEmpty || _slideAnimations.length != filteredModel.length) {
      _initializeGridAnimations(filteredModel.length);
    }

    return ManagementWidget(
      allServices: allServices,        // ✅ Used for filter chips
      filteredModel: filteredModel,    // ✅ Used for cards display
      selectedProviders: selectedProviders,
      doneServicesCount: doneServicesCount,
      searchController: _searchController,
      isGridViewChoose: isGridViewChoose,
      isMobile: context.isPhone,
      isArabic: Localizations.localeOf(context).languageCode == 'ar',
      lightMode: Theme.of(context).brightness == Brightness.light,
      employeeEntity: _employeeEntity,
      formatStartDate: formatStartDate,
      getLocalizedDurationUnit: getLocalizedDurationUnit,
      filterWidget: filterWidget,      // ✅ This should use allServices
      approvalAndServicesRequest: approvalAndServicesRequest,
      onToggleGridView: () => setState(() => isGridViewChoose = true),
      onToggleTableView: () => setState(() => isGridViewChoose = false),
    );
  }
  Widget requestServicesWidget() {
    //print"\n╔════════════════════════════════════════════════════════════════╗");
    //print"║         🔧 requestServicesWidget() CALLED                     ║");
    //print"╚════════════════════════════════════════════════════════════════╝");
    //print"📊 Data being passed to RequestServicesWidget:");
    //print"   - filteredServices count: ${filteredServices.length}");
    //print"   - selectStatus: '$selectStatus'");
    //print"   - _hasInitialized: $_hasInitialized");
    //print"   - _dataFullyLoaded: $_dataFullyLoaded");

    // ✅ Show loading if data is not ready yet
    if (!_hasInitialized || !_dataFullyLoaded) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleProgress(),
            const SizedBox(height: 20),
            Text(
              S
                  .of(context)
                  .loading ?? 'Loading...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme
                    .of(context)
                    .brightness == Brightness.light
                    ? AppColors.black.withOpacity(0.54)
                    : AppColors.white.withOpacity(0.70),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please wait while we load your services...',
              style: TextStyle(
                fontSize: 12,
                color: Theme
                    .of(context)
                    .brightness == Brightness.light
                    ? AppColors.black.withOpacity(0.38)
                    : AppColors.white.withOpacity(0.54),
              ),
            ),
          ],
        ),
      );
    }

    // ✅ CRITICAL FIX: Filter by selected department BEFORE passing to widget
    List<ServicesHistoryModel> departmentFilteredServices = filteredServices;

    if (selectStatus != "All") {
      //print"🔍 Filtering by department: '$selectStatus'");
      final selectedDeptNormalized = _normDept(selectStatus);
      //print"   - Normalized: '$selectedDeptNormalized'");

      departmentFilteredServices = filteredServices.where((service) {
        final serviceDept = _normDept(service.currentDepartmentRequester);
        final matches = serviceDept == selectedDeptNormalized;

        if (matches) {
          //print"   ✅ Including: ${service.currentServiceNameEnglish} (dept: $serviceDept)");
        }

        return matches;
      }).toList();

      //print"   📊 After department filter: ${departmentFilteredServices.length} services");
    } else {
      //print"ℹ️  'All' selected - showing all ${filteredServices.length} services");
    }

    final sortedMap = _createSortedDepartmentMap();
    //print"   - sortedMap: $sortedMap");
    //print"   - Passing ${departmentFilteredServices.length} services to RequestServicesWidget");

    return RequestServicesWidget(
      filteredServices: departmentFilteredServices,
      // ✅ FIXED: Pass filtered list
      selectStatus: selectStatus,
      onStatusSelected: (key) {
        //print"🎯 Department selected: '$key'");
        setState(() {
          selectStatus = key;
          isServiceListLoading = true;
        });
        // Don't call _applyFilters here - it will trigger rebuild automatically
      },
      totalServices: filteredServices.length,
      // ✅ Total is still all services
      sortedMap: sortedMap,
      userDepartment: userDepartment,
      isArabic: Localizations
          .localeOf(context)
          .languageCode == 'ar',
      searchController: searchController,
      getLocalizedDurationUnit: getLocalizedDurationUnit,
      selectServiceProvider: selectServiceProvider,
    );
  }

  // ========================================
// CORRECTED METHOD 1: filterWidget
// ========================================

  // In ServicesScreenTablet - update these methods:

  // In ServicesScreenTablet - update these methods:

  Widget filterWidget(List<ServicesHistoryModel> allServices) {
    final l = S.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    // ✅ FIX: Use English keys internally, translate only for display
    final String kAll = "All";
    final String kActive = l.active;
    final String kInactive = l.inactive;
    final String kDraft = l.draft;

    final String currentUserEmail = (_employeeEntity?.email ?? '').toLowerCase().trim();

    var userServices = allServices.where((service) {
      final serviceEmail = (service.currentEmailRequester ?? '').toLowerCase().trim();
      final serviceId = service.currentId.toLowerCase();

      final matchesEmail = serviceEmail == currentUserEmail;
      final isUsersDraft = serviceId.startsWith('draft_') && serviceId.contains(currentUserEmail);

      return matchesEmail || isUsersDraft;
    }).toList();

    var userActiveServices = allServices.where((service) {
      final serviceEmail = (service.currentEmailRequester ?? '').toLowerCase().trim();
      final serviceId = service.currentId.toLowerCase();
      final isUserService = (serviceEmail == currentUserEmail) ||
          (serviceId.startsWith('draft_') && serviceId.contains(currentUserEmail));
      final status = (service.currentStatus ?? '').toLowerCase().trim();
      return isUserService && status == 'active';
    }).toList();

    var userInactiveServices = allServices.where((service) {
      final serviceEmail = (service.currentEmailRequester ?? '').toLowerCase().trim();
      final serviceId = service.currentId.toLowerCase();
      final isUserService = (serviceEmail == currentUserEmail) ||
          (serviceId.startsWith('draft_') && serviceId.contains(currentUserEmail));
      final status = (service.currentStatus ?? '').toLowerCase().trim();
      return isUserService && status == 'inactive';
    }).toList();

    var userDraftServices = allServices.where((service) {
      final serviceId = service.currentId.toLowerCase();
      final state = (service.currentState ?? '').toLowerCase().trim();

      final isDraft = state == 'draft';
      final isUsersDraft = serviceId.startsWith('draft_') && serviceId.contains(currentUserEmail);

      return isDraft && isUsersDraft;
    }).toList();

    // ✅ FIX: Use English keys, but display counts with localized labels
    final Map<String, int> statusCountsNoAll = {
      kActive: userActiveServices.length,
      kInactive: userInactiveServices.length,
      kDraft: userDraftServices.length,
    };

    // ✅ FIX: Get the English key based on index
    String currentSelectedKey;
    switch (selectedStatusIndex) {
      case 0:
        currentSelectedKey = kAll;
        break;
      case 1:
        currentSelectedKey = kActive;
        break;
      case 2:
        currentSelectedKey = kInactive;
        break;
      case 3:
        currentSelectedKey = kDraft;
        break;
      default:
        currentSelectedKey = kAll;
    }

    return DepartmentFilterChips(
      selectedKey: currentSelectedKey, // ✅ Pass English key
      onSelected: (key) {
        setState(() {
          // ✅ Convert English key back to index
          if (key == kAll) {
            selectedStatusIndex = 0;
          } else if (key == kActive) {
            selectedStatusIndex = 1;
          } else if (key == kInactive) {
            selectedStatusIndex = 2;
          } else if (key == kDraft) {
            selectedStatusIndex = 3;
          }
        });
      },
      totalCount: userServices.length,
      departmentCounts: statusCountsNoAll,
      userDepartment: '',
      isArabic: isArabic,
      labelColors: {
        kActive: AppColors.green,
        kInactive: AppColors.red,
        kDraft: AppColors.grey,
      },
    );
  }// ========================================
// CORRECTED METHOD 2: _getFilteredServices
// ========================================

  List<ServicesHistoryModel> _getFilteredServices(List<ServicesHistoryModel> allServices) {
    final String query = _searchController.text.toLowerCase();
    final String currentUserEmail = (_employeeEntity?.email ?? '').toLowerCase().trim();

    var userServices = allServices.where((service) {
      final serviceEmail = (service.currentEmailRequester ?? '').toLowerCase().trim();
      return serviceEmail == currentUserEmail;
    }).toList();

    if (query.isNotEmpty) {
      userServices = userServices.where((item) {
        final serviceNameEn = (item.currentServiceNameEnglish ?? '').toLowerCase();
        final serviceNameAr = (item.currentServiceNameArabic ?? '').toLowerCase();
        return serviceNameEn.contains(query) || serviceNameAr.contains(query);
      }).toList();
    }

    // ✅ FIX: Use English key directly from index
    String selectedKey;
    switch (selectedStatusIndex) {
      case 0:
        selectedKey = "All";
        break;
      case 1:
        selectedKey = "Active";
        break;
      case 2:
        selectedKey = "Inactive";
        break;
      case 3:
        selectedKey = "Draft";
        break;
      default:
        selectedKey = "All";
    }

    if (selectedKey == "Active") {
      userServices = userServices.where((service) {
        final status = (service.currentStatus ?? '').toLowerCase().trim();
        return status == 'active';
      }).toList();

    } else if (selectedKey == "Inactive") {
      userServices = userServices.where((service) {
        final status = (service.currentStatus ?? '').toLowerCase().trim();
        return status == 'inactive';
      }).toList();

    } else if (selectedKey == "Draft") {
      userServices = userServices.where((service) {
        final state = (service.currentState ?? '').toLowerCase().trim();
        final isDraft = state == 'draft';
        return isDraft;
      }).toList();
    }

    return userServices;
  }
}

class ProviderData {
  final String id;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String gender;
  final String title;
  final String state;
  final String lastNameInArabic;
  final String firstNameInArabic;
  final String role;

  ProviderData({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.gender,
    required this.title,
    required this.state,
    required this.lastNameInArabic,
    required this.firstNameInArabic,
    required this.role,
  });
}

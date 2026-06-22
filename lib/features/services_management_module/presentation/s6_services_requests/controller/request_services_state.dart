import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';

import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/data/department_count_model.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/data/service_filter_model.dart';


abstract class RequestServicesState {}

class RequestServicesInitial extends RequestServicesState {}

class RequestServicesLoading extends RequestServicesState {}

class RequestServicesLoaded extends RequestServicesState {
  final List<ServicesHistoryModel> filteredServices;
  final DepartmentCountModel departmentCounts;
  final ServiceFilterModel filterModel;

  RequestServicesLoaded({
    required this.filteredServices,
    required this.departmentCounts,
    required this.filterModel,
  });
}

class RequestServicesError extends RequestServicesState {
  final String message;

  RequestServicesError(this.message);
}

class RequestServicesFilterChanged extends RequestServicesState {}

class RequestServicesSearchChanged extends RequestServicesState {}



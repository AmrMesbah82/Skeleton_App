import 'package:demo_app/features/services_management_module/data/models/model_employee.dart';

abstract class RequestServicesDetailsState {}

class RequestServicesDetailsInitial extends RequestServicesDetailsState {}

class RequestServicesDetailsLoading extends RequestServicesDetailsState {}

class RequestServicesDetailsLoaded extends RequestServicesDetailsState {
  final Map<String, dynamic> providerData;
  final List<EmployeeEntityModell> approvalCycle;

  RequestServicesDetailsLoaded({
    required this.providerData,
    required this.approvalCycle,
  });
}

class RequestServicesDetailsError extends RequestServicesDetailsState {
  final String message;

  RequestServicesDetailsError(this.message);
}

class RequestServicesDetailsProcessing extends RequestServicesDetailsState {}

class RequestServicesDetailsSuccess extends RequestServicesDetailsState {
  final String message;

  RequestServicesDetailsSuccess(this.message);
}

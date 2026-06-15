abstract class DashboardStates {}
class DashboardInitial extends DashboardStates {}
class DashboardLoading extends DashboardStates {}
class DashboardLoaded extends DashboardStates {
  final dynamic data;
  final Map<String, int> statusCounts;
  DashboardLoaded(this.data, {this.statusCounts = const {}});
}
class DashboardError extends DashboardStates {
  final String message;
  DashboardError(this.message);
}
class DashboardEmpty extends DashboardStates {}

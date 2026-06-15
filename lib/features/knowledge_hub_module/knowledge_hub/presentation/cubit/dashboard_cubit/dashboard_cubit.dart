import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_states.dart';
class DashboardCubit extends Cubit<DashboardStates> {
  DashboardCubit() : super(DashboardInitial());
  void loadDashboard() => emit(DashboardLoaded(null));
  List<dynamic> getAllDocuments() => [];
}

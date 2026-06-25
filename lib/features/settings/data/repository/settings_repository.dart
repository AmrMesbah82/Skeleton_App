
import 'package:demo_app/features/employee/data/models/emplyees_model/new_employee_model.dart';

import '../data/settings_remot_data_source.dart';
import 'package:demo_app/core/helper/employees/data/models/new_employee_model/emplyees_model/new_employee_model.dart';

class SettingsRepository{
  SettingsRemoteDataSource _remoteDataSource = SettingsRemoteDataSource();
updateEmployee(NewEmployeeModelHistory employee) async
{
return await _remoteDataSource.updateEmployeeModel(employee:employee, employeeId:employee.id!);
}
}
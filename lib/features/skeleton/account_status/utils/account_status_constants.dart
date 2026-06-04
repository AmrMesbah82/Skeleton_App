import 'package:demo_app/features/skeleton/authentication/domain/enums/employee_status_enum.dart';

abstract class AccountStatusConstants {
  static List<EmployeeStatusEnum> employeeStatus = [
    EmployeeStatusEnum.all,
    EmployeeStatusEnum.active,
    EmployeeStatusEnum.willBeDeactivated,
    EmployeeStatusEnum.deactivated,
    EmployeeStatusEnum.willBeActivated,
    //  EmployeeStatusEnum.inactive,
    EmployeeStatusEnum.locked,
    //   EmployeeStatusEnum.lockedWithRequest,
    //   EmployeeStatusEnum.resetPassword,
  ];
}

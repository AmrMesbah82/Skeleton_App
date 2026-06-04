import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/skeleton/employees/data/models/new_employee_model/wrong_employee_model.dart';

// Stub: AddWrongEmployeeController
class AddWrongEmployeeController extends GetxController with StateMixin {
  FirebaseFirestore db = FirebaseFirestore.instance;
  Rx<WrongEmployeeModel> wrongEmployeeModel = WrongEmployeeModel().obs;
  List<WrongEmployeeModel>? allWrongEmployees;

  Future<List<WrongEmployeeModel>> getAllEmployees() async {
    return allWrongEmployees ?? [];
  }

  Future createWrongEmployee(WrongEmployeeModel model, String email) async {
    update();
    final col = db.collection('/Wrong_Employees_Profile');
    await col.doc(email).set(model.toMap());
    update();
    change(model, status: RxStatus.success());
  }
}

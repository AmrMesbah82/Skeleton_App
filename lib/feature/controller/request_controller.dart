import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/skeleton/employees/data/models/request_model.dart';
import 'package:demo_app/features/skeleton/employees/presentation/controller/employee_controller.dart';
import 'package:demo_app/feature/controller/notification_controller.dart';
import 'package:demo_app/features/skeleton/system_logs/presentation/controller/system_logs_controller.dart';
import 'package:demo_app/features/external/main_core/features/employee/data/models/emplyees_model/new_employee_model.dart';

class RequestController extends GetxController with StateMixin {
  FirebaseFirestore db = FirebaseFirestore.instance;
  Rx<RequestsModel> requestsModel = RequestsModel().obs;
  List<RequestsModel> requestsList = [];
  Map<String, List<RequestsModel>> allRequestsPending = {};
  Map<String, List<RequestsModel>> allRequestReview = {};
  bool isLoading = false;

  SystemLogsController get systemLogsController =>
      Get.find<SystemLogsController>();

  AppNotificationController appNotificationController =
      Get.put(AppNotificationController());

  Future createRequest(RequestsModel model, String requestsId) async {
    update();
    final CollectionReference col = db.collection('/Requests');
    await col
        .doc('${model.email}_${model.section?.toLowerCase().replaceAll(' ', '_')}')
        .collection('User_Requests')
        .doc(requestsId)
        .set(model.toMap(), SetOptions(merge: true));
    update();
    change(model, status: RxStatus.success());
  }

  Future<List<RequestsModel>> getuserRequests(
      String userEmail, String section, bool isPending) async {
    final CollectionReference col = db.collection('/Requests');
    QuerySnapshot qs = isPending
        ? await col
            .doc('${userEmail}_$section')
            .collection('User_Requests')
            .where('Status', isEqualTo: 'pending')
            .get()
        : await col
            .doc('${userEmail}_$section')
            .collection('User_Requests')
            .where('Status', isNotEqualTo: 'pending')
            .get();
    List<RequestsModel> list = qs.docs
        .map((d) => RequestsModel.fromMap(d.data() as Map<String, dynamic>))
        .toList();
    update();
    change(list, status: RxStatus.success());
    return list;
  }

  void updateRequest(String status, RequestsModel model) async {
    model.status = status;
    final CollectionReference col = db.collection('/Requests');
    await col
        .doc('${model.email}_${model.section?.replaceAll(' ', '_')}')
        .collection('User_Requests')
        .doc(model.requestId)
        .set(model.toMap(), SetOptions(merge: true))
        .then((_) {
      appNotificationController.sendNotification(
        type: 'request',
        topic: model.email!,
        title: 'Request status changed',
        arabicTitle: 'تم تغيير حالة الطلب',
        body:
            'Your request to change ${model.whatChanged} has been ${status == 'approved' ? 'approved' : 'rejected'}',
        arabicBody:
            'الطلب لتغيير ${model.whatChanged?.capitalize?.tr} ${status == 'approved' ? 'تمت الموافقة عليه' : 'تم رفضه'}',
      );
      getAllRequests(true);
      getAllRequests(false);
    });
    update();
  }

  void acceptAll(List<RequestsModel> models) async {
    final CollectionReference col = db.collection('/Requests');
    WriteBatch batch = db.batch();
    for (var r in models) {
      r.status = 'approved';
      await col
          .doc('${r.email}_${r.section?.replaceAll(' ', '_')}')
          .collection('User_Requests')
          .doc(r.requestId)
          .set(r.toMap(), SetOptions(merge: true));
    }
    batch.commit().then((_) {
      if (models.isNotEmpty) {
        appNotificationController.sendNotification(
          type: 'request',
          topic: models[0].email!,
          title: 'Request status changed',
          arabicTitle: 'تم تغيير حالة الطلب',
          body: 'Your request to change ${models[0].section} has been approved',
          arabicBody:
              'الطلب لتغيير ${models[0].section?.capitalize?.tr} تمت الموافقة عليه',
        );
      }
      getAllRequests(true);
      getAllRequests(false);
    });
    update();
  }

  EmployeeController get addEmployeeController => Get.find();
  List<String> sections = [
    'personal_info',
    'additional_info',
    'health_insurance'
  ];

  Future<Map<String, List<RequestsModel>>> getAllRequests(bool isPending) async {
    isPending ? allRequestsPending = {} : allRequestReview = {};
    isLoading = true;
    for (var emp in addEmployeeController.allEmployees ?? []) {
      for (var section in sections) {
        List<RequestsModel> reqs =
            await getuserRequests(emp.email.last!, section, isPending);
        if (reqs.isNotEmpty) {
          isPending
              ? allRequestsPending['${emp.email.last!}_$section'] = reqs
              : allRequestReview['${emp.email.last!}_$section'] = reqs;
        }
      }
      update();
    }
    isLoading = false;
    return isPending ? allRequestsPending : allRequestReview;
  }
}

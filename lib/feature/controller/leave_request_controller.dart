import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:demo_app/feature/models/leave_request_model.dart';
// date:Feb/1/2024
// by:MohamedFouad
// lastUpdate:Feb/1/2024

class LeaveRequestController extends GetxController with StateMixin {
  // FirebaseFirestore instance for interacting with Firestore.
  FirebaseFirestore db = FirebaseFirestore.instance;
  Rx<LeaveRequestsModel> leaveRequestsModel = LeaveRequestsModel().obs;
  List<LeaveRequestsModel> leaveRequestsList = [];
  Future createLeaveRequest(
    LeaveRequestsModel leaveRequestsModel,
    String requestsId,
  ) async {
    // Update the controller state.
    update();

    final CollectionReference requestsCollection =
        db.collection('/Leave_Requests');

    await requestsCollection
        .doc(requestsId)
        .set((leaveRequestsModel).toMap(), SetOptions(merge: true));

    // Update the controller state.
    update();

    // Set the controller status to success.
    change(leaveRequestsModel, status: RxStatus.success());
  }

  Future<List<LeaveRequestsModel>> getAllLeaveRequests() async {
    leaveRequestsList = [];
    try {
      // Reference to the Firestore collection.
      final CollectionReference requestsCollection =
          db.collection('/Leave_Requests');

      // Fetch the documents from the collection.
      QuerySnapshot querySnapshot = await requestsCollection.get();

      // Iterate through the documents and convert them to RequestsModel objects.
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        LeaveRequestsModel requestsModel = LeaveRequestsModel.fromMap(data);

        // Add the RequestsModel object to the list.
        leaveRequestsList.add(requestsModel);
      }

      return leaveRequestsList;
    } catch (e) {
      // Handle errors here (e.g., log or throw an exception).
      print("Error getting requests: $e");
      return [];
    }
  }
}

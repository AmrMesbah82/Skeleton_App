import '../../../../../../../core/services/firebase/repository/firebase_repository.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/networking/get_base_url.dart';

class MainCoreEmployeeRemoteDataSource {
  getAllEmployees() async {
    return await FirebaseRepository.getCollection(
        collectionPath: getBaseUrl(ApiConstants.employeesInfo));
  }
}

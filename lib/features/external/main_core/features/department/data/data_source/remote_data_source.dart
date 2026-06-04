import '../../../../../../../core/services/firebase/repository/firebase_repository.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/networking/get_base_url.dart';

class DepartmentRemoteDataSource {
  getDepartments() async {
    return await FirebaseRepository.getCollection(
        collectionPath: getBaseUrl(ApiConstants.departments));
  }
}

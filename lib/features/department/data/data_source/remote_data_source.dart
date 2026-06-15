import 'package:demo_app/core/constants/api_constants.dart';
import 'package:demo_app/core/network/get_base_url.dart';

import '../../../../core/services/firebase/repository/firebase_repository.dart';
import 'package:demo_app/core/constants/api_constants.dart';
import 'package:demo_app/core/network/get_base_url.dart';

class DepartmentRemoteDataSource {
  getDepartments() async {
    return await FirebaseRepository.getCollection(
        collectionPath: getBaseUrl(ApiConstants.departments));
  }
}

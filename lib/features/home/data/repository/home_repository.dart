import 'package:dartz/dartz.dart';
import 'package:demo_app/features/home/data/models/home_component_model.dart';
import 'package:demo_app/features/home/data/models/home_page_layout_model.dart';

import '../../../../core/network/failure_model.dart';
import '../../domain/enum/app_bar_enum.dart';
import '../data/home_remote_data_source.dart';

class HomeRepository {
  HomeRemoteDataSource homeRemoteDataSource = HomeRemoteDataSource();

  updateHomeComponents({
    required List<AppBarOptions> appBarOptions,
    required List<HomeComponentModel> components,
    required String currentUserEmail,
    required List<String> headerIcons, // NEW: Add header icons parameter
  }) async {
    HomePageLayoutModel layoutModel = HomePageLayoutModel(
      id: currentUserEmail,
      activeComponents: components,
      activeAppBarOptions: appBarOptions,
      headerIcons: headerIcons, // NEW: Include header icons
    );
    return await homeRemoteDataSource.updateHomeComponents(layoutModel);
  }

  getHomeLayout({required String currentUserEmail}) async {
    Either<Failure, dynamic> result =
    await homeRemoteDataSource.getHomeLayout(currentUserEmail);
    if (result.isLeft()) return result;
    Map<String, dynamic>? layoutMap = result.getOrElse(() => null);
    if (layoutMap == null) return Left(FirebaseFailure("No layout found"));
    HomePageLayoutModel layoutModel = HomePageLayoutModel.fromMap(layoutMap);
    return result = Right(layoutModel);
  }
}
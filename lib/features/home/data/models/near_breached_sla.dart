import 'package:demo_app/features/home/data/models/home_component_model.dart';

import '../../domain/enum/home_components.dart';

class NearBreachedSLAModel extends HomeComponentModel {
  NearBreachedSLAModel(
      {required super.component,
      required super.rowNumber,
      required super.columnNumber});

  factory NearBreachedSLAModel.fromMap(Map<String, dynamic> map) {
    return NearBreachedSLAModel(
      component: HomeComponents.values.firstWhere(
          (e) => e.databaseName == map[HomeComponentModel.componentKey]),
      rowNumber: map[HomeComponentModel.rowNumberKey],
      columnNumber: map[HomeComponentModel.columnNumberKey],
    );
  }
}

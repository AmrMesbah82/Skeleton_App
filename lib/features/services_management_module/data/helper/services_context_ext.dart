import 'package:flutter/material.dart';

/// Module-local `isPhone` helper, bundled so the services-management module is
/// self-contained and portable between apps. Defines only `isPhone` to avoid
/// clashing with any other BuildContext extensions already in scope.
extension ServicesPhoneContext on BuildContext {
  bool get isPhone => MediaQuery.of(this).size.shortestSide < 600;
}

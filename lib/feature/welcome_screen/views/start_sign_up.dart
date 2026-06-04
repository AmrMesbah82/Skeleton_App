import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Stub SignUpView — registration flow not enabled in demo_app.
class SignUpView extends StatelessWidget {
  const SignUpView({
    super.key,
    this.isSignIn = true,
    this.companyInformation = 0,
    this.companyService = 0,
    this.confirmations = 0,
    this.contactInformation = 0,
    this.compServiceState,
    this.compInfoState,
    this.isSignInState,
    this.confState,
    this.conactInfoState,
  });

  final bool isSignIn;
  final double companyInformation;
  final double companyService;
  final double confirmations;
  final double contactInformation;
  final ValueChanged<double>? compServiceState;
  final ValueChanged<double>? compInfoState;
  final ValueChanged<bool>? isSignInState;
  final ValueChanged<double>? confState;
  final ValueChanged<double>? conactInfoState;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Sign Up is not available in demo mode.'.tr),
    );
  }
}

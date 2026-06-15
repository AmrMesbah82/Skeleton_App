import 'package:demo_app/features/employee/data/models/emplyees_model/new_employee_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/onboarding/authentication/presentation/ui/pages/start_sign_in.dart';

/// Stub ResetPassword screen — navigates user back to login after resetting password.
class ResetPassword extends StatefulWidget {
  const ResetPassword({
    super.key,
    required this.savedPassword,
    required this.employee,
    required this.isDemoActivation,
  });

  final String savedPassword;
  final NewEmployeeModelHistory? employee;
  final bool isDemoActivation;

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();

  @override
  void dispose() {
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reset Password'.tr)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _newPassController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'New Password'.tr),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPassController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirm Password'.tr),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submit,
              child: Text('Save'.tr),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (_newPassController.text != _confirmPassController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match'.tr)),
      );
      return;
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => StartSignIn()),
      (route) => false,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/skeleton/settings/presentation/ui/pages/settings_screen.dart' show SettingsScreen;

// Stub: Settings — wraps the main SettingsScreen for backward compatibility.
class Settings extends StatelessWidget {
  const Settings({super.key});
  @override
  Widget build(BuildContext context) => SettingsScreen();
}

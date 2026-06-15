// import 'package:flutter/material.dart';
//
// import 'package:demo_app/core/theme/services_management/app_color.dart';
//
//
// ThemeData lightTheme = ThemeData(
//   bottomSheetTheme: BottomSheetThemeData(
//     backgroundColor: Colors.grey[300]!, // Light theme bottom sheet
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//     ),
//   ),
//   brightness: Brightness.light,
//   primaryColor: Colors.blue,
//   scaffoldBackgroundColor: AppColors.background,
//   appBarTheme: const AppBarTheme(
//     backgroundColor: Colors.white,
//     foregroundColor: Colors.white,
//     iconTheme: IconThemeData(color: Colors.black),
//     elevation: 0,
//     toolbarHeight: 40, // Reduced AppBar height
//     titleTextStyle: TextStyle(
//         fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
//   ),
//   floatingActionButtonTheme: const FloatingActionButtonThemeData(
//     backgroundColor: Colors.blue,
//     foregroundColor: Colors.white,
//   ),
//   bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//     backgroundColor: Colors.white,
//     selectedItemColor: Colors.blue,
//     unselectedItemColor: Colors.grey,
//     showUnselectedLabels: true,
//   ),
//   elevatedButtonTheme: ElevatedButtonThemeData(
//     style: ElevatedButton.styleFrom(
//       backgroundColor: Colors.blue,
//       foregroundColor: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//     ),
//   ),
//   textTheme: const TextTheme(
//       displayLarge: TextStyle(
//           fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
//       displayMedium: TextStyle(
//           fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
//       bodyLarge: TextStyle(fontSize: 16, color: Colors.black),
//       bodyMedium: TextStyle(fontSize: 14, color: Colors.black),
//       bodySmall: TextStyle(fontSize: 14, color: Colors.black)),
//   cardTheme: CardTheme(
//     color: Colors.white,
//     shadowColor: Colors.grey.withOpacity(0.5),
//     elevation: 5,
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//   ),
//   textSelectionTheme: const TextSelectionThemeData(
//     cursorColor:  AppColors.blackButton ,
//     selectionColor: AppColors.primary,
//     selectionHandleColor: Colors.blue,
//   ),
//   inputDecorationTheme: InputDecorationTheme(
//     filled: true,
//     fillColor: AppColors.background,
//     focusedBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//             width: 1,
//           color: Color(0xFFE5B800)
//         ),
//         borderRadius: BorderRadius.circular(4)
//     ),
//     border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
//   ),
//   dividerTheme: const DividerThemeData(
//     color: Colors.transparent,
//     thickness: 1,
//   ),
// );
//
//
// ThemeData darkTheme = ThemeData(
//
//   bottomSheetTheme: const BottomSheetThemeData(
//     backgroundColor: Color(0xff3a1e22), // Light theme bottom sheet
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//     ),
//   ),
//   brightness: Brightness.dark,
//   primaryColor: Colors.deepPurple,
//   scaffoldBackgroundColor: AppColors.background,
//   appBarTheme: const AppBarTheme(
//     toolbarHeight: 40, // Re
//     backgroundColor: Color(0xff3a1e22),
//     foregroundColor: Colors.white,
//     elevation: 0,
//     titleTextStyle: TextStyle(
//         fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
//   ),
//   floatingActionButtonTheme: const FloatingActionButtonThemeData(
//     backgroundColor: Colors.deepPurple,
//     foregroundColor: Colors.white,
//   ),
//   bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//     backgroundColor: AppColors.card, // Change to dark color
//     selectedItemColor: Colors.deepPurple,
//     unselectedItemColor: Colors.grey,
//     showUnselectedLabels: true,
//   ),
//   elevatedButtonTheme: ElevatedButtonThemeData(
//     style: ElevatedButton.styleFrom(
//       backgroundColor: Colors.deepPurple,
//       foregroundColor: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//     ),
//   ),
//   textTheme: const TextTheme(
//     displayLarge: TextStyle(
//         fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
//     displayMedium: TextStyle(
//         fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
//     bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
//     bodyMedium: TextStyle(fontSize: 14, color: Colors.white),
//   ),
//   textSelectionTheme: const TextSelectionThemeData(
//     cursorColor:  AppColors.whiteShadow ,
//     selectionColor: AppColors.primary,
//     selectionHandleColor: Colors.blue,
//   ),
//   cardTheme: CardTheme(
//     color: AppColors.card,
//     shadowColor: Colors.black.withOpacity(0.5),
//     elevation: 5,
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//   ),
//   inputDecorationTheme: InputDecorationTheme(
//     focusedBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//             width: 1,
//             color: Color(0xFFE5B800)
//         ),
//         borderRadius: BorderRadius.circular(4)
//     ),
//     filled: true,
//     fillColor: AppColors.background,
//     border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
//   ),
//   dividerTheme: const DividerThemeData(
//     color: Colors.transparent,
//     thickness: 1,
//   ),
//
//
// );

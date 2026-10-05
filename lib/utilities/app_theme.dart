// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
//
// import 'color_data.dart';
//
// /// Shared radii used across cards, inputs, buttons and sheets.
// class AppRadius {
//   static const double sm = 8;
//   static const double md = 12;
//   static const double lg = 16;
//   static const double xl = 20;
// }
//
// /// Shared spacing scale; screens use these instead of ad-hoc values.
// class AppSpacing {
//   static const double xs = 4;
//   static const double sm = 8;
//   static const double md = 12;
//   static const double lg = 16;
//   static const double xl = 24;
//
//   /// Standard horizontal page gutter.
//   static const double page = 16;
//
//   /// Height of primary/secondary action buttons.
//   static const double buttonHeight = 52;
// }
//
// /// Shared text styles on the Gilroy families declared in pubspec.yaml.
// class AppText {
//   static const TextStyle pageTitle =
//       TextStyle(fontFamily: "Bold", fontSize: 20, color: textPrimary, height: 1.25);
//   static const TextStyle sectionTitle =
//       TextStyle(fontFamily: "Bold", fontSize: 16, color: textPrimary, height: 1.3);
//   static const TextStyle title =
//       TextStyle(fontFamily: "SemiBold", fontSize: 15, color: textPrimary, height: 1.35);
//   static const TextStyle body =
//       TextStyle(fontFamily: "Medium", fontSize: 14, color: textPrimary, height: 1.45);
//   static const TextStyle bodySecondary =
//       TextStyle(fontFamily: "Medium", fontSize: 13.5, color: textSecondary, height: 1.4);
//   static const TextStyle caption =
//       TextStyle(fontFamily: "Medium", fontSize: 12, color: textMuted, height: 1.35);
//
//   /// Small uppercase label above a group of content.
//   static const TextStyle overline = TextStyle(
//     fontFamily: "Bold",
//     fontSize: 11,
//     color: textMuted,
//     letterSpacing: 0.8,
//   );
// }
//
// /// Centralised Material 3 theme built on the existing ATS brand colors.
// class AppTheme {
//   static const SystemUiOverlayStyle statusBarStyle = SystemUiOverlayStyle(
//     statusBarColor: appColor,
//     statusBarIconBrightness: Brightness.light,
//     statusBarBrightness: Brightness.dark,
//   );
//
//   static ThemeData get light {
//     final colorScheme = ColorScheme.fromSeed(
//       seedColor: appColor,
//       brightness: Brightness.light,
//     ).copyWith(
//       primary: appColor,
//       onPrimary: whiteColor,
//       primaryContainer: accentLight,
//       onPrimaryContainer: appColor,
//       secondary: navyAccent,
//       onSecondary: whiteColor,
//       error: fail,
//       onError: whiteColor,
//       surface: surface,
//       onSurface: textPrimary,
//       onSurfaceVariant: textSecondary,
//       outline: borderDark,
//       outlineVariant: border,
//       surfaceTint: Colors.transparent,
//     );
//
//     final buttonShape = RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(AppRadius.md),
//     );
//     const buttonText = TextStyle(
//       fontFamily: "SemiBold",
//       fontSize: 16,
//       letterSpacing: 0.2,
//     );
//
//     OutlineInputBorder inputBorder(Color color, [double width = 1]) =>
//         OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppRadius.md),
//           borderSide: BorderSide(color: color, width: width),
//         );
//
//     return ThemeData(
//       useMaterial3: true,
//       fontFamily: "Medium",
//       colorScheme: colorScheme,
//       visualDensity: VisualDensity.standard,
//       materialTapTargetSize: MaterialTapTargetSize.padded,
//       scaffoldBackgroundColor: bg,
//       splashFactory: InkRipple.splashFactory,
//       appBarTheme: const AppBarTheme(
//         backgroundColor: appColor,
//         foregroundColor: whiteColor,
//         elevation: 0,
//         scrolledUnderElevation: 0,
//         surfaceTintColor: Colors.transparent,
//         centerTitle: false,
//         titleSpacing: 0,
//         iconTheme: IconThemeData(color: whiteColor),
//         titleTextStyle: TextStyle(
//           fontFamily: "SemiBold",
//           fontSize: 18,
//           color: whiteColor,
//           letterSpacing: 0.1,
//         ),
//         systemOverlayStyle: statusBarStyle,
//       ),
//       cardTheme: CardThemeData(
//         color: surface,
//         elevation: 0,
//         margin: EdgeInsets.zero,
//         surfaceTintColor: Colors.transparent,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(AppRadius.lg),
//           side: const BorderSide(color: border),
//         ),
//       ),
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: appColor,
//           foregroundColor: whiteColor,
//           elevation: 0,
//           minimumSize: const Size(64, 48),
//           disabledBackgroundColor: surface2,
//           disabledForegroundColor: textMuted,
//           shape: buttonShape,
//           textStyle: buttonText,
//         ),
//       ),
//       filledButtonTheme: FilledButtonThemeData(
//         style: FilledButton.styleFrom(
//           backgroundColor: appColor,
//           foregroundColor: whiteColor,
//           minimumSize: const Size(64, 48),
//           disabledBackgroundColor: surface2,
//           disabledForegroundColor: textMuted,
//           shape: buttonShape,
//           textStyle: buttonText,
//         ),
//       ),
//       outlinedButtonTheme: OutlinedButtonThemeData(
//         style: OutlinedButton.styleFrom(
//           foregroundColor: appColor,
//           minimumSize: const Size(64, 48),
//           side: const BorderSide(color: borderDark),
//           shape: buttonShape,
//           textStyle: buttonText,
//         ),
//       ),
//       textButtonTheme: TextButtonThemeData(
//         style: TextButton.styleFrom(
//           foregroundColor: appColor,
//           shape: buttonShape,
//           textStyle: buttonText.copyWith(fontSize: 15),
//         ),
//       ),
//       floatingActionButtonTheme: FloatingActionButtonThemeData(
//         backgroundColor: appColor,
//         foregroundColor: whiteColor,
//         elevation: 2,
//         highlightElevation: 4,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(AppRadius.lg),
//         ),
//       ),
//       inputDecorationTheme: InputDecorationTheme(
//         filled: true,
//         fillColor: surface,
//         isDense: true,
//         contentPadding:
//             const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
//         hintStyle: const TextStyle(color: textMuted, fontSize: 14),
//         border: inputBorder(border),
//         enabledBorder: inputBorder(border),
//         focusedBorder: inputBorder(appColor, 1.5),
//         errorBorder: inputBorder(fail),
//         focusedErrorBorder: inputBorder(fail, 1.5),
//       ),
//       dialogTheme: DialogThemeData(
//         backgroundColor: surface,
//         surfaceTintColor: Colors.transparent,
//         elevation: 0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(AppRadius.xl),
//         ),
//         titleTextStyle: const TextStyle(
//           fontFamily: "Bold",
//           fontSize: 18,
//           color: textPrimary,
//         ),
//         contentTextStyle: const TextStyle(
//           fontSize: 14,
//           color: textSecondary,
//           height: 1.45,
//         ),
//       ),
//       bottomSheetTheme: const BottomSheetThemeData(
//         backgroundColor: surface,
//         surfaceTintColor: Colors.transparent,
//         showDragHandle: false,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
//         ),
//       ),
//       snackBarTheme: SnackBarThemeData(
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: textPrimary,
//         contentTextStyle: const TextStyle(color: whiteColor, fontSize: 14),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(AppRadius.md),
//         ),
//       ),
//       progressIndicatorTheme: const ProgressIndicatorThemeData(
//         color: appColor,
//         linearTrackColor: surface2,
//         circularTrackColor: Colors.transparent,
//       ),
//       dividerTheme: const DividerThemeData(
//         color: border,
//         thickness: 1,
//         space: 1,
//       ),
//       tabBarTheme: const TabBarThemeData(
//         dividerColor: Colors.transparent,
//         labelColor: whiteColor,
//         unselectedLabelColor: textWhiteSub,
//         indicatorColor: whiteColor,
//       ),
//       iconTheme: const IconThemeData(color: textSecondary),
//       listTileTheme: const ListTileThemeData(
//         contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
//         minVerticalPadding: AppSpacing.md,
//         iconColor: textSecondary,
//         titleTextStyle: AppText.title,
//         subtitleTextStyle: AppText.bodySecondary,
//       ),
//       chipTheme: ChipThemeData(
//         backgroundColor: surface2,
//         selectedColor: accentLight,
//         side: BorderSide.none,
//         labelStyle: const TextStyle(fontFamily: "SemiBold", fontSize: 13, color: textPrimary),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
//       ),
//       checkboxTheme: CheckboxThemeData(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
//         side: const BorderSide(color: borderDark, width: 1.5),
//       ),
//       popupMenuTheme: PopupMenuThemeData(
//         color: surface,
//         surfaceTintColor: Colors.transparent,
//         elevation: 3,
//         textStyle: AppText.body,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
//       ),
//       textSelectionTheme: TextSelectionThemeData(
//         cursorColor: appColor,
//         selectionColor: appColor.withValues(alpha: 0.18),
//         selectionHandleColor: appColor,
//       ),
//       navigationBarTheme: NavigationBarThemeData(
//         backgroundColor: surface,
//         surfaceTintColor: Colors.transparent,
//         indicatorColor: accentLight,
//         elevation: 0,
//         labelTextStyle: WidgetStateProperty.resolveWith(
//           (states) => TextStyle(
//             fontFamily: "SemiBold",
//             fontSize: 12,
//             color: states.contains(WidgetState.selected) ? appColor : textSecondary,
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// Global EasyLoading look (used by CustomLoader) aligned with the theme.
//   static void configureLoader() {
//     EasyLoading.instance
//       ..loadingStyle = EasyLoadingStyle.custom
//       ..indicatorType = EasyLoadingIndicatorType.ring
//       ..indicatorSize = 36
//       ..lineWidth = 3
//       ..radius = AppRadius.lg
//       ..contentPadding = const EdgeInsets.symmetric(horizontal: 24, vertical: 20)
//       ..backgroundColor = surface
//       ..indicatorColor = appColor
//       ..progressColor = appColor
//       ..textColor = textPrimary
//       ..textStyle = const TextStyle(fontFamily: "SemiBold", fontSize: 14, color: textPrimary)
//       ..maskType = EasyLoadingMaskType.custom
//       ..maskColor = navy.withValues(alpha: 0.35)
//       ..boxShadow = const <BoxShadow>[]
//       ..userInteractions = false
//       ..dismissOnTap = false;
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'color_data.dart';

/// Shared radii used across cards, inputs, buttons and sheets.
class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
}

/// Centralised Material 3 theme built on the existing ATS brand colors.
class AppTheme {
  static const SystemUiOverlayStyle statusBarStyle = SystemUiOverlayStyle(
    statusBarColor: appColor,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  );

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: appColor,
      brightness: Brightness.light,
    ).copyWith(
      primary: appColor,
      onPrimary: whiteColor,
      primaryContainer: accentLight,
      onPrimaryContainer: appColor,
      secondary: navyAccent,
      onSecondary: whiteColor,
      error: fail,
      onError: whiteColor,
      surface: surface,
      onSurface: textPrimary,
      onSurfaceVariant: textSecondary,
      outline: borderDark,
      outlineVariant: border,
      surfaceTint: Colors.transparent,
    );

    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
    );
    const buttonText = TextStyle(
      fontFamily: "SemiBold",
      fontSize: 16,
      letterSpacing: 0.2,
    );

    OutlineInputBorder inputBorder(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: color, width: width),
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: bg,
      splashFactory: InkRipple.splashFactory,
      appBarTheme: const AppBarTheme(
        backgroundColor: appColor,
        foregroundColor: whiteColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleSpacing: 0,
        iconTheme: IconThemeData(color: whiteColor),
        titleTextStyle: TextStyle(
          fontFamily: "SemiBold",
          fontSize: 19,
          color: whiteColor,
          letterSpacing: 0.2,
        ),
        systemOverlayStyle: statusBarStyle,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: const BorderSide(color: border),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: appColor,
          foregroundColor: whiteColor,
          elevation: 0,
          minimumSize: const Size(64, 48),
          shape: buttonShape,
          textStyle: buttonText,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: appColor,
          foregroundColor: whiteColor,
          minimumSize: const Size(64, 48),
          shape: buttonShape,
          textStyle: buttonText,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: appColor,
          minimumSize: const Size(64, 48),
          side: const BorderSide(color: borderDark),
          shape: buttonShape,
          textStyle: buttonText,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: appColor,
          shape: buttonShape,
          textStyle: buttonText.copyWith(fontSize: 15),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: appColor,
        foregroundColor: whiteColor,
        elevation: 2,
        highlightElevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        hintStyle: const TextStyle(color: textMuted, fontSize: 14),
        border: inputBorder(border),
        enabledBorder: inputBorder(border),
        focusedBorder: inputBorder(appColor, 1.5),
        errorBorder: inputBorder(fail),
        focusedErrorBorder: inputBorder(fail, 1.5),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        titleTextStyle: const TextStyle(
          fontFamily: "Bold",
          fontSize: 18,
          color: textPrimary,
        ),
        contentTextStyle: const TextStyle(
          fontSize: 14,
          color: textSecondary,
          height: 1.45,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: textPrimary,
        contentTextStyle: const TextStyle(color: whiteColor, fontSize: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: appColor,
        linearTrackColor: surface2,
        circularTrackColor: Colors.transparent,
      ),
      dividerTheme: const DividerThemeData(
        color: border,
        thickness: 1,
        space: 1,
      ),
      tabBarTheme: const TabBarThemeData(
        dividerColor: Colors.transparent,
        labelColor: whiteColor,
        unselectedLabelColor: textWhiteSub,
        indicatorColor: whiteColor,
      ),
      iconTheme: const IconThemeData(color: textSecondary),
    );
  }
}

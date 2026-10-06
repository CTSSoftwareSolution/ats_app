import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../color_data.dart';
import 'app_icon_size.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_text.dart';

/// App-wide Material theme built from the ATS tokens ([AppText],
/// [AppSpacing], [AppRadius], colours in color_data.dart).
///
/// Principles (see docs/design_system.md):
/// * one brand colour ([appColor]); semantic colours only for status
/// * flat surfaces: hairline borders instead of shadows, no gradients
/// * 48dp minimum touch targets, 52dp primary actions
class AppTheme {
  static const SystemUiOverlayStyle statusBarStyle = SystemUiOverlayStyle(
    statusBarColor: appColor,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  );

  /// Status bar for the full-screen brand pages (Splash, Login), whose
  /// background is [appColorDark].
  static const SystemUiOverlayStyle brandStatusBarStyle = SystemUiOverlayStyle(
    statusBarColor: appColorDark,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  );

  static ThemeData get light {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: appColor,
          brightness: Brightness.light,
        ).copyWith(
          primary: appColor,
          onPrimary: textWhite,
          primaryContainer: primaryLight,
          onPrimaryContainer: appColor,
          secondary: appColorDark,
          onSecondary: textWhite,
          error: fail,
          onError: textWhite,
          surface: surface,
          onSurface: textPrimary,
          onSurfaceVariant: textSecondary,
          outline: borderDark,
          outlineVariant: border,
          scrim: scrim,
          surfaceTint: Colors.transparent,
        );

    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
    );
    const buttonMinSize = Size(64, AppSpacing.minTouchTarget);

    OutlineInputBorder inputBorder(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: color, width: width),
        );

    return ThemeData(
      useMaterial3: true,
      fontFamily: "Medium",
      colorScheme: colorScheme,
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      scaffoldBackgroundColor: bg,
      splashFactory: InkRipple.splashFactory,

      // Default Text / Material widgets pick these up, so unstyled text
      // still follows the scale.
      textTheme: const TextTheme(
        headlineSmall: AppText.display,
        titleLarge: AppText.pageTitle,
        titleMedium: AppText.sectionTitle,
        titleSmall: AppText.title,
        bodyLarge: AppText.body,
        bodyMedium: AppText.body,
        bodySmall: AppText.caption,
        labelLarge: AppText.button,
        labelMedium: AppText.chip,
        labelSmall: AppText.overline,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: appColor,
        foregroundColor: textWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleSpacing: 0,
        iconTheme: IconThemeData(color: textWhite, size: AppIconSize.lg),
        actionsIconTheme: IconThemeData(color: textWhite, size: AppIconSize.lg),
        titleTextStyle: TextStyle(
          fontFamily: "SemiBold",
          fontSize: 18,
          color: textWhite,
          letterSpacing: 0.1,
        ),
        systemOverlayStyle: statusBarStyle,
      ),

      // Cards are flat: a hairline border separates them from the page.
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
          foregroundColor: textWhite,
          elevation: 0,
          minimumSize: buttonMinSize,
          disabledBackgroundColor: surface2,
          disabledForegroundColor: textMuted,
          shape: buttonShape,
          textStyle: AppText.button,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: appColor,
          foregroundColor: textWhite,
          minimumSize: buttonMinSize,
          disabledBackgroundColor: surface2,
          disabledForegroundColor: textMuted,
          shape: buttonShape,
          textStyle: AppText.button,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: appColor,
          minimumSize: buttonMinSize,
          side: const BorderSide(color: borderDark),
          shape: buttonShape,
          textStyle: AppText.button,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: appColor,
          minimumSize: buttonMinSize,
          shape: buttonShape,
          textStyle: AppText.button,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size.square(AppSpacing.minTouchTarget),
          iconSize: AppIconSize.lg,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: appColor,
        foregroundColor: textWhite,
        elevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        hintStyle: AppText.body.copyWith(color: textMuted),
        labelStyle: AppText.fieldLabel,
        helperStyle: AppText.caption,
        errorStyle: AppText.caption.copyWith(color: fail),
        prefixIconColor: textSecondary,
        suffixIconColor: textSecondary,
        border: inputBorder(border),
        enabledBorder: inputBorder(border),
        disabledBorder: inputBorder(border),
        focusedBorder: inputBorder(appColor, 1.5),
        errorBorder: inputBorder(fail),
        focusedErrorBorder: inputBorder(fail, 1.5),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        barrierColor: scrim,
        insetPadding: const EdgeInsets.all(AppSpacing.xl),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        titleTextStyle: AppText.sectionTitle.copyWith(fontSize: 17),
        contentTextStyle: AppText.body.copyWith(
          color: textSecondary,
          height: 1.5,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        modalElevation: 0,
        modalBarrierColor: scrim,
        showDragHandle: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: textPrimary,
        elevation: 0,
        contentTextStyle: AppText.body.copyWith(color: textWhite),
        actionTextColor: textWhiteSub,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: textPrimary,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        textStyle: AppText.caption.copyWith(color: textWhite),
        waitDuration: const Duration(milliseconds: 400),
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
      tabBarTheme: TabBarThemeData(
        dividerColor: Colors.transparent,
        labelColor: textWhite,
        unselectedLabelColor: textWhiteSub,
        indicatorColor: textWhite,
        labelStyle: AppText.navLabel,
        unselectedLabelStyle: AppText.navLabel.copyWith(fontFamily: "Medium"),
      ),
      iconTheme: const IconThemeData(
        color: textSecondary,
        size: AppIconSize.md,
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        minVerticalPadding: AppSpacing.md,
        iconColor: textSecondary,
        titleTextStyle: AppText.title,
        subtitleTextStyle: AppText.bodySecondary,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surface2,
        selectedColor: primaryLight,
        side: BorderSide.none,
        labelStyle: AppText.chip,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: const BorderSide(color: borderDark, width: 1.5),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? textWhite : borderDark,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? appColor : surface2,
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? appColor : borderDark,
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: surface,
        surfaceTintColor: Colors.transparent,
        // The one place a shadow is kept: a floating menu needs to read as
        // being above the page.
        elevation: 2,
        textStyle: AppText.body,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: const BorderSide(color: border),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: appColor,
        selectionColor: appColor.withValues(alpha: 0.18),
        selectionHandleColor: appColor,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: primaryLight,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => AppText.navLabel.copyWith(
            color: states.contains(WidgetState.selected)
                ? appColor
                : textSecondary,
          ),
        ),
      ),
    );
  }

  /// Global EasyLoading look (used by CustomLoader) aligned with the theme.
  static void configureLoader() {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..indicatorSize = 36
      ..lineWidth = 3
      ..radius = AppRadius.lg
      ..contentPadding = const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 20,
      )
      ..backgroundColor = surface
      ..indicatorColor = appColor
      ..progressColor = appColor
      ..textColor = textPrimary
      ..textStyle = AppText.chip.copyWith(fontSize: 14)
      ..maskType = EasyLoadingMaskType.custom
      ..maskColor = scrim
      ..boxShadow = const <BoxShadow>[]
      ..userInteractions = false
      ..dismissOnTap = false;
  }
}

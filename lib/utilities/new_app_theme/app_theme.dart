import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../color_data.dart';
import 'app_icon_size.dart';
import 'app_layout.dart';
import 'app_radius.dart';
import 'app_shadow.dart';
import 'app_spacing.dart';
import 'app_text.dart';
import '../../widgets/new_app_ui/app_spinner.dart';

/// App-wide Material theme built from the ATS tokens ([AppText],
/// [AppSpacing], [AppRadius], colours in color_data.dart).
///
/// Principles (see docs/design_system.md):
/// * Deep Indigo palette: primary [appColor] #3F51B5, secondary
///   [secondaryColor] #5C6BC0, surface [surface2] #E8EAF6, background [bg]
///   #FAFAFF, accent [accent] #7C4DFF, text [textPrimary] #263238;
///   semantic colours only for status
/// * flat surfaces: hairline borders instead of shadows, no gradients
///   ([AppShadow.overlay] only for popup menus)
/// * small radii ([AppRadius]); 48dp minimum touch targets, 52dp primary
///   actions
/// * sheets and dialogs keep a readable width on tablets ([AppLayout])
class AppTheme {
  static const SystemUiOverlayStyle statusBarStyle = SystemUiOverlayStyle(
    statusBarColor: appColor,
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
          primaryContainer: accentLight,
          onPrimaryContainer: appColor,
          secondary: secondaryColor,
          onSecondary: textWhite,
          secondaryContainer: secondaryLight,
          onSecondaryContainer: secondaryDark,
          tertiary: accent,
          onTertiary: textWhite,
          tertiaryContainer: accentContainer,
          onTertiaryContainer: accent,
          error: fail,
          onError: textWhite,
          errorContainer: failLight,
          onErrorContainer: fail,
          surface: surface,
          onSurface: textPrimary,
          onSurfaceVariant: textSecondary,
          surfaceContainerLowest: surface,
          surfaceContainerLow: bg,
          surfaceContainer: bg,
          surfaceContainerHigh: surface2,
          surfaceContainerHighest: surface2,
          inverseSurface: primaryDark,
          onInverseSurface: textWhite,
          inversePrimary: accentOnDark,
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
        titleTextStyle: AppText.appBarTitle,
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
          disabledBackgroundColor: disabledBg,
          disabledForegroundColor: disabledFg,
          shape: buttonShape,
          textStyle: AppText.button,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: appColor,
          foregroundColor: textWhite,
          minimumSize: buttonMinSize,
          disabledBackgroundColor: disabledBg,
          disabledForegroundColor: disabledFg,
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
        disabledElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        isDense: true,
        contentPadding: const EdgeInsets.all(AppSpacing.inputPadding),
        hintStyle: AppText.hint,
        labelStyle: AppText.fieldLabel,
        helperStyle: AppText.caption,
        errorStyle: AppText.caption.copyWith(color: fail),
        errorMaxLines: 2,
        counterStyle: AppText.caption,
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
        constraints: const BoxConstraints(maxWidth: AppLayout.maxDialogWidth),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        titleTextStyle: AppText.dialogTitle,
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
        dragHandleColor: borderDark,
        constraints: BoxConstraints(maxWidth: AppLayout.maxSheetWidth),
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
        actionTextColor: accentOnDark,
        insetPadding: const EdgeInsets.all(AppSpacing.lg),
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
        linearMinHeight: 4,
        circularTrackColor: Colors.transparent,
      ),
      dividerTheme: const DividerThemeData(
        color: border,
        thickness: 1,
        space: 1,
      ),
      // Tab strips sit in the brand app bar (AppTopBar.bottom), so labels
      // are white; the selected tab gets a 3dp [accentOnDark] underline.
      tabBarTheme: TabBarThemeData(
        dividerColor: Colors.transparent,
        labelColor: textWhite,
        unselectedLabelColor: textWhiteSub,
        indicatorColor: accentOnDark,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: accentOnDark, width: 3),
        ),
        labelStyle: AppText.chip,
        unselectedLabelStyle: AppText.chip.copyWith(fontFamily: "Medium"),
        overlayColor: WidgetStatePropertyAll(
          textWhite.withValues(alpha: 0.08),
        ),
      ),
      // Two- or three-way choices (Pass / Fail). Selected: brand tint.
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          backgroundColor: surface,
          foregroundColor: textPrimary,
          selectedBackgroundColor: accentLight,
          selectedForegroundColor: appColor,
          side: const BorderSide(color: borderDark),
          minimumSize: const Size(0, AppSpacing.minTouchTarget),
          textStyle: AppText.chip,
          shape: buttonShape,
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? appColor : borderDark,
        ),
      ),
      // Collapsible groups (inspection categories, result details): flat,
      // no extra dividers when expanded.
      expansionTileTheme: const ExpansionTileThemeData(
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        tilePadding: EdgeInsets.symmetric(horizontal: AppSpacing.card),
        childrenPadding: EdgeInsets.fromLTRB(
          AppSpacing.card,
          0,
          AppSpacing.card,
          AppSpacing.card,
        ),
        iconColor: appColor,
        collapsedIconColor: textSecondary,
        textColor: textPrimary,
        collapsedTextColor: textPrimary,
        shape: Border(),
        collapsedShape: Border(),
      ),
      badgeTheme: const BadgeThemeData(
        backgroundColor: fail,
        textColor: textWhite,
        textStyle: AppText.badgeDense,
      ),
      scrollbarTheme: ScrollbarThemeData(
        thickness: const WidgetStatePropertyAll(4),
        radius: const Radius.circular(AppRadius.xs),
        thumbColor: WidgetStatePropertyAll(textMuted.withValues(alpha: 0.6)),
      ),
      iconTheme: const IconThemeData(
        color: textSecondary,
        size: AppIconSize.md,
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        minVerticalPadding: AppSpacing.md,
        minTileHeight: 56,
        iconColor: textSecondary,
        titleTextStyle: AppText.title,
        subtitleTextStyle: AppText.bodySecondary,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surface2,
        selectedColor: accentLight,
        side: BorderSide.none,
        labelStyle: AppText.chip,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
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
        elevation: AppShadow.overlayElevation,
        shadowColor: AppShadow.color,
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
      // Tablet rail: brand surface, white icons, active item on a 16% white
      // pill (matches TabletNavigationRail).
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: appColor,
        indicatorColor: textWhite.withValues(alpha: 0.16),
        selectedIconTheme: const IconThemeData(
          color: textWhite,
          size: AppIconSize.lg,
        ),
        unselectedIconTheme: const IconThemeData(
          color: textWhiteSub,
          size: AppIconSize.lg,
        ),
        // Same weight as unselected; colour and the pill mark selection.
        selectedLabelTextStyle: AppText.navLabel.copyWith(color: textWhite),
        unselectedLabelTextStyle: AppText.navLabel.copyWith(
          color: textWhiteSub,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: appColor,
        unselectedItemColor: textMuted,
        selectedLabelStyle: AppText.navLabel,
        unselectedLabelStyle: AppText.navLabel,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: appColor,
        inactiveTrackColor: surface2,
        thumbColor: appColor,
        overlayColor: appColor.withValues(alpha: 0.12),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        headerBackgroundColor: appColor,
        headerForegroundColor: textWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: const WidgetStatePropertyAll(surface),
          surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              side: const BorderSide(color: border),
            ),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: accentLight,
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
      // The app's one spinner, so blocking loads look like in-page ones.
      ..indicatorWidget = const AppSpinner.large()
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
      ..textStyle = AppText.label
      ..maskType = EasyLoadingMaskType.custom
      ..maskColor = scrim
      ..boxShadow = AppShadow.none
      ..userInteractions = false
      ..dismissOnTap = false;
  }
}

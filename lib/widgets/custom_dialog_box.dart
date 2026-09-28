import 'package:ats_app/Responsive/responsive_ext.dart';
import 'package:ats_app/utilities/app_theme.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';

customShowDialog({
  required BuildContext context,
  required String title,
  required String subTitle,
  required VoidCallback cancelClick,
  required VoidCallback okClick,
}) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (BuildContext context) => LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            final isTablet = constraints.isTablet;
            final isLandscape = orientation == Orientation.landscape;
            return Dialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isTablet
                      ? (isLandscape
                            ? constraints.maxWidth / 2.5
                            : constraints.maxWidth / 1.5)
                      : 420,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 12, 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          tooltip: 'Close',
                          visualDensity: VisualDensity.compact,
                          onPressed: () => context.pop(),
                          icon: const Icon(Icons.close_rounded, size: 20, color: textMuted),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: accentLight,
                                borderRadius: BorderRadius.circular(AppRadius.md),
                              ),
                              child: const Icon(Icons.help_outline_rounded, color: appColor, size: 24),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              title,
                              style: TextStyle(
                                fontFamily: "Bold",
                                fontSize: isTablet ? 20 : 18,
                                color: textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              subTitle,
                              style: TextStyle(
                                fontSize: isTablet ? 16 : 14.5,
                                color: textSecondary,
                                height: 1.45,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: cancelClick,
                                    child: const Text("No"),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: FilledButton(
                                    onPressed: okClick,
                                    child: const Text("Yes"),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ),
  );
}

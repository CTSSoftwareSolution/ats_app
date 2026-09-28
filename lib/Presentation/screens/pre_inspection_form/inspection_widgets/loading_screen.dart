
import 'package:flutter/material.dart';

import '../../../../utilities/color_data.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: bg,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 36,
              height: 36,
              child: CircularProgressIndicator(color: appColor, strokeWidth: 3),
            ),
            SizedBox(height: 16),
            Text(
              'Fetching inspection questions…',
              style: TextStyle(
                color: textSecondary,
                fontSize: 15,
                fontFamily: "Medium",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

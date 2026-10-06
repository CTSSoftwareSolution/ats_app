import 'package:flutter/material.dart';

import '../../../../utilities/color_data.dart';
import '../../../../widgets/new_app_ui/app_state_view.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: bg,
      child: AppLoadingView(message: 'Fetching inspection questions…'),
    );
  }
}

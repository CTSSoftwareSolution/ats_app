import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../Presentation/screens/login_page/login_screen.dart';
import '../../utilities/color_data.dart';
import '../auth_provider.dart';


/// Shows logout confirmation dialog, handles logout + navigation
Future<void> confirmLogout(BuildContext context) async {
  final auth = context.read<AuthProvider>();
  final user = auth.currentUser;

  final confirmed = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (_) => AlertDialog(
      backgroundColor: surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.all(24),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 56, height: 56,
          decoration: BoxDecoration(
            color: failLight,
            shape: BoxShape.circle),
          child: const Icon(Icons.logout_rounded,
              color: fail, size: 28)),
        const SizedBox(height: 16),
        Text('Sign Out?', style: GoogleFonts.inter(
            color: textPrimary, fontSize: 18,
            fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        if (user != null) ...[
          Text(user.displayName, style: GoogleFonts.inter(
              color: navyAccent, fontSize: 13,
              fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
        ],
        Text('You will be returned to the login screen.',
            style: GoogleFonts.inter(
                color: textMuted, fontSize: 13),
            textAlign: TextAlign.center),
        const SizedBox(height: 24),
        Row(children: [
          Expanded(child: OutlinedButton(
            onPressed: () => Navigator.pop(context, false),
            style: OutlinedButton.styleFrom(
              foregroundColor: textSecondary,
              side: const BorderSide(color: border),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(vertical: 12)),
            child: Text('Cancel', style: GoogleFonts.inter(
                fontWeight: FontWeight.w600)),
          )),
          const SizedBox(width: 12),
          Expanded(child: ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: fail,
              foregroundColor: Colors.white, elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(vertical: 12)),
            child: Text('Sign Out', style: GoogleFonts.inter(
                fontWeight: FontWeight.w700)),
          )),
        ]),
      ]),
    ),
  );

  if (confirmed == true && context.mounted) {
    await auth.logout();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (_) => false);
    }
  }
}

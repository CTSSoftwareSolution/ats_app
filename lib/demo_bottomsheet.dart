// // ─────────────────────────────────────────────────────────────
// //  change_status_sheet.dart  —  Clean iOS-style Bottom Sheet
// // ─────────────────────────────────────────────────────────────
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// // void main() {
// //   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
// //   runApp(const App());
// // }
//
// // ── App ──────────────────────────────────────────────────────
// // class App extends StatelessWidget {
// //   const App({super.key});
// //   @override
// //   Widget build(BuildContext context) => MaterialApp(
// //     debugShowCheckedModeBanner: false,
// //     theme: ThemeData(
// //       scaffoldBackgroundColor: const Color(0xFFF2F2F7),
// //       fontFamily: 'SF Pro Display',
// //       colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF007AFF)),
// //       useMaterial3: true,
// //     ),
// //     home: const HomeScreen(),
// //   );
// // }
//
// // ── Tokens ───────────────────────────────────────────────────
// class _C {
//   static const bg        = Color(0xFFF2F2F7);
//   static const surface   = Color(0xFFFFFFFF);
//   static const card      = Color(0xFFF9F9FB);
//   static const border    = Color(0xFFEBEBF0);
//   static const label     = Color(0xFF8E8E93);
//   static const primary   = Color(0xFF1C1C1E);
//   static const blue      = Color(0xFF007AFF);
//   static const green     = Color(0xFF27AE60);
//   static const red       = Color(0xFFE74C3C);
//   static const greenBg   = Color(0xFFE5F5EE);
//   static const redBg     = Color(0xFFFFE5E5);
//   static const greenText = Color(0xFF1A7A4A);
//   static const redText   = Color(0xFFC0392B);
//   static const divider   = Color(0xFFF2F2F7);
//   static const inputBg   = Color(0xFFF9F9FB);
//   static const inputBdr  = Color(0xFFE5E5EA);
//   static const cancelBg  = Color(0xFFF2F2F7);
//   static const cancelTxt = Color(0xFF636366);
//   static const drag      = Color(0xFFE5E5EA);
// }
//
// // ── Home ─────────────────────────────────────────────────────
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   bool _pass = false;
//
//   void _show() => showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     builder: (_) => ChangeStatusSheet(
//       isPass: _pass,
//       onSubmit: (v) => setState(() => _pass = v),
//     ),
//   );
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     backgroundColor: _C.bg,
//     body: SafeArea(
//       child: Column(
//         children: [
//           const SizedBox(height: 32),
//           // machine label
//           Text(
//             'MACHINE · LINE A',
//             style: TextStyle(
//               fontSize: 11, fontWeight: FontWeight.w600,
//               letterSpacing: 2.5, color: _C.label,
//             ),
//           ),
//           const SizedBox(height: 14),
//           // status badges
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               _StatusBadge(label: 'System', pass: _pass),
//               const SizedBox(width: 6),
//               _StatusBadge(label: 'Current', pass: _pass),
//             ],
//           ),
//           const Spacer(),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(24, 0, 24, 36),
//             child: _PrimaryButton(
//               label: 'Change Status',
//               color: _C.blue,
//               onTap: _show,
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
//
// // ── Status Badge ─────────────────────────────────────────────
// class _StatusBadge extends StatelessWidget {
//   final String label;
//   final bool pass;
//   const _StatusBadge({required this.label, required this.pass});
//
//   @override
//   Widget build(BuildContext context) {
//     final bg   = pass ? _C.greenBg  : _C.redBg;
//     final txt  = pass ? _C.greenText : _C.redText;
//     final dot  = pass ? _C.green    : _C.red;
//     final val  = pass ? 'Pass' : 'Fail';
//
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       decoration: BoxDecoration(
//         color: bg,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(width: 6, height: 6,
//               decoration: BoxDecoration(color: dot, shape: BoxShape.circle)),
//           const SizedBox(width: 5),
//           Text('$label: $val',
//               style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: txt)),
//         ],
//       ),
//     );
//   }
// }
//
// // ── Bottom Sheet ─────────────────────────────────────────────
// class ChangeStatusSheet extends StatefulWidget {
//   final bool isPass;
//   final void Function(bool) onSubmit;
//   const ChangeStatusSheet({super.key, required this.isPass, required this.onSubmit});
//
//   @override
//   State<ChangeStatusSheet> createState() => _ChangeStatusSheetState();
// }
//
// class _ChangeStatusSheetState extends State<ChangeStatusSheet> {
//   late bool _toPass;
//   final _ctrl = TextEditingController();
//   int _chars = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _toPass = !widget.isPass;
//     _ctrl.addListener(() => setState(() => _chars = _ctrl.text.length));
//   }
//
//   @override
//   void dispose() { _ctrl.dispose(); super.dispose(); }
//
//   void _submit() {
//     widget.onSubmit(_toPass);
//     Navigator.pop(context);
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Status updated to ${_toPass ? "Pass" : "Fail"}',
//             style: const TextStyle(fontWeight: FontWeight.w500)),
//         backgroundColor: _C.primary,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         margin: const EdgeInsets.all(16),
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final kb = MediaQuery.of(context).viewInsets.bottom;
//     final accent = _toPass ? _C.blue : _C.red;
//
//     return AnimatedPadding(
//       duration: const Duration(milliseconds: 280),
//       curve: Curves.easeOutCubic,
//       padding: EdgeInsets.only(bottom: kb),
//       child: Container(
//         decoration: const BoxDecoration(
//           color: _C.surface,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//
//             // ── Drag handle
//             Center(
//               child: Container(
//                 margin: const EdgeInsets.only(top: 10, bottom: 6),
//                 width: 36, height: 4,
//                 decoration: BoxDecoration(
//                   color: _C.drag,
//                   borderRadius: BorderRadius.circular(99),
//                 ),
//               ),
//             ),
//
//             // ── Header
//             Padding(
//               padding: const EdgeInsets.fromLTRB(20, 2, 20, 12),
//               child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                 const Text('Change Status',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700,
//                         color: _C.primary, letterSpacing: -0.3)),
//                 const SizedBox(height: 2),
//                 const Text('Machine · Line A',
//                     style: TextStyle(fontSize: 13, color: _C.label)),
//               ]),
//             ),
//             Divider(height: 1, color: _C.divider),
//
//             // ── Status cards
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
//               child: Row(children: [
//                 Expanded(child: _StatusCard(label: 'System status', pass: widget.isPass)),
//                 const SizedBox(width: 10),
//                 Expanded(child: _StatusCard(label: 'Current status', pass: widget.isPass)),
//               ]),
//             ),
//
//             // ── Toggle row
//             Padding(
//               padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
//               child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                 const Text('CHANGE TO',
//                     style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600,
//                         color: _C.label, letterSpacing: 1)),
//                 const SizedBox(height: 10),
//                 Row(children: [
//                   Expanded(
//                     child: Text('Change to ${_toPass ? "Pass" : "Fail"}',
//                         style: const TextStyle(fontSize: 16,
//                             fontWeight: FontWeight.w700, color: _C.primary)),
//                   ),
//                   _Toggle(value: _toPass,
//                       onChanged: (v) => setState(() => _toPass = v)),
//                 ]),
//               ]),
//             ),
//
//             // ── Reason field
//             Padding(
//               padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
//               child: Stack(children: [
//                 TextField(
//                   controller: _ctrl,
//                   maxLines: 3,
//                   maxLength: 200,
//                   buildCounter: (_, {required currentLength,
//                     required isFocused, maxLength}) => const SizedBox.shrink(),
//                   style: const TextStyle(fontSize: 14, color: _C.primary, height: 1.5),
//                   decoration: InputDecoration(
//                     hintText: 'Reason for this change…',
//                     hintStyle: const TextStyle(color: Color(0xFFC7C7CC), fontSize: 14),
//                     filled: true,
//                     fillColor: _C.inputBg,
//                     contentPadding: const EdgeInsets.fromLTRB(14, 12, 14, 28),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: const BorderSide(color: _C.inputBdr, width: 0.5),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: const BorderSide(color: _C.inputBdr, width: 0.5),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(color: accent, width: 1.5),
//                     ),
//                   ),
//                 ),
//                 Positioned(bottom: 10, right: 12,
//                     child: Text('$_chars / 200',
//                         style: const TextStyle(fontSize: 11, color: Color(0xFFC7C7CC)))),
//               ]),
//             ),
//
//             // ── Buttons
//             Padding(
//               padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
//               child: Row(children: [
//                 GestureDetector(
//                   onTap: () => Navigator.pop(context),
//                   child: Container(
//                     height: 50,
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     decoration: BoxDecoration(
//                       color: _C.cancelBg,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     alignment: Alignment.center,
//                     child: const Text('Cancel',
//                         style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600,
//                             color: _C.cancelTxt)),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(child: _PrimaryButton(
//                     label: 'Submit', color: accent, onTap: _submit)),
//               ]),
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ── Status Card ───────────────────────────────────────────────
// class _StatusCard extends StatelessWidget {
//   final String label;
//   final bool pass;
//   const _StatusCard({required this.label, required this.pass});
//
//   @override
//   Widget build(BuildContext context) => Container(
//     padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
//     decoration: BoxDecoration(
//       color: _C.card,
//       borderRadius: BorderRadius.circular(12),
//       border: Border.all(color: _C.border, width: 0.5),
//     ),
//     child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Text(label.toUpperCase(),
//           style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600,
//               color: _C.label, letterSpacing: 0.8)),
//       const SizedBox(height: 5),
//       Text(pass ? 'Pass' : 'Fail',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
//               color: pass ? _C.green : _C.red)),
//     ]),
//   );
// }
//
// // ── Toggle ───────────────────────────────────────────────────
// class _Toggle extends StatelessWidget {
//   final bool value;
//   final ValueChanged<bool> onChanged;
//   const _Toggle({required this.value, required this.onChanged});
//
//   @override
//   Widget build(BuildContext context) => GestureDetector(
//     onTap: () => onChanged(!value),
//     child: AnimatedContainer(
//       duration: const Duration(milliseconds: 240),
//       curve: Curves.easeInOut,
//       width: 48, height: 28,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(99),
//         color: value ? const Color(0xFF34C759) : const Color(0xFFE5E5EA),
//       ),
//       child: AnimatedAlign(
//         duration: const Duration(milliseconds: 240),
//         curve: Curves.easeOut,
//         alignment: value ? Alignment.centerRight : Alignment.centerLeft,
//         child: Container(
//           margin: const EdgeInsets.all(2),
//           width: 24, height: 24,
//           decoration: const BoxDecoration(
//             color: Colors.white, shape: BoxShape.circle,
//             boxShadow: [BoxShadow(color: Color(0x29000000), blurRadius: 4, offset: Offset(0,1))],
//           ),
//         ),
//       ),
//     ),
//   );
// }
//
// // ── Primary Button ────────────────────────────────────────────
// class _PrimaryButton extends StatefulWidget {
//   final String label;
//   final Color color;
//   final VoidCallback onTap;
//   const _PrimaryButton({required this.label, required this.color, required this.onTap});
//
//   @override
//   State<_PrimaryButton> createState() => _PrimaryButtonState();
// }
//
// class _PrimaryButtonState extends State<_PrimaryButton>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c =
//   AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
//   late final Animation<double> _s =
//   Tween(begin: 1.0, end: 0.96).animate(CurvedAnimation(parent: _c, curve: Curves.easeIn));
//
//   @override
//   void dispose() { _c.dispose(); super.dispose(); }
//
//   @override
//   Widget build(BuildContext context) => GestureDetector(
//     onTapDown: (_) => _c.forward(),
//     onTapUp: (_) { _c.reverse(); widget.onTap(); },
//     onTapCancel: () => _c.reverse(),
//     child: ScaleTransition(
//       scale: _s,
//       child: Container(
//         height: 50,
//         decoration: BoxDecoration(
//           color: widget.color,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         alignment: Alignment.center,
//         child: Text(widget.label,
//             style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
//                 color: Colors.white, letterSpacing: 0.1)),
//       ),
//     ),
//   );
// }
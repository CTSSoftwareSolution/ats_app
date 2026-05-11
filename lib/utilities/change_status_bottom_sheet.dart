import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Presentation/provider/ai_inspection_details_provider.dart';
import '../Presentation/provider/ai_update_result_provider.dart';

// ── Bottom Sheet ─────────────────────────────────────────────
class ChangeStatusSheet extends StatefulWidget {
  final bool isPass;
  final void Function(bool) onSubmit;
  const ChangeStatusSheet({super.key, required this.isPass, required this.onSubmit});

  @override
  State<ChangeStatusSheet> createState() => _ChangeStatusSheetState();
}

class _ChangeStatusSheetState extends State<ChangeStatusSheet> {


  @override
  void initState() {
    super.initState();
    final updateResultProvider = Provider.of<AiUpdateResultProvider>(context,listen: false);
    final detailsProvider = Provider.of<AiInspectionDetailsProvider>(context,listen: false);
    debugPrint("Status : ${widget.isPass}");
    debugPrint("selectedQuestionId : ${detailsProvider.selectedQueId}");
    updateResultProvider.toPass = false;
    updateResultProvider.ctrl.addListener(() => setState(() => updateResultProvider.chars = updateResultProvider.ctrl.text.length));

  }

  @override
  void dispose() {
    final updateResultProvider = Provider.of<AiUpdateResultProvider>(context,listen: false);
    updateResultProvider.ctrl.dispose(); super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final updateResultProvider = context.watch<AiUpdateResultProvider>();
    final kb = MediaQuery.of(context).viewInsets.bottom;
    final accent = updateResultProvider.toPass ? Color(0xFF007AFF) : Color(0xFFE74C3C);
    final status = widget.isPass ? "Fail" : "Pass";
    return AnimatedPadding(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(bottom: kb),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Drag handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 6),
                width: 36, height: 4,
                decoration: BoxDecoration(
                  color: Color(0xFFE5E5EA),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),

            // ── Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 2, 20, 12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Change Status',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700,
                        color: Color(0xFF1C1C1E), letterSpacing: -0.3)),
                const SizedBox(height: 2),
                const Text('Machine · Line A',
                    style: TextStyle(fontSize: 13, color: Color(0xFF8E8E93))),
              ]),
            ),
            Divider(height: 1, color: Color(0xFFF2F2F7)),

            // ── Status cards
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(children: [
                Expanded(child: _StatusCard(label: 'System status', pass: widget.isPass)),
                const SizedBox(width: 10),
                Expanded(child: _StatusCard(label: 'Current status', pass: widget.isPass)),
              ]),
            ),

            // ── Toggle row
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('CHANGE TO',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600,
                        color: Color(0xFF8E8E93), letterSpacing: 1)),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(
                    child: Text('Change to $status',
                        style: const TextStyle(fontSize: 16,
                            fontWeight: FontWeight.w700, color: Color(0xFF1C1C1E))),
                  ),
                  _Toggle(
                    value: updateResultProvider.toPass,
                    onChanged: (v) {

                     updateResultProvider.toPass = v;
                     // final bool changedStatus =
                     // v ? !widget.isPass : widget.isPass;

                     // ScaffoldMessenger.of(context).showSnackBar(
                     //   SnackBar(
                     //     duration: const Duration(seconds: 1),
                     //     content: Text(
                     //       'Selected: ${changedStatus ? "Pass" : "Fail"}',
                     //       style: const TextStyle(
                     //         fontWeight: FontWeight.w600,
                     //       ),
                     //     ),
                     //     backgroundColor: changedStatus
                     //         ? const Color(0xFF27AE60)
                     //         : const Color(0xFFE74C3C),
                     //   ),
                    // );
                    },
                  ),
                ]),
              ]),
            ),

            // ── Reason field
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Stack(children: [
                TextField(
                  controller: updateResultProvider.ctrl,
                  maxLines: 3,
                  maxLength: 200,
                  buildCounter: (_, {required currentLength,
                    required isFocused, maxLength}) => const SizedBox.shrink(),
                  style: const TextStyle(fontSize: 14, color: Color(0xFF1C1C1E), height: 1.5),
                  decoration: InputDecoration(
                    hintText: 'Reason for this change…',
                    hintStyle: const TextStyle(color: Color(0xFFC7C7CC), fontSize: 14),
                    filled: true,
                    fillColor: Color(0xFFF9F9FB),
                    contentPadding: const EdgeInsets.fromLTRB(14, 12, 14, 28),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E5EA), width: 0.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E5EA), width: 0.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: accent, width: 1.5),
                    ),
                  ),
                ),
                Positioned(bottom: 10, right: 12,
                    child: Text('${updateResultProvider.chars} / 200',
                        style: const TextStyle(fontSize: 11, color: Color(0xFFC7C7CC)))),
              ]),
            ),

            // ── Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
              child: Row(children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Color(0xFFF2F2F7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Text('Cancel',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600,
                            color: Color(0xFF636366))),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(child: _PrimaryButton(
                    label: 'Submit', color: accent, onTap: (){
                  final bool finalStatus =
                  updateResultProvider.toPass
                      ? !widget.isPass
                      : widget.isPass;
                  updateResultProvider.aiUpdateResult(context, finalStatus);
                  context.pop();
                  updateResultProvider.ctrl.clear();
                  updateResultProvider.toPass = false;
                })),
              ]),
            ),

          ],
        ),
      ),
    );
  }
}

// ── Status Card ───────────────────────────────────────────────
class _StatusCard extends StatelessWidget {
  final String label;
  final bool pass;
  const _StatusCard({required this.label, required this.pass});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
    decoration: BoxDecoration(
      color: Color(0xFFF9F9FB),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Color(0xFFEBEBF0), width: 0.5),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label.toUpperCase(),
          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600,
              color: Color(0xFF8E8E93), letterSpacing: 0.8)),
      const SizedBox(height: 5),
      Text(pass ? 'Pass' : 'Fail',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
              color: pass ? Color(0xFF27AE60) : Color(0xFFE74C3C))),
    ]),
  );
}

// ── Toggle ───────────────────────────────────────────────────
class _Toggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const _Toggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => onChanged(!value),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeInOut,
      width: 48, height: 28,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99),
        color: value ? const Color(0xFF34C759) : const Color(0xFFE5E5EA),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOut,
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.all(2),
          width: 24, height: 24,
          decoration: const BoxDecoration(
            color: Colors.white, shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Color(0x29000000), blurRadius: 4, offset: Offset(0,1))],
          ),
        ),
      ),
    ),
  );
}


// ── Primary Button ────────────────────────────────────────────
class _PrimaryButton extends StatefulWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _PrimaryButton({required this.label, required this.color, required this.onTap});

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
  AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
  late final Animation<double> _s =
  Tween(begin: 1.0, end: 0.96).animate(CurvedAnimation(parent: _c, curve: Curves.easeIn));

  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTapDown: (_) => _c.forward(),
    onTapUp: (_) { _c.reverse(); widget.onTap(); },
    onTapCancel: () => _c.reverse(),
    child: ScaleTransition(
      scale: _s,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(widget.label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                color: Colors.white, letterSpacing: 0.1)),
      ),
    ),
  );
}
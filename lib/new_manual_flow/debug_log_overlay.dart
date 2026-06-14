import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'auth_provider.dart';
import 'new_services/debug_service.dart';


// ── Wrap any screen with this to add the debug FAB ───────────────────────────
class DebugFabWrapper extends StatelessWidget {
  final Widget child;
  const DebugFabWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final debugOn = context.watch<AuthProvider>().config.debugMode;
    if (!debugOn) return child;
    return Stack(children: [
      child,
      Positioned(
        bottom: 90,
        right: 16,
        child: _DebugFab(),
      ),
    ]);
  }
}

class _DebugFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final count = DebugService.entries.length;
    return GestureDetector(
      onTap: () => _showLog(context),
      child: Container(
        width: 52, height: 52,
        decoration: BoxDecoration(
          color: const Color(0xFF0D1117),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.greenAccent.withOpacity(0.7), width: 1.5),
          boxShadow: [
            BoxShadow(color: Colors.greenAccent.withOpacity(0.25),
                blurRadius: 12, spreadRadius: 1),
          ],
        ),
        child: Stack(alignment: Alignment.center, children: [
          const Icon(Icons.terminal_rounded, color: Colors.greenAccent, size: 22),
          if (count > 0)
            Positioned(
              top: 6, right: 6,
              child: Container(
                width: 16, height: 16,
                decoration: const BoxDecoration(
                    color: Colors.redAccent, shape: BoxShape.circle),
                child: Center(child: Text(
                  count > 99 ? '99+' : '$count',
                  style: const TextStyle(color: Colors.white,
                      fontSize: 7, fontWeight: FontWeight.w800),
                )),
              ),
            ),
        ]),
      ),
    );
  }

  void _showLog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _DebugLogSheet(),
    );
  }
}

// ── Full log sheet ────────────────────────────────────────────────────────────
class _DebugLogSheet extends StatefulWidget {
  const _DebugLogSheet();
  @override State<_DebugLogSheet> createState() => _DebugLogSheetState();
}

class _DebugLogSheetState extends State<_DebugLogSheet> {
  final _scroll = ScrollController();
  String _filter = 'ALL';
  static const _filters = ['ALL', 'REQ', 'RES✓', 'RES✗', 'AUTH',
    'UP✓', 'UP✗', 'SYS'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() { _scroll.dispose(); super.dispose(); }

  void _scrollToBottom() {
    if (_scroll.hasClients) {
      _scroll.jumpTo(_scroll.position.maxScrollExtent);
    }
  }

  List<DebugEntry> get _filtered {
    if (_filter == 'ALL') return DebugService.entries;
    return DebugService.entries.where((e) => e.tag == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final entries = _filtered;
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.4,
      maxChildSize: 0.97,
      expand: false,
      builder: (_, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0D1117),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(children: [

          // ── Handle ─────────────────────────────────────────────────
          Container(
            width: 40, height: 4,
            margin: const EdgeInsets.only(top: 10, bottom: 8),
            decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2)),
          ),

          // ── Header ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
            child: Row(children: [
              const Icon(Icons.terminal_rounded,
                  color: Colors.greenAccent, size: 18),
              const SizedBox(width: 8),
              Text('API Debug Log', style: GoogleFonts.robotoMono(
                  color: Colors.greenAccent, fontSize: 14,
                  fontWeight: FontWeight.w700)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10)),
                child: Text('${DebugService.entries.length} entries',
                    style: GoogleFonts.robotoMono(
                        color: Colors.white54, fontSize: 9)),
              ),
              const Spacer(),
              // Copy all
              IconButton(
                icon: const Icon(Icons.copy_rounded,
                    color: Colors.white38, size: 18),
                tooltip: 'Copy all',
                onPressed: () {
                  final text = DebugService.entries
                      .map((e) => '[${e.timeStr}] ${e.tag}  ${e.message}')
                      .join('\n');
                  Clipboard.setData(ClipboardData(text: text));
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard'),
                          duration: Duration(seconds: 1)));
                },
              ),
              // Clear
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded,
                    color: Colors.white38, size: 18),
                tooltip: 'Clear log',
                onPressed: () {
                  setState(() => DebugService.clear());
                },
              ),
              // Close
              IconButton(
                icon: const Icon(Icons.close_rounded,
                    color: Colors.white54, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ]),
          ),

          // ── Filter chips ────────────────────────────────────────────
          SizedBox(
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _filters.length,
              itemBuilder: (_, i) {
                final f = _filters[i];
                final selected = _filter == f;
                final count = f == 'ALL'
                    ? DebugService.entries.length
                    : DebugService.entries.where((e) => e.tag == f).length;
                return GestureDetector(
                  onTap: () {
                    setState(() => _filter = f);
                    WidgetsBinding.instance.addPostFrameCallback(
                            (_) => _scrollToBottom());
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: selected
                          ? Colors.greenAccent.withOpacity(0.2)
                          : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: selected
                              ? Colors.greenAccent.withOpacity(0.6)
                              : Colors.white.withOpacity(0.1)),
                    ),
                    child: Text('$f ($count)',
                        style: TextStyle(
                            color: selected
                                ? Colors.greenAccent : Colors.white54,
                            fontSize: 10,
                            fontFamily: 'monospace',
                            fontWeight: selected
                                ? FontWeight.w700 : FontWeight.normal)),
                  ),
                );
              },
            ),
          ),

          const Divider(color: Colors.white12, height: 1),

          // ── Log entries ─────────────────────────────────────────────
          Expanded(
            child: entries.isEmpty
                ? Center(child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.info_outline_rounded,
                    color: Colors.white24, size: 36),
                const SizedBox(height: 10),
                Text('No log entries',
                    style: GoogleFonts.robotoMono(
                        color: Colors.white38, fontSize: 12)),
                const SizedBox(height: 4),
                Text('Make an API call to see entries here',
                    style: GoogleFonts.inter(
                        color: Colors.white24, fontSize: 11)),
              ],
            ))
                : ListView.separated(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
              itemCount: entries.length,
              separatorBuilder: (_, __) =>
              const Divider(color: Colors.white10, height: 1),
              itemBuilder: (_, i) {
                final e = entries[i];
                return _EntryRow(entry: e, index: i);
              },
            ),
          ),
        ]),
      ),
    );
  }
}

// ── Single log entry row ──────────────────────────────────────────────────────
class _EntryRow extends StatelessWidget {
  final DebugEntry entry;
  final int index;
  const _EntryRow({required this.entry, required this.index});

  @override
  Widget build(BuildContext context) {
    final isSeparator = entry.tag == 'REQ' || entry.tag == 'SYS';
    return GestureDetector(
      onLongPress: () {
        Clipboard.setData(ClipboardData(
            text: '[${entry.timeStr}] ${entry.tag}  ${entry.message}'));
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Line copied'),
                duration: Duration(milliseconds: 800)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: isSeparator ? 8 : 4, horizontal: 4),
        decoration: isSeparator
            ? BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(4))
            : null,
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Line number
          SizedBox(width: 28, child: Text('${index + 1}',
              style: const TextStyle(
                  color: Colors.white24, fontSize: 8,
                  fontFamily: 'monospace'))),
          // Time
          SizedBox(width: 54, child: Text(entry.timeStr,
              style: const TextStyle(
                  color: Colors.white38, fontSize: 8,
                  fontFamily: 'monospace'))),
          // Tag badge
          Container(
            width: 52,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
                color: entry.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(3)),
            child: Text(entry.tag,
                style: TextStyle(
                    color: entry.color, fontSize: 8,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 6),
          // Message
          Expanded(child: Text(entry.message,
              style: const TextStyle(
                  color: Color(0xFFCBD5E1), fontSize: 10,
                  fontFamily: 'monospace', height: 1.5))),
        ]),
      ),
    );
  }
}

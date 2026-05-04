import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

class ImageDialogBox extends StatefulWidget {
  final String path;

  const ImageDialogBox({super.key, required this.path});

  @override
  State<ImageDialogBox> createState() => _ImageDialogBoxState();
}

class _ImageDialogBoxState extends State<ImageDialogBox>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;

  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  bool _showControls = true;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      value: 1,
    );

    _scaleAnim =
        CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack);

    _fadeAnim =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);

    _scaleController.forward();
    _scheduleHideControls();
  }

  void _scheduleHideControls() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _fadeController.reverse();
        setState(() => _showControls = false);
      }
    });
  }

  void _onTap() {
    setState(() => _showControls = true);
    _fadeController.forward();
    _scheduleHideControls();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Center(
          child: SizedBox(
            width: size.width * 0.9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.09),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: _onTap,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        /// Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(
                            File(widget.path),
                            fit: BoxFit.contain,
                          ),
                        ),

                        /// Gradient overlay (same cinematic feel)
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.4),
                                  Colors.transparent,
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.5),
                                ],
                                stops: const [0.0, 0.25, 0.7, 1.0],
                              ),
                            ),
                          ),
                        ),

                        /// Close button
                        Positioned(
                          top: 12,
                          right: 12,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black.withOpacity(0.45),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.22),
                                      width: 1,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.close_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
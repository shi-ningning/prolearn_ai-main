import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

/// Enhanced interactive button with animations
class InteractiveButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isFullWidth;

  const InteractiveButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.isFullWidth = true,
  });

  @override
  State<InteractiveButton> createState() => _InteractiveButtonState();
}

class _InteractiveButtonState extends State<InteractiveButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!kIsWeb) {
      HapticFeedback.selectionClick();
    }
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bgColor = widget.backgroundColor ?? colorScheme.primary;
    final fgColor = widget.foregroundColor ?? colorScheme.onPrimary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: () {
          if (widget.onPressed == null) return;
          _controller
              .forward()
              .then((_) => _controller.reverse());
          widget.onPressed?.call();
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  width: widget.isFullWidth ? double.infinity : null,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _isHovered
                        ? [
                            bgColor.withValues(
                              red: (bgColor.r * 1.1).clamp(0, 1),
                              green: (bgColor.g * 1.1).clamp(0, 1),
                              blue: (bgColor.b * 1.1).clamp(0, 1),
                            ),
                            bgColor.withValues(
                              red: (bgColor.r * 0.95).clamp(0, 1),
                              green: (bgColor.g * 0.95).clamp(0, 1),
                              blue: (bgColor.b * 0.95).clamp(0, 1),
                            ),
                          ]
                        : [
                            bgColor,
                            bgColor.withValues(
                              red: (bgColor.r * 0.85).clamp(0, 1),
                              green: (bgColor.g * 0.85).clamp(0, 1),
                              blue: (bgColor.b * 0.85).clamp(0, 1),
                            ),
                          ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: fgColor.withValues(alpha: 0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: bgColor.withValues(
                          alpha: _isPressed ? 0.3 : (_isHovered ? 0.5 : 0.4),
                        ),
                        blurRadius: _isPressed ? 8 : (_isHovered ? 24 : 16),
                        offset: Offset(0, _isPressed ? 2 : (_isHovered ? 8 : 4)),
                        spreadRadius: _isPressed ? 0 : (_isHovered ? 1 : 0),
                      ),
                      if (!_isPressed)
                        BoxShadow(
                          color: (isDark ? Colors.black : Colors.grey).withValues(
                            alpha: isDark ? 0.4 : 0.1,
                          ),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(
                          widget.icon,
                          color: fgColor,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                      ],
                      Text(
                        widget.text,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: fgColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
            );
          },
        ),
      ),
    );
  }
}

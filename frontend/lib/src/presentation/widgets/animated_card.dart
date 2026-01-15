import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

/// Enhanced animated card with glassmorphism and modern effects
class AnimatedCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final double elevation;
  final Duration animationDuration;
  final VoidCallback? onLongPress;
  final VoidCallback? onDoubleTap;
  final bool useGlassmorphism;

  const AnimatedCard({
    super.key,
    required this.child,
    this.onTap,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.elevation = 4,
    this.animationDuration = const Duration(milliseconds: 200),
    this.onLongPress,
    this.onDoubleTap,
    this.useGlassmorphism = true,
  });

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _elevationAnimation = Tween<double>(
      begin: widget.elevation,
      end: widget.elevation + 8,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
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
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    
    return MouseRegion(
      onEnter: (_) {
        _controller.forward();
      },
      onExit: (_) {
        _controller.reverse();
      },
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onLongPress: widget.onLongPress == null
            ? null
            : () {
                if (!kIsWeb) {
                  HapticFeedback.lightImpact();
                }
                widget.onLongPress?.call();
              },
        onDoubleTap: widget.onDoubleTap,
        onTap: () {
          _controller.reverse();
          widget.onTap?.call();
        },
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                margin: widget.margin,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    // Primary shadow
                    BoxShadow(
                      color: colorScheme.primary.withValues(
                        alpha: 0.15 * _glowAnimation.value,
                      ),
                      blurRadius: 20 * _glowAnimation.value,
                      spreadRadius: -5,
                      offset: const Offset(0, 8),
                    ),
                    // Secondary shadow
                    BoxShadow(
                      color: (isDark ? Colors.black : Colors.grey).withValues(
                        alpha: isDark ? 0.5 : 0.1 + (_elevationAnimation.value * 0.02),
                      ),
                      blurRadius: _elevationAnimation.value * 3,
                      offset: Offset(0, _elevationAnimation.value),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                    filter: widget.useGlassmorphism 
                      ? ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10)
                      : ui.ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                    child: Container(
                      padding: widget.padding,
                      decoration: BoxDecoration(
                        color: widget.useGlassmorphism
                          ? (widget.backgroundColor ?? colorScheme.surface).withValues(
                              alpha: isDark ? 0.7 : 0.85,
                            )
                          : (widget.backgroundColor ?? colorScheme.surface),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: colorScheme.primary.withValues(
                            alpha: isDark ? (0.3 + (_glowAnimation.value * 0.2)) : (0.15 + (_glowAnimation.value * 0.2)),
                          ),
                          width: 1.5,
                        ),
                        gradient: widget.useGlassmorphism 
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                colorScheme.surface.withValues(alpha: isDark ? 0.8 : 0.95),
                                colorScheme.surface.withValues(alpha: isDark ? 0.65 : 0.75),
                              ],
                            )
                          : null,
                      ),
                      child: widget.child,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Enhanced animated stat card with modern styling
// Minimalistic Static Stat Card (No Animation)
class AnimatedStatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData? icon;

  const AnimatedStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

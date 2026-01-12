import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Animated gradient background that smoothly transitions colors
class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;
  final List<Color> colors;
  final Duration duration;

  const AnimatedGradientBackground({
    super.key,
    required this.child,
    this.colors = const [
      AppColors.background,
      AppColors.surfaceVariant,
      AppColors.background,
    ],
    this.duration = const Duration(seconds: 8),
  });

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState
    extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(widget.colors[0], widget.colors[1], _animation.value)!,
                Color.lerp(widget.colors[1], widget.colors[2], _animation.value)!,
                Color.lerp(widget.colors[2], widget.colors[0], _animation.value)!,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

/// Floating particles background effect
class ParticleBackground extends StatefulWidget {
  final Widget child;
  final int particleCount;
  final Color particleColor;

  const ParticleBackground({
    super.key,
    required this.child,
    this.particleCount = 50,
    this.particleColor = AppColors.primary,
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    // Initialize particles
    for (int i = 0; i < widget.particleCount; i++) {
      _particles.add(Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 3 + 1,
        speed: _random.nextDouble() * 0.5 + 0.1,
        direction: _random.nextDouble() * 2 * pi,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(
            particles: _particles,
            color: widget.particleColor,
            progress: _controller.value,
          ),
          child: widget.child,
        );
      },
    );
  }
}

class Particle {
  double x;
  double y;
  double size;
  double speed;
  double direction;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.direction,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Color color;
  final double progress;

  ParticlePainter({
    required this.particles,
    required this.color,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    for (final particle in particles) {
      // Update particle position
      particle.x += cos(particle.direction) * particle.speed * 0.01;
      particle.y += sin(particle.direction) * particle.speed * 0.01;

      // Wrap around edges
      if (particle.x < 0) particle.x = 1;
      if (particle.x > 1) particle.x = 0;
      if (particle.y < 0) particle.y = 1;
      if (particle.y > 1) particle.y = 0;

      // Draw particle
      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Combined animated background with gradient and particles
class AnimatedBackground extends StatelessWidget {
  final Widget child;
  final bool showParticles;

  const AnimatedBackground({
    super.key,
    required this.child,
    this.showParticles = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    Widget background = AnimatedGradientBackground(
      colors: isDark
          ? [
              AppColors.darkBackground,
              AppColors.darkSurface,
              AppColors.darkBackground,
            ]
          : [
              AppColors.background,
              AppColors.surfaceVariant,
              AppColors.background,
            ],
      child: child,
    );

    if (showParticles) {
      background = ParticleBackground(
        particleCount: 30,
        particleColor: isDark ? AppColors.darkPrimary : AppColors.primary,
        child: background,
      );
    }

    return background;
  }
}

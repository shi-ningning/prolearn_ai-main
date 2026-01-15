import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Enhanced animated gradient background with mesh and wave effects
class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;
  final List<Color> colors;
  final Duration duration;
  final Duration refreshRate;

  const AnimatedGradientBackground({
    super.key,
    required this.child,
    this.colors = const [
      AppColors.background,
      AppColors.surfaceVariant,
      AppColors.background,
    ],
    this.duration = const Duration(seconds: 10),
    this.refreshRate = const Duration(milliseconds: 66),
  });

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState
    extends State<AnimatedGradientBackground> {
  Timer? _timer;
  late Stopwatch _stopwatch;
  double _progress = 0.0;
  final List<_FloatingOrb> _orbs = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
    
    // Initialize floating orbs
    for (int i = 0; i < 5; i++) {
      _orbs.add(_FloatingOrb(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        radius: _random.nextDouble() * 0.3 + 0.2,
        speed: _random.nextDouble() * 0.03 + 0.01,
        direction: _random.nextDouble() * 2 * pi,
      ));
    }
    
    _timer = Timer.periodic(widget.refreshRate, (_) {
      if (!mounted) return;
      final durationMs = widget.duration.inMilliseconds;
      final normalized = durationMs == 0
          ? 0.0
          : (_stopwatch.elapsedMilliseconds % durationMs) / durationMs;
      
      // Update orbs
      final deltaSeconds = widget.refreshRate.inMilliseconds / 1000;
      for (final orb in _orbs) {
        orb.x += cos(orb.direction) * orb.speed * deltaSeconds;
        orb.y += sin(orb.direction) * orb.speed * deltaSeconds;
        
        if (orb.x < -0.2) orb.x = 1.2;
        if (orb.x > 1.2) orb.x = -0.2;
        if (orb.y < -0.2) orb.y = 1.2;
        if (orb.y > 1.2) orb.y = -0.2;
      }
      
      setState(() {
        _progress = Curves.easeInOut.transform(normalized);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base gradient with mesh effect
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(-0.3 + sin(_progress * 2 * pi) * 0.3, 
                             -0.3 + cos(_progress * 2 * pi) * 0.3),
              radius: 1.5,
              colors: [
                Color.lerp(widget.colors[0], widget.colors[1], _progress)!,
                Color.lerp(widget.colors[1], widget.colors[2], _progress)!,
                Color.lerp(widget.colors[2], widget.colors[0], _progress)!,
              ],
            ),
          ),
        ),
        // Floating orbs layer
        CustomPaint(
          painter: _OrbPainter(
            orbs: _orbs,
            baseColors: widget.colors,
            progress: _progress,
          ),
          child: Container(),
        ),
        // Content
        widget.child,
      ],
    );
  }
}

class _FloatingOrb {
  double x;
  double y;
  double radius;
  double speed;
  double direction;

  _FloatingOrb({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.direction,
  });
}

class _OrbPainter extends CustomPainter {
  final List<_FloatingOrb> orbs;
  final List<Color> baseColors;
  final double progress;

  _OrbPainter({
    required this.orbs,
    required this.baseColors,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < orbs.length; i++) {
      final orb = orbs[i];
      final center = Offset(orb.x * size.width, orb.y * size.height);
      final radius = orb.radius * size.width.clamp(0.0, 400.0);
      
      final colorIndex = i % baseColors.length;
      final color = Color.lerp(
        baseColors[colorIndex],
        baseColors[(colorIndex + 1) % baseColors.length],
        progress,
      )!;
      
      final gradient = ui.Gradient.radial(
        center,
        radius,
        [
          color.withValues(alpha: 0.15),
          color.withValues(alpha: 0.05),
          color.withValues(alpha: 0.0),
        ],
        [0.0, 0.6, 1.0],
      );
      
      final paint = Paint()..shader = gradient;
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Enhanced floating particles with glow and connection lines
class ParticleBackground extends StatefulWidget {
  final Widget child;
  final int particleCount;
  final Color particleColor;
  final Duration refreshRate;
  final bool showConnections;

  const ParticleBackground({
    super.key,
    required this.child,
    this.particleCount = 50,
    this.particleColor = AppColors.primary,
    this.refreshRate = const Duration(milliseconds: 66),
    this.showConnections = true,
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground> {
  Timer? _timer;
  final List<Particle> _particles = [];
  final Random _random = Random();
  late DateTime _lastTick;

  @override
  void initState() {
    super.initState();
    _lastTick = DateTime.now();
    _timer = Timer.periodic(widget.refreshRate, (_) {
      if (!mounted) return;
      final now = DateTime.now();
      final delta = now.difference(_lastTick);
      _lastTick = now;
      _updateParticles(delta);
      setState(() {});
    });

    // Initialize particles with varied properties
    for (int i = 0; i < widget.particleCount; i++) {
      _particles.add(Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 3 + 1.5,
        speed: _random.nextDouble() * 0.04 + 0.015,
        direction: _random.nextDouble() * 2 * pi,
        opacity: _random.nextDouble() * 0.4 + 0.2,
        pulsePhase: _random.nextDouble() * 2 * pi,
      ));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateParticles(Duration delta) {
    final deltaSeconds = delta.inMilliseconds / 1000;
    if (deltaSeconds <= 0) return;

    for (final particle in _particles) {
      particle.x += cos(particle.direction) * particle.speed * deltaSeconds;
      particle.y += sin(particle.direction) * particle.speed * deltaSeconds;
      particle.pulsePhase += deltaSeconds * 2;

      if (particle.x < -0.1) particle.x = 1.1;
      if (particle.x > 1.1) particle.x = -0.1;
      if (particle.y < -0.1) particle.y = 1.1;
      if (particle.y > 1.1) particle.y = -0.1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: ParticlePainter(
          particles: _particles,
          color: widget.particleColor,
          showConnections: widget.showConnections,
        ),
        child: widget.child,
      ),
    );
  }
}

class Particle {
  double x;
  double y;
  double size;
  double speed;
  double direction;
  double opacity;
  double pulsePhase;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.direction,
    required this.opacity,
    required this.pulsePhase,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Color color;
  final bool showConnections;

  ParticlePainter({
    required this.particles,
    required this.color,
    required this.showConnections,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw connection lines
    if (showConnections) {
      final linePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5;

      for (int i = 0; i < particles.length; i++) {
        for (int j = i + 1; j < particles.length; j++) {
          final p1 = particles[i];
          final p2 = particles[j];
          final dx = (p1.x - p2.x) * size.width;
          final dy = (p1.y - p2.y) * size.height;
          final distance = sqrt(dx * dx + dy * dy);

          if (distance < 150) {
            final alpha = (1 - distance / 150) * 0.15;
            linePaint.color = color.withValues(alpha: alpha);
            canvas.drawLine(
              Offset(p1.x * size.width, p1.y * size.height),
              Offset(p2.x * size.width, p2.y * size.height),
              linePaint,
            );
          }
        }
      }
    }

    // Draw particles with glow
    for (final particle in particles) {
      final center = Offset(particle.x * size.width, particle.y * size.height);
      final pulse = (sin(particle.pulsePhase) + 1) / 2;
      final currentOpacity = particle.opacity * (0.7 + pulse * 0.3);
      
      // Outer glow
      final glowPaint = Paint()
        ..color = color.withValues(alpha: currentOpacity * 0.2)
        ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 8);
      canvas.drawCircle(center, particle.size * 2.5, glowPaint);
      
      // Core particle
      final corePaint = Paint()
        ..color = color.withValues(alpha: currentOpacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, particle.size, corePaint);
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
    
    return Stack(
      children: [
        // Enhanced gradient background
        AnimatedGradientBackground(
          colors: isDark
              ? [
                  AppColors.darkBackground,
                  AppColors.darkSurface,
                  AppColors.darkBackground.withValues(
                    red: AppColors.darkBackground.r * 0.95,
                    green: AppColors.darkBackground.g * 0.95,
                    blue: AppColors.darkBackground.b * 1.05,
                  ),
                ]
              : [
                  AppColors.background,
                  AppColors.surfaceVariant,
                  AppColors.background.withValues(
                    red: AppColors.background.r * 0.98,
                    green: AppColors.background.g * 0.98,
                    blue: AppColors.background.b * 1.02,
                  ),
                ],
          child: Container(),
        ),
        // Particles layer
        if (showParticles)
          ParticleBackground(
            particleCount: 40,
            particleColor: isDark ? AppColors.darkPrimary : AppColors.primary,
            showConnections: true,
            child: Container(),
          ),
        // Content layer
        child,
      ],
    );
  }
}

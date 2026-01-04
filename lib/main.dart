import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(const HoloTiltApp());
}

class HoloTiltApp extends StatelessWidget {
  const HoloTiltApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HoloTilt',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(
          0xFFF5F5F7,
        ), // Light apple-gray / white
      ),
      home: const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Parallax Tilt Card",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 50),
              HoloCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class HoloCard extends StatefulWidget {
  const HoloCard({super.key});

  @override
  State<HoloCard> createState() => _HoloCardState();
}

class _HoloCardState extends State<HoloCard>
    with SingleTickerProviderStateMixin {
  // Dimensions
  static const double _cardWidth = 300.0;
  static const double _cardHeight = 450.0;
  static const double _maxTiltDegrees = 12.0;
  static const double _maxTiltRadians = _maxTiltDegrees * (math.pi / 180);

  // Animation & State
  late AnimationController _recenterController;
  late Animation<Offset> _recenterAnimation;

  // Current rotation state (X and Y axis in radians)
  // stored in an Offset where dx = rotateY, dy = rotateX for convenience/simplicity in lerping
  Offset _currentTilt = Offset.zero;

  @override
  void initState() {
    super.initState();
    _recenterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _recenterController.addListener(() {
      setState(() {
        _currentTilt = _recenterAnimation.value;
      });
    });
  }

  @override
  void dispose() {
    _recenterController.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    // Stop any active recentering
    if (_recenterController.isAnimating) {
      _recenterController.stop();
    }

    // Map drag distance to rotation
    // Reducing sensitivity so it feels "heavy" and physical
    final double sensitivity = 0.002;

    // Horizontal drag (dx) effects Y-axis rotation
    // Vertical drag (dy) effects X-axis rotation
    // Note: detailed tuning for direction
    double newRotY = _currentTilt.dx - details.delta.dx * sensitivity;
    double newRotX = _currentTilt.dy + details.delta.dy * sensitivity;

    // Clamp values
    newRotY = newRotY.clamp(-_maxTiltRadians, _maxTiltRadians);
    newRotX = newRotX.clamp(-_maxTiltRadians, _maxTiltRadians);

    setState(() {
      _currentTilt = Offset(newRotY, newRotX);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    // Animate back to neutral (0,0)
    _recenterAnimation = Tween<Offset>(begin: _currentTilt, end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _recenterController,
            curve: Curves.elasticOut, // Spring-like easing
          ),
        );

    _recenterController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    // Extract current rotation values
    final double rotY = _currentTilt.dx;
    final double rotX = _currentTilt.dy;

    // Calculate generic "tilt magnitude" (0.0 to 1.0) for opacity/intensity effects
    final double tiltMagnitude =
        (rotX.abs() + rotY.abs()) / (_maxTiltRadians * 2);

    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001) // Perspective
          ..rotateX(rotX)
          ..rotateY(rotY),
        alignment: Alignment.center,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // 1. Shadow Layer
            // Soft shadow shifts based on tilt direction.
            // If we tilt top-left (rotX < 0, rotY > 0 ??), shadow moves opposite.
            // Mapping:
            // Rotation Y+ (right side away) -> Shadow shift X- (left)
            // Rotation X+ (bottom away) -> Shadow shift Y- (top)
            Positioned.fill(
              child: Transform.translate(
                offset: Offset(-rotY * 80, -rotX * 80),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(
                          0xFFB8860B,
                        ).withAlpha(100), // Golden shadow
                        blurRadius: 40,
                        spreadRadius: -15,
                        offset: const Offset(0, 20), // Slight downward cast
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 2. Base Layer
            // 2. Base Layer
            Container(
              width: _cardWidth,
              height: _cardHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.white, // Card base is white for the footer
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Column(
                  children: [
                    // TOP SECTION: Art & Holographics
                    Expanded(
                      flex: 4,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Base Gradient (Soft Holographic)
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFBF953F), // Dark Gold / Bronze
                                  Color(0xFFFCF6BA), // Pale Gold
                                  Color(0xFFB38728), // Gold
                                  Color(0xFFFBF5B7), // Light Gold
                                  Color(0xFFAA771C), // Deep Gold
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ),

                          // Dolphin Asset
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 50.0,
                                left: 20.0,
                                right: 20.0,
                                bottom: 20.0,
                              ),
                              child: Image.asset(
                                'assets/roman_reigns.jpg',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                          // Text Overlays on Top Section
                          // Text Overlays on Top Section
                          const Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 24,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "WWE",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black26,
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "2025",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black26,
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // 3. Specular Highlight Layer (Overlayed on Art)
                          Positioned.fill(
                            child: Transform.translate(
                              offset: Offset(-rotY * 300, -rotX * 300),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Colors.white.withAlpha(51), // ~0.2
                                      Colors.transparent,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    stops: const [0.3, 0.5, 0.7],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // 4. Holographic Shimmer Layer (Overlayed on Art)
                          Positioned.fill(
                            child: Opacity(
                              opacity: (0.3 + tiltMagnitude).clamp(0.0, 1.0),
                              child: BlendMask(
                                blendMode: BlendMode.overlay,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Color(
                                          0xFFFFD700,
                                        ).withAlpha(100), // Gold
                                        Colors.white.withAlpha(
                                          200,
                                        ), // Sparkle White
                                        Color(
                                          0xFFFFD700,
                                        ).withAlpha(100), // Gold
                                        Colors.transparent,
                                        Color(
                                          0xFFDAA520,
                                        ).withAlpha(100), // GoldenRod
                                        Colors.white.withAlpha(
                                          200,
                                        ), // Sparkle White
                                        Colors.transparent,
                                      ],
                                      begin: Alignment(
                                        -1.0 - (rotY * 2),
                                        -1.0 - (rotX * 2),
                                      ),
                                      end: Alignment(
                                        1.0 - (rotY * 2),
                                        1.0 - (rotX * 2),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Extra specular shine
                          Positioned.fill(
                            child: Opacity(
                              opacity: tiltMagnitude.clamp(0.0, 0.6),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                    center: const Alignment(-0.8, -0.8),
                                    radius: 1.5,
                                    colors: [
                                      Colors.white.withAlpha(100),
                                      Colors.transparent,
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // BOTTOM SECTION: Text Info (White Footer)
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 12.0, // Reduced from 16 to fix overflow
                        ),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.auto_awesome,
                                  color: Colors.black87,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "The Tribal Chief",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Arial', // Fallback
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Roman Reigns 1316 days reign",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize:
                                    13, // Slightly reduced font size for safety
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper widget to apply BlendMode to a simplified child
class BlendMask extends SingleChildRenderObjectWidget {
  final BlendMode blendMode;
  final double opacity;

  const BlendMask({
    required this.blendMode,
    this.opacity = 1.0,
    super.key,
    super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderBlendMask(blendMode, opacity);
  }

  @override
  void updateRenderObject(BuildContext context, RenderBlendMask renderObject) {
    renderObject.blendMode = blendMode;
    renderObject.opacity = opacity;
  }
}

class RenderBlendMask extends RenderProxyBox {
  BlendMode _blendMode;
  double _opacity;

  RenderBlendMask(this._blendMode, this._opacity);

  set blendMode(BlendMode value) {
    if (_blendMode != value) {
      _blendMode = value;
      markNeedsPaint();
    }
  }

  set opacity(double value) {
    if (_opacity != value) {
      _opacity = value;
      markNeedsPaint();
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas.saveLayer(
      offset & size,
      Paint()
        ..blendMode = _blendMode
        ..color = Color.fromRGBO(0, 0, 0, _opacity),
    );
    super.paint(context, offset);
    context.canvas.restore();
  }
}

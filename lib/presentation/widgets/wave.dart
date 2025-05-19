import 'package:flutter/material.dart';
import 'package:my_demo_app/const/colors.dart';

class StaticWave extends StatelessWidget {
  final double height;

  const StaticWave({super.key, this.height = 200});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _WaveClipper(),
      child: Container(height: height, color: AppColors.primary),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const waveHeight = 40.0;

    path.lineTo(0, size.height - waveHeight);

    // Create 3 small smooth bumps
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height,
      size.width * 0.5,
      size.height - waveHeight,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height - 2 * waveHeight,
      size.width,
      size.height - waveHeight,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

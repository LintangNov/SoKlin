import 'package:flutter/material.dart';

import 'package:bersih_in/app/features/ai_vision/data/models/dirt_level_result.dart';

/// Color-coded widget that displays the dirt level classification result.
///
/// - Ringan → green  (#27AE60)
/// - Sedang → amber  (#F39C12)
/// - Berat  → red    (#E74C3C)
class DirtLevelIndicator extends StatelessWidget {
  final DirtLevelResult result;

  const DirtLevelIndicator({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(result.levelIndex);
    final icon = _iconFor(result.levelIndex);
    final confidencePct = (result.confidence * 100).toStringAsFixed(0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon circle
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),

          // Label + confidence
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tingkat Kekotoran',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  result.label,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),

          // Confidence badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  '$confidencePct%',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'yakin',
                  style: TextStyle(fontSize: 10, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _colorFor(int levelIndex) {
    switch (levelIndex) {
      case 0:
        return const Color(0xFF27AE60); // Ringan — green
      case 1:
        return const Color(0xFFF39C12); // Sedang — amber
      default:
        return const Color(0xFFE74C3C); // Berat  — red
    }
  }

  IconData _iconFor(int levelIndex) {
    switch (levelIndex) {
      case 0:
        return Icons.check_circle_rounded; // ✓ Ringan
      case 1:
        return Icons.warning_amber_rounded; // ⚠ Sedang
      default:
        return Icons.cancel_rounded; // ✗ Berat
    }
  }
}

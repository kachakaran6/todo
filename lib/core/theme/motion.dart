import 'package:flutter/material.dart';

/// Orbit Todo Design System — Motion Tokens
///
/// Consistent animation durations and curves used across the app.
/// All animations respect the "reduceMotion" accessibility preference.
class OrbitMotion {
  OrbitMotion._();

  // ──────────────────────────────────────────────────────────────────────────
  // Durations
  // ──────────────────────────────────────────────────────────────────────────

  /// Instant feedback: checkbox tap, icon state change
  static const Duration instant = Duration(milliseconds: 100);

  /// Fast micro-interactions: ripples, hover states, small appearance
  static const Duration fast = Duration(milliseconds: 150);

  /// Standard transitions: list item appear, chip toggle
  static const Duration standard = Duration(milliseconds: 200);

  /// Moderate transitions: sheet entry, filter expand
  static const Duration moderate = Duration(milliseconds: 300);

  /// Expressive transitions: screen navigation, dialog entry
  static const Duration expressive = Duration(milliseconds: 400);

  /// Slow: onboarding, celebratory animations
  static const Duration slow = Duration(milliseconds: 600);

  // ──────────────────────────────────────────────────────────────────────────
  // Curves
  // ──────────────────────────────────────────────────────────────────────────

  /// Standard easing for most animations
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeInOut = Curves.easeInOut;

  /// Spring-like for satisfying completion interactions
  static const Curve spring = Curves.elasticOut;

  /// Smooth deceleration for entering elements
  static const Curve decelerate = Curves.decelerate;

  /// Quick acceleration for exiting elements
  static const Curve accelerate = Curves.fastOutSlowIn;

  // ──────────────────────────────────────────────────────────────────────────
  // Reduced Motion Support
  // ──────────────────────────────────────────────────────────────────────────

  /// Returns the duration scaled by 0 if the user prefers reduced motion.
  /// Use this for ALL animations that are purely decorative.
  static Duration scaled(BuildContext context, Duration duration) {
    final reduceMotion =
        MediaQuery.of(context).disableAnimations;
    return reduceMotion ? Duration.zero : duration;
  }

  /// Returns the correct curve, falling back to linear if motion is reduced.
  static Curve scaledCurve(BuildContext context, Curve curve) {
    final reduceMotion =
        MediaQuery.of(context).disableAnimations;
    return reduceMotion ? Curves.linear : curve;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/motion.dart';
import '../constants/app_constants.dart';

/// Orbit custom animated checkbox widget.
///
/// Provides a satisfying tap-to-complete interaction with:
/// - Scale bounce animation on check
/// - Smooth color transition from outline → filled
/// - Subtle haptic feedback
/// - Proper accessibility semantics
/// - Support for all 5 priority-based colors
class OrbitCheckbox extends StatefulWidget {
  const OrbitCheckbox({
    super.key,
    required this.isChecked,
    required this.onChanged,
    this.borderColor,
    this.checkColor,
    this.size = AppConstants.checkboxSize,
    this.semanticLabel,
  });

  final bool isChecked;
  final ValueChanged<bool> onChanged;
  final Color? borderColor;
  final Color? checkColor;
  final double size;
  final String? semanticLabel;

  @override
  State<OrbitCheckbox> createState() => _OrbitCheckboxState();
}

class _OrbitCheckboxState extends State<OrbitCheckbox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _checkAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: OrbitMotion.standard,
      vsync: this,
    );

    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.85)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.85, end: 1.1)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.1, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
    ]).animate(_controller);

    _checkAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    );

    if (widget.isChecked) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(OrbitCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isChecked != widget.isChecked) {
      if (widget.isChecked) {
        _controller.forward(from: 0.0);
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticFeedback.lightImpact();
    widget.onChanged(!widget.isChecked);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderColor = widget.borderColor ?? colorScheme.outline;
    final checkColor = widget.checkColor ?? colorScheme.primary;

    return Semantics(
      label: widget.semanticLabel ?? (widget.isChecked ? 'Mark incomplete' : 'Mark complete'),
      button: true,
      checked: widget.isChecked,
      child: GestureDetector(
        onTap: _handleTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: AppConstants.touchTargetMin,
          height: AppConstants.touchTargetMin,
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return Transform.scale(
                  scale: _scaleAnim.value,
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorTween(
                        begin: Colors.transparent,
                        end: checkColor.withOpacity(0.15),
                      ).evaluate(_checkAnim),
                      border: Border.all(
                        color: Color.lerp(
                          borderColor,
                          checkColor,
                          _checkAnim.value,
                        )!,
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: AnimatedOpacity(
                        opacity: _checkAnim.value,
                        duration: OrbitMotion.fast,
                        child: Icon(
                          Icons.check_rounded,
                          size: widget.size * 0.6,
                          color: checkColor,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

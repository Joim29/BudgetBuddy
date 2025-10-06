import 'package:flutter/material.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';

class ProgressBar extends StatelessWidget {
  final double value;
  final double? height;
  final Color? background;
  final Color? foreground;
  const ProgressBar({
    super.key,
    required this.value,
    this.height = 20,
    this.background,
    this.foreground,
  }) : assert(value >= 0 && value <= 1);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(AppSpacing.spacing4),
      decoration: ShapeDecoration(
        color: background ?? context.purpleProgressBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusFull),
        ),
      ),
      child: LinearProgressIndicator(
        value: value,
        backgroundColor: Colors.transparent,
        valueColor: AlwaysStoppedAnimation(context.purpleProgressColor),
        borderRadius: BorderRadius.circular(AppRadius.radiusFull),
      ),
    );
  }
}

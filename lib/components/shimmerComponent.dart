import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerComponent extends StatelessWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerComponent({
    Key? key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor != null ? baseColor! : Colors.grey.shade300,
      highlightColor: highlightColor != null ? highlightColor! : Colors.grey.shade200,
      child: Container(
        color: Colors.grey.shade300,
        child: child,
      ),
    );
  }
}
